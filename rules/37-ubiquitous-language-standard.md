# 37 - Ubiquitous Language & Domain Context Standard (The Precision Jargon Mandate)

## Purpose

This document establishes the official **Ubiquitous Language & Domain Context Standard** across the entire Antigravity Engine, directly integrating the DDD (Domain-Driven Design) wisdom popularized by Eric Evans and distilled in Matt Pocock's `skills` framework (`CONTEXT.md`).

Its mission is to permanently eliminate conversational fluff, verbose approximations, and semantic drift between the developer and AI agents ("20 words where 1 domain word will do"). Every technical discussion, plan, and code artifact must operate on a shared, razor-sharp vocabulary.

---

# 1. THE PROBLEM: VERBOSE APPROXIMATION & SEMANTIC DRIFT

When an AI agent is dropped into an existing codebase without an explicit domain glossary, it attempts to guess terminology from file names and variable names. This causes two severe failure modes:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ FAILURE MODE 1: VERBOSE EXPLANATION ("20 Words Where 1 Will Do")                      │
│ - Before: "There's an issue when a lesson inside a section is made real on disk..."    │
│ - After:  "There's a problem with the materialization cascade."                        │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ FAILURE MODE 2: SEMANTIC AMBIGUITY (Confusing Domain Entities)                         │
│ - Example: Using "Account", "Profile", "User", and "Member" interchangeably when       │
│   they represent distinct lifecycle states in the backend and database.              │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. THE 4 PILLARS OF UBIQUITOUS LANGUAGE

## Rule 37.1: Single Source of Truth (`CONTEXT.md` Mandate)
- Every project or sub-module SHOULD maintain a single, hyper-concise domain dictionary located at either:
  - `docs/CONTEXT.md` (Preferred in modular projects)
  - `CONTEXT.md` (Project root)
- The AI MUST actively consult `CONTEXT.md` during Phase 0 & Phase 1 of the Master Workflow.

## Rule 37.2: Absolute 1-to-1 Mapping to Code Symbols
- Every Domain Concept defined in `CONTEXT.md` MUST map directly to an explicit Kotlin/Compose symbol:
  - `Domain Entity` ➔ Kotlin `data class` in `:domain:model`
  - `Domain Action` ➔ UseCase function or MVI `Intent`
  - `State Invariant` ➔ Sealed interface / enum state
  - `Navigation Target` ➔ Strongly-typed `@Serializable` destination in Navigation 3

## Rule 37.3: Banned Ambiguous Phrasing (Anti-Fluff Rule)
- When a domain concept has been formalized, the AI is STRICTLY FORBIDDEN from using vague approximations in responses, plans, or code comments.
- **Rule:** If `Vault Session` is defined, never say "when the user logs into the secure encrypted folder". Say "during Vault Session initialization".

## Rule 37.4: Living Context Evolution
- When a new business capability or architectural concept is introduced during `/plan` or brainstorming, the AI MUST propose updating `CONTEXT.md` so that future sessions immediately inherit the vocabulary.

---

# 3. STANDARD `CONTEXT.md` BLUEPRINT

Every project's `CONTEXT.md` must adhere to this structured, low-token blueprint:

```markdown
# Project Context & Ubiquitous Language

## 1. Domain Glossary (The Vocabulary)
| Domain Term | Technical Meaning / Invariant | Code Symbol / Mapping |
| :--- | :--- | :--- |
| **Vault Session** | Active decrypted state held strictly in memory with 5-min timeout | `VaultSessionState.Active` |
| **Direct Stream** | Local HTTP server streaming bytes without disk write | `KtorWebShareServer.stream()` |
| **Materialization** | Converting a virtual tree item into a physical file on storage | `MaterializeFileUseCase` |
| **Biometric Fallback**| Secondary PIN prompt triggered upon 3 biometric failures | `BiometricAuthManager.Fallback` |

## 2. Forbidden / Deprecated Synonyms (Ambiguity Killers)
- ❌ Do NOT say "Folder" ➔ Use **"Container"** (matches encrypted container semantics).
- ❌ Do NOT say "Logged In" ➔ Use **"Session Unlocked"** (matches local hardware crypto lock).
- ❌ Do NOT say "Page" ➔ Use **"Screen"** (matches Navigation 3 Compose destinations).

## 3. Core Domain Invariants (Non-Negotiable Rules)
1. A `Vault Session` must NEVER persist plaintext keys to disk or DataStore.
2. A `Direct Stream` terminates immediately upon client disconnect or screen pop.
```

---

# 4. CTO & ARCHITECTURAL ENFORCEMENT

1. **During Planning (`/plan`):**
   - The AI must explicitly verify whether proposed features introduce new domain terminology. If yes, include a "Domain Terms Added" section in the plan.
2. **During Review & Implementation:**
   - Verify that variable names, ViewModel Intents, and UI state models use the exact terminology defined in `CONTEXT.md`.
