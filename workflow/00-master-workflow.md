---
name: master-workflow
description: Mandatory system entrypoint for all engineering requests.
always_apply: true
---
# 00-master-workflow.md

# SYSTEM ENTRYPOINT

This document is the mandatory starting point for every engineering request.

No workflow may begin directly.

---

# Related Files

- Brain: `brain/00-master-cognition.md` (Cognitive Pipeline)
- Rules: `rules/00-system-mandate.md` (Execution Order), `rules/21-enforcement-engine.md` (Quality Gate)
- Memory: `memory/00-memory-core.md` (Memory Architecture)
- Skills: `skills/request-processing-flow.md` (Quick Reference)
- Index: `INDEX.md` (Full Cross-Reference Map)

---

Before selecting any workflow, the AI MUST execute the Brain Pipeline.

Brain Pipeline

1. Context Engine
2. Clarification Engine
3. Assumption Engine
4. Decision Engine
5. Confidence Engine

Only when:

- Clarification = READY
- Decision = READY
- Confidence >= 85

may a Workflow execute.

Otherwise:

Stop execution.

Ask the user.

Never generate plans.

Never write code.

# Master Workflow

## Purpose

This document defines the mandatory execution pipeline for every engineering request.

No workflow, skill, or implementation may execute directly.

Every request must first pass through the Brain and Memory systems before entering a workflow.

This workflow acts as the central orchestrator of the entire engineering process.

---

# Core Principles

Always think before acting.

Always understand before planning.

Always plan before implementing.

Always review before completing.

Never skip a phase.

---

# Global Execution Pipeline

Every request must follow this sequence.

```
User Request
    │
    ▼
Phase 0: Workspace & Project Auto-Discovery
    │
    ▼
Phase 1: Intent Detection
    │
    ▼
Phase 2: Memory Retrieval (Active Project Context)
    │
    ▼
Phase 3: Brain Analysis
    │
    ▼
Phase 4: Readiness Validation
    │
    ▼
Phase 5: Workflow Dispatch
    │
    ▼
Phase 6: Workflow Execution
    │
    ▼
Phase 7: Reflection & Gate E21 Enforcement Audit
    │
    ▼
Phase 8: Memory Update
```

No phase may be skipped.

---

# Phase 0 — Workspace & Project Auto-Discovery

Before parsing requirements or retrieving project memory, the AI MUST profile the active workspace to establish ground-truth context:

1. **Fast-Path Context Digest Bootstrapping (Preferred)**:
   - Check if `.context-digest.md` exists in the current project root or `~/.antigravity/.context-digest.md`.
   - If available, read this single compressed file to instantly ingest:
     - 100% Tech Stack & Architecture
     - 19 Core Engineering Domains & Defense Rules
     - Drop-in Code Blueprints (ViewModel, Screen, DI Driver: Koin/Hilt, SSOT Repository)
     - Anti-Patterns (DOs & DON'Ts)
     - Quality Enforcement Gates (E1 — E28)
   - *Result: Establish full context in ~2 seconds with ~5.4K tokens instead of reading 147 separate files!*

2. **Working Directory & Project Root**:
   - Check `pwd` and locate the root project folder.
   - Detect project type: Android (Gradle), Kotlin Multiplatform (KMP), Flutter (`pubspec.yaml`), iOS (`Package.swift` / Xcode), or Web.

3. **Stack & Configuration Profiling (Adaptive Driver Binding)**:
   - Inspect build configuration (`settings.gradle.kts`, `build.gradle.kts`, `libs.versions.toml`, `AndroidManifest.xml`).
   - Identify active stack drivers:
     - **DI Driver:** Koin OR Hilt / Dagger
     - **Networking Driver:** Ktor Client OR Retrofit + OkHttp
     - **Navigation Driver:** Navigation 3 OR Jetpack Navigation Compose OR Voyager/Decompose
     - **Storage Driver:** Room Database OR SQLDelight OR DataStore
   - Bind the active drivers into the current Session Context so all subsequent workflows generate code aligned with the project's existing architecture.
   - Detect module structure (`:app`, `:core`, `:feature`, `:domain`, `:data`, `:di`).

4. **Active Context Alignment**:
   - Reconcile active workspace ground-truth with `memory/01-project-memory.md`.
   - Never assume an old project's package structure or tech stack applies to a new workspace.

---

# Phase 1 — Intent Detection

Determine:

- What the user actually wants.
- The expected outcome.
- The scope of the request.
- Whether this is:
    - Question
    - Planning
    - Implementation
    - Refactoring
    - Review
    - Debugging
    - Testing
    - Documentation

If intent is ambiguous:

Stop.

Invoke the Clarification Engine.

---

# Phase 2 — Memory Retrieval

Before reasoning, retrieve only the required context.

Retrieve in order:

1. Session Memory
2. Task Memory
3. Project Memory
4. Decision Memory
5. Pattern Memory
6. User Preference Memory

Never retrieve unnecessary context.

---

# Phase 3 — Brain Analysis

Brain engines execute in the following order.

1. Context Engine (collect codebase context)
2. Clarification Engine (ask only what context cannot answer)
3. Assumption Engine (validate assumptions)
4. Decision Engine (choose strategy)
5. Confidence Engine (evaluate readiness)

Each engine produces an output.

The next engine consumes the previous output.

---

# Phase 4 — Readiness Validation

Before any workflow starts verify:

✓ Requirement sufficiently understood

✓ Unknowns identified

✓ Critical questions resolved

✓ Major assumptions validated

✓ Architecture understood

✓ Dependencies identified

✓ Risks evaluated

✓ Confidence acceptable

If any validation fails:

STOP.

Return control to the user with specific questions.

Do not continue.

---

# Phase 5 — Workflow Dispatch

Only after Readiness Validation succeeds.

Select the appropriate workflow.

Examples:

Requirement Analysis

Codebase Analysis

Implementation Planning

Implementation

Code Review

Testing

Performance Review

Security Review

Release

Only one primary workflow should execute at a time.

---

# Phase 6 — Workflow Execution

Execute the selected workflow.

During execution:

Follow all engineering rules.

Apply project patterns.

Respect accepted decisions.

Reuse existing implementations whenever appropriate.

Never bypass project architecture.

---

# Phase 7 — Reflection

After execution run the Reflection Engine.

Verify:

Architecture

Code Quality

Error Handling

Performance

Security

Maintainability

Testing Coverage

Potential Risks

**Enforcement Audit (Mandatory):**

Run all applicable checks from `rules/21-enforcement-engine.md` on modified files.

ZERO violations must remain before proceeding to Memory Update.

If critical issues are found:

Return to implementation.

---

# Phase 8 — Memory Update

After successful completion:

Update:

Task Memory

Decision Memory (if applicable)

Pattern Memory (if discovered)

Project Memory (if changed)

Never update memory with unverified information.

---

# Blocking Rules

Execution must stop immediately if:

Requirements are unclear.

Critical information is missing.

Architecture cannot be determined.

Confidence is below the acceptable threshold.

Conflicting decisions cannot be resolved.

The user requests clarification.

---

# Completion Criteria

A task is complete only if:

Requirement satisfied.

Workflow completed.

Reflection passed.

Memory updated.

No unresolved blockers remain.

---

# Anti-patterns

Never:

Generate code before understanding requirements.

Plan before clarification.

Assume architecture.

Ignore project patterns.

Skip reflection.

Update memory without validation.

Execute multiple unrelated workflows simultaneously.

---

# Final Rule

The Master Workflow is the only entry point for engineering execution.

Every request must pass through Brain, Memory, Validation, and Reflection before it is considered complete.