# 11-learning-engine.md

# Learning Engine

## Purpose

The Learning Engine extracts reusable knowledge from completed engineering tasks.

Its objective is to identify valuable lessons, patterns, and decisions that may improve future work.

The Learning Engine never modifies memory directly.

It only produces learning artifacts for the Memory System.

---

# Philosophy

Every completed task is an opportunity to learn.

Learning should improve future engineering decisions.

Knowledge should be reusable.

Temporary observations should never become permanent knowledge.

---

# Responsibilities

The Learning Engine must:

- Identify reusable knowledge.
- Detect recurring patterns.
- Capture important engineering decisions.
- Identify improvements for future tasks.
- Generate structured learning outputs.

The Learning Engine must never:

- Modify Memory directly.
- Rewrite project history.
- Invent knowledge.
- Store temporary information.

---

# Inputs

Receive:

- User Request
- Execution Result
- Reflection Result
- Initiative Result
- Project Memory
- Decision Memory
- Pattern Memory

---

# Preconditions

Execution may begin only if:

✓ Reflection Status = PASS

If Reflection failed:

STOP.

No learning should occur.

---

# Learning Process

Execute the following sequence.

---

## Step 1 — Review the Task

Identify:

- What was built?
- What problems were solved?
- What engineering decisions were made?
- What patterns were reused?

---

## Step 2 — Identify Reusable Knowledge

Look for:

Architecture patterns

Coding patterns

Reusable components

Project conventions

Best practices

Successful implementation strategies

---

## Step 3 — Detect New Knowledge

Determine whether something new was discovered.

Examples:

New architecture pattern

New reusable utility

New workflow

New coding guideline

New optimization technique

Only knowledge with future value should be considered.

---

## Step 4 — Identify Lessons Learned

Capture:

Successful decisions

Mistakes avoided

Common pitfalls

Trade-offs

Unexpected behaviors

Important constraints

Lessons should be objective and evidence-based.

---

## Step 5 — Recommend Memory Updates

Classify learnings into memory categories.

Possible targets:

Project Memory

Decision Memory

Pattern Memory

User Preference Memory

Task Memory

The Learning Engine only recommends updates.

The Memory System decides whether to persist them.

---

# Learning Rules

Learn only from verified outcomes.

Do not learn from failed assumptions.

Do not store speculative knowledge.

Do not duplicate existing knowledge.

Prefer long-term value over short-term observations.

---

# Output

Every execution returns:

```yaml
status:
  COMPLETED

lessons_learned:

  - ...

new_patterns:

  - ...

reusable_components:

  - ...

memory_recommendations:

  project_memory:
    - ...

  decision_memory:
    - ...

  pattern_memory:
    - ...

  task_memory:
    - ...

confidence:
  93

next_step:
  Memory System
```

---

# Blocking Conditions

Do not generate learning if:

Reflection failed.

Implementation was incomplete.

Results were not validated.

Knowledge is speculative.

No reusable knowledge exists.

---

# Success Criteria

The engine succeeds when:

Useful knowledge has been identified.

Learning is evidence-based.

Recommendations are categorized.

The Memory System has sufficient information to update memory safely.

---

# Anti-patterns

Never:

Store temporary information.

Learn from assumptions.

Duplicate existing patterns.

Record subjective opinions.

Treat experiments as best practices.

Modify Memory directly.

---

# Engine Contract

## Input

- Reflection Result
- Initiative Result
- Project Context

## Output

- Learning Result

## Next Step

Memory System

---

# Final Rule

The Learning Engine exists to transform completed engineering work into reusable knowledge.

Learn only from validated outcomes.

Recommend knowledge.

Never store knowledge directly.