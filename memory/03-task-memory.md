# 03-task-memory.md

# Task Memory

## Purpose

This document defines how the AI tracks, manages, and completes engineering tasks.

Task Memory represents the execution state of work.

It ensures that implementation progresses in a structured, traceable, and recoverable manner.

Task Memory exists until the task is completed, cancelled, or replaced.

---

# Philosophy

Project Memory remembers the project.

Session Memory remembers the collaboration.

Task Memory remembers the work.

Every task should have a clear beginning, current state, and completion.

The AI should never lose track of what it is doing.

---

# Primary Goal

Maintain an accurate execution state for every engineering task.

The AI should always know:

Current task

Task status

Dependencies

Progress

Blockers

Next step

Completion criteria

---

# Task Lifecycle

Every task follows the same lifecycle.

```text
Created
    │
    ▼
Analyzing
    │
    ▼
Ready
    │
    ▼
Implementing
    │
    ▼
Reviewing
    │
    ▼
Testing
    │
    ▼
Completed
```

Alternative states:

```text
Blocked

Cancelled

Deferred

Failed
```

A task always has one active state.

---

# Task Structure

Each task contains:

Identifier

Objective

Description

Priority

Owner

Status

Dependencies

Assumptions

Blockers

Progress

Completion Criteria

Result

Tasks should be independently understandable.

---

# Task Categories

Implementation

Bug Fix

Refactor

Architecture

Testing

Documentation

Performance

Security

Migration

Investigation

Each category may follow different workflows.

---

# Task Hierarchy

Tasks may be decomposed into subtasks.

```text
Feature

↓

Task

↓

Subtask

↓

Action
```

Example:

```text
Feature

Search

↓

Task

Repository

↓

Subtask

Search DAO

↓

Action

Implement query
```

Only decompose when it improves execution.

---

# Task Prioritization

Priority order:

Critical

High

Medium

Low

Background

Critical tasks should always be resolved first.

---

# Task Dependencies

Each task may depend on:

Architecture

API

Database

Navigation

Permissions

Shared Components

Other Tasks

Dependencies must be satisfied before execution.

---

# Task Progress

Track meaningful progress.

Example:

```text
Repository

██████████

100%

ViewModel

██████░░░░

60%

Compose UI

██░░░░░░░░

20%
```

Progress should reflect completed engineering work, not elapsed time.

---

# Blocker Management

Every blocker should include:

Description

Cause

Impact

Required Action

Status

Resolve blockers as soon as possible.

---

# Resume Strategy

When returning to a task:

Retrieve:

Task Objective

↓

Current Status

↓

Completed Work

↓

Dependencies

↓

Blockers

↓

Next Action

The AI should resume without repeating previous work.

---

# Completion Criteria

A task is complete only when:

Requirements satisfied

Implementation finished

Validation passed

Review completed

Testing completed

No unresolved blockers

No unfinished subtasks

---

# Task Update Policy

Update Task Memory whenever:

Status changes

Progress changes

Dependencies change

Blockers appear

Blockers resolved

Scope changes

Completion reached

Task Memory should always reflect reality.

---

# Task Recovery

If execution is interrupted:

Restore:

Current state

↓

Current progress

↓

Current blocker

↓

Next executable action

Continue from the latest valid checkpoint.

---

# Parallel Tasks

Multiple tasks may exist simultaneously.

Each task should maintain:

Independent status

Independent progress

Independent blockers

Independent completion

Avoid mixing unrelated tasks.

---

# Task Archive

After completion:

Archive:

Objective

Result

Major decisions

Lessons learned

Discard:

Temporary implementation notes

Working state

Execution context

Completed tasks should become historical references.

---

# Self Validation

Before executing a task verify:

Is this still the active task?

Have dependencies changed?

Has another task taken higher priority?

Has the scope changed?

If necessary,

update Task Memory before continuing.

---

# Anti-patterns

Never:

Forget active tasks.

Duplicate tasks.

Lose blocker information.

Skip completion validation.

Mix unrelated work.

Leave orphaned subtasks.

Track implementation details that belong to code.

---

# Active Tasks

- [2026-09-07] **Adaptive Stack Hardware Abstraction Layer (HAL) & 10-Role Syndicate Architecture** | Status: DONE
  - Objective: Transform the Antigravity framework into a non-dogmatic, framework-agnostic Adaptive Stack HAL supporting both Hilt & Koin, Ktor & Retrofit, Room & SQLDelight; formally document the 10-Role Multi-Role Engineering Syndicate.
  - Scope & Deliverables:
    1. Upgraded `rules/01-tech-stack.md`, `rules/09-networking.md`, `rules/12-dependency-injection.md`, and `.context-digest.md` to Adaptive Stack HAL.
    2. Synchronized `workflow/00-master-workflow.md`, `03-architecture-design.md`, `04-implementation-planning.md`, `06-code-review.md`, and `07-testing-validation.md` with Adaptive HAL and Gates E1–E28.
    3. Documented the 10-Role Multi-Role Engineering Syndicate (CTO, PO, UI/UX Director, Vitals Principal, Memory Specialist, Modular Core Architect, Staff QA, Security Specialist, Domain Modeler, ask-cto Router) in `README.md`.
    4. Verified build integrity and synchronized open-source repository structure.
  - Progress: Completed 100%.

- [2026-09-04] **Matt Pocock Skills Synthesis & System Upgrade (Rule 37 + Tracer Bullets + Living ADR + ask-cto Router + Gate E28)** | Status: DONE
  - Objective: Research Matt Pocock's `mattpocock/skills` repository, extracting anti-vibe-coding methodology to upgrade the Antigravity Engine:
    1. **New System Rule (`rules/37-ubiquitous-language-standard.md`)**:
       - Enforced Ubiquitous Language & Domain Dictionary (`CONTEXT.md`), eliminated verbose phrasing ("20 words where 1 will do"), and mapped domain concepts 1-to-1 to Kotlin/Compose symbols.
    2. **Upgraded Planning Skills (`skills/writing-plans/SKILL.md` & `skills/spec-driven-development/SKILL.md`)**:
       - Integrated **Tracer-Bullet Vertical Slicing** (strictly ban horizontal layer separation DAO ➔ Repo ➔ UI; mandate end-to-end thin vertical slices that can be executed and tested immediately).
       - Integrated **Living ADR Auto-Extraction** (automatically detect architectural compromises and export ADR files to `docs/adr/00xx-<title>.md`).
    3. **New Meta-Router Skill (`skills/ask-cto/SKILL.md`)**:
       - Intelligent routing skill (inspired by `/ask-matt`) to instantly route technical symptoms (dropped FPS, process death, offline sync, memory leak) to the exact 1-2 relevant skills and quality gates.
    4. **New Quality Gate (`Gate E28`) & System Synchronization**:
       - Updated `INDEX.md`, `.context-digest.md`, and Gate E28 (Ubiquitous Language & Domain Precision Gates).
  - Progress: Completed 100%.

- [2026-09-03] **World-Class UI/UX Design & Anti-AI-Design-Cliché Standard Integration (Rule 36 + Gate E27)** | Status: DONE
  - Objective: Permanently eliminate "generic AI-generated interface: rigid, flat, uninspired" tropes; officially activate **Lead UI/UX Architect & Product Design Director** role with 6 aesthetic pillars: zero AI clichés (ban purple on dark, neon glowing, biscuit pills), optical depth (subtle 0.5dp borders & tonal surfaces), golden ratio 3-tier typography, 8-pt grid rhythm, domain-tailored aesthetics, and refined micro-interactions.
  - Scope & Deliverables:
    1. **New System Rule (`rules/36-ui-ux-design-standard.md`)**:
       - Enforced Rule 36: The Human-Grade Aesthetic Mandate, 6 Forbidden AI Design Clichés, and Drop-in Compose Blueprints (Polished Surface Card, Expressive Typography Header).
    2. **Deep Integrated Skill (`skills/ui-ux-pro-max/SKILL.md`)**:
       - Operate 240+ UI Styles, 170+ Color Palettes, 150+ Font Pairings tailored to specific domains.
    3. **Automated Quality Gate (`rules/21-enforcement-engine.md` - CATEGORY E27)**:
       - `E27.1`: Anti-AI-Design-Cliché Gate
       - `E27.2`: Visual Depth & Subtle Border Gate
       - `E27.3`: Typography Hierarchy & Contrast Gate
       - `E27.4`: 8-Point Grid Visual Rhythm Gate
       - `E27.5`: Domain-Tailored Aesthetics Gate
       - `E27.6`: Micro-Interactions & State Polish Gate
    4. **User Preference Rule (`memory/06-user-preference-memory.md`)**:
       - Enforced World-Class UI/UX Design & Anti-AI-Slop Mandate.
    5. **System Synchronization (`.context-digest.md`, `INDEX.md`)**:
       - Integrated Gate E27 into Fast-Path Context Digest and Cross-Reference Index.
  - Progress: Completed 100%.
  - Next Action: Automatically apply Gate E27 aesthetic audit to all UI/UX screens.

- [2026-09-03] **Automated ProGuard & R8 Rules Synthesis Mandate Integration** | Status: DONE
  - Objective: Automated 100% codebase and dependency analysis, identify all DTOs, Room Entities, Navigation 3 Routes, and generate `proguard-rules.pro` (for host app) and `consumer-rules.pro` (for each module/SDK) accurately, with real release build verification (`assembleRelease`).
  - Scope & Deliverables:
    1. **User Preference Rule (`memory/06-user-preference-memory.md`)**:
       - Enforced Automated ProGuard/R8 Rules Synthesis Mandate.
       - Automatically scan `libs.versions.toml`, `build.gradle.kts`, separate 2-tier rules (App vs Module), and verify via `./gradlew assembleRelease`.
  - Progress: Completed 100%.
  - Next Action: Ready to scan and synthesize ProGuard / Consumer rules for any project/module on demand.

- [2026-09-03] **Database Migration & R8 ProGuard Release Defense Integration (Rule 35 + Gate E26)** | Status: DONE
  - Objective: Permanently eliminated two catastrophic Android production hazards: user data loss on Room database upgrades, and app crashes when R8 Minify is enabled on Release builds due to stripped/renamed DTOs, Room Entities, and Navigation 3 Routes.
  - Scope & Deliverables:
    1. **New System Rule (`rules/35-database-migration-r8-defense.md`)**:
       - Enforced Rule 35: The Zero-Data-Loss & Zero-Release-Crash Mandate, banned `fallbackToDestructiveMigration()`, mandated KSP `room.schemaLocation` export, implemented `MigrationTestHelper` test suite, and configured `consumer-rules.pro` for all modules/SDKs.
    2. **Automated Quality Gate (`rules/21-enforcement-engine.md` - CATEGORY E26)**:
       - `E26.1`: Zero-Destructive-Migration Gate
       - `E26.2`: Room Schema Export & Migration Test Gate
       - `E26.3`: Consumer Proguard Rules Isolation Gate
       - `E26.4`: R8 Serialization & Keep Annotation Gate
       - `E26.5`: Real Release Minify Build Gate (`assembleRelease`)
    3. **System Synchronization (`.context-digest.md`, `INDEX.md`)**:
       - Integrated Gate E26 into Fast-Path Context Digest and Cross-Reference Index.
  - Progress: Completed 100%.
  - Next Action: Automatically apply Gate E26 to comprehensively audit the safety of Room Migrations and R8 ProGuard Release builds.

- [2026-09-03] **Internal Module & SDK Architectural Standard Integration (Rule 34 + Gate E25)** | Status: DONE
  - Objective: Established Enterprise Modular Core & SDK Architectural Standard with 6 core pillars: Minimal Public Surface (`internal` by default), mandatory bundled Test Fake Module (`:testing`), Zero Startup Overhead (ban ContentProvider auto-init), fault isolation & host app protection (`SdkResult<T>`), Gradle layering & Convention Plugins (`build-logic`), and Binary Compatibility & SemVer Deprecation lifecycle.
  - Scope & Deliverables:
    1. **New System Rule (`rules/34-sdk-modular-architecture.md`)**:
       - Enforced Rule 34: The Enterprise Modularity Mandate, 4-Tier Module Taxonomy (`:api`, `:impl`, `:testing`, `:model`), and Drop-in SDK Blueprints (Public/Internal contracts, In-Memory Test Fakes).
    2. **Specialized Skill (`skills/sdk-modular-engineering.md` & `skills/sdk-modular-engineering/SKILL.md`)**:
       - Provided SDK design playbook, Gradle Convention Plugins, Fake Test Doubles, and audit checklist.
    3. **Automated Quality Gate (`rules/21-enforcement-engine.md` - CATEGORY E25)**:
       - `E25.1`: Public API Surface & Visibility Isolation Gate
       - `E25.2`: Mandatory Test Double / Fake Artifact Gate
       - `E25.3`: Zero Startup Penalty Gate
       - `E25.4`: Gradle Dependency Isolation Gate
       - `E25.5`: Host App Error Isolation Gate
       - `E25.6`: SemVer & Deprecation Lifecycle Gate
    4. **System Synchronization (`.context-digest.md`, `INDEX.md`)**:
       - Integrated Gate E25 into Fast-Path Context Digest and Cross-Reference Index.
  - Progress: Completed 100%.
  - Next Action: Automatically apply Gate E25 to design, refactor, and review all internal SDKs and modules.

- [2026-09-03] **Modern Android & Compose Testing Standard Integration (Rule 33 + Gate E24)** | Status: DONE
  - Objective: Established Modern Android & Compose Testing Standard with 5 core pillars: Test-Driven Development (mandatory TDD Red-Green-Refactor), asynchronous StateFlow testing with Turbine, Dependency Injection graph validation (Koin verify), zero flaky tests, and real compiler verification gate (`./gradlew test assembleDebug`); eliminating vibe-coding habits of claiming completion without tests.
  - Scope & Deliverables:
    1. **New System Rule (`rules/33-modern-android-testing.md`)**:
       - Enforced Rule 33: The Modern Testing Mandate, TDD Red-Green-Refactor Lifecycle, Turbine Flow Testing, Koin Graph Verification, and Roborazzi Visual Regression.
    2. **Automated Quality Gate (`rules/21-enforcement-engine.md` - CATEGORY E24)**:
       - `E24.1`: TDD Red-Green-Refactor Compliance Gate
       - `E24.2`: Async Flow & Turbine Verification Gate
       - `E24.3`: DI Graph Integrity Gate (`verify()`)
       - `E24.4`: Flaky Test Elimination & Coroutine Dispatcher Gate
       - `E24.5`: Real Terminal Compilation & Test Execution Gate
    3. **System Synchronization (`.context-digest.md`, `INDEX.md`)**:
       - Integrated Gate E24 into Fast-Path Context Digest and Cross-Reference Index.
  - Progress: Completed 100%.

- [2026-09-03] **The 7 AI Blind Spots Defense Mandate Integration (Gate E23)** | Status: DONE
  - Objective: Enforced structural protection against the 7 primary mobile engineering blind spots where AI coding agents typically fail: unkeyed lazy layouts, duplicate clicks on slow networks, lost form inputs on Process Death, keyboard obscuring inputs, deprecated navigation routes, fragile string concatenation, and verbose small-talk boilerplate.
  - Scope & Deliverables:
    1. Enforced Gate E23 in `rules/21-enforcement-engine.md`.
    2. Updated `rules/06-compose.md`, `rules/07-viewmodel.md`, and `rules/08-navigation.md`.
    3. Added 7 Blind Spots checklist to `.context-digest.md`.
  - Progress: Completed 100%.

- [2026-09-03] **Self-Documenting Code & Ban on Trivial Comments Mandate (Rule 32.6 + Gate E22.6)** | Status: DONE
  - Objective: Strictly eliminate code clutter, redundant comments, and trivial docstrings that mirror symbol names; enforce self-documenting naming where code expresses 100% of business intent, reserving comments solely for "WHY" rather than "WHAT".
  - Scope & Deliverables:
    1. Enforced Rule 32.6 and Gate E22.6 across enforcement engines.
    2. Updated user preference memory to maintain self-documenting naming standard.
  - Progress: Completed 100%.

- [2026-09-03] **Default Invariant Mandate: Zero-Crash, Zero-ANR, Zero-Leak & Ban on Paranoic Try-Catch Sprawling** | Status: DONE
  - Objective: Enforce default invariants across all generated code: Zero-Crash via Kotlin null safety and exhaustive when, Zero-ANR via main-thread purity and non-blocking Flow, Zero-Leak via lifecycle-scoped observers, and an absolute ban on paranoic try-catch sprawl across Presentation and Domain layers.
  - Scope & Deliverables:
    1. Enforced single I/O boundary wrapping with `AppResult<T>`.
    2. Integrated into Brain Execution Engine and Quality Gate checks.
  - Progress: Completed 100%.

- [2026-09-02] **Ponytail Anti-Overengineering & Minimalist Standard Integration (Rule 32 + Gate E22)** | Status: DONE
  - Objective: Integrated the Ponytail Minimalist Engineering standard based on DietrichGebert/ponytail; enforced the 7-Rung Decision Ladder, native platform/stdlib first, and single-expression idioms while preserving 100% safety and defense rigor.
  - Scope & Deliverables:
    1. Added `rules/32-ponytail-minimalist.md` and `skills/ponytail-minimalist/SKILL.md`.
    2. Enforced Gate E22 (Anti-Overengineering & Minimalist Architecture).
  - Progress: Completed 100%.

- [2026-08-31] **Proactive CTO/PO Advisory & Critical Pushback Mandate (Anti-Yes-Man Protocol)** | Status: DONE
  - Objective: Upgraded agent cognitive behavior from passive agreement to proactive architectural advisory and product leadership, inspecting every requirement through CTO (performance/architecture) and PO (viability/UX) lenses before proposing optimal solutions.
  - Scope & Deliverables:
    1. Added `brain/10-initiative-engine.md`.
    2. Enforced structured Before vs After comparisons and trade-off analysis.
  - Progress: Completed 100%.

- [2026-08-31] **Antigravity Fast-Path Context Digest Architecture (V2 - 5.4K Tokens)** | Status: DONE
  - Objective: Designed ultra-compact context digest `.context-digest.md` enabling AI agents to ingest 100% of core architecture, 19 domains, and quality gates in a single read (~5.4K tokens) with zero file-reading overhead.
  - Scope & Deliverables:
    1. Generated `.context-digest.md` with drop-in blueprints and gates E1-E28.
    2. Integrated with Phase 0 Workspace Discovery.
  - Progress: Completed 100%.

- [2026-08-31] **Mobile Engineering Master Playbook & Architectural Defense Matrix (19 Core Domains)** | Status: DONE
  - Objective: Standardized the 19 core mobile engineering domains into an exhaustive defense matrix with concrete invariants, failure modes, and automated quality gates.
  - Scope & Deliverables:
    1. Added `rules/31-mobile-engineering-core.md` and `skills/mobile-engineering-core/SKILL.md`.
    2. Established compliance checklist for all Android and KMP projects.
  - Progress: Completed 100%.

- [2026-08-29] **Real Build & Runtime Verification Mandate (Rule 30 + Gate E20)** | Status: DONE
  - Objective: Mandated real terminal compilation and test execution (`./gradlew compileDebugKotlin`, `./gradlew test`) with verified `BUILD SUCCESSFUL` output before declaring any task complete.
  - Scope & Deliverables:
    1. Enforced Rule 30 and Gate E20 in `rules/21-enforcement-engine.md`.
    2. Eliminated false "done" claims without compiler verification.
  - Progress: Completed 100%.

- [2026-08-29] **Defensive & Aesthetic Jetpack Compose Layout Mandate (Rule 29 + Gate E19)** | Status: DONE
  - Objective: Enforced layout defensiveness (48dp touch bounds, non-linear 200% font scaling, keyboard auto-scroll) and Compose recomposition stability.
  - Scope & Deliverables:
    1. Enforced Rule 29 and Gate E19.
    2. Standardized `Modifier.imePadding()` and scroll container integrations.
  - Progress: Completed 100%.

- [2026-08-29] **GitHub Spec Kit & Spec-Driven Development (SDD) Integration Mandate (Rule 28 + Gate E18)** | Status: DONE
  - Objective: Integrated GitHub Spec Kit methodology, establishing the Tri-Artifact standard (`spec.md`, `plan.md`, `tasks.md`), 5-State UI Matrix, and Gherkin behavioral verification with zero spec drift.
  - Scope & Deliverables:
    1. Added `rules/28-spec-driven-development.md` and `skills/spec-driven-development/SKILL.md`.
    2. Enforced Gate E18.
  - Progress: Completed 100%.

- [2026-08-26] **Android Vitals, App Quality & 2-Tier Hybrid Splash Orchestrator Mandate (Rule 27 + Gate E17)** | Status: DONE
  - Objective: Enforced Google Play Android Vitals standards (Cold start TTID < 500ms, TTFD < 800ms, zero background crashes, zero ANRs) and 2-Tier Hybrid Splash Orchestration.
  - Scope & Deliverables:
    1. Added `rules/27-app-quality-vitals.md` and `skills/app-quality-vitals/SKILL.md`.
    2. Enforced Gate E17 and Baseline Profiles integration.
  - Progress: Completed 100%.

- [2026-08-26] **Stack vs Heap Memory Architecture Mandate & Enforcement Engine (Rule 26 + Gate E16)** | Status: DONE
  - Objective: Enforced Stack vs Heap discipline in Kotlin and Compose: zero object allocations in render loops, `@JvmInline value class` for IDs, primitive State, and 16KB page alignment on Android 15+.
  - Scope & Deliverables:
    1. Added `rules/26-stack-heap-memory.md` and `skills/stack-heap-memory/SKILL.md`.
    2. Enforced Gate E16.
  - Progress: Completed 100%.

---

# Final Rule

Task Memory represents the active execution state of work.

It must always be kept accurate, concise, and aligned with project standards.
