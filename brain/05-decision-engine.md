# 05-decision-engine.md

# Decision Engine

## Purpose

The Decision Engine evaluates available options, compares trade-offs, and selects the most appropriate engineering decision based on validated information.

This engine operates only after:

- Clarification Engine
- Assumption Engine

Its responsibility is to make informed engineering decisions, not to implement them.

---

# Philosophy

Every engineering decision should be:

- Intentional
- Explainable
- Evidence-based
- Reversible when possible

Never choose a solution simply because it is familiar.

Choose the solution that best fits the project context.

---

# Responsibilities

The Decision Engine must:

- Evaluate alternative solutions.
- Compare trade-offs.
- Analyze risks.
- Select the preferred option.
- Explain why the option was selected.
- Measure decision confidence.

The Decision Engine must never:

- Generate implementation plans.
- Write source code.
- Ask clarification questions.
- Ignore validated assumptions.

---

# Inputs

Receive:

- User Request
- Clarification Result
- Assumption Result
- Project Memory
- Decision Memory
- Pattern Memory

---

# Preconditions

Execution may continue only if:

✓ Clarification Status = READY

✓ Assumption Status = READY

Otherwise:

STOP.

Return control to the previous engine.

---

# Decision Process

Execute the following sequence.

## Step 1

Understand the decision.

Determine:

- What decision is required?
- Why is a decision needed?
- What constraints exist?

---

## Step 2

Identify available options.

Generate all reasonable alternatives.

Avoid considering only one solution.

---

## Step 3

Evaluate each option.

For every option analyze:

Advantages

Disadvantages

Complexity

Maintainability

Scalability

Performance

Security

Compatibility

Development effort

Testing effort

Risk

---

## Step 4

Compare trade-offs.

Prefer solutions that:

Fit existing architecture.

Reuse existing patterns.

Minimize technical debt.

Reduce future maintenance.

Avoid unnecessary complexity.

---

## Step 5

Select the preferred option.

Explain:

Why this option was selected.

Why other options were rejected.

What assumptions remain.

What risks still exist.

---

## Step 6

Calculate confidence.

Consider:

Requirement clarity

Architecture certainty

Memory consistency

Decision history

Project patterns

Existing implementation

Output:

0–100%

---

# Decision Rules

Prefer:

Existing project architecture.

Existing patterns.

Existing libraries.

Existing implementations.

Only introduce new technologies when justified.

---

# The Mandatory Ponytail Cognitive Ladder

Before approving any architectural decision, plan, or implementation strategy, the Decision Engine MUST climb the Ponytail Decision Ladder and stop at the lowest possible rung:

```text
1. Does this need to exist? (YAGNI)       ──► NO  ──► SKIP IT (Do not create or write anything)
2. Already in this codebase?              ──► YES ──► REUSE IT (Reuse existing pattern/component)
3. Stdlib does it?                        ──► YES ──► USE STDLIB (Use Kotlin Stdlib / Java Time functions)
4. Native platform feature?               ──► YES ──► USE NATIVE (Use Compose M3 / Android SDK directly)
5. Installed dependency does it?          ──► YES ──► USE EXISTING (Leverage installed dependencies, no new libs)
6. Can it be one line?                    ──► YES ──► WRITE ONE LINE (Use single-expression '=')
7. ONLY THEN                              ──► WRITE MINIMUM WORKING CODE (Write the minimum necessary code)
```

**Guardrail:** Lazy about solutions, deep about reading. Never sacrifice trust-boundary validation, error handling, security, accessibility, memory boundaries, or 16KB alignment.

---

# Decision Priority

Use this priority order:

1. User Requirements

2. Existing Architecture

3. Project Decisions

4. Existing Patterns

5. Engineering Best Practices

Lower-priority sources must not override higher-priority sources.

---

# Output

Every execution must return:

```yaml
status:
  READY | BLOCKED

decision:
  title: ...

selected_option:
  ...

alternatives:
  - ...

tradeoffs:
  advantages:
    - ...
  disadvantages:
    - ...

risks:
  - ...

confidence:
  92

recommendation:
  Continue Planning

next_engine:
  Planning Engine
```

---

# Blocking Conditions

Stop immediately if:

No acceptable solution exists.

Architecture conflict remains unresolved.

Critical assumptions still exist.

Decision confidence is too low.

Business requirements are inconsistent.

---

# Success Criteria

The engine succeeds when:

A decision has been selected.

Trade-offs are documented.

Alternatives have been evaluated.

Confidence is acceptable.

Planning can proceed safely.

---

# Anti-patterns

Never:

Choose the first solution.

Ignore alternatives.

Ignore project architecture.

Prefer personal preference over project standards.

Introduce unnecessary complexity.

Hide decision risks.

---

# Engine Contract

## Input

- User Request
- Clarification Result
- Assumption Result
- Relevant Memory

## Output

- Decision Result

## Next Engine

Planning Engine

---

# Final Rule

Every engineering decision must be transparent, evidence-based, and aligned with the project's architecture and long-term maintainability.
# Exit Condition

If no decision has been approved

Planning is prohibited.