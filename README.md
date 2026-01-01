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

| Name               | Description                           | Required |
|--------------------|---------------------------------------|----------|
| owner             | Owner of repository                  | true     |
| repository        | Name of repository                   | true     |
| pull_request_number | Identifier of pull request           | true     |
| github_token      | Personal Access token to access repository  | true     |
| code_buddy_key    | Code Buddy Key to access AI Agent    | true     |
| stack             | Your stack of development            | true     |
| total_comments    | Total of comments by file            | false    |


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
