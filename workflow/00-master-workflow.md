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
Phase 7: Reflection, Dev Mirror Self-Review & Gates E1–E40 Enforcement Audit
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
     - Drop-in Code Blueprints (ViewModel, Screen, Koin, SSOT Repository)
     - Anti-Patterns (DOs & DON'Ts)
     - Quality Enforcement Gates (E1 — E40)
   - *Result: Establish full context in ~2 seconds with ~5.4K tokens instead of reading 147 separate files!*

2. **Working Directory & Project Root**:
   - Check `pwd` and locate the root project folder.
   - Detect project type: Android (Gradle), Kotlin Multiplatform (KMP), Flutter (`pubspec.yaml`), iOS (`Package.swift` / Xcode), or Web.

3. **Stack & Configuration Profiling (If digest not present)**:
   - Inspect build configuration (`settings.gradle.kts`, `build.gradle.kts`, `AndroidManifest.xml`).
   - Identify active libraries: Jetpack Compose / Material 3 version, Navigation 3 / Voyager / Jetpack Navigation, Koin / Hilt, Ktor / Retrofit, Room / SQLDelight / DataStore, Coroutines.
   - Detect module structure (`:app`, `:core`, `:feature`, `:domain`, `:data`, `:di`).

4. **Active Context Alignment**:
   - Reconcile active workspace ground-truth with `memory/01-project-memory.md`.
   - Never assume an old project's package structure or tech stack applies to a new workspace.

5. **Dynamic Module Persona Telepathy (App vs. SDK)**:
   - Check if current module applies `com.android.library` or is a shared library module.
   - **If SDK/Library Module**: Automatically switch to **SDK Persona & Gate E25** (`internal` by default, `:testing` test fakes, crash-proof isolation, minimal `consumer-rules.pro`, binary compatibility, 16KB page alignment).
   - **If Application Module** (`com.android.application`): Automatically switch to **App Persona & Gates E1–E4, E29, E34** (Compose M3, Edge-to-Edge, Android Vitals, Atomic `_state.update`, Play Store policy).

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
2. Clarification Engine (**Mandatory Auto-Grilling Protocol**: For features, architectural choices, and SDK design, automatically build a Design Tree and present the Frontier in numbered Rounds with `❓ Q1`, `❓ Q2` and `➡️ CTO Recommendation`, then HARD STOP to wait for user resolution)
3. Assumption Engine (validate assumptions)
4. Decision Engine (choose strategy via Pareto frontier trade-off matrix)
5. Confidence Engine (evaluate readiness >= 85)

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

# Phase 5 — Workflow Dispatch & GSD Loop Mapping

Only after Readiness Validation succeeds.

Select the appropriate workflow, mapped directly into the **GSD Phased Execution Lifecycle** (`skills/gsd-orchestrator/SKILL.md`):

1. **Discuss (Pha 1):** Requirement Analysis, Consult Before Code, Clarification, Domain Modeling (`spec.md`).
2. **Plan (Pha 2):** Implementation Planning, Tracer-bullet Slicing, Wave Decomposition (`plan.md`, `tasks.md`).
3. **Execute (Pha 3):** Implementation, Refactoring, Bug Fixing (Subagent Wave Dispatcher + Gate E39 Dev Mirror Self-Review).
4. **Verify (Pha 4):** Code Review, Gates E1–E40 Audit, Living Traceability, Bounded 3-Round Red-Team Testing (`qa-enforcer`).
5. **Ship (Pha 5):** Milestone Closure, Memory Update, Zero-Auto-Commit Hand-off.

Only one primary workflow should execute at a time.

---

# Phase 6 — Workflow Execution & Context Engineering

Execute the selected workflow under strict **Context Engineering & Anti-Rot Governance**:

### A. Context Delegation, Dev Mirror Self-Review & Bounded 3-Round Dev ↔ QA Separation Gate (Rule 42 & Gates E37, E39, E40)
To prevent **Context Rot**, **First-Draft Dump Sloppiness**, **Confirmation Bias**, and **Infinite QA Ping-Pong Loops**:
1. **Primary Adversarial Pair (`dev-builder` vs. `qa-enforcer`):**
   - **`dev-builder` (`enable_write_tools = true`):** Executes code changes (Draft 1), **performs Mandatory 4-Step Dev Mirror Self-Review (Gate E39: `view_file` physical read-back ➔ 5-Mirror Lens audit ➔ self-refactor to Clean Draft 2 ➔ `🪞 Dev Mirror Self-Review` report block)**, performs **Systemic Codebase Sweeps (`Gate E40.3`)** across all modified files for any `[CLUSTER-XX]` reported by QA, writes unit/Turbine/UI tests, and runs `./gradlew testDebugUnitTest`.
   - **`qa-enforcer` (`enable_write_tools = false`):** Registered via `define_subagent` (Read-Only) and invoked via `invoke_subagent` in a **100% blind fresh context** under **Bounded 3-Round Convergence (`Gate E40`)**: Round 1 Full-Scope Pattern-Clustered `[CLUSTER-XX]` audit; Rounds 2–3 Delta-Only scope + Zero Moving Goalposts; automatic Round 3 Circuit Breaker (`🛑 CIRCUIT BREAKER TRIGGERED: ARCHITECTURAL PIVOT REQUIRED`).
2. **Mandatory Subagent Waves (`invoke_subagent`):** Enforced for all multi-file features, architecture refactors, and complex debugging.
   - Main Agent functions strictly as CTO Orchestrator (and when editing < 1-2 files directly, Main Agent MUST also execute Gate E39 Mirror Self-Review).
   - Tasks are grouped into sequential/parallel **Waves** (Wave 1: Data/Domain, Wave 2: ViewModel/State, Wave 3: UI/Compose), followed by mandatory `qa-enforcer` verification.
   - Main session context remains lean, receiving only structured diff summaries, `🪞 Dev Mirror Self-Review` logs, test evidence, and the `qa-enforcer` binary verdict.

### B. Engineering Guardrails
During execution:
- Follow all engineering rules (Kotlin 2.x, Jetpack Compose M3, Atomic `_state.update`, Vector XMLs).
- Apply project patterns and respect accepted architectural decisions.
- Reuse existing implementations whenever appropriate; never bypass project architecture.

**Mandatory Refactoring Safety Net (Rule 40 & Gate E32):**
For any task involving Refactoring, Cleanup, Modularization, or Migration:
1. Write Characterization / Pinning Tests FIRST capturing existing observable behavior.
2. Run tests to confirm Green Baseline (100% pass) on untouched production code.
3. Perform refactoring in single atomic micro-steps.
4. Verify tests pass after every micro-step (Instant Revert on Red).
5. Provide test execution proof of zero regression.
Zero production code changes are allowed before Characterization tests are written and verified green.

**Mandatory Scientific Closed-Loop Debugging Protocol (Rule 41 & Gate E33.1/E33.2):**
For any task involving Bug Fixes, Test Failures, or Regressions:
1. Formulate exactly ONE falsifiable Root-Cause Hypothesis based on stacktrace and system invariants.
2. Write a Minimal Failing Isolation Test proving reproduction before editing any production code.
3. Apply a Single-Variable Atomic Fix targeting only the isolated invariant (Zero Vibe Debugging).
4. Execute full regression test sweep (`./gradlew testDebugUnitTest`) to prove zero side-effects.
Zero production code changes are allowed before reproduction test is written and confirmed RED.

---

# Phase 7 — Reflection, Dev Mirror Self-Review & Bounded 3-Round QA Audit

After execution run the Dev Mirror Self-Review (Gate E39) & `qa-enforcer` Verification Engine (Gates E33.4 & E40).

Verify:

Architecture

Code Quality & Self-Documenting Naming (Gate E28.6)

Error Handling

Performance & Vitals (Gate E38)

Security

Maintainability

Testing Coverage & 6-Dimension Edge Cases (Gate E31)

Potential Risks

**Mandatory Dev Mirror Self-Review (Gate E39):**
Before dispatching `qa-enforcer` or reporting completion, verify that `dev-builder` (or Main Agent) has:
1. Physically read back (`view_file`) 100% of modified/created files on disk.
2. Audited and self-refactored Draft 1 into Clean Draft 2 across all 5 Mirror Lenses.
3. Produced the explicit **`🪞 Dev Mirror Self-Review`** summary block.

**Enforcement Audit (Mandatory):**

Run all applicable checks from `rules/21-enforcement-engine.md` (Gates E1–E40) on modified files.

ZERO violations must remain before proceeding to Memory Update.

**Living Executable Traceability Audit (Rule 28, Rule 33 & Gate E33.3):**
Verify that 100% of Gherkin Scenarios in `spec.md` have direct 1-to-1 mapped tests in code.

**Bounded 3-Round Zero-Compromise QA-Enforcer Audit (Rule 42 & Gates E33.4, E40):**
QA NEVER compromises with Dev, and NEVER loops beyond 3 rounds:
1. Spawn `qa-enforcer` (`enable_write_tools = false`) in a blind fresh context with the Blind Handoff Contract (`QA Round: [1 | 2 | 3] / 3`, Prior Cluster Ledger, Spec, Full/Delta Diff, Raw Test Logs, Mirror Evidence Block).
2. Audit across all 4 Mandatory Fronts (Gate E38 Vitals, Gates E1–E36 Architecture/UI, Gate E31 6-Dimension Edge Cases, Gates E20, E39 & E40 Real Execution, Mirror & Bounded 3-Round Convergence).
3. Enforce Binary Guillotine Verdict & 4 Convergence Laws:
   - **Round 1:** Full-Scope audit; batch all identical defects into `[CLUSTER-XX]` patterns (`Gate E40.3`).
   - **Rounds 2 & 3:** Delta-Only audit (`Gate E40.2`) + Zero Moving Goalposts on untouched Round-1 code (`Gate E40.4`). `dev-builder` must fix 100% of `[CLUSTER-XX]` items via a Systemic Codebase Sweep + Rule 41.
   - **Round 3 Circuit Breaker (`Gate E40.1`):** If Round 3 still yields `VERDICT: REJECTED`, trigger **`🛑 CIRCUIT BREAKER TRIGGERED: ARCHITECTURAL PIVOT REQUIRED`**, stop patching immediately, and escalate to the user with a root-cause post-mortem and 2 architectural pivot options.
   - Only when **`VERDICT: APPROVED`** (0 defects) is issued may the task proceed to user delivery.

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

**Autonomous Continuous Learning (Auto-Learn Loop):**
Whenever the user corrects code, expresses a design preference ("tôi thích X hơn", "đừng dùng Y", "lần sau nhớ Z"), or rejects an architectural option:
1. Automatically extract the invariant and specific preference rule.
2. Persist the rule into `memory/06-user-preference-memory.md` without waiting for explicit `/learn` commands.
3. Silently apply this rule across all future development sessions.

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