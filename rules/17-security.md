# 17-security.md

# Purpose

This document defines the project's security architecture and secure development rules.

Security must be considered throughout the entire software lifecycle.

Every feature should protect:

- User data
- Credentials
- Files
- Network communication
- Application integrity
- Privacy

Security is a fundamental requirement, not an optional enhancement.

---

# Security Principles

Follow these principles:

- Least Privilege
- Defense in Depth
- Secure by Default
- Fail Securely
- Principle of Minimal Exposure

Never sacrifice security for convenience.

---

# Security Ownership

Security applies across every layer.

Presentation

- Protect user privacy

Domain

- Validate business rules

Data

- Secure storage
- Secure communication

Infrastructure

- Protect secrets
- Protect integrity

Security is everyone's responsibility.

---

# Sensitive Data

Sensitive data includes:

- Tokens
- API Keys
- Passwords
- Refresh Tokens
- Session IDs
- Encryption Keys
- User Identifiers
- Private Files

Treat all sensitive information as confidential.

---

# Secret Management

Never hardcode:

- API Keys
- Tokens
- Secrets
- Passwords

Preferred:

```text
BuildConfig

↓

Encrypted Storage

↓

Remote Configuration
```

Never commit secrets into source control.

---

# Secure Storage

Sensitive information must be stored using encrypted storage.

Preferred:

- EncryptedSharedPreferences
- Android Keystore
- Encrypted File
- Credential Manager (when appropriate)

Avoid storing secrets in plain text.

---

# Authentication

Authentication must be centralized.

Never duplicate login logic.

Support:

- Token expiration
- Token refresh
- Session invalidation

---

# Authorization

Always verify authorization before performing protected actions.

Never rely only on UI restrictions.

Server-side authorization is authoritative.

---

# Network Security

All network communication must use HTTPS.

Never transmit sensitive information over unsecured connections.

Validate server certificates.

---

# Certificate Validation

Use proper certificate validation.

Avoid disabling SSL verification.

Never bypass certificate errors in production.

---

# Token Handling

Tokens should:

- Be encrypted at rest
- Be transmitted only over HTTPS
- Be refreshed securely
- Be cleared on logout

Never log tokens.

---

# Logging

Never log:

- Passwords
- Tokens
- Cookies
- API Keys
- Personal Information

Logs should contain only diagnostic information.

---

# Permission Rules

Request only permissions required by the feature.

Request permissions only when needed.

Avoid requesting permissions during application startup.

---

# Input Validation

Validate every external input.

Examples:

- User input
- Intent extras
- Deep links
- API responses
- File paths

Never trust external data.

---

# SQL Security

Always use parameterized queries.

Avoid constructing SQL manually.

Prevent SQL injection.

---

# File Security

Validate:

- File existence
- File size
- File extension
- MIME type
- Access permissions

Avoid trusting file names alone.

---

# URI Handling

Treat every external URI as untrusted.

Validate before opening.

Avoid unrestricted file access.

---

# Web Content

If using WebView:

Disable unnecessary capabilities.

Avoid:

- JavaScript interfaces unless required
- File access unless necessary

Validate every loaded URL.

---

# Clipboard

Do not copy sensitive information to the clipboard unless explicitly requested.

Clear sensitive clipboard content when appropriate.

---

# Screenshots

Sensitive screens should prevent screenshots when appropriate.

Example:

Authentication

Payment

Private Documents

---

# Backup

Exclude sensitive data from application backups.

Protect encrypted data appropriately.

---

# Root Detection

Do not depend solely on root detection.

Use it only as one signal in a broader security strategy.

---

# Code Obfuscation

Release builds should enable:

- R8
- Code shrinking
- Resource shrinking

Keep rules should be minimal and documented.

---

# Dependency Security

Only use trusted libraries.

Regularly update dependencies.

Remove unused dependencies.

Monitor known vulnerabilities.

---

# Integrity

Verify application integrity when appropriate.

Examples:

- Play Integrity API
- Signature validation

Do not rely solely on client-side validation.

---

# Privacy

Collect only necessary user data.

Avoid excessive data collection.

Respect user consent.

Comply with platform privacy requirements.

---

# Error Messages

Do not expose internal implementation details.

Bad:

```text
SQL Exception at UserDao.kt:54
```

Good:

```text
Unable to complete the request.
Please try again.
```

---

# Release Builds

Release builds must:

- Disable debug logging
- Disable debug tools
- Remove test endpoints
- Remove mock data
- Enable shrinking

Never ship debug configurations.

---

# Testing

Security should be tested.

Verify:

- Authentication
- Authorization
- Input validation
- Secure storage
- Permission handling

Include security scenarios in testing.

---

# Review Checklist

Before completing a feature:

□ No hardcoded secrets

□ Secure storage used

□ HTTPS enforced

□ Sensitive logs removed

□ Input validated

□ Permissions minimized

□ Release configuration verified

□ Dependencies reviewed

□ Privacy considered

□ Security tested

---

# Anti-patterns

Do not:

Hardcode API Keys

Do not:

Store passwords in SharedPreferences

Do not:

Disable SSL validation

Do not:

Trust client-side validation

Do not:

Log tokens

Do not:

Expose stack traces

Do not:

Request unnecessary permissions

---

# Decision Priority

When making security decisions:

1. Protect user data

2. Minimize exposure

3. Validate all inputs

4. Secure storage

5. Secure communication

6. Privacy

7. Maintainability

---

# Final Rule

Security should be built into every feature from the beginning.

Every implementation should minimize risk, protect user data, and follow the principle of least privilege while remaining maintainable and testable.