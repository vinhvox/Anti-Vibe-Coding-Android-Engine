---
name: gsd-orchestrator
description: Context Engineering and Spec-Driven Subagent Wave Orchestration engine adapted from GSD Core (open-gsd/gsd-core). Prevents context rot, executes plans via isolated fresh-context subagents in waves, and enforces the 5-phase loop (Discuss -> Plan -> Execute -> Verify -> Ship).
---

# GSD Orchestrator Skill

This skill implements the **Context Engineering and Phased Execution System** adapted from **GSD Core** (`open-gsd/gsd-core`), tailored for Antigravity's Kotlin 2.x, Jetpack Compose, and Enterprise Clean Architecture environment.

---

## 1. Core Philosophy: Context Engineering & Anti-Rot

### The Problem: Context Rot
As an AI coding session progresses through multiple turns, the context window accumulates:
* Massive file reads and exploration traces
* Terminal outputs, Gradle build traces, and compiler errors
* Obsolete code diffs and superseded ideas

**Result:** The model degrades in reasoning quality, forgets early architecture rules, suffers hallucinations, and regresses previously working code.

### The GSD Solution
1. **Lean Main Orchestrator:** The primary session maintains high-level awareness, roadmaps, and architectural governance. It **never** absorbs voluminous raw file dumps or lengthy test logs.
2. **Fresh-Context Subagents (200k Tokens):** Heavy codebase exploration, code authoring, and test runs are delegated to isolated subagents running in clean contexts via `invoke_subagent`.
3. **Structured 5-Phase Loop:** Strict phase gates ensure work never advances prematurely.

---

## 2. The 5-Phase GSD Loop in Antigravity

```
┌─────────────┐     ┌───────────┐     ┌─────────────┐     ┌────────────┐     ┌──────────┐
│ 1. DISCUSS  │ ──► │  2. PLAN  │ ──► │ 3. EXECUTE  │ ──► │ 4. VERIFY  │ ──► │ 5. SHIP  │
│ Consultation│     │ Waves/SDD │     │  Subagents  │     │ Gate Audit │     │ Archive  │
└─────────────┘     └───────────┘     └─────────────┘     └────────────┘     └──────────┘
```

### Phase 1: DISCUSS (Consultation & Scope Locking)
* **Goal:** Capture implementation decisions and clarify ambiguity before touching files.
* **Actions:**
  - Execute Brain Pipeline (Context, Clarification, Confidence >= 85%).
  - Enforce Matt Pocock's *Consult Before Code* (Investigation ➔ Assessment ➔ Proposed Solution & Roadmap ➔ Hard Stop).
  - Produce or align `spec.md` with Gherkin acceptance scenarios and ubiquitous domain terms (`rules/37-ubiquitous-language-standard.md`).
* **Exit Gate:** User explicitly approves the scope and roadmap. Zero code written.

### Phase 2: PLAN (Wave Decomposition & Context Budgeting)
* **Goal:** Break the feature into vertical tracer-bullet slices sized for fresh-context subagents.
* **Actions:**
  - Create/update `plan.md` (architecture, ADR, layer touchpoints) and `tasks.md` (executable checklist).
  - Organize tasks into **Sequential Waves**:
    - **Wave 1 (Domain & Data Foundation):** Repositories, DAOs, Network models, Characterization/Unit tests.
    - **Wave 2 (Presentation & State):** ViewModels, MVI Intents, Atomic StateFlow, Turbine tests.
    - **Wave 3 (UI & Declarative Wiring):** Compose screens, Design System tokens, Edge-to-Edge insets, UI semantics tests.
  - **Context Budget Rule:** Each task must be sized so that a subagent needs to read at most 3–5 files (< 30,000 tokens) to complete it.
* **Exit Gate:** Every task has explicit target files, test commands, and definition of done.

### Phase 3: EXECUTE (Subagent Wave Dispatcher)
* **Goal:** Implement code without polluting the main session's context.
* **Actions:**
  - Dispatch subagents via `invoke_subagent` per Wave.
  - Independent tasks within the same wave run concurrently; dependent tasks run sequentially.
  - Use the **Self-Contained Subagent Prompt Contract** (see below).
  - Main session receives only concise completion summaries: files touched, test output (PASS/FAIL), and key decisions.
* **Exit Gate:** All tasks in the wave report GREEN test status and zero gate violations.

### Phase 4: VERIFY (Enforcement & Audit Gate)
* **Goal:** Inspect what was built across all layers against Antigravity Quality Gates.
* **Actions:**
  - **Living Traceability Audit (Gate E33.3):** Ensure 100% of Gherkin scenarios in `spec.md` have corresponding test methods.
  - **Zero-Tolerance Anti-Patterns (Gate E1–E36):**
    - Atomic `_state.update { copy(...) }` enforced in ViewModels (E21.10).
    - No inlined emojis or raw string icons; XML Vector Drawables only (E1.3 / E4).
    - `collectAsStateWithLifecycle()` in Compose (E4).
    - Minimum touch target 48dp (E21.8).
  - **Build & Test Verification:** Run `./gradlew assembleDebug testDebugUnitTest` and verify exit code 0.
  - If regressions occur: Apply Rule 41 (Closed-Loop Debugging) via a dedicated debug subagent.
* **Exit Gate:** Zero compiler warnings, 100% tests passing, clean audit report.

### Phase 5: SHIP & ARCHIVE (Milestone Closure & Memory Update)
* **Goal:** Archive phase state, update persistent memory, and prepare for release.
* **Actions:**
  - Archive working artifacts (`spec.md`, `plan.md`, `tasks.md`) to `.antigravity/archive/milestone-<name>/` or brain directory.
  - Update `memory/01-project-memory.md` and `memory/04-decision-memory.md` with newly accepted architecture decisions.
  - **Zero Auto-Commit (Rule Mandate):** Never commit code automatically. Present the clean verification summary and prompt the user for git operations.

---

## 3. Decision Matrix: Main Agent vs. Subagent Delegation

| Task Characteristic | Execution Mode | Rationale |
| :--- | :--- | :--- |
| Single file edit, quick typo fix, or 1-turn targeted question | **Main Agent Direct** | Spawning subagents has overhead; 1 turn does not cause context rot. |
| Multi-file feature, refactor, or complex bug diagnosis (> 3 files) | **GSD Subagent Wave (Mandatory)** | Prevents context pollution; isolates compiler traces and code diffs. |
| Parallel independent tasks (e.g. 2 unrelated screen components) | **Concurrent Subagents** | Drastically cuts turnaround time while keeping contexts isolated. |
| Codebase-wide audit, lint sweep, or R8 keep rules pruning | **Dedicated Subagent** | High token output (hundreds of lines of logs) stays in subagent. |

---

## 4. Self-Contained Subagent Prompt Contract

When dispatching an executor subagent, the Main Agent MUST construct a standalone prompt containing:

```markdown
Role: [e.g. Wave 1 Executor - Domain & Data Layer]
Task: [Exact task description from tasks.md]
Reference Files:
- Spec: [Path to spec.md or relevant Gherkin scenarios]
- Codebase Files to inspect/edit: [Absolute paths]
Strict Guardrails:
- Architecture: Kotlin 2.x, Clean Architecture, Single Source of Truth
- Rules: Atomic _state.update, Vector XML drawables only, no emojis in code
- Safety: Rule 40 (Pinning tests first if refactoring) or Rule 41 (Root-cause test if fixing bug)
Validation Command:
- [e.g. ./gradlew :core:data:testDebugUnitTest]
Output Contract:
- Return ONLY: (1) Files modified, (2) Test execution evidence, (3) Brief notes on edge cases handled.
- DO NOT return entire file dumps or conversational filler.
```

---

## 5. References & Cross-Engine Mapping

* GSD Upstream: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core)
* Antigravity Master Workflow: [00-master-workflow.md](file:///Users/vio/.antigravity/workflow/00-master-workflow.md)
* Spec-Driven Development: [spec-driven-development.md](file:///Users/vio/.antigravity/skills/spec-driven-development.md)
* Quality Gates Engine: [21-enforcement-engine.md](file:///Users/vio/.antigravity/rules/21-enforcement-engine.md)
* Subagent Dispatch Standard: [dispatching-parallel-agents](file:///Users/vio/.antigravity/skills/dispatching-parallel-agents/SKILL.md)
