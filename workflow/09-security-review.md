---
name: security-review
description: Phase 9 workflow to conduct threat modeling, input validation, secure storage, network security, Android component exposure, and privacy checks prior to release.
triggers:
  - "security review"
  - "kiểm tra bảo mật"
  - "audit security"
prerequisites:
  - ".antigravity/workflow/08-performance-review.md"
next_step: ".antigravity/workflow/10-release.md"
---
# 09-security-review.md

# Purpose

This document defines the security review workflow.

Every implementation must undergo a structured security review before release.

The objective is to identify vulnerabilities, reduce attack surfaces, and ensure compliance with the project's security standards.

Security is a mandatory quality requirement.

---

# Philosophy

Security should be built into the design.

Do not treat security as a final patch.

Every feature should minimize risk while preserving usability.

---

# Core Principles

Always:

Review security before release.

Protect sensitive information.

Validate all external inputs.

Minimize attack surfaces.

Follow the principle of least privilege.

---

# Security Review Workflow

Every implementation follows this workflow.

```text
Implementation
        │
        ▼
Threat Analysis
        │
        ▼
Input Validation Review
        │
        ▼
Permission Review
        │
        ▼
Storage Review
        │
        ▼
Network Review
        │
        ▼
Component Review
        │
        ▼
Dependency Review
        │
        ▼
Privacy Review
        │
        ▼
Ready
```

---

# Step 1 — Threat Analysis

Identify potential threats.

Examples:

- Data leakage
- Unauthorized access
- Intent spoofing
- Deep Link abuse
- File exposure
- Code injection
- MITM attacks

Understand the attack surface before reviewing implementation.

---

# Step 2 — Input Validation Review

Verify all external inputs.

Examples:

- Intent Extras
- Deep Link Parameters
- API Responses
- User Input
- File Paths
- Content Providers

Never trust external input.

---

# Step 3 — Permission Review

Verify:

- Runtime permissions requested only when needed
- Least privilege principle followed
- Dangerous permissions justified
- Permission denial handled gracefully

Avoid requesting unnecessary permissions.

---

# Step 4 — Storage Review

Review:

- SharedPreferences
- DataStore
- Room
- Internal Storage
- External Storage
- Cache

Sensitive data should not be stored in plain text.

Use Android Keystore and encrypted storage when appropriate.

---

# Step 5 — Network Review

Verify:

- HTTPS enforced
- Certificate validation enabled
- Network Security Config reviewed
- Timeouts configured
- Retry strategy appropriate
- Sensitive headers protected

Avoid insecure network communication.

---

# Step 6 — Authentication & Authorization Review

Verify:

- Tokens stored securely
- Session lifecycle managed
- Authorization checks enforced
- Logout clears sensitive data

Authentication should not rely on UI state.

---

# Step 7 — Android Component Review

Inspect:

- Activities
- Services
- Broadcast Receivers
- Content Providers

Verify:

- exported configuration
- Intent Filters
- Permission protection
- Component visibility

Expose only what is required.

---

# Step 8 — Deep Link Review

Verify:

- Supported hosts
- Path validation
- Parameter validation
- Navigation restrictions

Deep Links should not bypass authentication or business rules.

---

# Step 9 — FileProvider Review

Verify:

- Restricted paths
- Temporary URI permissions
- No unrestricted file sharing

Never expose private files unintentionally.

---

# Step 10 — WebView Review

If WebView is used, verify:

- JavaScript enabled only when required
- Safe Browsing enabled
- File access restricted
- Mixed content disabled
- addJavascriptInterface used safely

Treat WebView as an untrusted execution environment.

---

# Step 11 — Logging Review

Verify:

- No API keys in logs
- No tokens in logs
- No personal data in logs
- Debug logging removed or disabled in release builds

Logs should never expose sensitive information.

---

# Step 12 — Dependency Review

Review third-party libraries.

Verify:

- Trusted source
- Maintained versions
- No known critical vulnerabilities
- Minimal required permissions

Dependencies extend the application's attack surface.

---

# Step 13 — Privacy Review

Verify compliance with privacy requirements.

Examples:

- User consent
- Data minimization
- Purpose limitation
- Data retention
- Data deletion

Collect only data required for the feature.

---

# Step 14 — Backup & Export Review

Verify:

- allowBackup configuration
- Data extraction rules
- Backup exclusions
- Exported resources

Prevent unintended data exposure through backups.

---

# Step 15 — Secrets Review

Verify:

- API keys not hardcoded
- Secrets not committed to source control
- BuildConfig used appropriately
- Keystore protected

Secrets should be managed securely.

---

# Deliverables

Security review should produce:

- Threat Summary
- Attack Surface Analysis
- Security Findings
- Risk Assessment
- Recommended Actions
- Approval Status

---

# Review Checklist

Before completing security review:

□ Inputs validated

□ Permissions minimized

□ Secure storage used

□ Network secured

□ Components protected

□ Deep Links reviewed

□ FileProvider reviewed

□ WebView reviewed

□ Logging reviewed

□ Dependencies reviewed

□ Privacy reviewed

□ Secrets protected

---

# Anti-patterns

Do not:

Trust external input.

Do not:

Store secrets in plain text.

Do not:

Export components unnecessarily.

Do not:

Expose internal file paths.

Do not:

Log sensitive information.

Do not:

Disable TLS validation.

---

# Decision Priority

When reviewing security:

1. Protect user data

2. Minimize attack surface

3. Validate all inputs

4. Secure communication

5. Secure storage

6. Secure components

7. Privacy compliance

---

# Exit Criteria

Security review is complete only if:

✓ No critical vulnerabilities remain

✓ Sensitive data protected

✓ Components secured

✓ Network communication secure

✓ Storage secure

✓ Privacy requirements satisfied

✓ Security standards followed

---

# Final Rule

Security is not an optional enhancement.

Every implementation should reduce risk while preserving functionality, maintainability, and user trust.