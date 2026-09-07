# Skill: Ponytail Minimalist (The Lazy Senior Dev Playbook)

## Purpose

Provide a comprehensive, high-efficiency architectural playbook and cheat-sheet for writing minimal, idiomatic, zero-overengineered Kotlin, Jetpack Compose, and Kotlin Multiplatform code based on [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail).

---

# The Core Mindset

> *"He says nothing. He writes one line. It works."*

- **Deep Reading, Minimal Solution:** Trace real data flow through contracts, themes, and repositories before writing a single character.
- **YAGNI Enforcement:** Cut away speculative abstractions, wrapper types, and fake extensibility.
- **Native Platform & Stdlib First:** Replace hundreds of lines of boilerplate with native Jetpack Compose Material 3 components, Kotlin Coroutines Flow operators, and Kotlin Standard Library functions.
- **100% Safety Guarantee:** Never compromise validation, error boundaries, security, accessibility (48dp touch bounds), 16KB memory page alignment, or memory boundaries (Stack vs Heap).

---

# The 7-Rung Decision Ladder

When designing or implementing any code snippet:

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

# The Anti-Pattern vs Ponytail Transformation Matrix

### 1. UI Selection Components
| Task | ❌ Over-engineered Trap | ✅ Ponytail Minimalist Solution |
| :--- | :--- | :--- |
| **Date Picker** | Installing 3rd-party library + 150 LOC wrapper | `@OptIn(ExperimentalMaterial3Api::class) DatePicker(state = datePickerState)` |
| **Time Picker** | Custom Canvas clock or external library | `TimePicker(state = timePickerState)` |
| **Search Debounce** | Hand-rolled Timer / Handler class (40 LOC) | `queryFlow.debounce(400.milliseconds).distinctUntilChanged()` |
| **Text Truncation** | Custom measurement subcomposable | `Text(text = text, maxLines = 1, overflow = TextOverflow.Ellipsis)` |
| **Chip/Tag List** | Custom measure layout or row wrapping | `FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) { ... }` |

---

### 2. Domain & Data Layers
| Task | ❌ Over-engineered Trap | ✅ Ponytail Minimalist Solution |
| :--- | :--- | :--- |
| **CRUD Delegation** | 1-line `GetItemUseCase` forwarding to repository | Call `repository.getItem()` directly from ViewModel |
| **List Mapping** | Manual loop with `mutableListOf()` | `items.map { it.toUiModel() }` |
| **ID Lookup Map** | Manual `for` loop populating a HashMap | `items.associateBy { it.id }` |
| **Nullable Formatting** | 15-line `StringUtils` static helper | `fun User?.displayName(): String = this?.run { "$first $last".trim() }.orEmpty()` |
| **Scope Execution** | `GlobalScope` or unbounded thread creation | `safeLaunch { ... }` / `viewModelScope.launch { ... }` |

---

### 3. Architecture & State Management
| Task | ❌ Over-engineered Trap | ✅ Ponytail Minimalist Solution |
| :--- | :--- | :--- |
| **Event Routing** | Custom event bus with reflection | MVI `sendIntent(Intent)` + `BaseViewModel` |
| **State Emission** | 4 separate LiveData objects | Single `StateFlow<UiState>` with immutable data class |
| **Navigation** | String route parsing with string concatenation | Strongly-typed `@Serializable data class Destination` |

---

# Verification Checklist (Gate E22 Audit)

Before submitting any code:
- [ ] **YAGNI Verified:** Are all classes and methods strictly necessary for the active requirement?
- [ ] **No Redundant UseCases:** Did we avoid creating useless pass-through UseCases?
- [ ] **Native First:** Did we leverage Compose Material 3 & Kotlin Stdlib instead of hand-rolling?
- [ ] **Zero New Dependencies:** Is `libs.versions.toml` untouched unless explicitly approved?
- [ ] **Single-Expression Idioms:** Are 1-line functions written with `= expression`?
- [ ] **Safety Matrix 100%:** Are validation, error handling, a11y (48dp), and 16KB memory alignment intact?
