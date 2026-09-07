---
name: release
description: Phase 10 workflow acting as the final quality gate to verify all architectural, test, performance, security, build, and documentation criteria before production release.
triggers:
  - "release"
  - "release readiness"
  - "release verification"
prerequisites:
  - ".antigravity/workflow/06-code-review.md"
  - ".antigravity/workflow/07-testing-validation.md"
  - ".antigravity/workflow/08-performance-review.md"
  - ".antigravity/workflow/09-security-review.md"
next_step: "task-completion"
---
# 10-release.md

# Purpose

This document defines the release readiness workflow.

Release is the final quality gate before delivering software to production.

The objective is to ensure that every implementation is stable, secure, tested, documented, and compliant with project standards.

A task is not complete until it passes release validation.

---

# Philosophy

Release is not the act of generating an APK.

Release is the confirmation that the software is ready for production.

Quality is verified before delivery.

---

# Core Principles

Always:

Release only tested software.

Release only reviewed code.

Release only secure implementations.

Release only documented changes.

Release only reproducible builds.

---

# Release Workflow

Every implementation follows this workflow.

```text
Implementation Complete
        │
        ▼
Code Review Completed
        │
        ▼
Testing Validation Passed
        │
        ▼
Performance Approved
        │
        ▼
Security Approved
        │
        ▼
Documentation Updated
        │
        ▼
Build Verification
        │
        ▼
Release Readiness
        │
        ▼
Ready for Production
```

---

# Step 1 — Verify Requirements

Confirm:

- Original requirements satisfied
- Acceptance criteria met
- Scope completed
- No unfinished mandatory work

Every requested capability should be implemented.

---

# Step 2 — Verify Architecture

Verify:

- Architecture preserved
- Layer boundaries respected
- Dependency rules followed
- No temporary implementations remain

Production code should not contain experimental architecture.

---

# Step 3 — Verify Code Review

Confirm:

- Code review completed
- Critical findings resolved
- High severity findings resolved
- Remaining issues documented

No unresolved critical issues may remain.

---

# Step 4 — Verify Testing

Verify:

- Unit tests passed
- Integration tests passed
- UI tests passed (if applicable)
- Manual validation completed

Release requires successful validation.

---

# Step 5 — Verify Performance

Confirm:

- Startup acceptable
- Rendering smooth
- Memory stable
- CPU usage acceptable
- Database efficient
- Network efficient
- Battery impact acceptable

Performance regressions must be resolved.

---

# Step 6 — Verify Security

Confirm:

- Security review completed
- Sensitive data protected
- Secrets secured
- Permissions reviewed
- Components protected

No known critical vulnerabilities may remain.

---

# Step 7 — Verify Build

Confirm:

- Release build successful
- No compilation warnings affecting release
- Correct signing configuration
- Correct build variant
- Required ProGuard/R8 rules applied

Release builds must be reproducible.

---

# Step 8 — Verify Dependencies

Review:

- Dependency versions
- Removed unused libraries
- No deprecated critical dependencies
- License compliance (if required)

Minimize unnecessary dependencies.

---

# Step 9 — Verify Documentation

Confirm updates when required:

- README
- Architecture
- Feature documentation
- Changelog
- Migration notes
- Release notes

Documentation should reflect the released implementation.

---

# Step 10 — Release Readiness Review

Perform the final review.

Verify:

- No blocking issues
- No unresolved critical bugs
- No release blockers
- Feature complete
- Build stable

Only approved implementations are release-ready.

---

# Deliverables

Release validation should produce:

- Release Report
- Build Status
- Test Summary
- Performance Summary
- Security Summary
- Documentation Summary
- Known Issues
- Release Approval

---

# Release Checklist

Before approving release:

□ Requirements satisfied

□ Architecture preserved

□ Code reviewed

□ Tests passed

□ Performance approved

□ Security approved

□ Documentation updated

□ Release build successful

□ Dependencies verified

□ No critical issues remaining

---

# Anti-patterns

Do not:

Release unreviewed code.

Do not:

Release failing builds.

Do not:

Release with unresolved critical bugs.

Do not:

Release without testing.

Do not:

Release without documentation.

Do not:

Release temporary implementations.

---

# Decision Priority

When determining release readiness:

1. Functional correctness

2. Stability

3. Security

4. Performance

5. Maintainability

6. Documentation

7. Build reproducibility

---

# Exit Criteria

Release is approved only if:

✓ Requirements completed

✓ Architecture preserved

✓ All mandatory reviews completed

✓ Tests passed

✓ Performance acceptable

✓ Security approved

✓ Documentation complete

✓ Build reproducible

✓ No release blockers remain

---

# Final Rule

A release represents a production-quality commitment.

Software is ready for release only when it satisfies functional, architectural, performance, security, testing, and documentation standards.