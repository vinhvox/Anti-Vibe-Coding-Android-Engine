# 02-context-engine.md

# Context Engine

## Purpose

This document defines how the AI collects, evaluates, and organizes context before reasoning about a request.

The Context Engine bridges Communication (01) and Clarification (03).

It ensures that the AI has a complete understanding of the existing codebase, architecture, and project state before deciding what questions to ask or what assumptions to make.

---

# Related Files

- Brain: `00-master-cognition.md` (Master Pipeline), `01-communication-engine.md` (Input), `03-clarification-engine.md` (Output Consumer)
- Memory: `01-project-memory.md`, `07-context-retrieval.md`
- Workflow: `02-codebase-analysis.md`
- Rules: `02-architecture.md`, `04-feature-construction.md`, `14-code-reuse.md`

---

# Primary Goal

Before the AI reasons, clarifies, or plans, it MUST collect and organize all relevant context from the existing project.

Context Collection reduces unnecessary questions and prevents architecture violations.

---

# Core Principles

Context before Clarification.

Analysis before Assumptions.

Existing code before new code.

Project conventions before best practices.

Never skip context collection.

---

# Context Pipeline

```text
Receive Request
        │
        ▼
Auto-Discover Workspace & Project Profile (pwd, build.gradle, settings.gradle, modules)
        │
        ▼
Identify Scope (which layers/features are affected?)
        │
        ▼
Locate Relevant Files (search codebase)
        │
        ▼
Read Existing Patterns (how is it done currently?)
        │
        ▼
Map Dependencies (what depends on what?)
        │
        ▼
Evaluate Impact & 19 Core Domains Compliance
        │
        ▼
Produce Context Summary
        │
        ▼
Pass to Clarification Engine (03)
```

No step may be skipped.

---

# Context Categories

Every request requires context from one or more of these categories.

## Architecture Context

- Which layers are involved? (Data / Domain / Presentation)
- Which feature modules are affected?
- What is the dependency direction?
- Does a similar feature already exist?

## Codebase Context

- What files exist in the affected area?
- What patterns do they follow? (MVI Contract, BaseViewModel, etc.)
- What shared components are available?
- What Design System tokens exist?

## State Context

- What is the current state of the feature? (new / existing / broken)
- Are there related pending tasks?
- Are there known issues in the affected area?

## Convention Context

- How are similar features structured in this project?
- What naming conventions are used?
- What DI patterns are used?
- What navigation patterns are used?

---

# Context Collection Strategy

## For Simple Requests (single file edit, typo fix)

Collect:

- Target file location
- Existing code patterns in that file
- Design System tokens used

Estimated effort: Minimal (1-2 file reads)

## For Medium Requests (feature modification, bug fix)

Collect:

- All files in the affected feature module
- Related ViewModel Contract (State/Intent/Effect)
- Shared components used by the feature
- DI bindings in AppModule

Estimated effort: Moderate (5-10 file reads)

## For Complex Requests (new feature, architecture change)

Collect:

- Full feature module structure
- Related domain models and use cases
- Repository interfaces and implementations
- Navigation graph entries
- Design System components available for reuse
- Similar features for pattern reference

Estimated effort: Significant (10-20 file reads)

---

# Context Output Format

The Context Engine produces a structured summary consumed by the Clarification Engine.

```text
Context Summary:
  Scope: [layers/features affected]
  Existing Patterns: [how similar things are done]
  Reusable Components: [what can be reused]
  Dependencies: [what depends on what]
  Impact: [what could break]
  Missing Information: [what is genuinely unknown]
```

Only "Missing Information" items become candidates for clarification questions.

Everything else is resolved by context.

---

# Context Validation

Before passing context to Clarification Engine, verify:

✓ All affected files have been identified

✓ Existing patterns have been documented

✓ Reusable components have been listed

✓ Dependency direction has been verified

✓ No architecture violations are introduced by the proposed change

If validation fails, collect more context before proceeding.

---

# Anti-patterns

Never:

Skip codebase inspection before asking questions.

Assume architecture without reading existing code.

Ignore existing patterns in favor of new implementations.

Ask the user questions whose answers exist in the codebase.

Propose solutions before understanding the current state.

Create new components without checking for existing ones.

---

# ENFORCEMENT

Before the AI proceeds to the Clarification Engine (03), it MUST confirm:

1. At least 1 file in the affected area has been read.
2. The existing architectural pattern for that area has been identified.
3. Available shared components have been listed.
4. The Design System has been inspected for reusable tokens.

If ANY of these checks fail, context collection is INCOMPLETE and the AI must NOT proceed.

---

# Final Rule

Context is the foundation of good engineering decisions.

The AI should know the codebase before it asks questions.

It should understand existing patterns before proposing new ones.

Context collection is not optional — it is the prerequisite for every engineering action.
