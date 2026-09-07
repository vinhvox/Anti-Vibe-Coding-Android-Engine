# 09-confidence-engine.md

# Confidence Engine

## Purpose

The Confidence Engine evaluates whether the AI has sufficient understanding and evidence to continue execution safely.

Its responsibility is not to measure intelligence.

Its responsibility is to measure decision reliability.

The Confidence Engine is the final validation gate before any workflow execution begins.

---

# Philosophy

Confidence is earned through evidence.

High confidence does not mean certainty.

Low confidence requires clarification.

Never continue execution when confidence is insufficient.

---

# Responsibilities

The Confidence Engine must:

- Measure overall confidence.
- Evaluate information completeness.
- Detect uncertainty.
- Determine execution readiness.
- Recommend whether execution should continue.

The Confidence Engine must never:

- Generate code.
- Make architecture decisions.
- Ignore uncertainty.
- Inflate confidence.

---

# Inputs

Receive:

- User Request
- Clarification Result
- Assumption Result
- Decision Result
- Project Memory
- Existing Codebase
- Engineering Rules

---

# Preconditions

Execution may begin only if:

✓ Clarification Status = READY

✓ Assumption Status = READY

✓ Decision Status = READY

Otherwise:

STOP.

Return control to the previous engine.

---

# Confidence Evaluation Process

Execute the following sequence.

---

## Step 1 — Requirement Confidence

Evaluate:

Requirement completeness

Requirement clarity

Acceptance criteria

Business rules

Expected behavior

Score:

0–100

---

## Step 2 — Technical Confidence

Evaluate:

Architecture understanding

Technology familiarity

Existing patterns

Dependencies

Project conventions

Score:

0–100

---

## Step 3 — Implementation Confidence

Evaluate:

Implementation feasibility

Complexity

Reuse opportunities

Testing feasibility

Estimated risk

Score:

0–100

---

## Step 4 — Memory Confidence

Evaluate:

Project Memory

Decision Memory

Pattern Memory

User Preference Memory

Consistency

Freshness

Score:

0–100

---

## Step 5 — Risk Confidence

Evaluate:

Architecture risk

Security risk

Performance risk

Migration risk

Maintenance risk

Score:

0–100

---

## Step 6 — Overall Confidence

Calculate the overall engineering confidence.

Suggested weighting:

Requirement: 30%

Technical: 25%

Implementation: 20%

Memory: 15%

Risk: 10%

Overall Confidence:

0–100

---

# Confidence Levels

95–100

Excellent

Execution may continue.

---

85–94

High

Execution may continue.

Monitor assumptions.

---

70–84

Moderate

Execution may continue.

Highlight uncertainties.

---

50–69

Low

Clarification recommended.

Avoid major architectural decisions.

---

Below 50

Critical

Execution must stop.

Return to Clarification Engine.

---

# Decision Rules

If Overall Confidence ≥ 85

Status = READY

---

If Overall Confidence is between 70–84

Status = READY_WITH_WARNINGS

---

If Overall Confidence is below 70

Status = BLOCKED

---

# Output

Every execution returns:

```yaml
status:
  READY
  READY_WITH_WARNINGS
  BLOCKED

confidence_breakdown:

  requirement: 95

  technical: 90

  implementation: 88

  memory: 93

  risk: 84

overall_confidence: 90

warnings:

  - ...

recommended_actions:

  - Continue

next_step:

  Workflow Execution
```

---

# Blocking Conditions

Immediately stop if:

Overall Confidence < 70

Critical requirements are missing.

Architecture confidence is too low.

Project Memory conflicts with implementation.

High-risk assumptions remain unresolved.

---

# Success Criteria

The engine succeeds when:

Confidence has been measured objectively.

Weak areas are identified.

Warnings are documented.

Execution readiness is determined.

Workflow execution can proceed safely.

---

# Anti-patterns

Never:

Assume confidence.

Ignore uncertainty.

Continue with low confidence.

Hide risks.

Inflate confidence without evidence.

Treat confidence as certainty.

---

# Engine Contract

## Input

- User Request
- Clarification Result
- Assumption Result
- Decision Result
- Project Context

## Output

- Confidence Result

## Next Step

Workflow Execution

---

# Final Rule

The Confidence Engine is the final safety gate before execution.

Execution should proceed only when confidence is supported by evidence.

When confidence is low,

the AI must stop,

explain why,

and seek additional information rather than guessing.