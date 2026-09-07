---
name: testing-validation
description: Phase 7 workflow to perform end-to-end functional, architectural, integration, state, edge-case, and automated test validation before finalizing tasks.
triggers:
  - "testing validation"
  - "test and validate"
  - "kiểm thử và xác minh"
prerequisites:
  - ".antigravity/workflow/06-code-review.md"
next_step: ".antigravity/workflow/08-performance-review.md"
---
# 07-testing-validation.md

# Purpose

This document defines the validation workflow that every implementation must complete before being considered finished.

Validation ensures that the implementation satisfies functional, architectural, and quality requirements.

Testing is one part of validation.

Validation is mandatory.

---

# Philosophy

Passing unit tests does not guarantee correctness.

Validation verifies the entire implementation.

Always validate before completion.

---

# Validation Principles

Always:

Validate incrementally.

Validate objectively.

Validate behavior rather than assumptions.

Verify the complete user flow.

Never assume correctness because the code compiles.

---

# Validation Workflow

Every implementation follows this workflow.

```text
Implementation
        │
        ▼
Build Validation
        │
        ▼
Functional Validation
        │
        ▼
Architecture Validation
        │
        ▼
Integration Validation
        │
        ▼
Regression Validation
        │
        ▼
User Experience Validation
        │
        ▼
Testing Validation
        │
        ▼
Ready
```

---

# Step 1 — Build Validation (Mandatory Real Compiler Execution)

The AI MUST execute real compilation and testing commands in the terminal:
- `./gradlew compileDebugKotlin` (Verify 0 compilation errors)
- `./gradlew testDebugUnitTest` (Verify unit tests pass)
- In KMP projects: `./gradlew compileCommonMainKotlinMetadata`

**ABSOLUTE INVARIANT:**
NEVER declare validation complete based solely on editing files.
A task is only validated when terminal output explicitly confirms `BUILD SUCCESSFUL`.

Build success with ZERO errors is the non-negotiable baseline.

---

# Step 2 — Functional Validation

Verify:

- Feature behaves correctly
- Business rules satisfied
- Expected outputs produced
- Invalid inputs handled

Validate functionality before optimization.

---

# Step 3 — Architecture Validation

Verify:

- Layer boundaries respected
- Module boundaries preserved
- Dependency direction correct
- Engineering Rules followed

No architectural regressions allowed.

---

# Step 4 — Integration Validation

Verify interactions between:

- UI
- ViewModel
- UseCase
- Repository
- API
- Database
- Navigation

Ensure components work together.

---

# Step 5 — State Validation

Verify all supported states.

Examples:

Loading

Success

Empty

Error

Retry

Cancelled

No state should be unreachable.

---

# Step 6 — User Flow Validation

Validate the complete user journey.

Examples:

Launch

↓

Navigate

↓

Perform Action

↓

Observe Result

↓

Return

The entire flow should succeed.

---

# Step 7 — Edge Case Validation

Verify:

- Empty input
- Invalid input
- Null values
- Offline mode
- Slow network
- Configuration changes
- Process recreation

Edge cases should be predictable.

---

# Step 8 — Regression Validation

Ensure existing behavior remains correct.

Verify:

- Existing features
- Shared components
- Navigation
- Repositories
- Existing tests

Avoid introducing regressions.

---

# Step 9 — Error Recovery Validation

Verify:

- Retry
- Recovery
- Failure messaging
- Graceful degradation

The application should recover whenever possible.

---

# Step 10 — User Experience Validation

Verify:

- Loading feedback
- Error messages
- Empty states
- Accessibility
- Responsiveness

The implementation should feel complete.

---

# Step 11 — Performance Validation

Verify:

- No unnecessary recomposition
- Smooth scrolling
- Responsive interactions
- Efficient database queries
- Efficient network usage

Performance regressions are failures.

---

# Step 12 — Security Validation

Verify:

- Sensitive data protected
- Secure storage
- Safe logging
- Input validation
- Correct permissions

Security must remain intact.

---

# Step 13 — Testing Validation

Verify:

- Unit tests pass
- Integration tests pass
- UI tests pass (if applicable)
- Benchmark tests pass (if applicable)

All relevant automated tests should succeed.

---

# Deliverables

Validation should produce:

- Validation Report
- Functional Verification
- Architecture Verification
- Regression Summary
- Test Results
- Known Limitations

---

# Validation Checklist

Before completing a task:

□ Build succeeds

□ Feature works

□ Rules respected

□ Architecture preserved

□ Integration verified

□ Edge cases handled

□ User flow validated

□ Regression checked

□ Performance acceptable

□ Security verified

□ Tests passed

---

# Anti-patterns

Do not:

Assume build success equals feature success.

Do not:

Skip manual validation.

Do not:

Ignore regression risks.

Do not:

Ignore edge cases.

Do not:

Release with failing tests.

Do not:

Validate only the happy path.

---

# Decision Priority

When validating:

1. Functional correctness

2. Architecture integrity

3. Regression prevention

4. User experience

5. Performance

6. Security

7. Test results

---

# Exit Criteria

Validation is complete only if:

✓ Feature behaves correctly

✓ Architecture preserved

✓ No regression detected

✓ User flow verified

✓ Performance acceptable

✓ Security maintained

✓ Tests successful

---

# Final Rule

Implementation is complete only after successful validation.

Validation confirms that the software behaves correctly in real usage, not merely that it compiles or passes isolated tests.