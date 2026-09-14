# 01-project-memory.md

# Project Memory

## Purpose

This document defines how the AI understands, stores, and maintains long-term project knowledge.

Project Memory represents stable engineering knowledge about the project.

It enables the AI to make consistent engineering decisions without repeatedly rediscovering the same information.

Project Memory evolves slowly and only when the project itself changes.

---

# Philosophy

The AI should behave like an engineer who has worked on the project for months.

It should remember:

Architecture.

Standards.

Conventions.

Patterns.

Engineering decisions.

Not individual conversations.

Project Memory is the long-term engineering identity of the project.

---

# Primary Goal

Maintain a verified understanding of the project including:

Architecture

Module structure

Technology stack

Coding conventions

Dependency rules

Engineering standards

Project-specific decisions

Project Memory should reduce repeated analysis.

---

# Knowledge Hierarchy

Project knowledge is organized into layers.

```text
Project
    │
    ▼
Architecture
    │
    ▼
Modules
    │
    ▼
Engineering Standards
    │
    ▼
Reusable Patterns
    │
    ▼
Stable Decisions
```

Higher layers change less frequently.

---

# What To Store

Project Memory may store:

Architecture style

Module organization

Navigation framework

Dependency Injection framework

Repository pattern

ViewModel pattern

State management

Networking approach

Database strategy

Testing strategy

Logging framework

Error handling strategy

Security practices

Build configuration

Design system

Shared utilities

Feature conventions

Project glossary

Only stable engineering knowledge should be stored.

---

# What NOT To Store

Never store:

Temporary bugs

Experimental branches

One-time fixes

Debug notes

Incomplete implementations

Personal opinions

Conversation history

Task progress

Session-specific information

These belong to other memory layers.

---

# Knowledge Sources

Project Memory may learn from:

Accepted project architecture

Engineering Rules

Workflow

Enforcement Engine

Repeated implementation patterns

Verified codebase structure

User-approved architectural decisions

Never learn from isolated examples.

---

# Pattern Stability

A project pattern becomes stable only if:

It is consistently used.

It complies with project architecture.

It has been accepted by the user or existing codebase.

It appears across multiple features.

Otherwise,

treat it as local implementation detail.

---

# Memory Structure

Project Memory consists of multiple domains.

## Architecture

Application architecture.

Layer boundaries.

Dependency direction.

Feature organization.

---

## Technology

Compose

Navigation

Koin

Room

Retrofit

Coroutines

Paging

WorkManager

Serialization

Only technologies actually used by the project.

---

## Coding Standards

Naming conventions.

Folder structure.

Package organization.

File organization.

Code style.

---

## Engineering Standards

Error handling.

State management.

Dependency Injection.

Navigation.

Repository contracts.

Testing conventions.

Performance standards.

---

## Project Decisions

Architectural decisions.

Technology choices.

Long-term engineering agreements.

Only decisions intended to remain valid.

---

# Project Identity

The AI should understand the project's identity.

Example:

```text
Project Identity

Architecture:
Clean MVVM

Navigation:
Navigation3

Dependency Injection:
Koin

Networking:
Retrofit

Database:
Room

Async:
Coroutines + Flow

UI:
Jetpack Compose

State:
StateFlow

Result Wrapper:
Result<T>

Testing:
JUnit + MockK
```

Project identity should influence every implementation.

---

# Memory Update

Project Memory should update only when:

Architecture changes.

Technology changes.

User changes conventions.

Stable patterns evolve.

Major refactoring occurs.

Do not update based on temporary work.

---

# Memory Validation

Before storing project knowledge verify:

Is it stable?

Is it used across the project?

Is it intentional?

Is it production quality?

If not,

do not store.

---

# Retrieval Strategy

Before implementing any feature:

Retrieve:

Project Identity

↓

Architecture

↓

Engineering Standards

↓

Reusable Patterns

↓

Project Decisions

Implementation should align with retrieved knowledge.

---

# Conflict Resolution

If multiple sources disagree:

Priority order:

Current User Instruction

↓

Verified Current Codebase

↓

Accepted Project Decisions

↓

Project Memory

↓

Engineering Rules

↓

Android Best Practices

Explicit project changes always override memory.

---

# Project Evolution

Projects evolve.

When major architectural changes occur:

Validate.

Update Project Memory.

Deprecate obsolete knowledge.

Do not retain conflicting architecture.

---

# Self Validation

Before applying Project Memory verify:

Is this knowledge still valid?

Does the codebase still follow it?

Has the user replaced it?

Is there stronger evidence available?

If uncertain,

revalidate first.

---

# Anti-patterns

Never:

Store temporary implementations.

Store debugging information.

Store abandoned experiments.

Assume one feature defines the project.

Ignore project evolution.

Override explicit user instructions.

Duplicate information already stored elsewhere.

---

# Active Workspace & Dynamic Project Profiling

Project Memory operates as a **Dynamic Multi-Project Profiler**. When the AI enters any project workspace, Phase 0 (Workspace & Project Auto-Discovery) dynamically extracts the active repository profile:

```text
Workspace Discovery (pwd, git root)
        │
        ▼
Scan Build Config (settings.gradle.kts, build.gradle.kts, AndroidManifest.xml, pubspec.yaml)
        │
        ▼
Extract Tech Stack & Architecture (Compose/Views, Nav3/Voyager, Koin/Hilt, Ktor/Retrofit, Room/DataStore)
        │
        ▼
Bind Active Project Profile for Current Session
```

## Baseline Verified Project Profiles

### Profile A: Base-Jetpack (Android Native Reference)
- **UI:** Jetpack Compose + Material 3 (BOM 2026.03.01)
- **Navigation:** Navigation 3 (State-driven, `NavDisplay`, `SnapshotStateList<Screen>`)
- **State:** MVI/UDF via `BaseViewModel<State, Intent, Effect>`
- **DI:** Koin 4.2.1 (Constructor-based injection)
- **Networking:** Ktor Client (Android) + Ktor Server CIO (WebShare)
- **Database:** Room 2.8.4
- **Preferences:** DataStore 1.2.1
- **Security:** AndroidX Security-Crypto (AES-256-GCM), Biometric
- **Media:** Coil (Image/Video), Media3 ExoPlayer
- **Archive:** Zip4j 2.11.5 (Pure Java, 16KB safe)
- **Analytics:** Firebase (Crashlytics, Analytics, Config, FCM)

### Profile B: Cross-Platform & KMP / Flutter
- **KMP Multiplatform:** Compose Multiplatform, Voyager / Decompose, SQLDelight / Room KMP, Ktor Client KMP, Koin KMP.
- **Flutter Bridge:** Pigeon Type-Safe IPC (`@HostApi()`), `FlutterEngineCache`, Dart Background Isolates.

---

## 19 Core Engineering Compliance Checklist
For ANY active project profile, the AI must enforce:
1. Lifecycle & State (3-Tier State, SavedStateHandle, Process Death resilience)
2. Background Execution (WorkManager, isStopped check, NonCancellable cleanup)
3. Permissions & Privacy (JIT verification, PickVisualMedia)
4. Networking & Offline-first (SSOT Room, Outbox Queue, Exponential backoff)
5. Persistence & Migration (Zero data loss, MigrationTestHelper, WAL)
6. Navigation (State-driven Navigation 3, @Serializable routes, 400ms debounce)
7. Adaptive UI (WindowSizeClass Compact/Medium/Expanded, safeDrawing, imePadding)
8. Accessibility a11y (Minimum 48x48dp touch bounds, Non-linear 200% font scale)
9. Localization & Theming (RTL Start/End, getQuantityString, semantic token theme)
10. Concurrency & Flow (Main-thread purity, atomic StateFlow update)
11. Performance & Vitals (Stack vs Heap Rule 26, Baseline Profiles, TTID < 500ms)
12. Platform Behaviors (SDK_INT branching, Predictive Back gesture)
13. Cross-Platform Bridge (Pigeon type safety)
14. System Integrations (Lifecycle-bound sensors & CameraX)
15. Security (Hardware Keystore, FLAG_SECURE)
16. Build & 16KB (16KB page alignment linker flags, In-App updates)
17. Observability (Crashlytics breadcrumbs, reportFullyDrawn TTFD)
18. Testing Strategy (Turbine, Koin verify, real assembleDebug build)
19. Hostile Runtime & Edge Cases Defense (The 8-Vector Hostile Runtime Matrix — Rule 39 & Gate E30: Process Death, Captive Portal, 401 Mutex, Swallowed Cancellation, Multi-Tap Debounce, Atomic File I/O, 200% Font Scale, JIT Permissions)

---

# Final Rule

Project Memory is the engineering memory of the project.

It should preserve long-term knowledge,

maintain architectural consistency,

and allow the AI to work as if it were an experienced member of the engineering team.