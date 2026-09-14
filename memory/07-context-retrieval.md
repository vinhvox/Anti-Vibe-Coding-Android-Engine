# 07-context-retrieval.md

# Context Retrieval Engine

## Purpose

This document defines how the AI retrieves the minimum, most relevant engineering context required to complete the current task.

Context Retrieval connects Memory with Reasoning.

Its goal is to maximize relevance while minimizing cognitive overload.

The AI should retrieve only what is necessary.

---

# Philosophy

Better memory does not create better engineering.

Better retrieval does.

The AI should never load everything.

The AI should retrieve only the knowledge that improves the current decision.

Relevant context is more valuable than large context.

---

# Primary Goal

Before every reasoning step,

retrieve the smallest set of verified information required to:

Understand the task

Make decisions

Implement correctly

Avoid repeated analysis

Maintain engineering consistency

---

# Retrieval Pipeline

Every request follows the same pipeline.

```text
User Request
      │
      ▼
Intent Detection
      │
      ▼
Context Planning
      │
      ▼
Memory Retrieval
      │
      ▼
Context Ranking
      │
      ▼
Context Validation
      │
      ▼
Reasoning
```

Retrieval always happens before reasoning.

---

# Retrieval Principles

Retrieve:

Relevant

Recent

Verified

Minimal

Actionable

Never retrieve information that does not improve the current task.

---

# Retrieval Priority

Always retrieve in this order.

```text
Current User Request
        │
        ▼
Current Session
        │
        ▼
Current Task
        │
        ▼
Project Memory
        │
        ▼
Decision Memory
        │
        ▼
Pattern Memory
        │
        ▼
User Preference
        │
        ▼
Engineering Rules
        │
        ▼
Android Best Practices
```

Higher priority replaces lower priority.

---

# Context Categories

Possible context includes:

Requirements

Architecture

Current Feature

Current Module

Current Task

Dependencies

Project Standards

Engineering Decisions

Implementation Patterns

Known Risks

Open Questions

User Preferences

Only retrieve categories relevant to the current request.

---

# Intent-based Retrieval

Different requests require different context.

## New Feature

Retrieve:

Requirements

Project Architecture

Feature Pattern

Navigation Pattern

Dependency Injection Pattern

Design System

Current Session

---

## Bug Fix

Retrieve:

Bug Description

Affected Module

Current Implementation

Error Handling Pattern

Recent Decisions

Known Issues

Testing Strategy

---

## Refactor

Retrieve:

Current Implementation

Architecture Rules

Reusable Patterns

Performance Rules

Dependency Graph

Affected Features

---

## Code Review

Retrieve:

Coding Standards

Project Rules

Architecture

Testing Rules

Security Rules

Performance Rules

---

## Testing

Retrieve:

Implementation

Testing Pattern

Expected Behavior

Known Edge Cases

Mock Strategy

---

# Context Ranking

Every retrieved item should receive a relevance score.

Ranking factors:

Task relevance

Freshness

Confidence

Project scope

Engineering impact

Retrieve highest-ranked context first.

---

# Context Window

Maintain a limited active context.

```text
Active Context

Requirement

Current Task

Architecture

Pattern

Decision

Blocker

Next Action
```

Avoid loading unnecessary knowledge.

---

# Lazy Retrieval

Retrieve additional context only when required.

Example:

Implement Repository

↓

Do not retrieve UI Pattern

↓

Need UI later

↓

Retrieve Compose Pattern

Load knowledge on demand.

---

# Context Validation

Before using retrieved context verify:

Is it current?

Is it verified?

Does it conflict with newer knowledge?

Does it match the current task?

Discard invalid context immediately.

---

# Context Refresh

Refresh context when:

Requirements change

Task changes

Architecture changes

User changes direction

Blockers appear

Never continue using stale context.

---

# Context Expiration

Remove context when:

Task completed

Module changes

Feature changes

Session ends

Requirement replaced

Expired context should not influence future reasoning.

---

# Retrieval Optimization

Prefer:

Specific over general

Project knowledge over generic knowledge

Recent decisions over historical ones

Verified patterns over assumptions

Minimal context over maximum context

---

# Context Compression

When multiple memories describe the same concept:

Merge them into one unified context.

Avoid duplicate information.

Reduce cognitive load.

---

# Failure Recovery

If retrieval fails:

Retrieve broader project context.

If still insufficient:

Ask targeted clarification.

Never guess when essential context is missing.

---

# Self Validation

Before reasoning verify:

Do I have enough context?

Am I missing a dependency?

Am I using outdated information?

Am I loading unnecessary knowledge?

Retrieve only what improves the decision.

---

# Anti-patterns

Never:

Load every memory.

Ignore current session.

Use outdated context.

Retrieve irrelevant knowledge.

Mix unrelated features.

Reason without retrieving context.

Retrieve duplicate memories.

---

# Final Rule

Context Retrieval exists to provide the right knowledge,

at the right time,

in the right amount,

so that reasoning remains accurate, efficient, and consistent.