# 08-reflection-engine.md

# Reflection Engine

## Purpose

The Reflection Engine performs a comprehensive self-review after implementation to ensure engineering quality before considering the task complete.

Its responsibility is to identify issues, validate implementation quality, and recommend improvements.

Reflection always occurs after the Execution Engine.

---

# Philosophy

Implementation is not completion.

Completion requires verification.

The AI should critique its own work before anyone else does.

Every implementation deserves reflection.

---

# Responsibilities

The Reflection Engine must:

- Review implementation quality.
- Detect architecture violations.
- Identify potential bugs.
- Evaluate maintainability.
- Measure implementation confidence.
- Recommend improvements.

The Reflection Engine must never:

- Rewrite the implementation directly.
- Introduce new features.
- Change project requirements.
- Make architectural decisions.

---

# Inputs

Receive:

- User Request
- Planning Result
- Execution Result
- Modified Files
- Project Memory
- Engineering Rules

---

# Preconditions

Execution may begin only if:

✓ Execution Status = SUCCESS

Otherwise:

STOP.

Return control to the Execution Engine.

---

# Reflection Process

Execute the following sequence.

---

## Step 1 — Verify Requirements

Check:

Does the implementation satisfy the original request?

Does every planned task exist?

Are acceptance criteria fulfilled?

Has any requirement been missed?

---

## Step 2 — Architecture Review

Verify:

Project architecture remains consistent.

Layer boundaries are respected.

Dependencies follow project rules.

No architecture violations exist.

---

## Step 3 — Code Quality Review

Review:

Readability

Maintainability

Naming consistency

Code duplication

Modularity

Reusability

Documentation

---

## Step 4 — Reliability Review

Verify:

Null safety

Concurrency

Error handling

Edge cases

Unexpected inputs

Recovery behavior

---

## Step 5 — Performance Review

Evaluate:

Memory allocation

Compose recomposition

Lazy loading

Caching

Thread usage

IO operations

Database queries

Rendering efficiency

---

## Step 6 — Security Review

Verify:

Sensitive data exposure

Permission handling

Input validation

Authentication

Authorization

Encryption

Secure storage

---

## Step 7 — Testing Review

Determine:

Required unit tests

Required UI tests

Integration testing

Regression risks

Manual verification steps

---

## Step 8 — Improvement Opportunities

Identify:

Possible refactoring

Simplification

Performance optimization

Architecture improvements

Code reuse opportunities

Future enhancements

---

# Reflection Checklist

Review the implementation against:

✓ Requirements

✓ Architecture

✓ Coding Rules

✓ Performance

✓ Security

✓ Testing

✓ Maintainability

✓ Scalability

✓ Readability

✓ Project Conventions

---

# Reflection Rules

Be objective.

Identify strengths.

Identify weaknesses.

Support findings with evidence.

Avoid subjective opinions.

Do not invent issues.

---

# Output

Every execution returns:

```yaml
status:
  PASS | NEEDS_IMPROVEMENT | FAILED

summary:
  ...

strengths:
  - ...

issues:
  - ...

recommendations:
  - ...

performance_notes:
  - ...

security_notes:
  - ...

testing_recommendations:
  - ...

overall_quality:
  Excellent | Good | Fair | Poor

confidence:
  95

next_engine:
  Learning Engine
```

---

# Blocking Conditions

Stop immediately if:

Critical bugs are detected.

Architecture is violated.

Security vulnerabilities exist.

Implementation does not satisfy requirements.

Major regressions are likely.

Return control to the Execution Engine.

---

# Success Criteria

Reflection succeeds when:

Implementation satisfies requirements.

Architecture is preserved.

No critical issues remain.

Recommendations are documented.

Learning Engine can continue.

---

# Anti-patterns

Never:

Approve code without review.

Ignore architecture violations.

Ignore performance concerns.

Ignore security issues.

Ignore testing.

Recommend changes without evidence.

---

# Engine Contract

## Input

- Execution Result
- Project Context

## Output

- Reflection Result

## Next Engine

Learning Engine

---

# Final Rule

The Reflection Engine exists to ensure that implementation quality is verified before completion.

Every implementation should be reviewed,

every issue should be visible,

and every recommendation should be actionable.