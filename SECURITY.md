# Security Policy

## Security Features

CodeBuddy implements several security best practices:

### 1. Secure Communication
- **HTTPS by default**: All API communications use HTTPS to prevent man-in-the-middle attacks
- **Configurable endpoint**: API endpoint is configurable as an input parameter, not hardcoded
- **No hardcoded credentials**: All sensitive data (tokens, keys) are passed as inputs

### 2. Input Validation
- **Required parameter validation**: All required parameters are validated before making API calls
- **JSON injection prevention**: Uses `jq` for safe JSON construction, preventing injection attacks
- **Proper shell quoting**: All variables are properly quoted to prevent command injection

### 3. Error Handling
- **Secure error messages**: Error messages don't expose sensitive information
- **HTTP status validation**: Validates HTTP response codes before processing responses
- **JSON validation**: Validates API responses are valid JSON before processing

### 4. Data Handling
- **Temporary file cleanup**: Automatically removes temporary files using trap handlers
- **No data persistence**: No sensitive data is written to disk (except temporary files that are cleaned up)
- **Proper output escaping**: GitHub Actions output is properly escaped using heredoc syntax

## Reporting a Vulnerability

If you discover a security vulnerability in CodeBuddy, please report it by:

1. **Do NOT** create a public GitHub issue
2. Email the maintainers directly (check repository for contact information)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Best Practices for Users

When using CodeBuddy in your workflows:

### 1. Protect Your Secrets
```yaml
# ✅ Good: Use GitHub secrets
code_buddy_key: "${{ secrets.CODE_BUDDY_KEY }}"
github_token: "${{ secrets.GITHUB_TOKEN }}"

# ❌ Bad: Never hardcode secrets
code_buddy_key: "my-secret-key-12345"
```

### 2. Limit Permissions
```yaml
# Give minimal required permissions
permissions:
  contents: read
  pull-requests: write
```

### 3. Restrict to Internal PRs
```yaml
# Only run on PRs from the same repository
if: github.event.pull_request.head.repo.full_name == github.repository
```

### 4. Use Branch Protection
- Enable branch protection rules on your main branch
- Require status checks to pass before merging
- Require pull request reviews

### 5. Audit API Endpoint
```yaml
# If using custom endpoint, ensure it's HTTPS
api_endpoint: "https://your-endpoint.com/api"  # ✅ HTTPS
api_endpoint: "http://your-endpoint.com/api"   # ❌ Insecure
```

## Dependencies

CodeBuddy uses minimal dependencies:
- `alpine:3.19` - Base image (pinned version for security)
- `bash` - Shell scripting
- `curl` - HTTP client
- `jq` - JSON processor
- `ca-certificates` - SSL/TLS certificates

All dependencies are installed from official Alpine package repositories.

## Security Updates

- We recommend always using the latest version of CodeBuddy
- Security updates will be released promptly when vulnerabilities are discovered
- Subscribe to repository releases to stay informed

## Compliance

CodeBuddy is designed to:
- Not store or log sensitive data
- Use encrypted communication (HTTPS)
- Follow GitHub Actions security best practices
- Comply with common security standards (OWASP, CWE)

## Additional Resources

- [GitHub Actions Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
