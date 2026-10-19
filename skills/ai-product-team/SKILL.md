---
name: ai-product-team
description: Complete Virtual AI-Native Product Studio workflow in Antigravity for Modern Android App & SDK development. Coordinates Product Owner, UI/UX Designer, Architect, App/SDK Builder, Adversarial QA, and CTO Orchestrator through strict Handoff Artifacts (Rule 42) and Antigravity 37 Quality Gates.
---

# Virtual AI-Native Product Studio (`ai-product-team`)

The **Virtual AI-Native Product Studio** turns Antigravity into an autonomous enterprise engineering team. Instead of letting multiple agents converse loosely in an unstructured chat (which leads to hallucination and context pollution), this team operates through **Strict Handoff Artifacts (Rule 42)** and **Isolated Subagent Execution Waves (Gate E37)**.

---

## 1. Studio Org Chart & Role Directory

```
                      ┌────────────────────────────────────────┐
                      │        USER / EXECUTIVE FOUNDER        │
                      │  (Business Vision, Approval, Sign-off) │
                      └──────────────────┬─────────────────────┘
                                         │
                      ┌──────────────────▼─────────────────────┐
                      │        MAIN AGENT (CTO ORCHESTRATOR)   │
                      │  (Pipeline Dispatcher, Synthesis, Gate) │
                      └──────┬──────────┬───────────┬──────────┘
                             │          │           │
       ┌─────────────────────┼──────────┴───────────┼────────────────────┐
       ▼                     ▼                      ▼                    ▼
┌──────────────┐     ┌──────────────┐       ┌──────────────┐     ┌──────────────┐
│product-owner │     │ ui-designer  │       │  architect   │     │ adversarial- │
│  (Read-Only) │     │ (Read-Only)  │       │ (Read-Only)  │     │   reviewer   │
│  `spec.md`   │     │`design-spec` │       │  `plan.md`   │     │ (Read-Only)  │
└──────┬───────┘     └──────┬───────┘       └──────┬───────┘     └──────▲───────┘
       │                    │                      │                    │
       └────────────────────┼──────────────────────┘                    │
                            ▼                                           │
             ┌──────────────────────────────┐                           │
             │   app-builder / sdk-builder  │                           │
             │        (Write-Enabled)       │───────────────────────────┘
             │  Implementation & Local Test │    (Code Diff for Audit)
             └──────────────────────────────┘
```

| Role | Subagent Type | Permissions | Core Deliverables | Applicable Gates |
| :--- | :--- | :--- | :--- | :--- |
| **Founder / Stakeholder** | User | Human | Vision, Business Objectives, Gate Approvals | Executive Sign-off |
| **CTO & Orchestrator** | Main Agent (`self`) | Full Orchestration | Pipeline orchestration, synthesis, auto-grilling, user checkpoints | Master Mandate, Rule 00 |
| **Product Owner** | `product-owner` | **Read-Only** | `spec.md`, Gherkin Scenarios, 5-State UI Matrix, Ubiquitous Glossary | Rule 36, Rule 37 |
| **UI/UX Designer** | `ui-designer` | **Read-Only** | `design-spec.md`, Design Tokens, 8dp Grids, XML Vector Drawables | Rule 36, E3, E4 |
| **Principal Architect** | `architect` | **Read-Only** | `plan.md`, Layer Boundaries, Public API Surface, ADRs | E25.1, E37, Codebase Design |
| **Lead App Builder** | `app-builder` | **Write-Enabled** | Jetpack Compose M3 UI, ViewModels, atomic `_state.update`, Unit Tests | E1–E4, E26, E29 |
| **Lead SDK Builder** | `sdk-builder` | **Write-Enabled** | `internal` modules, `:testing` fakes, `Result<T>` isolation, 16KB `.so` | E25, E26.3, E34.2 |
| **Adversarial QA** | `adversarial-reviewer` | **Read-Only** | Red-Team Audit Report, Living Traceability Proof, Bug tickets | Gates E1–E37 |

---

## 2. The 5-Station Handoff Pipeline (Rule 42)

Multi-agent coordination MUST never rely on informal chat. Work progresses strictly across **5 Stations**, each producing an immutable artifact:

```
[Vision] ➔ Station 1 (PO) ────► `spec.md`
                                   │
         ➔ Station 2 (UI) ────► `design-spec.md`
                                   │
         ➔ Station 3 (Arch) ──► `plan.md` + ADR
                                   │
         ➔ Station 4 (Dev) ───► Code Diff + Green Test Logs
                                   │
         ➔ Station 5 (QA) ────► Adversarial Audit Certificate (E1–E37) ➔ [User Sign-off]
```

### Station 1: Product Specification (`product-owner`)
- **Input:** User prompt / requirement / feature request.
- **Action:** Subagent `product-owner` examines codebase and decomposes requirements.
- **Output Artifact:** `spec.md` containing:
  1. Ubiquitous Domain Vocabulary (Rule 37).
  2. Gherkin Scenarios (`Given-When-Then`) for every business flow.
  3. **5-State UI Matrix**: Loading, Success, Empty, Error, Offline.
  4. Non-Goals & Out-of-Scope boundaries (Ponytail YAGNI).
- **Gate Check:** Must pass Ponytail Rung 1 ("Does this need to exist?").

### Station 2: Visual & Design System (`ui-designer`)
*(Skipped automatically for headless SDK/library modules)*
- **Input:** `spec.md`.
- **Action:** Subagent `ui-designer` establishes design system tokens and visual assets.
- **Output Artifact:** `design-spec.md` containing:
  1. Material 3 Semantic Color mappings (`Primary`, `Surface`, `OnSurface`, etc.).
  2. 8dp Spatial Grid specifications (padding, margins, touch targets $\ge 48\text{dp}$).
  3. Vector Drawable XML blueprints (`res/drawable/ic_*.xml`). **Zero raw inlined emojis permitted**.
  4. 5-State Component Visual Specs (Shimmer loading, empty-state illustration vector, retry button layout).

### Station 3: Architectural Blueprint (`architect`)
- **Input:** `spec.md` and `design-spec.md`.
- **Action:** Subagent `architect` formulates technical structure and contracts.
- **Output Artifact:** `plan.md` containing:
  1. Target module type (`com.android.application` vs `com.android.library`).
  2. Layer boundaries (Presentation ➔ Domain ➔ Data).
  3. Public API surface contracts (for SDKs: `internal` by default, deliberate public interfaces).
  4. Sequence of GSD Execution Waves (Wave 1: Contracts/Fakes, Wave 2: Domain/Data, Wave 3: UI/Presentation).
  5. Architectural Decision Records (ADRs) explaining technical trade-offs.

### Station 4: Lead Development Wave (`app-builder` / `sdk-builder`)
- **Input:** `plan.md`, `spec.md`, `design-spec.md`.
- **Action:** CTO Orchestrator launches builder subagent with fresh 200k context.
- **Deliverables:**
  1. Production code adhering to Android 2026 standards:
     - ViewModels use atomic `_state.update { copy(...) }`.
     - UI uses `collectAsStateWithLifecycle()`.
     - SDK modules wrap external errors in `Result<T>` and provide companion `:testing` test fakes.
  2. Characterization & Unit Tests:
     - Turbine StateFlow tests (`flow.test { ... }`).
     - Compose semantics tests with half-dp bounds checking.
  3. Verification logs proving local tests pass green.

### Station 5: Adversarial Red-Team Audit (`adversarial-reviewer`)
- **Input:** Git diff of changes + Test logs.
- **Action:** Subagent `adversarial-reviewer` performs unbiased verification.
- **Output Artifact:** `audit-report.md` evaluating:
  1. **Living Traceability:** 100% of Gherkin scenarios in `spec.md` map to concrete automated tests.
  2. **Gates E1–E37 Compliance:** Scans for coroutine leaks, DEX bloat, hardcoded strings/emojis, wildcard Proguard keeps, and Play Store policy risks (`#policy`).
  3. **Pass/Fail Verdict:** If any gate fails, precise bug reproduction steps are routed back to Station 4 before human sign-off.

---

## 3. CTO Orchestration Workflows

The CTO Orchestrator dispatches subagents depending on the scope of the request:

### Pipeline A: Full App Feature Workflow
```text
User Request ──► [Auto-Grilling] ──► Station 1 (PO) ──► Station 2 (UI) ──► Station 3 (Arch) ──► Station 4 (App-Builder) ──► Station 5 (QA) ──► Presentation to User
```

### Pipeline B: SDK / Core Library Workflow (Headless)
```text
User Request ──► [Auto-Grilling] ──► Station 1 (PO) ──► Station 3 (Arch: Gate E25) ──► Station 4 (SDK-Builder) ──► Station 5 (QA) ──► Presentation to User
```
*(Station 2 is skipped because SDKs provide headless APIs without Compose UI screens).*

### Pipeline C: Fast Bug Diagnosis & Fix
```text
Bug Report ──► Root-Cause Tracing ──► Station 3 (Arch Plan) ──► Station 4 (Builder: Failing Test First) ──► Station 5 (QA Verify) ──► User
```

---

## 4. Subagent Dispatch Commands Reference

The CTO Orchestrator executes subagents via `invoke_subagent`:

```json
// Example: Invoking Station 1 (PO)
{
  "Subagents": [
    {
      "TypeName": "product-owner",
      "Role": "Product Owner",
      "Model": "pro",
      "Prompt": "Analyze user request: Add biometric authentication to login flow. Create spec.md including ubiquitous domain vocabulary, Gherkin scenarios, 5-state UI matrix (Loading, Success, Empty, Error, Offline), and non-goals. Output only the spec artifact."
    }
  ]
}

// Example: Invoking Station 2 (UI Designer)
{
  "Subagents": [
    {
      "TypeName": "ui-designer",
      "Role": "UI Designer",
      "Model": "pro",
      "Prompt": "Based on spec.md, design design-spec.md for Biometric Login. Define Material 3 tokens, 8dp spatial rules, and author XML Vector Drawables for fingerprint and face-unlock icons. Emojis strictly prohibited."
    }
  ]
}
```

---

## 5. Non-Negotiable Quality Safeguards

1. **Zero Auto-Commit:** Subagents and Orchestrator NEVER run `git commit`, `git add`, or `git push`. Version control stays with the user.
2. **Fresh Context Waves (Gate E37):** Heavy refactoring or long implementations must be split into isolated subagent waves to prevent context saturation.
3. **Evidence Before Assertions:** The team never claims a feature is complete without providing verifiable build or test execution logs.
4. **Ponytail YAGNI:** The Product Owner and Architect must prune speculative abstractions before any builder touches code.
