# 28-spec-driven-development.md

# SPEC-DRIVEN DEVELOPMENT (SDD) & LIVING CONTRACT MANDATE

## Purpose

This document establishes the official **Spec-Driven Development (SDD)** standard across the entire Antigravity Engine, learned and synthesized from the GitHub Spec Kit standard (`github/spec-kit`).

SDD inverts the traditional "vibe coding" (prompt-first, code-immediately) methodology. In SDD, **Specifications are the executable Single Source of Truth (SSOT)**. Code does not exist until the specification and architectural blueprint are formalized, reviewed, and approved.

---

# 1. THE CORE SDD PHILOSOPHY

1. **No Vibe Coding**: Never write production code, refactorings, or add libraries based on loose prompts. Every non-trivial feature or change MUST have a written, structured specification.
2. **Specifications as Living Contracts**: The specification is not a throwaway document. It is a living contract committed to version control that binds the AI agent and the human engineer to explicit requirements, data boundaries, and acceptance criteria.
3. **Zero Spec Drift**: Code MUST strictly adhere to the approved specification. An agent MUST NOT introduce un-specified logic, silent architectural diversions, or unapproved 3rd-party dependencies. If requirements change during implementation, the Specification MUST be updated first.

---

# 2. THE TRI-ARTIFACT STANDARD

Every feature or major architectural change MUST produce and maintain the **Tri-Artifact Standard**:

```
┌────────────────────────────────┐
│ 1. SPECIFICATION (spec.md)     │ ──> WHAT & WHY (Business intent, models, 5-state matrix, Gherkin)
└────────────────────────────────┘
                │
                ▼
┌────────────────────────────────┐
│ 2. ARCHITECTURE PLAN (plan.md) │ ──> HOW (Layers, contracts, Compose/MVI tokens, file touchpoints)
└────────────────────────────────┘
                │
                ▼
┌────────────────────────────────┐
│ 3. TASK CHECKLIST (tasks.md)   │ ──> EXECUTION (Ordered dependencies: Data -> Domain -> UI -> Test)
└────────────────────────────────┘
```

### Artifact 1: Specification (`docs/plans/feature_<name>_spec.md` or embedded in Living Spec)
* **Goal & Problem Statement**: Clear definition of user problem and business objective.
* **User Stories & Actors**: Who uses this feature and what outcome is expected.
* **Domain Model & Data Boundaries**: Entities, value classes, immutable attributes, and constraints.
* **UI/UX State Matrix**: Comprehensive mapping of all 5 UI states (see Section 3).
* **Acceptance Criteria (Gherkin Format)**: Testable `Given-When-Then` criteria for every interaction and use case.
* **Non-Functional Constraints**: Android Vitals budgets (Crash $< 0.05\%$, ANR $< 0.02\%$, Cold Start $< 500\text{ms}$), 16KB memory page alignment, Stack/Heap memory allocation budgets.

### Artifact 2: Architecture Plan (`docs/plans/feature_<name>_plan.md` or embedded in Living Spec)
* **Architecture Layer Mapping**: Clean Architecture separation (`Data` $\rightarrow$ `Domain` $\rightarrow$ `Presentation`).
* **Design System Mapping**: Reused tokens (`AppColors`, `AppTypography`, `AppSpacing`, `AppShapes`) vs new Atoms/Molecules.
* **Contract Definitions**: MVI UiState, MVIIntent, MVIEffect, Repository interfaces, and Navigation 3 `Screen` sealed hierarchy.
* **File Touchpoints**: Precise demarcation of changes (`[NEW]`, `[MODIFY]`, `[DELETE]`).
* **Risk & Memory Assessment**: Escape analysis, coroutine dispatcher safety, leak vectors, 16KB compatibility.

### Artifact 3: Task Execution Checklist (`docs/plans/feature_<name>_tasks.md` or embedded in Living Spec)
* **Dependency-Ordered Subtasks**:
  1. Data Layer (Entities, DAOs, DTOs, Repository Implementation).
  2. Domain Layer (Models, Repository Interfaces, Use Cases).
  3. Presentation Layer (MVI Contracts, ViewModel, Stateless & Stateful Composables).
  4. Navigation & DI (Route registration, Koin module bindings).
  5. Automated Verification (Unit Tests, Compose UI Tests, `./gradlew compileDebugKotlin`).
* **Verification Command for Each Task**: Concrete commands and expected outputs.

---

# 3. MANDATORY 5-STATE UI/UX MATRIX

In declarative Jetpack Compose applications, every screen and interactive organism MUST explicitly handle and define the **5-State Matrix**:

| State | Definition | Visual / Behavioral Requirement |
| :--- | :--- | :--- |
| **1. Loading** | Data is being fetched or computed asynchronously. | Skeleton shimmer or centralized non-blocking spinner; must NOT freeze UI. |
| **2. Content / Success** | Data successfully loaded and validated. | Render standard Compose components adhering to Design System tokens. |
| **3. Empty State** | Query succeeded but returned 0 results / empty list. | Meaningful illustration/icon, clear explanation, and primary Action button (e.g. "Create New", "Refresh"). |
| **4. Error State** | Network error, database error, or exception occurred. | Human-readable error message, retry button, and non-blocking snackbar/banner. |
| **5. Offline Mode** | Device disconnected from network. | Cached local data indicator, offline banner, and disabled online-only triggers. |

---

# 4. GHERKIN ACCEPTANCE CRITERIA STANDARD

All business logic, Use Cases, and ViewModel Intents MUST specify acceptance criteria using standard Gherkin syntax:

```gherkin
Scenario: [Behavioral test scenario name]
  Given [Precondition / Initial system state]
  And [Prepared test fixture or mock data]
  When [User performs an action / ViewModel receives Intent]
  Then [UiState updates accordingly]
  And [Side-effect Effect / Navigation is triggered]
```

---

# 5. ZERO SPEC DRIFT & REVISION WORKFLOW

1. **Change In Scope**: If during development the human engineer requests changes or new edge cases are discovered:
   * **STOP coding**.
   * Update the Specification (`spec.md` / Living Spec).
   * Update the Plan & Task Checklist (`plan.md`, `tasks.md`).
   * Resume implementation against the revised contract.
2. **Traceability**: All PRs and commit plans MUST link back to the Living Feature Spec in `docs/plans/`.

---

# 6. ENFORCEMENT & COMPLIANCE

* This rule is strictly guarded by **CATEGORY E18** in `rules/21-enforcement-engine.md`.
* No code may be marked complete without passing all 4 gates of SDD Compliance.
