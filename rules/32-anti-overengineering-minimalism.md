# 32 - Anti-Overengineering & Minimalist Standard (Ponytail Mandate)

## Purpose

This document establishes the **Anti-Overengineering & Minimalist Code Quality Mandate** for the Antigravity Engine, inspired by the high-efficiency principles of [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail).

Its purpose is to eliminate AI over-engineering, destroy redundant boilerplate, ban useless abstractions and wrapper classes, enforce Kotlin Stdlib & Native Platform First, and mandate the 7-Rung Decision Ladder while preserving 100% architectural correctness, safety, and defense rigor.

---

# Philosophy

> *"He says nothing. He writes one line. It works."*

- **Lazy about solutions, deep about reading:** Trace the complete, real data flow before writing any code. Never guess or "vibe code". But when producing the solution, write the absolute minimum code necessary.
- **YAGNI (You Ain't Gonna Need It):** If it is not required for the current task, it must NOT exist.
- **Native & Stdlib First:** Never create a custom component or add an external library when the platform or standard library already provides it.
- **Safety is Non-Negotiable:** Minimality is NOT code-golfing. Validation, error boundaries, security, accessibility, 16KB memory alignment, and Vitals performance must NEVER be compromised.

---

# The Mandatory 7-Rung Decision Ladder

Before writing, proposing, or refactoring any code, the AI MUST climb this ladder sequentially and stop at the first rung that solves the problem:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. Does this need to exist? (YAGNI)       ──► NO  ──► SKIP IT (Do not create/write)   │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 2. Already in this codebase?              ──► YES ──► REUSE IT (Reuse existing pattern)│
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 3. Stdlib does it?                        ──► YES ──► USE STDLIB (Use Kotlin/Java API) │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 4. Native platform feature?               ──► YES ──► USE NATIVE (Material 3 / SDK)    │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 5. Installed dependency does it?          ──► YES ──► USE EXISTING (No new libraries)  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 6. Can it be one line?                    ──► YES ──► WRITE ONE LINE (Single-expr '=') │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 7. ONLY THEN                              ──► WRITE MINIMUM WORKING CODE               │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# Core Mandates

## Rule 32.1: The Zero-New-Dependency Mandate
- **Rule:** Never introduce a new 3rd-party dependency if:
  1. Kotlin Standard Library (`kotlin.time.*`, `kotlin.io.*`, `kotlin.collections.*`) can do it.
  2. Android Platform SDK / Jetpack Compose Material 3 has a native API (e.g., `DatePicker`, `TimePicker`, `BasicTextField2`).
  3. An existing, already-approved library in `libs.versions.toml` (e.g., Ktor, Room, Coil, DataStore) can fulfill the requirement.
- **Violation:** Adding a 3rd-party date picker library, a custom debounce utility library, or a string manipulation dependency.

---

## Rule 32.2: Redundant Abstraction & Wrapper Ban
- **Rule:** Do NOT create empty wrapper classes, redundant delegate UseCases, or bloated helper objects that simply forward a call to a Repository or DAO without adding business logic.
- **Direct Repository Flow:** If a feature requires simple CRUD or direct Flow emission without transformation, ViewModel can directly interact with the Repository contract. Do NOT create a `GetItemUseCase` that only contains `repository.getItem()`.
- **Prefer Kotlin Extension Functions:** Instead of creating static `DateUtils`, `StringUtils`, or `ViewHelper` classes, write focused, top-level Kotlin extension functions.

---

## Rule 32.3: Single-Expression Idioms & Dense Kotlin Coding
- **Rule:** When a function body is a single statement or expression, use Kotlin single-expression syntax (`=`) rather than wrapping it in a block `{ return ... }`.
- **Collection & Flow Idioms:** Use idiomatic standard functions (`associateBy`, `groupBy`, `filterNotNull`, `scan`, `debounce`) instead of manual loops, mutable accumulator lists, or hand-rolled state machines.

---

## Rule 32.4: Read-Deep-Write-Min Standard
- **Rule:** The agent must thoroughly inspect existing codebase definitions, theme tokens, and contracts before proposing changes.
- **Diff Hygiene:** PRs and code modifications must be compact, focused, and clean. Avoid noisy whitespace refactors or rewriting entire files when modifying a few lines.

---

## Rule 32.5: The Untouchable Safety Matrix
Minimalism stops where safety begins. The following items MUST NEVER be removed or shortened at the expense of correctness:
1. **Trust-Boundary Validation:** Non-null assertions, boundary checks, input sanitization.
2. **Error Boundaries:** `runCatching`, custom domain exceptions, `AppResult<T>` error modeling.
3. **Accessibility (a11y):** Minimum 48x48dp touch bounds, `contentDescription`, high contrast.
4. **16KB Memory Page Alignment:** Safe JNI, 16KB linker flags, zero unaligned native libraries.
5. **Stack vs Heap Memory Safety (Rule 26):** Zero allocations in Composable measurement/draw passes, primitive unboxing prevention.

---

## Rule 32.6: Self-Documenting Naming & Ban on Trivial Comments
- **Rule:** Variable, function, and class names MUST be 100% self-explanatory and intention-revealing (`isUserSubscribed`, `fetchUserProfile`, `calculateDiscountAmount`).
- **Strict Ban on Trivial Comments:** Strictly forbid trivial, redundant, or micro-comments that simply restate what the code or variable name does (e.g., `// Load data`, `// User list`, `// Handle button click`, `// Initialize viewModel`).
- **Comments Strictly Reserved for "WHY":** Comments are permitted ONLY when explaining:
  1. Complex mathematical formulas, bitwise arithmetic, or domain-specific algorithms.
  2. Non-obvious workarounds for OS / platform bugs or 3rd-party library quirks.
  3. Subtle concurrency or hardware synchronization constraints.
- **Enforcement:** Any redundant "what" comment is classified as code clutter and MUST be stripped out immediately.

---

# Anti-Pattern vs Ponytail Minimalist Blueprints

### 1. Date / Color / UI Component Selection
```kotlin
// ❌ ANTI-PATTERN: Over-engineered 3rd-party wrapper component (150+ lines)
@Composable
fun OverEngineeredDatePicker(...) {
    // Adding 3rd party flatpickr wrapper or custom canvas datepicker with 20 state classes
}

// ✅ PONYTAIL MINIMALIST: Native Jetpack Compose Material 3 DatePicker (5 lines)
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MinimalistDatePicker(state: DatePickerState, modifier: Modifier = Modifier) {
    DatePicker(state = state, modifier = modifier)
}
```

### 2. Search Debounce Logic
```kotlin
// ❌ ANTI-PATTERN: Hand-rolled custom debounce handler with Timer & Handler (40 lines)
class CustomDebouncer {
    private var handler = Handler(Looper.getMainLooper())
    private var runnable: Runnable? = null
    fun debounce(action: () -> Unit) { ... }
}

// ✅ PONYTAIL MINIMALIST: Kotlin Coroutines Flow native operator (1 line)
val debouncedQuery = queryFlow.debounce(400.milliseconds).distinctUntilChanged()
```

### 3. Single Expression Functions & Top-level Extensions
```kotlin
// ❌ ANTI-PATTERN: Bloated Helper Class with Block Return (15 lines)
object UserFormatterHelper {
    fun formatDisplayName(user: User?): String {
        if (user == null) {
            return ""
        }
        return "${user.firstName} ${user.lastName}".trim()
    }
}

// ✅ PONYTAIL MINIMALIST: Idiomatic Kotlin Extension (1 line)
fun User?.formatDisplayName(): String = this?.run { "$firstName $lastName".trim() }.orEmpty()
```

---

# Review & Enforcement Checkpoint

Every implementation must pass **GATE E22** in `rules/21-enforcement-engine.md`:
1. `E22.1`: Redundant Helper/Wrapper Gate
2. `E22.2`: Over-Architected Intermediate Layer Gate
3. `E22.3`: Single-Expression Idiom Gate
4. `E22.4`: Native Platform & Stdlib First Gate
5. `E22.5`: Zero-Dependency-Bloat Gate
