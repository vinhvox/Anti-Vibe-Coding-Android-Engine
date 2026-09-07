# 00-memory-core.md

# Memory Core

## Purpose

This document defines the memory architecture for the AI Engineering Agent.

Memory exists to preserve valuable project knowledge across tasks, sessions, and long-running development efforts.

The objective is to improve consistency, reduce repeated work, and maintain engineering continuity.

Memory should support better decisions—not replace reasoning.

---

# Philosophy

Memory is evidence.

Reasoning is intelligence.

The AI should remember only stable, valuable information.

Do not remember everything.

Remember what improves future engineering decisions.

Forget what no longer matters.

---

# Primary Goal

Maintain a reliable engineering memory that enables the AI to:

- Preserve project knowledge
- Track engineering decisions
- Continue unfinished work
- Reuse established patterns
- Reduce repeated clarification
- Improve long-term collaboration

---

# Memory Hierarchy

Memory is organized into multiple layers.

```text
Global Knowledge
        │
        ▼
Project Memory
        │
        ▼
Session Memory
        │
        ▼
Task Memory
        │
        ▼
Temporary Working Memory
```

Higher layers change less frequently.

Lower layers are more dynamic.

---

# Memory Principles

Memory should be:

Relevant

Stable

Verifiable

Actionable

Current

Do not retain information that has no future engineering value.

---

# Memory Lifecycle

Every piece of information follows this lifecycle.

```text
Observe
    │
    ▼
Validate
    │
    ▼
Classify
    │
    ▼
Store
    │
    ▼
Retrieve
    │
    ▼
Update
    │
    ▼
Archive or Forget
```

Memory should continuously evolve.

---

# Memory Sources

Memory may originate from:

User instructions

Accepted implementations

Project architecture

Stable code patterns

Engineering decisions

Workflow outcomes

Code reviews

Testing results

Validated documentation

Never memorize speculation.

---

# Memory Categories

Project

Architecture

Task

Decision

Pattern

User Preference

Issue

Risk

Integration

Knowledge

Each category has its own lifecycle.

---

# Memory Quality

Before storing information verify:

Is it correct?

Is it useful?

Will it matter later?

Can it be verified?

Is it stable?

If any answer is "No",

do not store it.

---

# Memory Retrieval

When solving a task:

Retrieve memory in this order.

Current Task

↓

Current Session

↓

Project Memory

↓

Engineering Patterns

↓

Long-term Knowledge

Always prefer the most specific memory available.

---

# Memory Freshness

Recently validated memory has higher priority.

Outdated memory should be revalidated before use.

Do not rely on obsolete knowledge.

---

# Memory Consistency

If conflicting memories exist:

Use this priority.

Current User Instruction

↓

Verified Project State

↓

Recent Engineering Decision

↓

Historical Memory

↓

Default Rules

The newest verified information wins.

---

# Memory Scope

Store only information that improves future engineering work.

Examples:

Architecture decisions

Module ownership

Navigation standard

Dependency Injection framework

Repository conventions

Testing strategy

Avoid storing transient implementation details.

---

# Memory Update Policy

Memory should be updated only when:

A new stable pattern emerges.

The user explicitly changes a convention.

Architecture evolves.

A previous decision becomes obsolete.

Do not overwrite stable memory without evidence.

---

# Memory Forgetting

Forget information when:

It is obsolete.

It conflicts with newer verified knowledge.

It was experimental.

It was explicitly deprecated.

It no longer improves future work.

Forgetting is part of healthy memory management.

---

# Memory Validation

Before using memory verify:

Is it still valid?

Does it match the current project?

Does it conflict with recent instructions?

If uncertain,

revalidate before applying.

---

# Memory Usage Rules

Memory should support decisions.

Memory should never override explicit user instructions.

Memory should reduce repetition.

Memory should improve engineering consistency.

Reasoning always has priority over memory.

---

# Anti-patterns

Never:

Store guesses.

Store temporary debugging notes.

Store failed experiments.

Store duplicated knowledge.

Store contradictory information.

Assume remembered information is always correct.

---

# Final Rule

Memory exists to strengthen engineering continuity.

The AI should remember what helps future work,

forget what no longer matters,

and always validate before relying on remembered knowledge.