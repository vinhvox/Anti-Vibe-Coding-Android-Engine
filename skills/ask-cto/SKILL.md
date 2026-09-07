---
name: ask-cto
description: Interactive CTO & Principal Architect meta-router for instantly identifying the right Antigravity skills, rules, and enforcement gates for any engineering challenge or symptom.
---

# Ask-CTO (The Principal Architect Meta-Router)

## Overview

Inspired by the `/ask-matt` router in Matt Pocock's `skills` framework, **Ask-CTO** serves as the central intelligent dispatcher across the 49+ specialized skills and 27 quality enforcement gates in the Antigravity Engine.

Instead of reading all documentation files, developers and subagents can describe their symptom or objective to immediately obtain:
1. The **Primary Skill** to invoke.
2. The **Mandatory Rules & Quality Gates** to enforce.
3. The **Recommended Architectural Approach** (CTO Lens).

---

## The CTO Diagnostic Routing Matrix

| Symptom / Developer Challenge | Primary Skill to Invoke | Mandatory Rules & Quality Gates | CTO Architectural Guidance |
| :--- | :--- | :--- | :--- |
| **"UI stuttering, dropped FPS during list scrolling"** | `stack-heap-memory` | `rules/26-stack-vs-heap-memory-management.md`<br>`Gate E19 (Memory & Allocation)` | Inspect allocations inside `@Composable` lambdas, specify `key = { it.id }` and `contentType`, memoize inline lambdas or use method references. |
| **"Data loss on screen rotation or process death"** | `mobile-engineering-core` | `rules/07-viewmodel.md`<br>`Domain 1 (Lifecycle & State)` | Apply 3-Tier State: Hoist all mutable inputs into `SavedStateHandle` or `rememberSaveable`. |
| **"Building new feature from vague requirements"** | `brainstorming` ➔ `spec-driven-development` | `rules/37-ubiquitous-language-standard.md`<br>`rules/28-spec-driven-development.md` | Run a grilling session (`/grill-me`), build `docs/CONTEXT.md` (Ubiquitous Language), then generate Tri-Artifact (`spec.md`, `plan.md`, `tasks.md`). |
| **"How to decompose tasks to avoid integration bugs"** | `writing-plans` | `skills/writing-plans`<br>`Tracer-Bullet Vertical Slicing` | Ban horizontal slicing (DAO ➔ Repo ➔ UI). Mandate razor-thin vertical slices (Tracer Bullets) from Data to UI per user flow. |
| **"UI looks rigid, flat, or AI-generated"** | `ui-ux-pro-max` | `rules/36-ui-ux-design-standard.md`<br>`Gate E27 (Anti-AI-Design-Cliché)` | Apply 0.5dp subtle borders, tonal surface hierarchy, 8-pt grid rhythm, and 3-tier typography. Ban purple-on-dark neon glow and vibrating pills. |
| **"Unexplained bug, race condition, or coroutine crash"** | `systematic-debugging` | `rules/12-error-handling.md`<br>`Domain 10 (Concurrency & Flow)` | Stop guessing. Isolate root cause, write a reproduction test before fixing (Red-Green TDD loop). |
| **"Designing Offline-First with Room caching & Ktor/Retrofit"** | `networking-ktor` & `room-database` | `rules/10-networking.md`<br>`rules/11-database.md`<br>`Domain 4 (Networking & SSOT)` | Room is Single Source of Truth (SSOT). Network pushes to DB only; UI observes Flow from DAO. Use Outbox Pattern for offline mutations. |
| **"Navigation 3: Screen transitions & ViewModel scoping"** | `navigation-3` & `navigation-3-di` | `rules/08-navigation.md`<br>`Domain 6 (Navigation 3)` | Navigation is reactive state (`SnapshotStateList<Screen>`). 100% routes use `@Serializable data class Screen`. Scope ViewModel to NavEntry. |
| **"Extracting new module, core library, or SDK"** | `sdk-modular-engineering` | `rules/34-sdk-modular-architecture.md`<br>`Gate E25 (API Surface)` | `internal` by default. Provide `:testing` module with test fakes. Zero ContentProvider auto-init, isolate host app crashes. |
| **"Quality check before closing PR / merging"** | `requesting-code-review` | `rules/21-enforcement-engine.md`<br>`Gates E1 — E28` | Run full 28 quality audit gates. Execute real `./gradlew test assembleDebug` before claiming completion. |

---

## Usage in Agent Conversations

Whenever you are unsure which skill or rule applies:
1. Announce: `"Invoking ask-cto meta-router to diagnose engineering approach..."`
2. Match the user's situation against the diagnostic matrix above.
3. Invoke the designated Primary Skill and immediately apply its mandatory gates.
