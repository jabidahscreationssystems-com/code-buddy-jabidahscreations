# Contributing to CodeBuddy

Thank you for your interest in contributing to CodeBuddy! This document provides guidelines and instructions for contributing.

## Getting Started

### Prerequisites
- Bash shell
- Docker
- Git
- Basic understanding of GitHub Actions

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/code-buddy-jabidahscreations.git
   cd code-buddy-jabidahscreations
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Guidelines

### Code Style

**Bash Scripts:**
- Use 2 spaces for indentation
- Always quote variables: `"$VARIABLE"`
- Use `set -euo pipefail` for error handling
- Add comments for complex logic
- Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

**Documentation:**
- Use clear, concise language
- Include examples
- Update README.md if adding new features
- Add comments to complex code

### Testing

Before submitting a pull request:

1. **Validate bash syntax:**
   ```bash
   bash -n entrypoint.sh
   ```

2. **Test the script locally:**
   ```bash
   # Set up test environment
   export GITHUB_OUTPUT=/tmp/test_output.txt
   
   # Run the script with test parameters
   bash entrypoint.sh "owner" "repo" "123" "token" "key" "stack" "2"
   ```

3. **Build the Docker image:**
   ```bash
   docker build -t codebuddy-test .
   ```

4. **Test the Docker image:**
   ```bash
   docker run --rm \
     -e GITHUB_OUTPUT=/tmp/output.txt \
     codebuddy-test \
     "owner" "repo" "123" "token" "key" "Node.js" "2"
   ```

### Making Changes

1. **Keep changes focused**: One feature or fix per pull request
2. **Write clear commit messages**: Use descriptive commit messages
   ```
   Add retry logic for API failures
   
   - Implements exponential backoff
   - Retries up to 3 times
   - Improves reliability
   ```
3. **Update documentation**: Update README.md if you add/change features
4. **Test thoroughly**: Test your changes in different scenarios

## Pull Request Process

1. **Update documentation**: Ensure README.md and other docs are updated
2. **Test your changes**: Run all tests and manual testing
3. **Create pull request**: 
   - Use a clear title
   - Describe what changes you made and why
   - Reference any related issues
4. **Address feedback**: Respond to review comments promptly
5. **Keep PR updated**: Rebase on main if needed

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Security fix

## Testing
- [ ] Tested locally
- [ ] Docker image builds successfully
- [ ] Script syntax validated
- [ ] No security vulnerabilities introduced

## Checklist
- [ ] Documentation updated
- [ ] SECURITY.md reviewed (if applicable)
- [ ] Examples updated (if applicable)
```

## Areas for Contribution

### High Priority
- Additional error handling scenarios
- Support for more code review providers
- Performance improvements
- Better error messages

### Medium Priority
- Additional output formats
- Caching mechanisms
- Metrics and analytics
- Integration tests

### Documentation
- More examples
- Video tutorials
- Troubleshooting guides
- Translation to other languages

## Security

If you discover a security vulnerability:
- **Do NOT** create a public issue
- See [SECURITY.md](SECURITY.md) for reporting instructions

## Code of Conduct

### Our Standards
- Be respectful and inclusive
- Accept constructive criticism
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior
- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing others' private information
- Any conduct inappropriate in a professional setting

## Questions?

- Open an issue for general questions
- Check existing issues and discussions first
- Be patient and respectful

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes (for significant contributions)
- README.md (for major features)

Thank you for contributing to CodeBuddy! 🎉
