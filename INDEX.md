# ANTIGRAVITY FRAMEWORK — INTER-SYSTEM INDEX

## Purpose

This is the **single reference file** that maps relationships between all 90+ files across Brain, Memory, Workflow, Rules, and Skills.

Use this file to quickly find which files are related to any given topic.

---

# MASTER PIPELINE (Unified)

```text
User Request
      │
      ▼
[Fast-Path] .context-digest.md ─── Ingest 100% Core Context in 1 Read (~5.4K tokens)
      │
      ▼
[Brain] 00-master-cognition ─── Intent Detection
      │
      ▼
[Brain] 01-communication ────── Receive & Parse
      │
      ▼
[Brain] 02-context-engine ───── Collect Codebase Context
      │
      ▼
[Memory] 07-context-retrieval ── Retrieve Project/Session/Decision Memory
      │
      ▼
[Brain] 03-clarification ────── Ask Only What Context Cannot Answer
      │
      ▼
[Brain] 04-assumption ──────── Mark & Validate Assumptions
      │
      ▼
[Brain] 05-decision ─────────── Choose Strategy
      │
      ▼
[Brain] 09-confidence ───────── Evaluate Confidence (≥85% → proceed)
      │
      ▼
[Brain] 06-planning ─────────── Create Execution Plan (if needed)
      │
      ▼
[Workflow] Dispatch to appropriate phase (01-10)
      │
      ▼
[Brain] 07-execution ────────── Execute with Rules + Skills
      │
      ▼
[Rules] 21-enforcement-engine ── Self-Audit All Applicable Rules
      │
      ▼
[Brain] 08-reflection ───────── Review Quality
      │
      ▼
[Memory] Update (01-project, 03-task, 04-decision, 05-pattern)
      │
      ▼
[Brain] 11-learning ─────────── Extract Reusable Knowledge
      │
      ▼
[Brain] 10-initiative ──────── Suggest Improvements
      │
      ▼
Deliver Result
```

---

# CROSS-REFERENCE MAP

## Brain → Everything

| Brain Engine | Consumes From | Produces For |
|-------------|--------------|-------------|
| `00-master-cognition` | User Request | All engines |
| `01-communication` | User Request | `02-context-engine` |
| `02-context-engine` | Codebase, `memory/01-project`, `memory/07-context` | `03-clarification` |
| `03-clarification` | `02-context-engine` output | `04-assumption` |
| `04-assumption` | `03-clarification` output | `05-decision` |
| `05-decision` | `04-assumption` output | `09-confidence` |
| `06-planning` | `05-decision` output | `workflow/*` |
| `07-execution` | `06-planning` output, `rules/*`, `skills/*` | `08-reflection` |
| `08-reflection` | Implementation output | `memory/*` updates |
| `09-confidence` | `05-decision` output | `06-planning` or STOP |
| `10-initiative` | `08-reflection` output | User suggestions |
| `11-learning` | `08-reflection` output | `memory/05-pattern` |

---

## Workflow → Rules → Skills Mapping

| Workflow Phase | Required Rules | Recommended Skills |
|---------------|---------------|-------------------|
| `01-requirement-analysis` | `00-system-mandate` | `request-processing-flow` |
| `02-codebase-analysis` | `02-architecture`, `14-code-reuse` | `architecture`, `clean-code` |
| `03-architecture-design` | `02-architecture`, `01-tech-stack` | `architecture`, `mvi`, `navigation-3` |
| `04-implementation-planning` | `04-feature-construction`, `03-base-layer`, `23-living-feature-plans` | `mvi`, `compose-essentials`, `writing-plans` |
| `05-feature-development` | `04-feature-construction`, `05-design-system`, `06-compose`, `07-viewmodel`, `08-coroutines`, `11-navigation`, `12-dependency-injection`, `22-superpowers-tdd`, `23-living-feature-plans` | `compose-essentials`, `material-design`, `koin`, `navigation-3`, `coroutines-flow`, `mvi`, `superpowers` |
| `06-code-review` | `05-design-system`, `07-viewmodel`, `13-error-handling`, `14-code-reuse`, `21-enforcement-engine`, `22-superpowers-tdd` | `clean-code`, `anti-patterns`, `superpowers` |
| `07-testing-validation` | `20-testing`, `22-superpowers-tdd` | `testing`, `superpowers` |
| `08-performance-review` | `16-performance` | `performance`, `lists-grids` |
| `09-security-review` | `17-security` | N/A |
| `10-release` | `19-build`, `18-monetization` | `gradle-build`, `ci-cd-distribution` |

---

## Rules → Enforcement Mapping

| Rule File | Enforcement Category | Scan Pattern |
|----------|---------------------|-------------|
| `02-architecture` | E3 (Clean Architecture & SSOT) | Import direction, fake data, Offline-First Room SSOT |
| `05-design-system` | E1 (Design System) | `Color(0x`, hardcoded `.dp`, `Text("` |
| `06-compose` | E4 (Compose & Recomposition) | `Scaffold(`, stability, lambda memo, Phase Deferral, Lazy keys & contentType |
| `07-viewmodel` | E2 (ViewModel) | `BaseViewModel`, `viewModelScope.launch`, dead code |
| `08-coroutines` | E5 (Coroutines) | Unscoped `CoroutineScope(`, dispatcher |
| `09-networking` | E7 (Error Handling) | Raw exception propagation |
| `11-navigation` | E6 (Navigation) | String routes, URI parsing |
| `12-dependency-injection` | E10 (DI) | Manual instantiation, missing bindings |
| `13-error-handling` | E7 (Error Handling) | `catch (e: Exception)`, raw throws |
| `17-security` | E8 (Security) | Hardcoded secrets, Zip Slip |
| `20-testing` | E9 (Testing) | Build verification, test coverage |
| `22-superpowers-tdd` | E11 (TDD & Evidence Verification) | Red-Green-Refactor execution, mandatory logs |
| `23-living-feature-plans` | E12 (Living Specs & Project Plans) | `docs/plans/feature_<name>.md`, no plan sprawl |
| `24-rtk-token-killer` | E13 (Token Optimization & Output Compression) | `rtk gradlew`, `rtk git`, `rtk npm`, `rtk test` |
| `28-spec-driven-development` | E18 (Spec-Driven Development) | `spec.md`, 5-State Matrix, Gherkin Given-When-Then, Tri-Artifact |
| `29-ui-layout-defense` | E19 (UI Aesthetics & Layout Defense) | Unweighted Row text, unanchored Box, missing Ellipsis, rigid chip Rows |
| `30-build-runtime-verification` | E20 (Real Build & Runtime Verification) | `assembleDebug`, Koin DI graph integrity, initial data triggers, AAPT2 |
| `31-mobile-engineering-core` | E21 (Mobile Engineering 19-Core Defense) | Process Death, WorkManager cancellation, JIT permissions, SSOT Outbox, 16KB alignment |
| `32-anti-overengineering-minimalism` | E22 (Anti-Overengineering & Minimalism) | Ponytail Decision Ladder, redundant wrappers/UseCases, single-expression idioms, stdlib first |
| `06-user-preference-memory` | E23 (AI Blind Spots & Defensive Gates) | Lazy layout keys, duplicate click lock, form state survival, IME auto-scroll, modern imports, plurals, zero fluff |
| `33-modern-testing-standard` | E24 (Modern Testing & QA Gates) | Turbine StateFlow testing, Fakes > Mocks, zero-flakiness runTest, Koin appModule.verify, 5-State UI Matrix coverage |
| `34-sdk-modular-architecture` | E25 (SDK & Modular Quality Gates) | Public API surface isolation, mandatory :testing fakes, zero auto-init, Gradle isolation, host app protection |
| `35-database-migration-r8-defense` | E26 [Quick Tag: `#dex`] (DB Migration & R8 ProGuard Release Gates E26.1–E26.9) | Zero destructive migration, schema export & migration tests, consumer proguard rules, serialization keep guard, real release minify build, R8 Full Mode, ban wildcard keeps, zero redundant rules, DEX optimization & blast radius audit |
| `36-ui-ux-design-standard` | E27 (UI/UX & Haute Couture Design Gates) | Anti-AI-Slop Cliché Filter, Optical Depth & 0.5dp Specular Hairline, Editorial Negative Tracking, Chromatic Restraint 90/10, Tactile Spring Physics |
| `38-device-network-abuse-policy` | E29 [Quick Tag: `#policy`] (Google Play Device & Network Abuse Gates E29.1–E29.6) | Zero DCL, Android 14+ FGS/UIDT, REQUIRE_SECURE_ENV, FLAG_SECURE, WebView JS guard, Anti-Proxy |
| `28-spec-driven-development` | E31 (Problem Deconstruction & 6-Dimension Test Coverage Gates) | Happy-Path Rejection, 6-Dimension Boundary Coverage, Concurrency & Re-Entrancy Tests, Invariant Assertions |
| `40-refactoring-safety-net` | E32 (Senior Refactoring Safety Net & Characterization Gates) | Pre-Emptive Edit Block, Green Baseline Verification, Micro-Step Discipline, Zero Observable Regression |
| `41-scientific-closed-loop-debugging` | E33.1, E33.2 (Scientific Closed-Loop Debugging Gates) | Root-Cause Hypothesis, Minimal Failing Test before fix, Single-variable isolation, Zero Vibe Debugging |
| `28-spec-driven-development` / `33-modern-testing-standard` | E33.3 (Living Executable Traceability Gate) | 1-to-1 mapping between Gherkin Scenario IDs and test methods, zero orphaned scenarios |
| `42-adversarial-red-team-verification` | E33.4 (Dual-Agent Adversarial Red-Team Gates) | Handoff Contract, 4 Chaos Vectors injection, Red-Team audit pass, anti-confirmation bias |
| `27-app-quality-vitals` | E34 (Android 15/16 App Quality & Vitals Gates) | Google Play Core Vitals (<0.05% Crash, <0.02% ANR, <600ms TTID), 16KB Page Alignment, Enforced Edge-to-Edge, Baseline Profiles, System Photo Picker |
| `43-xml-compose-interoperability` | E35 (XML & Compose Hybrid Interoperability Gates) | DisposeOnViewTreeLifecycleDestroyed in Fragments, ViewBinding nullification in onDestroyView(), AndroidView onRelease cleanup, Shared UDF repeatOnLifecycle |
| `44-pure-xml-modern-architecture` | E36 (100% Pure XML Modern Architecture Gates) | ViewBinding nullification in onDestroyView(), ListAdapter with background DiffUtil, Android 15 WindowInsetsCompat Edge-to-Edge, SafeArgs Type-Safety |
| `skills/gsd-orchestrator` | E37 (Context Engineering & GSD Wave Isolation) | Ban Monolithic Long-Session, Fresh-Context 200k Subagents, Milestone Archiving |
| `rules/21-enforcement-engine` | E38 (Zero-Tolerance Pre-Flight Vitals Gate) | Ban Verbal Reassurances, 3-Pillar Static Audit: Zero-Crash, Zero-ANR (<5ms Main), Zero-Leak |

---

## Memory → Usage Mapping

| Memory File | Written By | Read By |
|------------|-----------|--------|
| `00-memory-core` | N/A (defines architecture) | All memory operations |
| `01-project-memory` | `brain/11-learning`, `brain/08-reflection` | `brain/02-context-engine` |
| `02-session-memory` | Auto (per session) | `brain/02-context-engine` |
| `03-task-memory` | `workflow/*` completion | `brain/02-context-engine` |
| `04-decision-memory` | `brain/05-decision` | `brain/02-context-engine`, `brain/04-assumption` |
| `05-pattern-memory` | `brain/11-learning` | `brain/02-context-engine` |
| `06-user-preference-memory` | User directives | ALL brain engines, ALL workflows |
| `07-context-retrieval` | N/A (defines retrieval logic) | `brain/02-context-engine` |
| `08-memory-pruning` | N/A (defines cleanup) | Memory maintenance |
| `09-memory-validation` | N/A (defines validation) | Memory write operations |

---

## Skills — Status & Applicability

| Skill | Status | Applicable When |
|-------|:------:|----------------|
| `mvi.md` | ✅ Primary | **Always** — project uses MVI |
| `mvvm.md` | ⚠️ Reference Only | Never for this project |
| `compose-essentials.md` | ✅ Active | Any UI work |
| `material-design.md` | ✅ Active | Any UI work |
| `navigation-3.md` | ✅ Primary | Any navigation work |
| `navigation-3-di.md` | ✅ Active | Navigation + DI integration |
| `navigation.md` | ⛔ Deprecated | Never — use navigation-3 |
| `navigation-migration.md` | ⛔ Deprecated | Only if migrating legacy |
| `koin.md` | ✅ Primary | Any DI work |
| `dependency-injection.md` | ⚠️ Thin (82 lines) | Merge into koin.md |
| `coroutines-flow.md` | ✅ Active | Async operations |
| `coroutines-flow-advanced.md` | ✅ Active | Complex async patterns |
| `room-database.md` | ✅ Active | Database operations |
| `datastore.md` | ✅ Active | Preferences storage |
| `networking-ktor.md` | ✅ Primary | API calls |
| `networking-ktor-architecture.md` | ✅ Active | Network architecture |
| `networking-ktor-auth.md` | ✅ Active | Authentication flows |
| `networking-ktor-testing.md` | ✅ Active | Network testing |
| `testing.md` | ✅ Active | Test writing |
| `performance.md` | ✅ Active | Performance optimization |
| `lists-grids.md` | ✅ Active | LazyColumn/LazyGrid |
| `image-loading.md` | ✅ Active | Coil image loading |
| `paging.md` | ✅ Active | Pagination |
| `paging-offline.md` | ✅ Active | Offline pagination |
| `paging-mvi-testing.md` | ✅ Active | Paging + MVI testing |
| `animations.md` | ✅ Active | Basic animations |
| `animations-advanced.md` | ✅ Active | Complex animations |
| `architecture.md` | ✅ Active | Architecture decisions |
| `design-patterns.md` | ✅ Primary | Design patterns, Kotlin & Compose patterns |
| `clean-code.md` | ✅ Active | Code quality |
| `anti-patterns.md` | ✅ Active | Code review |
| `resources.md` | ✅ Active | Android resources |
| `accessibility.md` | ✅ Active | A11y compliance |
| `ui-ux.md` | ✅ Active | UX design |
| `archive-compression.md` | ✅ Primary | Zip4j, AES-256 compression & safe extraction |
| `vault-encryption.md` | ✅ Primary | AndroidX Security Crypto & MasterKey vault storage |
| `localization.md` | ✅ Primary | i18n & l10n parity (English & Vietnamese) |
| `gradle-build.md` | ✅ Active | Build configuration |
| `ci-cd-distribution.md` | ✅ Active | CI/CD pipelines |
| `cross-platform.md` | ⚠️ Future | KMP consideration |
| `request-processing-flow.md` | ⚠️ Unified | Refs master workflow |
| `skills/dex-optimization/SKILL.md` | ✅ Primary | DEX code optimization, R8 Full Mode & Blast Radius [#dex] |
| `skills/app-reskinning/SKILL.md` | ✅ Primary | Architecture-preserving reskinning & dead code purge [#reskin] |
| `skills/gsd-orchestrator/SKILL.md` | ✅ Primary | GSD 5-Phase Loop, context engineering & subagent wave execution |
| `skills/subagent-modes/SKILL.md` | ✅ Primary | Native specialized subagent modes (PO, UI Designer, Architect, SDK-Builder, App-Builder, Reviewer) |
| `skills/ai-product-team/SKILL.md` | ✅ Primary | Virtual AI-Native Product Studio (PO -> UI -> Arch -> Builder -> QA -> CTO) |


---

# QUICK LOOKUP

## "I'm building a new feature" → Read these files in order:
1. `rules/04-feature-construction.md`
2. `rules/05-design-system.md`
3. `rules/07-viewmodel.md`
4. `skills/mvi.md`
5. `skills/compose-essentials.md`
6. `rules/39-android-runtime-edge-cases.md`
7. `rules/21-enforcement-engine.md`

## "I'm building or architecting an SDK / Core Module" → Read these files in order:
1. `rules/34-sdk-modular-architecture.md`
2. `skills/sdk-modular-engineering.md`
3. `rules/35-database-migration-r8-defense.md` (Gate E26.3 consumer-rules.pro)
4. `rules/21-enforcement-engine.md` (Gate E25 SDK Audit & Gate E34.2 16KB Page Alignment)

## "I'm orchestrating a large feature without context rot" → Read these files:
1. `skills/gsd-orchestrator/SKILL.md`
2. `workflow/00-master-workflow.md` (Phase 5 & Phase 6)
3. `rules/21-enforcement-engine.md` (Gate E37 Context Engineering)

## "I'm fixing a bug" → Read these files:
1. `rules/13-error-handling.md`
2. `rules/15-debugging.md`
3. `rules/39-android-runtime-edge-cases.md`
4. `rules/21-enforcement-engine.md` (Gate E33.1/E33.2 Scientific Closed-Loop Debugging)

## "I'm reviewing code" → Read these files:
1. `rules/21-enforcement-engine.md`
2. `rules/05-design-system.md`
3. `rules/07-viewmodel.md`
4. `skills/anti-patterns.md`
5. `skills/clean-code.md`

## "I'm refactoring code" → Read these files:
1. `rules/40-refactoring-safety-net.md` (Rule 40 Characterization / Pinning Tests First)
2. `rules/21-enforcement-engine.md` (Gate E32)
3. `rules/33-modern-testing-standard.md`
4. `skills/clean-code.md`

## "I'm adding navigation" → Read these files:
1. `rules/11-navigation.md`
2. `skills/navigation-3.md`
3. `skills/navigation-3-di.md`

## "I want to run a complete AI-Native Product Team" → Read these files:
1. `skills/ai-product-team/SKILL.md`
2. `skills/subagent-modes/SKILL.md`
3. `rules/28-spec-driven-development.md`
4. `rules/36-ui-ux-design-standard.md`
5. `rules/42-adversarial-red-team-verification.md`
6. `rules/21-enforcement-engine.md` (Gates E1–E37)
