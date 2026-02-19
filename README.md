# CodeBuddy

The AI Code Review Partner For You!

Cut code reviews time, reduce bugs, improve your code quality with the power of LLM agents. Everything for free!

## Agent Identification

**CodeBuddy Agent** is clearly identified in all interactions to avoid confusion:
- Agent Name: **CodeBuddy**
- All code reviews are performed by the CodeBuddy Agent
- Agent information is included in the action outputs (`agent` and `agent_version`)
- Console output shows which agent is working (🤖 Agent: CodeBuddy)

## Before Usage

You need create a `code buddy key` at: https://codebuddy-react-nu.vercel.app


## Inputs

| Name               | Description                           | Required | Default |
|--------------------|---------------------------------------|----------|---------|
| owner             | Owner of repository                  | true     | - |
| repository        | Name of repository                   | true     | - |
| pull_request_number | Identifier of pull request           | true     | - |
| github_token      | Personal Access token to access repository  | true     | - |
| code_buddy_key    | Code Buddy Key to access AI Agent    | true     | - |
| stack             | Your stack of development            | true     | - |
| total_comments    | Total of comments by file            | false    | null |
| api_endpoint      | CodeBuddy API endpoint URL           | false    | https://codebuddy-api.vercel.app/v1/code-review-agent |


## Outputs

| Name           | Description                                                          |
|----------------|----------------------------------------------------------------------|
| response       | Returns the HTTP response from the CodeBuddy Agent request used to analyze the code. |
| agent          | Name of the agent that performed the review (CodeBuddy)             |
| agent_version  | Version of the CodeBuddy agent that performed the review            |


## Example usage

```yml
name: CodeBuddy CodeReview
on:
  pull_request:
    types: [ opened, synchronize ]

jobs:
  ai_agent_code_review:
    runs-on: ubuntu-latest
    name: Job to make automatic code review with LLM
    steps:
      - name: CodeBuddy Agent Code Review
        id: code_review
        uses: code-buddy-agent/code-buddy@v1.0.0
        with:
          owner: "${{ github.repository_owner }}"
          repository: code-buddy-agent
          pull_request_number: "${{ github.event.pull_request.number }}"
          github_token: "${{ secrets.GH_TOKEN }}"
          code_buddy_key: "${{ secrets.CODE_BUDDY_KEY }}"
          stack: "Java, Spring, Spring AI"
          total_comments: 2
      
      - name: Display Agent Information
        run: |
          echo "Review completed by: ${{ steps.code_review.outputs.agent }}"
          echo "Agent version: ${{ steps.code_review.outputs.agent_version }}"
```

## Features

### Security & Reliability
- ✅ HTTPS support for secure API communication
- ✅ Configurable API endpoint
- ✅ Input validation for all required parameters
- ✅ Retry logic with exponential backoff (3 attempts)
- ✅ Request/response timeout handling (120s)
- ✅ JSON injection prevention using jq
- ✅ HTTP status code validation
- ✅ Response validation (checks for valid JSON)

### Error Handling
- Clear error messages for missing parameters
- Detailed logging for debugging
- Proper exit codes on failure
- Automatic cleanup of temporary files

## Troubleshooting

### Common Issues

**Issue: "Error: code_buddy_key parameter is required"**
- Make sure you've created a CodeBuddy key at https://codebuddy-react-nu.vercel.app
- Add the key to your repository secrets as `CODE_BUDDY_KEY`

**Issue: "Connection failed or timeout"**
- Check your network connectivity
- Verify the API endpoint is accessible
- The action will automatically retry up to 3 times

**Issue: "API returned HTTP 4xx"**
- Verify your CodeBuddy key is valid
- Check that your GitHub token has proper permissions
- Ensure the repository and PR number are correct

**Issue: "Failed to get successful response after 3 attempts"**
- The CodeBuddy API might be temporarily unavailable
- Check the action logs for detailed error messages
- Try running the workflow again

### Custom API Endpoint

If you need to use a custom API endpoint (for self-hosted or testing):

```yml
- uses: code-buddy-agent/code-buddy@v1.0.0
  with:
    # ... other parameters ...
    api_endpoint: "https://your-custom-endpoint.com/v1/code-review-agent"
```

## Development

### Building the Docker Image

```bash
docker build -t codebuddy:latest .
```

### Testing Locally

```bash
docker run --rm \
  -e GITHUB_OUTPUT=/tmp/output.txt \
  codebuddy:latest \
  "owner" \
  "repository" \
  "123" \
  "github_token" \
  "code_buddy_key" \
  "Node.js, React" \
  "2"
```
