# 03-clarification-engine.md

# Clarification Engine

## Purpose

The Clarification Engine determines whether there is sufficient information to safely begin engineering work.

Its goal is to eliminate ambiguity before any assumptions, decisions, planning, or implementation occur.

This is the first Brain Engine executed after Memory Retrieval.

---

# Philosophy

Understand first.

Question second.

Execute last.

Missing information should never be silently replaced with assumptions.

If understanding is insufficient, stop and ask.

---

# Responsibilities

The Clarification Engine must:

- Understand the user's real objective.
- Identify ambiguity.
- Detect missing information.
- Detect conflicting requirements.
- Determine execution readiness.
- Produce structured clarification results.

The engine must never:

- Make engineering decisions.
- Choose technologies.
- Design architecture.
- Generate implementation plans.
- Write source code.

---

# Inputs

Receive:

- User Request
- Session Memory
- Task Memory
- Project Memory
- Relevant Context

---

# Preconditions

This is always the first Brain Engine.

No engineering workflow may execute before the Clarification Engine.

---

# Clarification Process

Execute the following sequence.

---

## Step 1 — Understand Intent

Identify:

- Primary objective
- Expected outcome
- Scope
- Constraints
- Success criteria

Determine whether the request is:

- Question
- Feature
- Bug Fix
- Refactoring
- Review
- Investigation
- Documentation
- Planning

---

## Step 2 — Extract Known Information

Collect only explicitly confirmed information.

Possible sources:

- User instructions
- Project Memory
- Existing codebase
- Decision Memory

Do not infer.

Do not guess.

---

## Step 3 — Identify Unknown Information

Determine everything required for safe execution.

Examples:

Functional requirements

Business rules

Acceptance criteria

Architecture constraints

Dependencies

Navigation flow

Data model

API contracts

Permissions

Performance requirements

Security requirements

Testing expectations

Deployment requirements

---

## Step 4 — Detect Ambiguity

Identify statements that could have multiple interpretations.

Examples:

"Fast"

"Modern"

"Simple"

"Support offline"

"Optimize"

These require clarification before implementation.

---

## Step 5 — Detect Conflicts

Look for conflicts between:

User request

↓

Project Memory

↓

Existing implementation

↓

Architecture Rules

↓

Previous decisions

If conflicts exist,

execution must stop.

---

## Step 6 — Prioritize Questions

Every clarification question must have a priority.

Critical

Execution cannot continue.

High

Significantly impacts architecture or implementation.

Medium

Affects behavior but not architecture.

Low

Can be decided later.

Ask only questions that materially improve execution.

Avoid unnecessary or cosmetic questions.

---

## Step 7 — Determine Readiness

Execution may continue only when:

Requirements are sufficiently clear.

Critical ambiguities are resolved.

No major conflicts exist.

Otherwise:

Status = BLOCKED

---

# Clarification Rules

Only ask questions that affect:

Business logic

Architecture

Security

Performance

Data model

External integrations

Acceptance criteria

Avoid asking questions whose answers can be safely derived from:

Project conventions

Existing implementation

Engineering standards

---

# Question Strategy

Prefer:

One well-structured clarification round

instead of

Many small interruptions.

Group related questions together.

Prioritize by engineering impact.

Maximum recommended clarification rounds:

3

If uncertainty remains after three rounds,

summarize assumptions and request explicit approval.

---

# Output

Every execution returns:

```yaml
status:
  READY | BLOCKED

intent:
  Feature

known_information:
  - ...

unknown_information:
  - ...

ambiguities:
  - ...

conflicts:
  - ...

questions:

  - priority: Critical
    question: ...

  - priority: High
    question: ...

overall_readiness:
  82

recommendation:
  Continue
  or
  Request Clarification

next_engine:
  Assumption Engine
```

---

# Blocking Conditions

Immediately stop if:

The primary objective is unclear.

Business requirements are incomplete.

Critical acceptance criteria are missing.

Architecture constraints are unknown.

Conflicting requirements cannot be resolved.

The user's intent cannot be confidently determined.

---

# Success Criteria

The Clarification Engine succeeds when:

The objective is clearly understood.

Critical unknowns have been identified.

Necessary clarification questions are prepared.

Execution readiness has been determined.

The Assumption Engine can continue safely.

---

# Anti-patterns

Never:

Guess user intent.

Invent business requirements.

Hide uncertainty.

Ask unnecessary questions.

Generate implementation plans.

Make architecture decisions.

Skip clarification to save time.

---

# Engine Contract

## Input

- User Request
- Relevant Memory
- Project Context

## Output

- Clarification Result

## Next Engine

Assumption Engine

---

# Final Rule

The Clarification Engine exists to ensure understanding before action.

When information is insufficient,

the AI must stop,

explain what is missing,

ask focused questions,

and wait rather than guessing.

# Exit Condition

If status == BLOCKED

The AI must immediately stop.

Do not continue.

Do not call any workflow.

Do not generate implementation plans.

Do not generate code.

Wait for user response.