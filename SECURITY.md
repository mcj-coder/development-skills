# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. Please report them responsibly.

### How to Report

**Do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **GitHub Security Advisories (Preferred)**:
   - Navigate to the Security tab of this repository
   - Click "Report a vulnerability"
   - Follow the prompts to submit your report

2. **Email**:
   - Send details to the repository maintainer
   - Use the subject line: `[SECURITY] development-skills - Brief Description`

### What to Include

Please include the following in your report:

- Type of vulnerability
- Location of the affected source code (file path, line numbers)
- Steps to reproduce the issue
- Proof of concept or exploit code (if available)
- Impact assessment
- Suggested fix (if you have one)

### Response Timeline

| Action                         | Timeframe           |
| ------------------------------ | ------------------- |
| Initial response               | Within 48 hours     |
| Triage and severity assessment | Within 1 week       |
| Fix development                | Based on severity   |
| Security advisory publication  | After fix available |

### Severity-Based Response

| Severity | Fix Timeline    |
| -------- | --------------- |
| Critical | Within 48 hours |
| High     | Within 1 week   |
| Medium   | Within 1 month  |
| Low      | Best effort     |

## What to Expect

1. **Acknowledgment**: We will acknowledge receipt of your report within 48 hours.

2. **Communication**: We will keep you informed of our progress.

3. **Credit**: If you wish, we will credit you in the security advisory.

4. **Confidentiality**: Please keep the vulnerability confidential until we release a fix.

## Security Best Practices

When contributing to this project:

- Never commit secrets or credentials
- Use environment variables for sensitive configuration
- Follow the principle of least privilege
- Validate and sanitize all inputs
- Keep dependencies up to date
