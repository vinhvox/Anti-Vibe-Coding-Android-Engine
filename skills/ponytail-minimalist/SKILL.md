---
name: ponytail-minimalist
description: Comprehensive architectural guide and reference for writing minimal, idiomatic, zero-overengineered Kotlin, Jetpack Compose, and Kotlin Multiplatform code based on DietrichGebert/ponytail. Enforces the 7-Rung Decision Ladder, native platform/stdlib first, and single-expression idioms while preserving 100% safety and defense rigor.
---

# Ponytail Minimalist Skill

## Purpose
Provide actionable rules, code blueprints, and inspection checklists to eliminate AI over-engineering and boilerplate across Modern Android, Jetpack Compose, and Kotlin Multiplatform development.

---

# The 7-Rung Decision Ladder

Climb sequentially before writing or refactoring any code:

```text
1. Does this need to exist? (YAGNI)       ──► NO  ──► SKIP IT (Zero code)
2. Already in this codebase?              ──► YES ──► REUSE IT (Reuse existing theme/helper/base)
3. Stdlib does it?                        ──► YES ──► USE STDLIB (Use Kotlin Stdlib / Java Time)
4. Native platform feature?               ──► YES ──► USE NATIVE (Compose M3 DatePicker/BasicTextField2)
5. Installed dependency does it?          ──► YES ──► USE EXISTING (Use Ktor/Room/Coil without adding new libs)
6. Can it be one line?                    ──► YES ──► WRITE ONE LINE (Use '=' single-expression)
7. ONLY THEN                              ──► WRITE MINIMUM WORKING CODE (Dense, readable, safe)
```

---

# Anti-Pattern vs Ponytail Transformation Matrix

### 1. UI Components
- **Date Picker**: Use `@OptIn(ExperimentalMaterial3Api::class) DatePicker(state = datePickerState)` instead of 3rd-party flatpickr wrappers.
- **Search Debounce**: Use `queryFlow.debounce(400.milliseconds).distinctUntilChanged()` instead of hand-rolled handler/timer classes.
- **Dynamic Chip List**: Use `FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp))` instead of custom layout measurement loops.

### 2. Domain & Data Layers
- **Direct Repository Flow**: Call `repository.getItem()` directly from ViewModel when no domain logic or transformation is required. Ban 1-line pass-through UseCases.
- **Collections**: Use `items.associateBy { it.id }` and `items.map { it.toUi() }` instead of manual accumulator loops.
- **Top-Level Extensions**: Write `fun User?.displayName(): String = ...` instead of bloated `StringUtils` / `UserHelper` static classes.

---

# Quality Enforcement (Gate E22)

- `E22.1`: Redundant Helper/Wrapper Gate
- `E22.2`: Over-Architected Intermediate Layer Gate
- `E22.3`: Single-Expression Idiom Gate
- `E22.4`: Native Platform & Stdlib First Gate
- `E22.5`: Zero-Dependency-Bloat Gate
