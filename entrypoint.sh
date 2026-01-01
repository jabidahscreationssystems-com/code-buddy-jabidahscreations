#!/bin/bash

# Exit on error
set -e

# Agent identification
AGENT_NAME="CodeBuddy"
AGENT_VERSION="v1.0.0"

echo "=================================="
echo "🤖 Agent: $AGENT_NAME $AGENT_VERSION"
echo "=================================="

# Read input parameters
OWNER="$1"
REPOSITORY="$2"
PULL_REQUEST_NUMBER="$3"
GITHUB_TOKEN="$4"
CODE_BUDDY_KEY="$5"
STACK="$6"
TOTAL_COMMENTS="$7"

echo "📊 Analyzing PR #$PULL_REQUEST_NUMBER in $OWNER/$REPOSITORY"

# Construct the payload for the request
PAYLOAD=$(cat <<EOF
{
  "owner": "$OWNER",
  "repository": "$REPOSITORY",
  "pullRequestNumber": "$PULL_REQUEST_NUMBER",
  "githubToken": "$GITHUB_TOKEN",
  "codeBuddyKey": "$CODE_BUDDY_KEY",
  "stack": "$STACK",
  "totalComments": ${TOTAL_COMMENTS:-null},
  "agentName": "$AGENT_NAME",
  "agentVersion": "$AGENT_VERSION"
}
EOF
)

echo "🔍 $AGENT_NAME is reviewing your code..."

# Make the CURL request
RESPONSE=$(curl -s --location 'http://64.23.245.115:8080/v1/code-review-agent' \
  --header 'Content-Type: application/json' \
  --data "$PAYLOAD")

echo "✅ $AGENT_NAME review completed!"
echo "=================================="

# Set the action output with agent identification
echo "::set-output name=response::$RESPONSE"
echo "::set-output name=agent::$AGENT_NAME"
echo "::set-output name=agent_version::$AGENT_VERSION"
