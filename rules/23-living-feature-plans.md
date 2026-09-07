# 23-living-feature-plans.md

# LIVING FEATURE SPECIFICATIONS & SPEC-DRIVEN DEVELOPMENT RULE

## Purpose

This rule mandates that all feature implementation plans and specifications are saved directly within the project repository as persistent, version-controlled **Living Feature Specifications** following the **Spec-Driven Development (SDD)** standard.

This prevents plan sprawl, fragmented documentation, and unanchored AI code generation.

---

## 1. Primary Mandates

### A. Project-Local Storage & SDD Tri-Artifact Standard
- **Storage Directory**: All feature specifications MUST be saved in the project repository under:
  `docs/plans/`
- **Living Spec Suite**: Every non-trivial feature is maintained either as a unified living spec (`docs/plans/feature_<feature_name>.md`) or as the SDD Tri-Artifact suite:
  1. `docs/plans/feature_<feature_name>_spec.md` (What & Why: Requirements, 5-State Matrix, Gherkin criteria).
  2. `docs/plans/feature_<feature_name>_plan.md` (How: Clean Architecture, MVI contracts, DTOs, file touchpoints).
  3. `docs/plans/feature_<feature_name>_tasks.md` (Execution: Dependency-ordered checklist with test commands).
- **Git Tracking**: Plans and specs are part of the codebase documentation and MUST be committed to Git alongside source code.

### B. Single Source of Truth (One Feature = One Living Spec)
- **Zero Plan Sprawl**: Never create fragmented plan files for incremental updates (e.g., `feature_login_v1.md`, `feature_login_update.md`).
- **Living Spec Standard**: Every feature has exactly ONE living spec file. Subsequent changes MUST update and append to the existing feature plan.

---

## 2. Structure of a Living Feature Spec

Every unified `docs/plans/feature_<feature_name>.md` MUST follow this structure:

```markdown
# Living Feature Spec: <Feature Name>

## Status: <ACTIVE | IN_PROGRESS | DEPRECATED>
## Last Updated: <YYYY-MM-DD>

---

## 1. Business Specification (WHAT & WHY)
- **Problem Statement & Goal**: User need and business value.
- **User Stories & Actors**: Journey walkthrough.
- **5-State UI Matrix**: Loading, Content/Success, Empty, Error, Offline.
- **Gherkin Acceptance Criteria**: Given-When-Then behavioral criteria.

---

## 2. Technical Architecture Blueprint (HOW)
- **Data Layer**: DataSources, Repositories, DTOs, Mappers.
- **Domain Layer**: UseCases, Domain Models.
- **Presentation Layer**: ViewModels, StateFlow/SharedFlow, Compose Screen/Components.
- **Navigation**: Type-safe Navigation 3 routes.
- **Dependency Injection**: Koin bindings.
- **Test Matrix**: Unit test suites and UI test coverage.

---

## 3. Iteration History & Change Log

### [YYYY-MM-DD] Revision X.Y — <Brief Summary of Change>
- **Objective**: <Why this change is being made>
- **Modified Components**:
  - `[MODIFY]` filename: details
  - `[NEW]` filename: details
- **Verification Log**: Actual test execution evidence (compile & unit tests).
```

---

## 3. Workflow Integration

1. **Before Planning**: Check if `docs/plans/feature_<feature_name>.md` exists in the project.
2. **If Exists**: Read existing spec $\rightarrow$ Update section 1 & 2 $\rightarrow$ Append new revision under section 3 (Iteration History).
3. **If New**: Create `docs/plans/feature_<feature_name>.md` with initial Revision 1.0 adhering to SDD standards.

