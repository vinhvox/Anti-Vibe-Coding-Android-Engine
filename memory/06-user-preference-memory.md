# 06-user-preference-memory.md

# User Preference Memory

## Purpose

This document defines how the AI learns, stores, and applies stable user preferences during engineering collaboration.

User Preference Memory captures how the user prefers to work, communicate, and make engineering decisions.

Its purpose is to improve collaboration by adapting to the user's preferred workflow without changing project architecture or engineering correctness.

User preferences should improve the experience, not override engineering quality.

---

# Philosophy

Every engineer works differently.

Some prefer detailed explanations.

Some prefer direct implementation.

Some value performance over simplicity.

The AI should adapt its collaboration style while preserving technical correctness.

Learn preferences.

Respect preferences.

Do not assume preferences.

---

# Primary Goal

Understand and consistently apply the user's long-term collaboration preferences.

Examples include:

Communication style

Review style

Planning depth

Implementation style

Documentation preference

Testing expectations

Refactoring preference

Workflow preference

User Preference Memory should make future collaboration smoother.

---

# Preference Lifecycle

Every preference follows this lifecycle.

```text
Observe
    │
    ▼
Confirm
    │
    ▼
Validate Stability
    │
    ▼
Store
    │
    ▼
Apply
    │
    ▼
Revalidate
```

Only stable preferences should be retained.

---

# What To Store

User Preference Memory may store:

Preferred communication language

Preferred explanation depth

Preferred implementation style

Preferred review format

Preferred documentation format

Preferred commit style

Preferred testing expectations

Preferred code generation style

Preferred debugging workflow

Preferred planning detail

Preferred response structure

Preferred collaboration rhythm

---

# What NOT To Store

Never store:

Temporary requests

One-time instructions

Session-specific preferences

Sensitive personal information

Business secrets

Experimental preferences

Current task requirements

Temporary mood

These belong to Session Memory or should not be stored.

---

# Preference Categories

Communication

Engineering Workflow

Code Style

Review Style

Documentation

Testing

Architecture Discussion

Learning Style

Debugging

Planning

Automation

Reporting

---

# Preference Detection

A preference becomes stable only if:

The user explicitly requests it.

OR

The user consistently repeats it across multiple interactions.

One occurrence is not enough unless the user clearly states it is a permanent preference.

---

# Preference Priority

Apply preferences using this order:

Explicit instruction in current request

↓

Current session instruction

↓

Stored user preference

↓

Project standards

↓

Engineering best practices

Current requests always override stored preferences.

---

# Preference Validation

Before storing verify:

Is it stable?

Will it likely apply in future work?

Does it improve collaboration?

Does it conflict with project rules?

If uncertain,

do not store it.

---

# Preference Application

Apply preferences only when relevant.

Examples:

Use the preferred language.

Match the preferred explanation depth.

Structure responses as preferred.

Generate code according to agreed conventions.

Do not force preferences into unrelated tasks.

---

# Preference Evolution

Users change.

If the user explicitly changes a preference:

Validate.

Update the stored preference.

Deprecate the previous preference.

Never keep conflicting preferences active.

---

# Preference Conflict

If multiple preferences conflict:

Priority order:

Current user request

↓

Current session instruction

↓

Latest validated preference

↓

Default collaboration style

Never ignore an explicit request.

---

# Collaboration Adaptation

The AI should gradually adapt to:

Preferred communication pace

Preferred planning depth

Preferred implementation detail

Preferred review process

Preferred level of explanation

Adaptation should feel natural.

---

# Self Validation

Before applying a preference verify:

Is it still relevant?

Does it conflict with the current request?

Has the user recently changed it?

Is it appropriate for this task?

If not,

do not apply it.

---

# Anti-patterns

Never:

Invent preferences.

Assume one-time requests are permanent.

Store sensitive information without explicit permission.

Override explicit user instructions.

Apply preferences blindly.

Confuse project standards with user preferences.

---

# Active User Preferences

- **World-Class UI/UX Design & Anti-AI-Slop Mandate:**
  - **Eliminate 100% of Cliché AI Motifs (Anti-AI-Design-Clichés):** Strictly FORBID interfaces with excessive dark-purple backgrounds (purple on dark), glowing neon outlines, pulsing biscuit/pill badges, flashy text gradients, and claustrophobic 3-4 level nested cards.
  - **Visual Depth & Subtle Borders:** Every Card/Container must have a subtle **0.5dp — 1dp** translucent border (`AppTheme.colors.outlineVariant.copy(alpha = 0.5f)`) and coordinate tonal surface layers (`surfaceContainerLowest` to `surfaceContainerHigh`) to create optical depth and sophistication.
  - **Golden Ratio 3-Tier Typography:** Distinct contrast between Hero Display (28-34sp Bold, tracking -0.5sp) > Section Title (18-22sp SemiBold) > Body (14-16sp, line-height 1.4x) > Meta (11-12sp onSurfaceVariant).
  - **8-Point Grid Rhythm:** 100% of spacing aligns with tokens `4dp`, `8dp`, `16dp`, `24dp`, `32dp`.
  - **Domain-Tailored Aesthetics:** Design according to industry domain identity (Fintech: trustworthiness, E-Commerce: high-conversion clarity, SaaS: minimal data density, Media: vibrant visuals).
  - **Delicate Micro-Interactions:** Mandatory smooth ripple effects and natural shimmer skeleton loading states.

- **Automated ProGuard & R8 Rules Synthesis Mandate:**
  - **Automated Codebase Inspection:** When configuring ProGuard/R8 or preparing a Release build, the AI automatically scans `libs.versions.toml`, `build.gradle.kts`, DTOs, Room Entities, and Navigation 3 Routes across the workspace.
  - **Standardized 2-Tier Rule Separation:**
    1. Module/SDK Layer: Auto-generates `consumer-rules.pro` (bundles keep rules for DTOs, Entities, DAOs so host apps do not require manual configuration).
    2. Host App Layer: Auto-generates `proguard-rules.pro` (configures R8 FullMode, Coroutines internals, and release log stripping).
  - **Real Release Build Verification:** Mandatory execution of `./gradlew assembleRelease` to prove zero missing keep rules prior to completion.

- **The 7 AI Blind Spots Defense Mandate:**
  1. *Lazy Layout Keys*: Mandatory specification of `key = { it.id }` and `contentType` in `LazyColumn`/`LazyRow` to eliminate unnecessary full-list recompositions and frame drops.
  2. *Duplicate Click Lock*: Lock state in ViewModel (`if (state.value.isLoading) return@safeLaunch`) and apply 400ms debounce on navigation actions.
  3. *Form State Survival*: Use `rememberSaveable` or hoist into `SavedStateHandle` for all user inputs to survive configuration changes, theme swaps, and Process Death.
  4. *Keyboard Auto-Scroll*: Pair `Modifier.imePadding()` with scroll containers and `BringIntoViewRequester` to prevent the software keyboard from covering input fields.
  5. *Modern API & Navigation 3 Purity*: 100% native Material 3 APIs and `@Serializable data class Screen` in Navigation 3 (ban legacy Accompanist and raw string routes).
  6. *Localization & Plurals*: 100% `pluralStringResource` and `stringResource` with placeholders; strictly ban manual string concatenation such as `"$count items"` or `"$ " + price`.
  7. *Zero-Fluff Direct Communication*: Present findings concisely and directly with CTO-grade clarity, without generic introductory boilerplate.

- **Self-Documenting Code & Ban on Trivial Comments:**
  - **Self-Documenting Naming:** Variable, function, class, and interface names must unambiguously express intent and domain concepts (`isUserSubscribed`, `fetchUserProfile`, `calculateDiscountAmount`).
  - **Zero Trivial Comments:** Strictly FORBID obvious comments that mirror function/variable names (e.g. `// Load data`, `// User ID`, `// Handle click`, `// Initialize viewModel`).
  - **Comment for "WHY", Never "WHAT":**
    - Comments are permitted only when explaining:
      1. Complex mathematical formulas or non-obvious algorithms.
      2. Mandatory workarounds for platform, OS, or third-party library bugs.
      3. Subtle hardware invariants or concurrency edge cases.
    - All other comments are considered code clutter and must be removed.

- **Zero-Crash, Zero-ANR, Zero-Leak Default Invariant & Anti-Try-Catch-Sprawl Mandate:**
  - **Default Invariant:** The user does NOT need to repeat "ensure no crash, ANR, or leak" on every prompt. All AI-written code must achieve Zero-Crash, Zero-ANR, Zero-Leak standards by default.
  - **Ban on Indiscriminate Try-Catch (Anti-Defensive Paranoia):** Forbid wrapping Presentation (Compose UI) or ViewModel/Domain layers in generic try-catch blocks to conceal underlying flaws.
  - **Precise Error Boundaries:** Place error handling and result wrappers strictly at the single **I/O Boundary** (Network APIs, Room Database, File I/O, JSON Deserialization) via `AppResult<T>`.
  - **Structural Safety:**
    1. *Zero-Crash*: Enforced via Kotlin Null-Safety (`val`, `T?`, smart casts), exhaustive `when` without fallback `else ->`, and immutable State Flow (`_state.update { copy(...) }`).
    2. *Zero-ANR*: Enforced via Main-Thread Purity (`Dispatchers.IO` for Disk/Network, `Dispatchers.Default` for heavy computation, non-blocking asynchronous Flow).
    3. *Zero-Leak*: Enforced via lifecycle-bound scopes (`viewModelScope`, `DisposableEffect` with `onDispose`), strictly forbidding static references to `Context` or `View`.

- **Proactive CTO/PO Advisory & Constructive Pushback Rule:**
  - When reviewing requirements, designs, or code snippets, evaluate through two lenses:
    1. **CTO Lens (Performance & Architecture)**: Recomposition stability, heap allocations in composables, main-thread purity, Process Death recovery, and the 19 Core Domains.
    2. **PO Lens (Product & UI/UX)**: 5-State UI Matrix, zero dead-ends, insets and keyboard handling, 48dp touch bounds, non-linear 200% font scaling, and visual hierarchy.
  - Strictly FORBID passive agreement (Anti-Yes-Man). Proactively identify potential bottlenecks and propose superior architectural alternatives with structured Before vs After comparisons:
    - 🎯 **CTO/PO Assessment** (Strategic objectives & business value)
    - ⚠️ **Critical Risks & Bottlenecks** (Performance hazards, stutter, or dead-end user flows)
    - 💡 **Recommended Architectural Solution** (Optimized architecture & production-ready code)

- **Mandatory Pre-Completion Verification:**
  - Prior to claiming completion on any task, execute real compiler verification (`./gradlew compileDebugKotlin`, `./gradlew test` or equivalent) and verify `BUILD SUCCESSFUL` output.
  - Never declare tasks finished based solely on code edits without terminal verification.

- **Clarification & Explicit Confirmation Flow Rule:**
  - If requirements are ambiguous or underspecified, proactively ask clarifying questions.
  - Once requirements are understood, present a clear summary of understanding and task breakdown, then wait for explicit confirmation before mutating code.

- **3rd-Party Library Consent & 16KB Page Alignment Audit Rule:**
  - All proposed third-party dependencies must be explicitly presented and approved in the planning phase.
  - Must verify that libraries are secure, maintained, and compliant with 16KB Memory Page Alignment requirements on Android 15+.

- **Plan Artifact Project Storage Location Rule:**
  - All approved execution plans must be stored as Markdown files directly within the project's `docs/plans/` directory.

- **Mandatory Code Quality Gate:**
  - Prior to completing any UI-related task, conduct a self-audit against Design System rules:
    1. Scan for raw `Color(0x` in presentation → must use `AppTheme.colors.*`
    2. Scan for hardcoded `.dp` → must use `AppSpacing.*`, `AppShapes.*`
    3. Scan for hardcoded `Text("` → must use `stringResource(R.string.xxx)`
    4. Scan for unstyled `Text()` → must use typography composables (`Heading1`, `Body1`...)
    5. Verify Dark Theme compatibility → ban hardcoded `Color.White` or `Color.Black`
  - Any violation rejects the implementation until rectified.

- **Mandatory Architecture Compliance Gate:**
  - Prior to completing any ViewModel-related task, conduct an architecture compliance check:
    1. All ViewModels must inherit from `BaseViewModel<State, Intent, Effect>` — raw `ViewModel()` is prohibited.
    2. All coroutines must use `launch {}` (safeLaunch) — raw `viewModelScope.launch {}` is prohibited.
    3. Remove dead code (methods not dispatched from `onIntent()`).
    4. `when (intent)` must be exhaustive without fallback `else ->`.
  - Violations must be reported and resolved before proceeding with new feature logic.

- **Stub/Placeholder Detection Rule:**
  - When constructing or modifying features, verify:
    1. Is `delay()` used to simulate asynchronous progress?
    2. Is hardcoded dummy data used instead of real backend/repository integration?
    3. Are any `// TODO`, `// placeholder`, `// stub`, or `// fake` tags present?
  - If placeholder logic is unavoidable, clearly notify the user and label it as "⚠️ Simulation/Coming Soon". Never report completion if backend logic relies on fake delays.

- **Violation-First Refactoring Rule:**
  - If existing files contain violations (hardcoded colors, bypassed safeLaunch, broken MVI):
    1. Report the violation to the user.
    2. Propose remediation alongside the current task.
    3. Never add new code on top of unresolved legacy violations without reporting.

- **Mandatory No Auto-Commit Mandate:**
  - The AI must NEVER execute `git commit` autonomously under any circumstances.
  - All commit actions must be explicitly initiated or approved by the developer.

- **Mandatory Background Task Cleanup & Non-Lingering Process Rule:**
  - When running background CLI or Gradle tasks, check `manage_task(Action="list")` upon output verification and call `manage_task(Action="kill", TaskId=...)` immediately to free resources.
  - Never allow lingering background tasks in `running` state on the UI after execution completes.

- **Project-Scoped Auto-Approval & Strict Out-of-Project Isolation Mandate:**
  - **In-Project Workspace:** Once a plan is approved, the AI is authorized to create and modify source files inside project boundaries (`app/src/main/`, `domain/`, `data/`, `presentation/`, `di/`, `core/`) using native tools (`write_to_file`, `replace_file_content`).
  - **Eliminate Shell File Creation:** Strictly FORBID shell redirection commands (`cat << 'EOF' > ...`, `echo >`, `tee`) for file mutations to prevent permission popups.
  - **Strict Out-of-Project Boundary:** The AI is strictly FORBIDDEN from modifying, creating, or deleting any files outside the project workspace (system files, `~/.zshrc`, `~/.bash_profile`, Desktop, user directories). Any external operation requires explicit approval.

---

# Final Rule

User Preference Memory exists to improve long-term collaboration.

The AI should adapt to how the user prefers to work,

while always respecting explicit instructions, project standards, and sound engineering practices.