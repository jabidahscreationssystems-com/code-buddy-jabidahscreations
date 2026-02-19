#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Agent identification
AGENT_NAME="CodeBuddy"
AGENT_VERSION="v1.0.0"

echo "=================================="
echo "🤖 Agent: $AGENT_NAME $AGENT_VERSION"
echo "=================================="

# Read input parameters
OWNER="${1:-}"
REPOSITORY="${2:-}"
PULL_REQUEST_NUMBER="${3:-}"
GITHUB_TOKEN="${4:-}"
CODE_BUDDY_KEY="${5:-}"
STACK="${6:-}"
TOTAL_COMMENTS="${7:-}"
API_ENDPOINT="${8:-https://codebuddy-api.vercel.app/v1/code-review-agent}"

# Validate required parameters
if [[ -z "$OWNER" ]]; then
  echo "❌ Error: owner parameter is required"
  exit 1
fi

if [[ -z "$REPOSITORY" ]]; then
  echo "❌ Error: repository parameter is required"
  exit 1
fi

if [[ -z "$PULL_REQUEST_NUMBER" ]]; then
  echo "❌ Error: pull_request_number parameter is required"
  exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ Error: github_token parameter is required"
  exit 1
fi

if [[ -z "$CODE_BUDDY_KEY" ]]; then
  echo "❌ Error: code_buddy_key parameter is required"
  exit 1
fi

if [[ -z "$STACK" ]]; then
  echo "❌ Error: stack parameter is required"
  exit 1
fi

echo "📊 Analyzing PR #$PULL_REQUEST_NUMBER in $OWNER/$REPOSITORY"
echo "🔗 Using API endpoint: $API_ENDPOINT"

# Construct the payload for the request using jq for safe JSON construction
PAYLOAD=$(jq -n \
  --arg owner "$OWNER" \
  --arg repository "$REPOSITORY" \
  --arg pullRequestNumber "$PULL_REQUEST_NUMBER" \
  --arg githubToken "$GITHUB_TOKEN" \
  --arg codeBuddyKey "$CODE_BUDDY_KEY" \
  --arg stack "$STACK" \
  --arg agentName "$AGENT_NAME" \
  --arg agentVersion "$AGENT_VERSION" \
  --argjson totalComments "${TOTAL_COMMENTS:-null}" \
  '{
    owner: $owner,
    repository: $repository,
    pullRequestNumber: $pullRequestNumber,
    githubToken: $githubToken,
    codeBuddyKey: $codeBuddyKey,
    stack: $stack,
    totalComments: $totalComments,
    agentName: $agentName,
    agentVersion: $agentVersion
  }')

echo "🔍 $AGENT_NAME is reviewing your code..."

# Create a temporary file for response
RESPONSE_FILE=$(mktemp)
HTTP_CODE_FILE=$(mktemp)

# Cleanup function to remove temporary files
cleanup() {
  rm -f "$RESPONSE_FILE" "$HTTP_CODE_FILE"
}
trap cleanup EXIT

# Make the CURL request with retry logic
MAX_RETRIES=3
RETRY_COUNT=0
SUCCESS=false

while [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; do
  if [[ $RETRY_COUNT -gt 0 ]]; then
    echo "⏳ Retry attempt $RETRY_COUNT of $MAX_RETRIES..."
    # Exponential backoff: 2^RETRY_COUNT seconds (2, 4, 8 seconds)
    sleep $((2 ** RETRY_COUNT))
  fi

  # Make the API call with timeout and capture both response and HTTP code
  HTTP_CODE=$(curl -s -w "%{http_code}" -o "$RESPONSE_FILE" \
    --max-time 120 \
    --location "$API_ENDPOINT" \
    --header 'Content-Type: application/json' \
    --data "$PAYLOAD" || echo "000")

  # Check if HTTP code indicates success
  if [[ "$HTTP_CODE" =~ ^2[0-9][0-9]$ ]]; then
    # Validate that response is valid JSON
    if jq -e . "$RESPONSE_FILE" > /dev/null 2>&1; then
      SUCCESS=true
      break
    else
      echo "⚠️  Received invalid JSON response (HTTP $HTTP_CODE)"
      RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
  elif [[ "$HTTP_CODE" == "000" ]]; then
    echo "⚠️  Connection failed or timeout"
    RETRY_COUNT=$((RETRY_COUNT + 1))
  else
    echo "❌ API returned HTTP $HTTP_CODE"
    cat "$RESPONSE_FILE"
    RETRY_COUNT=$((RETRY_COUNT + 1))
  fi
done

if [[ "$SUCCESS" != "true" ]]; then
  echo "❌ Failed to get successful response from $AGENT_NAME API after $MAX_RETRIES attempts"
  exit 1
fi

# Read the response
RESPONSE=$(cat "$RESPONSE_FILE")

echo "✅ $AGENT_NAME review completed successfully!"
echo "=================================="

# Set the action output with agent identification
# Escape the response for GitHub Actions output
{
  echo "response<<EOF"
  echo "$RESPONSE"
  echo "EOF"
  echo "agent=$AGENT_NAME"
  echo "agent_version=$AGENT_VERSION"
} >> "$GITHUB_OUTPUT"
