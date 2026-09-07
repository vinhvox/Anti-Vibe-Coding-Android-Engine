# 04-assumption-engine.md

# Assumption Engine

## Purpose

The Assumption Engine identifies, evaluates, and manages assumptions that may influence engineering decisions.

It operates only after the Clarification Engine.

Its responsibility is not to invent missing information, but to explicitly identify what is known, what is unknown, and what is being assumed.

All assumptions must be visible, traceable, and reviewable.

---

# Core Principle

Assumptions are temporary.

Facts are permanent.

Never treat assumptions as facts.

Every assumption must have a confidence level and an explicit owner.

---

# Responsibilities

The Assumption Engine must:

- Identify implicit assumptions.
- Separate facts from assumptions.
- Evaluate the impact of assumptions.
- Determine whether execution can continue.
- Produce structured assumption results.

The Assumption Engine must never:

- Ask clarification questions.
- Make architecture decisions.
- Select implementation strategies.
- Generate code.

---

# Inputs

Receive:

- Clarification Result
- User Request
- Retrieved Memory
- Project Context

---

# Preconditions

The Clarification Engine must complete successfully.

If Clarification Result is:

Status = BLOCKED

Immediately stop.

Return control to the Clarification Engine.

---

# Assumption Process

Execute the following steps.

---

## Step 1

Collect verified facts.

Only include information explicitly confirmed by:

- User
- Project Memory
- Decision Memory
- Architecture Rules
- Existing Codebase

Never infer.

---

## Step 2

Identify assumptions.

Examples:

Technology choice

API behavior

Business rules

Navigation flow

Authentication

Storage

Permissions

Third-party services

Default values

Error handling

---

## Step 3

Categorize assumptions.

Every assumption belongs to one category.

Technical

Business

Architecture

Infrastructure

UX

Performance

Security

Testing

Deployment

---

## Step 4

Evaluate impact.

Each assumption must be classified.

Critical

Incorrect assumption would invalidate architecture.

High

Incorrect assumption causes major implementation changes.

Medium

Implementation changes only.

Low

Minor behavior changes.

---

## Step 5

Evaluate confidence.

Each assumption receives a confidence score.

100%

Confirmed fact.

90%

Verified by project memory.

75%

Strong engineering evidence.

50%

Reasonable but unverified.

25%

Weak assumption.

0%

Pure speculation.

---

## Step 6

Determine execution status.

Execution may continue only when:

No Critical assumption remains unresolved.

Otherwise:

Status = BLOCKED

---

# Assumption Rules

Never silently create assumptions.

Every assumption must be:

Explicit

Visible

Traceable

Reviewable

Explainable

---

# Assumption Validation

Before accepting an assumption verify:

Does it conflict with project memory?

Does it conflict with user requirements?

Does it conflict with architecture?

Does it conflict with existing patterns?

If conflict exists:

Reject the assumption.

---

# Assumption Priority

Prefer information from:

1. Current User Instruction
2. Project Memory
3. Decision Memory
4. Existing Codebase
5. Architecture Rules
6. Engineering Best Practices

Lower-priority sources may never override higher-priority sources.

---

# Output

Every execution produces:

```yaml
status: READY | BLOCKED

facts:
  - ...

assumptions:
  - description: ...
    category: Technical
    impact: High
    confidence: 75

critical_assumptions:
  - ...

rejected_assumptions:
  - ...

overall_confidence: 82

next_engine: Decision Engine
```

---

# Blocking Conditions

Immediately stop if:

A Critical assumption exists.

Architecture depends on an unverified assumption.

Security depends on an assumption.

Business rules are unknown.

Project Memory conflicts with assumptions.

Return control to the user or Clarification Engine.

---

# Success Criteria

The Assumption Engine succeeds when:

Facts and assumptions are clearly separated.

All assumptions are categorized.

Critical assumptions are resolved.

Confidence is calculated.

The next engine can reason safely.

---

# Anti-patterns

Never:

Treat assumptions as facts.

Hide assumptions.

Invent business logic.

Guess project architecture.

Continue with Critical assumptions unresolved.

Ignore conflicting evidence.

---

# Engine Contract

Input:

- Clarification Result
- Project Context
- Memory

Output:

- Assumption Result

Next Engine:

Decision Engine

---

# Final Rule

Assumptions are temporary engineering hypotheses.

The AI must expose them,

measure them,

validate them,

and remove them as soon as evidence becomes available.

# Exit Condition

If unresolved assumptions exist

Return BLOCKED.

Planning is prohibited.