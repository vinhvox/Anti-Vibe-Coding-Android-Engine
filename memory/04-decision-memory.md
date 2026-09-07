# 04-decision-memory.md

# Decision Memory

## Purpose

This document defines how the AI records, retrieves, and applies engineering decisions throughout the lifecycle of a project.

Decision Memory preserves important decisions that influence future engineering work.

It ensures consistency, avoids repeated discussions, and maintains architectural integrity.

A decision should be remembered only after it has been accepted or verified.

---

# Philosophy

Projects are shaped by decisions.

Good engineering depends on making consistent decisions over time.

The AI should remember why a decision was made,

not only what was decided.

Every important decision should become reusable engineering knowledge.

---

# Primary Goal

Maintain a reliable history of engineering decisions including:

Architecture decisions

Technology choices

Coding conventions

Project standards

Integration strategies

Engineering trade-offs

Business-approved implementation choices

Future work should build upon previous decisions rather than rediscover them.

---

# Decision Lifecycle

Every decision follows the same lifecycle.

```text
Problem
    │
    ▼
Options
    │
    ▼
Evaluation
    │
    ▼
Decision
    │
    ▼
Validation
    │
    ▼
Accepted
    │
    ▼
Applied
    │
    ▼
Revisited (if necessary)
```

Only accepted decisions should influence future work.

---

# What To Store

Decision Memory may store:

Architecture decisions

Technology selections

Dependency Injection framework

Navigation framework

Repository contracts

Error handling strategy

State management approach

Database strategy

Networking strategy

Testing strategy

Security policies

Performance strategies

Module boundaries

Long-term engineering agreements

---

# What NOT To Store

Never store:

Temporary workarounds

Debugging decisions

Incomplete discussions

Speculative ideas

Rejected proposals

Unverified assumptions

Personal opinions

Session-specific choices

Task execution details

---

# Decision Structure

Each decision should contain:

Identifier

Title

Description

Context

Problem

Available options

Selected option

Reason

Supporting evidence

Decision owner

Status

Impact

Affected modules

Review date (optional)

Future decisions should be traceable.

---

# Decision Status

Possible states:

Proposed

Under Review

Accepted

Implemented

Deprecated

Replaced

Rejected

Only Accepted and Implemented decisions should guide engineering work.

---

# Decision Categories

Architecture

Technology

Code Structure

Performance

Security

Testing

Build

Deployment

Developer Experience

User Experience

Integration

---

# Decision Validation

Before storing a decision verify:

Has it been accepted?

Is it intentional?

Is it expected to remain stable?

Does it affect future work?

If not,

do not store.

---

# Decision Retrieval

Before making any important engineering decision:

Retrieve:

Relevant project decisions

↓

Related architecture decisions

↓

Technology decisions

↓

Engineering standards

Future decisions should align with previous accepted decisions whenever possible.

---

# Decision Evolution

Projects evolve.

If a decision changes:

Create a new decision.

Mark the old decision as Deprecated or Replaced.

Never silently overwrite history.

Preserve the reasoning behind changes.

---

# Conflict Resolution

If multiple decisions conflict:

Priority order:

Current User Instruction

↓

Latest Accepted Decision

↓

Verified Current Codebase

↓

Project Memory

↓

Engineering Rules

↓

Android Best Practices

The most recent verified decision takes precedence.

---

# Decision Impact

Every decision should identify:

Affected modules

Affected features

Migration requirements

Compatibility considerations

Potential risks

Understanding impact prevents unintended consequences.

---

# Decision Reuse

Before introducing:

New architecture

New library

New pattern

New abstraction

Verify whether an existing accepted decision already covers the situation.

Reuse decisions whenever possible.

---

# Decision Review

Periodically verify:

Is this decision still valid?

Does the project still follow it?

Has technology evolved?

Has the user replaced it?

If obsolete,

deprecate rather than delete.

---

# Self Validation

Before applying a remembered decision verify:

Is it still accepted?

Does it match the current codebase?

Has a newer decision replaced it?

Does it conflict with explicit user instructions?

If uncertain,

revalidate first.

---

# Anti-patterns

Never:

Forget accepted decisions.

Store rejected proposals.

Ignore decision history.

Override accepted decisions without evidence.

Treat temporary discussions as permanent decisions.

Create conflicting decisions without explanation.

---

# Recorded Decisions

<!-- 
  Format: - [DATE] **Decision** | Context: why | Alternatives rejected: what else was considered
-->

- [2026-07] **MVI over MVVM** | Context: Strict UDF with sealed Intent/Effect provides better state traceability | Alternatives: MVVM with named functions
- [2026-07] **Koin over Hilt** | Context: Lightweight, no annotation processing, faster builds | Alternatives: Hilt, manual DI
- [2026-07] **Zip4j over ZipInputStream** | Context: Pure Java, AES-256 support, multi-format, 16KB aligned | Alternatives: Native ZipInputStream, Apache Commons Compress
- [2026-07] **Navigation 3 over Navigation Compose** | Context: State-driven backstack, Compose-first, type-safe | Alternatives: Navigation Compose with routes
- [2026-07] **Single FileItem model** | Context: Avoid model duplication across Browser/Category/Home screens | Alternatives: Separate models per feature
- [2026-07] **Ktor over Retrofit** | Context: KMP-ready, coroutine-native, also used for local WebShare server | Alternatives: Retrofit, OkHttp
- [2026-08] **Unified FileActionBottomSheet** | Context: Consistent action menu across all screens | Alternatives: Per-screen action menus
- [2026-08] **Smart password detection for archives** | Context: Better UX by hiding password field when not needed | Alternatives: Always show password field
- [2026-09] **Matt Pocock Skills Synthesis (Ubiquitous Language, Tracer Bullets, Living ADR, ask-cto Meta-Router)** | Context: Integrated anti-vibe coding methodology from mattpocock/skills; standardized `CONTEXT.md` to eliminate verbosity ("20 words where 1 will do"), mandated vertical slicing (Tracer Bullets) over horizontal isolation, automated ADR extraction to Git, and added `/ask-cto` meta-router to coordinate 49 skills and 28 gates | Alternatives: Retaining legacy workflow or raw TypeScript skills incompatible with Native Android


---

# Final Rule

Decision Memory exists to preserve engineering consistency.

Every accepted decision should make future engineering work faster, more predictable, and more aligned with the project's long-term direction.