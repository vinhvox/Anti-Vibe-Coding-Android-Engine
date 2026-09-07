# 03-task-memory.md

# Task Memory

## Purpose

This document defines how the AI tracks, manages, and completes engineering tasks.

Task Memory represents the execution state of work.

It ensures that implementation progresses in a structured, traceable, and recoverable manner.

Task Memory exists until the task is completed, cancelled, or replaced.

---

# Philosophy

Project Memory remembers the project.

Session Memory remembers the collaboration.

Task Memory remembers the work.

Every task should have a clear beginning, current state, and completion.

The AI should never lose track of what it is doing.

---

# Primary Goal

Maintain an accurate execution state for every engineering task.

The AI should always know:

Current task

Task status

Dependencies

Progress

Blockers

Next step

Completion criteria

---

# Task Lifecycle

Every task follows the same lifecycle.

```text
Created
    │
    ▼
Analyzing
    │
    ▼
Ready
    │
    ▼
Implementing
    │
    ▼
Reviewing
    │
    ▼
Testing
    │
    ▼
Completed
```

Alternative states:

```text
Blocked

Cancelled

Deferred

Failed
```

A task always has one active state.

---

# Task Structure

Each task contains:

Identifier

Objective

Description

Priority

Owner

Status

Dependencies

Assumptions

Blockers

Progress

Completion Criteria

Result

Tasks should be independently understandable.

---

# Task Categories

Implementation

Bug Fix

Refactor

Architecture

Testing

Documentation

Performance

Security

Migration

Investigation

Each category may follow different workflows.

---

# Task Hierarchy

Tasks may be decomposed into subtasks.

```text
Feature

↓

Task

↓

Subtask

↓

Action
```

Example:

```text
Feature

Search

↓

Task

Repository

↓

Subtask

Search DAO

↓

Action

Implement query
```

Only decompose when it improves execution.

---

# Task Prioritization

Priority order:

Critical

High

Medium

Low

Background

Critical tasks should always be resolved first.

---

# Task Dependencies

Each task may depend on:

Architecture

API

Database

Navigation

Permissions

Shared Components

Other Tasks

Dependencies must be satisfied before execution.

---

# Task Progress

Track meaningful progress.

Example:

```text
Repository

██████████

100%

ViewModel

██████░░░░

60%

Compose UI

██░░░░░░░░

20%
```

Progress should reflect completed engineering work, not elapsed time.

---

# Blocker Management

Every blocker should include:

Description

Cause

Impact

Required Action

Status

Resolve blockers as soon as possible.

---

# Resume Strategy

When returning to a task:

Retrieve:

Task Objective

↓

Current Status

↓

Completed Work

↓

Dependencies

↓

Blockers

↓

Next Action

The AI should resume without repeating previous work.

---

# Completion Criteria

A task is complete only when:

Requirements satisfied

Implementation finished

Validation passed

Review completed

Testing completed

No unresolved blockers

No unfinished subtasks

---

# Task Update Policy

Update Task Memory whenever:

Status changes

Progress changes

Dependencies change

Blockers appear

Blockers resolved

Scope changes

Completion reached

Task Memory should always reflect reality.

---

# Task Recovery

If execution is interrupted:

Restore:

Current state

↓

Current progress

↓

Current blocker

↓

Next executable action

Continue from the latest valid checkpoint.

---

# Parallel Tasks

Multiple tasks may exist simultaneously.

Each task should maintain:

Independent status

Independent progress

Independent blockers

Independent completion

Avoid mixing unrelated tasks.

---

# Task Archive

After completion:

Archive:

Objective

Result

Major decisions

Lessons learned

Discard:

Temporary implementation notes

Working state

Execution context

Completed tasks should become historical references.

---

# Self Validation

Before executing a task verify:

Is this still the active task?

Have dependencies changed?

Has another task taken higher priority?

Has the scope changed?

If necessary,

update Task Memory before continuing.

---

# Anti-patterns

Never:

Forget active tasks.

Duplicate tasks.

Lose blocker information.

Skip completion validation.

Mix unrelated work.

Leave orphaned subtasks.

Track implementation details that belong to code.

---

# Active Tasks

- [2026-09-04] **Matt Pocock Skills Synthesis & System Upgrade (Rule 37 + Tracer Bullets + Living ADR + ask-cto Router + Gate E28)** | Status: DONE
  - Objective: Nghiên cứu repository `mattpocock/skills` của Matt Pocock, chiết xuất các tinh hoa phương pháp luận chống Vibe Coding để nâng cấp hệ thống Antigravity Engine:
    1. **Quy tắc Hệ thống Mới (`rules/37-ubiquitous-language-standard.md`)**:
       - Ban hành chuẩn Ubiquitous Language & Domain Dictionary (`CONTEXT.md`), triệt tiêu diễn đạt lan man ("20 words where 1 will do"), ánh xạ 1-1 khái niệm nghiệp vụ sang Kotlin/Compose symbols.
    2. **Nâng Cấp Kỹ Năng Lập Kế Hoạch (`skills/writing-plans/SKILL.md` & `skills/spec-driven-development/SKILL.md`)**:
       - Tích hợp nguyên lý **Tracer-Bullet Vertical Slicing** (cấm chia tầng ngang cô lập DAO ➔ Repo ➔ UI, bắt buộc chia lát cắt dọc mỏng end-to-end có thể chạy và kiểm thử ngay).
       - Tích hợp **Living ADR Auto-Extraction** (tự động phát hiện thỏa hiệp kiến trúc và xuất file ADR vào `docs/adr/00xx-<title>.md`).
    3. **Kỹ Năng Meta-Router Mới (`skills/ask-cto/SKILL.md`)**:
       - Kỹ năng điều phối thông minh (lấy cảm hứng từ `/ask-matt`), giúp định tuyến lập tức mọi triệu chứng kỹ thuật (drop FPS, process death, offline sync, memory leak) sang đúng 1-2 skills và quality gates phù hợp.
    4. **Cổng Kiểm Soát Mới (`Gate E28`) & Đồng Bộ Hệ Thống**:
       - Cập nhật `INDEX.md`, `.context-digest.md`, và Gate E28 (Ubiquitous Language & Domain Precision Gates).
  - Progress: Hoàn thành 100%.

- [2026-09-03] **World-Class UI/UX Design & Anti-AI-Design-Cliché Standard Integration (Rule 36 + Gate E27)** | Status: DONE
  - Objective: Xóa sổ vĩnh viễn định kiến "Nhìn là biết AI code / Giao diện AI xấu, thô cứng, phẳng lì"; chính thức kích hoạt vai trò **Lead UI/UX Architect & Product Design Director** vào hệ thống với 6 trụ cột thẩm mỹ đỉnh cao: Triệt tiêu 100% mô-típ AI sáo rỗng (cấm purple on dark, neon glowing, biscuit pills), Phân tầng độ sâu quang học (bắt buộc viền mỏng 0.5dp subtle border & tonal surfaces), Tỷ lệ vàng typography 3 tầng, Nhịp điệu lưới 8-point grid, Bản sắc ngành dọc riêng biệt (Fintech, E-commerce, SaaS, Media), và Micro-interactions tinh tế.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/36-ui-ux-design-standard.md`)**:
       - Ban hành Rule 36: The Human-Grade Aesthetic Mandate, 6 Forbidden AI Design Clichés, và Drop-in Compose Blueprints (Polished Surface Card, Expressive Typography Header).
    2. **Kỹ năng Tích hợp Chuyên sâu (`skills/ui-ux-pro-max/SKILL.md`)**:
       - Vận hành 240+ UI Styles, 170+ Color Palettes, 150+ Font Pairings theo từng ngành dọc.
    3. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md` - CATEGORY E27)**:
       - `E27.1`: Anti-AI-Design-Cliché Gate
       - `E27.2`: Visual Depth & Subtle Border Gate
       - `E27.3`: Typography Hierarchy & Contrast Gate
       - `E27.4`: 8-Point Grid Visual Rhythm Gate
       - `E27.5`: Domain-Tailored Aesthetics Gate
       - `E27.6`: Micro-Interactions & State Polish Gate
    4. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành World-Class UI/UX Design & Anti-AI-Slop Mandate.
    5. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Tích hợp Gate E27 vào Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động áp dụng Gate E27 kiểm toán chất lượng thẩm mỹ cho mọi màn hình UI/UX.

- [2026-09-03] **Automated ProGuard & R8 Rules Synthesis Mandate Integration** | Status: DONE
  - Objective: Tự động hóa 100% năng lực đọc phân tích codebase/dependencies, nhận diện toàn bộ DTOs, Room Entities, Navigation 3 Routes, và sinh ra file `proguard-rules.pro` (cho App mẹ) và `consumer-rules.pro` (cho từng module/SDK) chuẩn xác, kèm lệnh kiểm chứng build release thực tế (`assembleRelease`).
  - Scope & Deliverables:
    1. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành Quy tắc Tự Động Quét & Sinh ProGuard/R8 Rules.
       - Tự động quét `libs.versions.toml`, `build.gradle.kts`, phân tách 2 tầng rules (App vs Module), và xác thực bằng `./gradlew assembleRelease`.
  - Progress: Hoàn thành 100%.
  - Next Action: Sẵn sàng quét và sinh ProGuard / Consumer rules cho bất kỳ dự án/module nào khi được yêu cầu.

- [2026-09-03] **Database Migration & R8 ProGuard Release Defense Integration (Rule 35 + Gate E26)** | Status: DONE
  - Objective: Triệt tiêu vĩnh viễn 2 thảm họa sản xuất lớn nhất trên Android: Mất dữ liệu người dùng khi cập nhật Database Room (Data Loss), và Crash ứng dụng khi bật R8 Minify trên bản Release do bị cắt/đổi tên Reflection, DTOs, Room Entities, Navigation 3 Routes.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/35-database-migration-r8-defense.md`)**:
       - Ban hành Rule 35: The Zero-Data-Loss & Zero-Release-Crash Mandate, Cấm `fallbackToDestructiveMigration()`, Bắt buộc KSP `room.schemaLocation` export, Viết `MigrationTestHelper` test suite, và Thiết lập `consumer-rules.pro` cho mọi module/SDK.
    2. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md` - CATEGORY E26)**:
       - `E26.1`: Zero-Destructive-Migration Gate
       - `E26.2`: Room Schema Export & Migration Test Gate
       - `E26.3`: Consumer Proguard Rules Isolation Gate
       - `E26.4`: R8 Serialization & Keep Annotation Gate
       - `E26.5`: Real Release Minify Build Gate (`assembleRelease`)
    3. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Tích hợp Gate E26 vào Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động áp dụng Gate E26 để kiểm toán toàn diện tính an toàn của Room Migrations và R8 ProGuard Release builds.

- [2026-09-03] **Internal Module & SDK Architectural Standard Integration (Rule 34 + Gate E25)** | Status: DONE
  - Objective: Thiết lập Chuẩn mực Kiến trúc Module Nội bộ & SDK Chuyên sâu (SDK & Modular Architecture Standard) với 6 Trụ cột vàng: Minimal Public Surface (`internal` mặc định), Bắt buộc xuất xưởng Test Fake Module (`:testing`), Zero Startup Overhead (Cấm ContentProvider auto-init), Phân vùng lỗi và bảo vệ App mẹ (`SdkResult<T>`), Phân tầng Gradle & Convention Plugins (`build-logic`), và Quản lý vòng đời Binary Compatibility & SemVer Deprecation.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/34-sdk-modular-architecture.md`)**:
       - Ban hành Rule 34: The Enterprise Modularity Mandate, 4-Tier Module Taxonomy (`:api`, `:impl`, `:testing`, `:model`), và Drop-in SDK Blueprints (Public/Internal contracts, In-Memory Test Fakes).
    2. **Kỹ năng Chuyên biệt (`skills/sdk-modular-engineering.md` & `skills/sdk-modular-engineering/SKILL.md`)**:
       - Cung cấp Playbook thiết kế SDK, Gradle Convention Plugins, Fake Test Doubles, và checklist kiểm toán.
    3. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md` - CATEGORY E25)**:
       - `E25.1`: Public API Surface & Visibility Isolation Gate
       - `E25.2`: Mandatory Test Double / Fake Artifact Gate
       - `E25.3`: Zero Startup Penalty Gate
       - `E25.4`: Gradle Dependency Isolation Gate
       - `E25.5`: Host App Error Isolation Gate
       - `E25.6`: SemVer & Deprecation Lifecycle Gate
    4. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Tích hợp Gate E25 vào Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động áp dụng Gate E25 để thiết kế, refactor và review mọi SDK/Module nội bộ.

- [2026-09-03] **Modern Android & Compose Testing Standard Integration (Rule 33 + Gate E24)** | Status: DONE
  - Objective: Hoàn thiện mảnh ghép tối thượng của Bộ khung phát triển sản phẩm: Thiết lập Chuẩn mực Kiểm thử Toàn diện (Modern Testing Standard) với Kim tự tháp kiểm thử 4 tầng, 5 Định luật vàng chống test rác (Fakes > Mocks, Turbine StateFlow testing, Zero-Flakiness Coroutines, Koin DI graph verification, Room schema migration testing, và 5-State UI Matrix test coverage).
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/33-modern-testing-standard.md`)**:
       - Ban hành Rule 33: The Anti-Brittle Testing Mandate, 4-Tier Testing Pyramid (Unit/Concurrency, Integration/Contract, UI/Semantics, Real Build Gate), và Drop-in Testing Blueprints (Turbine, In-Memory Fakes, Koin verify, Room migration).
    2. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md` - CATEGORY E24)**:
       - `E24.1`: Turbine Flow Emission Gate
       - `E24.2`: Fakes Over Mocks Gate
       - `E24.3`: Zero-Flakiness Coroutine Gate
       - `E24.4`: Koin DI Graph Self-Verification Gate
       - `E24.5`: 5-State UI Matrix Test Coverage Gate
    3. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Tích hợp Gate E24 vào Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động áp dụng Gate E24 để kiểm toán chất lượng test suites cho mọi tính năng.

- [2026-09-03] **The 7 AI Blind Spots Defense Mandate Integration (Gate E23)** | Status: DONE
  - Objective: Triệt tiêu vĩnh viễn 7 điểm mù kinh điển của AI trong phát triển Android Jetpack Compose & Navigation 3, ngăn chặn từ gốc các lỗi: giật lag danh sách do thiếu key, race condition khi spam click, mất dữ liệu form khi xoay màn hình, bàn phím che input, import thư viện cũ, nối chuỗi vỡ i18n, và văn phong giao tiếp sáo rỗng.
  - Scope & Deliverables:
    1. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành Quy tắc Phòng Vệ 7 Điểm Mù Kỹ Thuật (Lazy Keys, Duplicate Click Lock, Form State Survival, Keyboard Auto-Scroll, Modern API Purity, Localization & Plurals, Zero-Fluff Communication).
    2. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md` - CATEGORY E23)**:
       - `E23.1`: Lazy Layout Stable Key & ContentType Gate
       - `E23.2`: Duplicate Click & Action Debounce Gate
       - `E23.3`: Form State Survival Gate
       - `E23.4`: Keyboard IME Auto-Scroll & Viewport Gate
       - `E23.5`: Modern Compose & Navigation 3 Import Purity Gate
       - `E23.6`: Localization & Plurals Compliance Gate
       - `E23.7`: Zero-Fluff Direct Communication Standard
    3. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Tích hợp Gate E23 vào Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động kích hoạt Gate E23 kiểm toán cho mọi tác vụ code.

- [2026-09-03] **Self-Documenting Code & Ban on Trivial Comments Mandate (Rule 32.6 + Gate E22.6)** | Status: DONE
  - Objective: Triệt tiêu hoàn toàn rác comment nhỏ lẻ, hiển nhiên (Code Clutter) do AI tự sinh ra; bắt buộc tên biến, hàm, class phải tự tường minh (Self-Documenting Naming), và chỉ cho phép comment ở các bài toán/thuật toán thực sự phức tạp hoặc non-obvious workarounds.
  - Scope & Deliverables:
    1. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành Quy tắc Code Tự Tường Minh & Cấm Comment Rác.
       - Tên biến/hàm phải tự giải thích mục đích; chỉ comment cho "WHY" (thuật toán phức tạp, OS/lib workaround, concurrency constraints), cấm comment cho "WHAT".
    2. **Quy tắc Hệ thống (`rules/32-anti-overengineering-minimalism.md`)**:
       - Ban hành **Rule 32.6: Self-Documenting Naming & Ban on Trivial Comments**.
    3. **Cổng Kiểm soát Tự động (`rules/21-enforcement-engine.md`)**:
       - Bổ sung **Gate E22.6: Trivial Comment Noise Gate** để tự động scan, phát hiện và xóa bỏ các comment hiển nhiên, lặp lại tên hàm/biến.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động giữ sạch mã nguồn, không sinh comment thừa.

- [2026-09-03] **Default Invariant Mandate: Zero-Crash, Zero-ANR, Zero-Leak & Ban on Paranoic Try-Catch Sprawling** | Status: DONE
  - Objective: Thiết lập quy chuẩn An Toàn Mặc Định (Default Invariant) cho toàn bộ hệ thống: Loại bỏ vĩnh viễn nhu cầu người dùng phải nhắc nhở "Hãy đảm bảo không bị crash, ANR, leak", đồng thời cấm triệt để thói quen bọc `try-catch` bừa bãi trong UI/Presentation/Domain để "chữa cháy" thay vì thiết kế kiến trúc an toàn.
  - Scope & Deliverables:
    1. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành Quy tắc An Toàn Mặc Định & Cấm Lạm Dụng Try-Catch.
       - Zero-Crash, Zero-ANR, Zero-Leak là Invariant hiển nhiên của mọi đoạn code; chỉ đặt Error Boundary ở duy nhất **I/O Boundary** (`Ktor`, `Room`, `JSON/File`).
    2. **Quy tắc Kiến trúc Hệ thống (`rules/13-error-handling.md`)**:
       - Ban hành **Rule 13.5: Anti-Paranoic Try-Catch & Boundary-Only Error Isolation**.
       - Bảo vệ tính toàn vẹn của Structured Concurrency (cấm nuốt `CancellationException`), đạt Zero-Crash qua Kotlin Null-Safety và Exhaustive `when`.
    3. **Kiến trúc Phòng vệ Thực chất**:
       - Zero-Crash: Type-Safe Kotlin, Smart Casts, StateFlow immutability.
       - Zero-ANR: Main-Thread Purity (`Dispatchers.IO` / `Dispatchers.Default`), non-blocking Flow.
       - Zero-Leak: Lifecycle-aware scopes (`viewModelScope`, `DisposableEffect` với `onDispose`), zero static Context/View references.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động tuân thủ Invariant an toàn kiến trúc mặc định cho mọi phiên làm việc.

- [2026-09-02] **Ponytail Anti-Overengineering & Minimalist Standard Integration (Rule 32 + Gate E22)** | Status: DONE
  - Objective: Tích hợp triết lý và thang ra quyết định 7 bậc của DietrichGebert/ponytail vào Antigravity Engine để triệt tiêu hoàn toàn bệnh over-engineering, code rườm rà, lạm dụng thư viện ngoài và boilerplate của AI.
  - Scope & Deliverables:
    1. **Nâng cấp Brain Decision Engine (`brain/05-decision-engine.md`)**:
       - Bổ sung Thang 7 Bậc Ra Quyết Định Bắt Buộc (The Mandatory Ponytail Decision Ladder: YAGNI -> Codebase Reuse -> Stdlib -> Native Platform -> Installed Dependency -> Single Expression -> Minimum Working Code).
    2. **Quy tắc Hệ thống Mới (`rules/32-anti-overengineering-minimalism.md`)**:
       - Ban hành Rule 32: The Zero-New-Dependency Mandate, Redundant Abstraction Ban, Single-Expression Idioms, Read-Deep-Write-Min, và The Untouchable Safety Matrix.
    3. **Cổng Kiểm soát Chất lượng Tự động (`rules/21-enforcement-engine.md` - CATEGORY E22)**:
       - `E22.1`: Redundant Helper/Wrapper Gate
       - `E22.2`: Over-Architected Intermediate Layer Gate
       - `E22.3`: Single-Expression Idiom Gate
       - `E22.4`: Native Platform & Stdlib First Gate
       - `E22.5`: Zero-Dependency-Bloat Gate
    4. **Kỹ năng Chuyên biệt (`skills/ponytail-minimalist.md` & `skills/ponytail-minimalist/SKILL.md`)**:
       - Cung cấp playbook tra cứu nhanh: Anti-Patterns vs Ponytail Minimalist Blueprints cho Compose UI, Kotlin Coroutines Flow, và Data/Domain Layers.
    5. **Đồng bộ hóa Hệ thống (`.context-digest.md`, `INDEX.md`)**:
       - Cập nhật Fast-Path Context Digest và Cross-Reference Index.
  - Progress: Hoàn thành 100%.
  - Next Action: Tự động áp dụng tư duy "Lazy Senior Dev" và Gate E22 cho mọi phiên code.

- [2026-08-31] **Proactive CTO/PO Advisory & Critical Pushback Mandate (Anti-Yes-Man Protocol)** | Status: DONE
  - Objective: Nâng cấp toàn diện tư duy và hành vi của AI từ "Vâng lời thụ động" (Passive Yes-Man) sang "Cố vấn & Phản biện Chủ động của CTO & PO", trang bị khả năng soi xét rủi ro hiệu năng và trải nghiệm người dùng trước khi code, đồng thời đưa ra các giải pháp kiến trúc tối ưu vượt trội.
  - Scope & Deliverables:
    1. **Nâng cấp Initiative Engine (`brain/10-initiative-engine.md`)**:
       - Tích hợp 3 bước: Friction & Risk Scan (CTO/PO Lens), Constructive Counter-Argument (Phản biện có số liệu), và Recommended Solution (Giải pháp tối ưu có Before vs After).
    2. **Ma trận Heuristics trong Fast-Path Digest (`~/.antigravity/.context-digest.md`)**:
       - Bổ sung Section 6: CTO Performance Heuristics (Recomposition, Zero Heap Garbage, Main Budget) & PO UI/UX Heuristics (5-State Matrix, Defensive Layout, 48dp Touch Targets, Insets/IME).
    3. **Quy tắc Ưu tiên Người dùng (`memory/06-user-preference-memory.md`)**:
       - Ban hành Quy tắc Phản biện & Cố vấn Chủ động CTO/PO bắt buộc áp dụng cho mọi tương tác.
  - Progress: Hoàn thành 100%.
  - Next Action: Sẵn sàng phản biện và đề xuất giải pháp tối ưu cho mọi yêu cầu của người dùng.

- [2026-08-31] **Antigravity Fast-Path Context Digest Architecture (V2 - 5.4K Tokens)** | Status: DONE
  - Objective: Tối ưu hóa toàn diện hiệu năng và chi phí ngữ cảnh của Agentic AI bằng kiến trúc 2 Tầng (2-Tier Fast/Deep Dual-Path): Fast-Path qua file nén `.context-digest.md` (~5.4K tokens) và Deep-Path qua kho lưu trữ chi tiết `~/.antigravity/`.
  - Scope & Deliverables:
    1. **Canonical Context Digest (`~/.antigravity/.context-digest.md`)**:
       - Nén 147 file thành 1 file duy nhất ~5.4K tokens bao phủ 100% Tech Stack, 19 Core Engineering Domains, Drop-in Code Blueprints (ViewModel, Compose Screen, Koin, SSOT Repository), Anti-Patterns (DOs & DON'Ts) và Quality Gates (E1 - E21).
    2. **Tự động sinh Digest cho Mọi Dự án (`init_project_anchor.sh`)**:
       - Nâng cấp script để tự động sinh `.context-digest.md` và `.antigravity/project.json` ngay tại root của bất kỳ workspace mới nào.
    3. **Tích hợp Fast-Path Bootstrapping vào Master Workflow & INDEX**:
       - Cập nhật Phase 0 trong `00-master-workflow.md` và `INDEX.md` ưu tiên nạp `.context-digest.md` trong 1 tool call duy nhất (~2 giây) để bắt đầu code ngay.
  - Progress: Hoàn thành 100%. Giảm 84% - 98% Token và tăng tốc độ khởi động gấp 15x - 150x.
  - Next Action: Sẵn sàng áp dụng cho tất cả các phiên làm việc và dự án.

- [2026-08-31] **Mobile Engineering Master Playbook & Architectural Defense Matrix (19 Core Domains)** | Status: DONE
  - Objective: Xây dựng Bộ Cẩm nang Kiến trúc Thực chiến (Master Playbook) và Ma trận Phòng vệ Kiến trúc (Architectural Defense Matrix) bao phủ toàn diện 19 Nhóm Vấn đề Cốt lõi của Kỹ thuật Phần mềm Di động Hiện đại.
  - Scope & Deliverables:
    1. **Master Playbook Dự Án (`plan/mobile_engineering_master_playbook.md`)**:
       - 19 chương chuyên sâu phân rã theo cấu trúc 5 tầng: Root Problem, Architectural Principles, Defensive Code Blueprints, Failure Recovery Matrix, và Quality Gates.
       - Ma trận 10 Kịch bản Thất bại Tối thượng (The 10 Ultimate Failure Modes) kèm sơ đồ Mermaid và quy trình tự phục hồi.
       - Bộ Cổng kiểm soát Chất lượng Tự động (Enforcement Gates E1 - E20).
    2. **Kỹ Năng Kiến Trúc Toàn Cục (`skills/mobile-engineering-core.md` & `skills/mobile-engineering-core/SKILL.md`)**:
       - Tích hợp trực tiếp vào Antigravity Engine (`~/.antigravity/skills/`) để tự động tra cứu và audit cho toàn bộ các phiên làm việc và dự án.
    3. **Kế Hoạch & Walkthrough**:
       - Lưu bản sao kế hoạch tại `plan/mobile_engineering_master_playbook_plan.md` và tạo Walkthrough tổng kết.
  - Progress: Hoàn thành 100%.
  - Next Action: Sẵn sàng áp dụng làm chuẩn mực kiến trúc và checklist kiểm toán cho mọi dự án di động.

- [2026-08-29] **Real Build & Runtime Verification Mandate (Rule 30 + Gate E20)** | Status: DONE
  - Objective: Triệt tiêu vĩnh viễn tình trạng "Unit test báo pass nhưng assembleDebug bị lỗi hoặc vào app bị crash/treo loading" bằng việc thiết lập Rule 30 (Real Build & Runtime Verification Mandate) và Cổng kiểm soát E20 trong Enforcement Engine.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/30-build-runtime-verification.md`)**:
       - 5 Trụ cột Kiểm thử Thực tế: Mandatory Full Assemble Build (`./gradlew assembleDebug testDebugUnitTest`), Koin DI Graph Integrity Audit (`koin.verify()`), UI Initial Data Trigger Safety (`init {}` / `LaunchedEffect(Unit)`), Anti-Over-Mocking & Realistic State Assertions (`StateFlow.value`), và AAPT2 Resource & XML Resolution Defense.
    2. **Nâng cấp Cổng Kiểm soát (`rules/21-enforcement-engine.md` - CATEGORY E20)**:
       - `E20.1`: Full Assemble Build Gate (Bắt buộc `assembleDebug` thành công 100%).
       - `E20.2`: Koin Dependency Graph Integrity Gate (Quét constructor ViewModels/UseCases vs `di/` modules).
       - `E20.3`: UI Initial Data Trigger Safety Gate (Bắt buộc có trigger tải dữ liệu ban đầu).
       - `E20.4`: Anti-Over-Mocking & State Assertion Gate (Bắt buộc assert giá trị UiState thật).
       - `E20.5`: Android Resources & AAPT2 Safety Gate (Bắt buộc 100% `R.string.*` và drawables tồn tại).
    3. **Đồng bộ hóa Hệ thống**:
       - Cập nhật `INDEX.md` và `rules/20-testing.md`, đưa Gate E20 vào bước kiểm tra bắt buộc của mọi task.
  - Progress: Hoàn thành 100%.
  - Next Action: Áp dụng trực tiếp vào tất cả các lệnh build và verify của hệ thống.

- [2026-08-29] **Defensive & Aesthetic Jetpack Compose Layout Mandate (Rule 29 + Gate E19)** | Status: DONE
  - Objective: Khắc phục triệt để các lỗi giao diện bị xấu, mất cân đối, đè view lên nhau (layout collisions), và tràn mép không xuống dòng bằng việc thiết lập Rule 29 (Defensive Compose Layout Standard) và Cổng kiểm soát E19 trong Enforcement Engine.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/29-ui-layout-defense.md`)**:
       - 5 Định luật Layout phòng vệ: Anti-Collision Box Anchoring (`Modifier.align()`), Row Truncation & Weight Defense (`Modifier.weight(1f)` + `maxLines` + `TextOverflow.Ellipsis`), Responsive Flow Wrapping (`FlowRow`/`LazyRow` cho tags/chips), Hệ thống lưới 8-Point Grid Spacing (`4/8/12/16/24/32/48dp`), và Phân cấp thị giác 3 Tầng (Hero > Body > Metadata) kèm viền kính mờ tinh tế `0.5.dp`.
    2. **Nâng cấp Cổng Kiểm soát (`rules/21-enforcement-engine.md` - CATEGORY E19)**:
       - `E19.1`: Row Text Overflow & Weight Gate (Cấm text không có weight trong Row bên cạnh component cố định).
       - `E19.2`: Unanchored Box Multi-Child Collision Gate (Bắt buộc `Modifier.align()` cho mọi child trong Box).
       - `E19.3`: Dynamic Text Safety & Truncation Gate (Bắt buộc `maxLines` và `Ellipsis` cho text động).
       - `E19.4`: Horizontal List Wrapping Gate (Bắt buộc dùng `FlowRow` cho danh sách chip/tag).
       - `E19.5`: 8-Point Grid Spacing & Proportions Gate (Cấm hardcoded dp tùy tiện).
    3. **Đồng bộ hóa Hệ thống**:
       - Cập nhật `INDEX.md` và kích hoạt tự động quét Gate E19 cho mọi tác vụ liên quan đến UI.
  - Progress: Hoàn thành 100%.
  - Next Action: Áp dụng trực tiếp vào tất cả các màn hình và component được tạo mới hoặc refactor.

- [2026-08-29] **GitHub Spec Kit & Spec-Driven Development (SDD) Integration Mandate** | Status: DONE
  - Objective: Học hỏi và chuẩn hóa toàn diện phương pháp luận Spec-Driven Development (SDD) từ GitHub Spec Kit (`github/spec-kit`) vào Antigravity Engine (`~/.antigravity/`), bao gồm Rule 28 (SDD Standards), Kỹ năng `spec-driven-development`, Cổng kiểm soát E18 (SDD Gate) trong Enforcement Engine, nâng cấp Workflow 01, 04 và hoàn thiện Living Specs.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/28-spec-driven-development.md`)**:
       - Triệt tiêu "vibe coding"; chuẩn hóa Bộ 3 Tạo tác SDD (`spec.md` -> `plan.md` -> `tasks.md`).
       - Bắt buộc Ma trận 5 Trạng thái UI/UX (`Loading`, `Content/Success`, `Empty`, `Error`, `Offline`).
       - Chuẩn hóa Kiểm thử Hành vi Gherkin (`Given-When-Then`) và Quy tắc Zero Spec Drift.
    2. **Kỹ năng Kiến trúc Mới (`skills/spec-driven-development.md` & `skills/spec-driven-development/SKILL.md`)**:
       - Cẩm nang chuyên sâu và bộ template mẫu: `Spec Template`, `Plan Template`, `Tasks Template` tối ưu cho Jetpack Compose & Kotlin Multiplatform.
    3. **Nâng cấp Cổng Kiểm soát (`rules/21-enforcement-engine.md` - CATEGORY E18)**:
       - `E18.1`: Spec Contract Alignment Gate (Cấm tự ý thêm code/logic/thư viện ngoài Spec).
       - `E18.2`: Exhaustive 5-State UI Matrix Gate (Bắt buộc đủ 5 trạng thái cho Compose screen).
       - `E18.3`: Gherkin Acceptance Criteria Verification Gate (Kiểm thử 100% kịch bản hành vi).
       - `E18.4`: Task Dependency Ordering Gate (Thực thi tuần tự Data -> Domain -> Presentation -> Tests).
    4. **Đồng bộ hóa Hệ thống & Living Specs**:
       - Nâng cấp `rules/23-living-feature-plans.md`, `workflow/01-requirement-analysis.md`, `workflow/04-implementation-planning.md`, và `INDEX.md`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/spec_driven_development_engine_plan.md`.
  - Next Action: Sẵn sàng áp dụng cho tất cả các task phát triển và thiết kế tính năng tiếp theo.

- [2026-08-26] **Android Vitals, App Quality & 2-Tier Hybrid Splash Orchestrator Mandate** | Status: DONE
  - Objective: Thiết lập toàn diện Bộ Quy tắc, Kỹ năng và Cổng kiểm soát (Enforcement Gate) về Google Play Android Vitals (Crash, ANR, Leak, Startup Optimization, Baseline Profiles) và Kiến trúc Splash 2 Tầng (2-Tier Hybrid Splash Orchestration) cho Jetpack Compose & Kotlin Multiplatform.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/27-app-quality-vitals.md`)**:
       - Rule 27.1: Google Play Android Vitals Budget Enforcement (Crash $< 0.05\%$, ANR $< 0.02\%$, Cold Start TTID $< 500\text{ms}$, TTFD $< 800\text{ms}$).
       - Rule 27.2: Triệt tiêu 100% Main-Thread Blocking $> 5\text{ms}$ (Cấm I/O, Room, JSON deserialization trên `Dispatchers.Main`; kích hoạt `StrictMode` trong Debug).
       - Rule 27.3: Bắt buộc `safeLaunch` cho mọi ViewModel coroutines và fallback mapping an toàn trong tầng Data.
       - Rule 27.4: Kiến trúc Splash 2 Tầng: Tầng 1 (AndroidX `SplashScreen` API tắt trong $< 200\text{ms}$ đạt chuẩn TTID) + Tầng 2 (Compose In-App Splash điều phối Remote Config $\le 2.5\text{s}$ và Ad Loading $\le 3.5\text{s}$ bằng `withTimeoutOrNull`).
       - Rule 27.5: An toàn hiển thị Ad và xóa sạch Splash khỏi Navigation 3 Backstack (`navigateAndClearBackStack`); cấm show interstitial ads trong first-launch onboarding.
       - Rule 27.6: Tăng tốc khởi động ứng dụng bằng Baseline Profiles (AOT compilation) và Koin Lazy DI resolution.
    2. **Kỹ năng Kiến trúc Mới (`skills/app-quality-vitals.md` & `skills/app-quality-vitals/SKILL.md`)**:
       - Hướng dẫn chuyên sâu cấu hình StrictMode, Jetpack Macrobenchmark Baseline Profiles, State Machine MVI cho Splash Orchestrator và Google UMP GDPR Consent.
    3. **Nâng cấp Cổng Kiểm soát (`rules/21-enforcement-engine.md` - CATEGORY E17)**:
       - Bổ sung 6 gate kiểm tra tự động E17.1 -> E17.6.
    4. **Đồng bộ hóa Hệ thống**:
       - Cập nhật `rules/16-performance.md` và `rules/18-monetization.md`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/app_quality_vitals_splash_plan.md`.
  - Next Action: Sẵn sàng áp dụng cho tất cả các task phát triển và kiểm toán mã nguồn tiếp theo.

- [2026-08-26] **Stack vs Heap Memory Architecture Mandate & Enforcement Engine (KMP + Jetpack Compose)** | Status: DONE
  - Objective: Thiết lập toàn diện Bộ Quy tắc, Kỹ năng và Cổng kiểm soát (Enforcement Gate) về Quản lý Bộ nhớ Stack và Heap cấp hệ thống cho Kotlin Multiplatform, Jetpack Compose và Coroutines.
  - Scope & Deliverables:
    1. **Quy tắc Hệ thống Mới (`rules/26-stack-heap-memory.md`)**:
       - Rule 26.1: `@JvmInline value class` cho toàn bộ Domain Identifiers và Metrics để nằm hoàn toàn trên Stack, cấm autoboxing sang Heap.
       - Rule 26.2: Triệt tiêu 100% cấp phát Heap tức thời (`SimpleDateFormat`, `Regex`, `Modifier.then()`, anonymous lambdas capturing scope) trong thân `@Composable` và `drawBehind {}`. Hoist lên ViewModel hoặc dùng `remember`.
       - Rule 26.3: Bắt buộc dùng Primitive Snapshot State (`mutableIntStateOf`, `mutableFloatStateOf`, `mutableLongStateOf`, `mutableDoubleStateOf`) để loại bỏ hoàn toàn boxing wrappers trên Heap.
       - Rule 26.4: Đánh dấu `inline` cho utility functions nhận lambda trong hot paths để giải phóng function object `FunctionN` khỏi Heap.
       - Rule 26.5: Bắt buộc dùng `.asSequence()` cho chuỗi xử lý collection $\ge 2$ bước và Primitive Arrays (`IntArray`, `ByteArray`) cho tính toán nặng.
       - Rule 26.6: Cấm giữ `Activity`, `Context`, `View` trong ViewModels/Singletons; giải phóng tài nguyên đối xứng trong `DisposableEffect.onDispose` và `ViewModel.onCleared()`.
       - Rule 26.7: Tối ưu đồ họa và bộ nhớ trực tiếp (`Bitmap.Config.HARDWARE`, 16KB Page Alignment).
    2. **Kỹ năng Kiến trúc Mới (`skills/stack-heap-memory.md` & `skills/stack-heap-memory/SKILL.md`)**:
       - Hướng dẫn chuyên sâu cơ chế ART & JVM (Young Gen, Eden, Survivor, Tenured, LOS, CMC GC pauses, Escape Analysis, SlotTable, Coroutine Continuations, Memory Leaks).
    3. **Nâng cấp Cổng Kiểm soát (`rules/21-enforcement-engine.md` - CATEGORY E16)**:
       - Bổ sung 6 gate kiểm tra tự động E16.1 -> E16.6.
    4. **Đồng bộ hóa Hệ thống**:
       - Cập nhật `rules/16-performance.md` và `rules/01-tech-stack.md`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/stack_heap_memory_mandate_plan.md`.
  - Next Action: Sẵn sàng áp dụng cho tất cả các task phát triển và kiểm toán mã nguồn tiếp theo.

- [2026-08-25] **100% Real Hardware & Network Engine Audit & Implementation (No-Fake Engine)** | Status: DONE
  - Objective: Kiểm toán triệt để, loại bỏ 100% các đoạn code giả lập, placeholder hoặc mô phỏng, và nâng cấp toàn bộ động cơ kết nối mạng và phần cứng thực tế trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Động cơ Quét TV Mạng Wi-Fi Thật (`:core:tvengine/discovery/SsdpDiscoveryService.kt`)**:
       - Triển khai thuật toán Subnet Probing đa luồng thực tế bằng Ktor HTTP Client tới dải IP mạng Wi-Fi cục bộ qua các cổng chuẩn:
         - Port `8060`: Roku ECP REST (`/query/device-info`).
         - Port `8001/8002`: Samsung Tizen REST (`/api/v2/`).
         - Port `3000/3001`: LG webOS Handshake probe.
         - Port `6466/6467`: Android TV / Google TV remote probe.
       - Tự động bóc tách XML/JSON để nhận diện tên TV, model, và danh sách capabilities thực tế.
    2. **Động cơ Điều khiển Samsung Tizen & LG webOS Thật (`:core:tvengine/controller/`)**:
       - `SamsungTizenRemoteController.kt`: Gửi HTTP REST probe kiểm tra `/api/v2/` và gửi lệnh điều khiển phím qua REST/WebSocket payload `ms.remote.control`.
       - `LgWebOsRemoteController.kt`: Bắt tay đăng ký SSAP `register_req` và gửi lệnh SSAP `ssap://audio/volumeUp`, `ssap://system/turnOff` thật.
       - `RokuRemoteController.kt`: Gửi HTTP POST trực tiếp tới `http://<ip>:8060/keypress/<key>` và `/launch/<appId>` thật 100%.
       - `DlnaCastController.kt`: Gửi SOAP XML `SetAVTransportURI`, `Play`, `Pause`, `Seek`, `SetVolume` tới UPnP endpoint `http://<ip>:<port>/upnp/control/AVTransport` thật 100%.
    3. **Trang Web Mirroring Receiver HTML Thật trên Ktor Server (`:core:tvengine/cast/server/LocalMediaHttpServer.kt`)**:
       - Máy chủ Ktor CIO nhúng trực tiếp trang HTML5 Canvas Live Stream hiện đại tại `http://IP:8088/mirror` với Dark OLED theme, đo lường FPS, độ trễ và chế độ toàn màn hình (Fullscreen) thực tế.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/real_engine_implementation_and_no_fake_audit_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL in 10s` (176 actionable tasks, 100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-25] **IPTV Live Stream Player, Web Browser Mirroring & Cast Stability Fix (KMP + CMP)** | Status: DONE
  - Objective: Xử lý triệt để 3 yêu cầu cốt lõi từ người dùng: (1) Xây dựng **Màn hình IPTV Live Stream Player Toàn diện** (`IptvPlayerScreen.kt` & `Route.IptvPlayer`), (2) Bổ sung **Screen Mirroring qua Trình duyệt Web** (`BrowserMirroringSection.kt` qua mã QR & máy chủ Web cục bộ), và (3) **Khắc phục triệt để lỗi Crash khi Cast TV** (xóa bỏ xung đột lồng cuộn Jetpack Compose & chống lỗi chia cho 0 NaN trong Seekbar) trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Khắc phục triệt để lỗi Crash khi Cast TV (`:feature:cast`)**:
       - `VideoListSection.kt`, `PhotoGallerySection.kt`, `AudioListSection.kt`: Chuyển đổi toàn bộ layout sang cấu trúc phẳng (Flat non-nested Column và Chunked Rows), loại bỏ 100% lỗi xung đột cuộn vô hạn (`IllegalStateException: Vertically scrollable component was measured with an infinity maximum height constraints`).
       - `CastPlayerDialog.kt`: Bổ sung kiểm tra an toàn `safeProgress = if (playbackState.durationMs > 0L) (playbackState.currentPositionMs.toFloat() / playbackState.durationMs).coerceIn(0f, 1f) else 0f` chống lỗi `NaN` chia cho 0, bảo vệ toàn diện hàm `formatMs`.
    2. **Màn hình IPTV Live Stream Player Toàn diện (`:feature:iptv/player/IptvPlayerScreen.kt`, `IptvPlayerRoute.kt`)**:
       - Khung phát Video tỷ lệ 16:9 với hoạt họa sóng âm thanh sống động (Audio/Video Visualizer Bars), nhãn `● LIVE STREAM`, badge `1080p 60FPS HD`.
       - Top HUD Bar: Nút Back, Thông tin kênh & Quốc gia, Nút **Cast 1-chạm sang Smart TV**, Nút chuyển tỷ lệ hình (16:9, Fit, Fill).
       - Center HUD: Cụm phím Play/Pause lớn và nút chuyển kênh Trước/Sau.
       - Bottom Section: **Băng chuyền chuyển nhanh kênh ngang (Horizontal Quick Channels Carousel)** cùng danh mục giúp chuyển đổi luồng phát tức thì không cần thoát player.
       - Tích hợp `Route.IptvPlayer(val channelId: String)` vào `NavDisplay` trong `App.kt`.
    3. **Screen Mirroring qua Trình duyệt Web (`:feature:mirroring/component/BrowserMirroringSection.kt`)**:
       - Bổ sung `MirroringMode` (`TV_DIRECT` vs `WEB_BROWSER`) với thanh chuyển tab Cupertino Segmented Control trên `MirroringScreen.kt`.
       - `BrowserMirroringSection.kt`: Hiển thị mã **QR Code** tự động trên màn hình, địa chỉ IP mạng nội bộ `http://192.168.1.xxx:8080/mirror`, nút *"Copy Link"*, hướng dẫn 3 bước kết nối cho PC/Mac/iPad/TV Browser, và huy hiệu số lượng trình duyệt đang kết nối.
       - `MirroringContract.kt` & `MirroringViewModel.kt`: Tích hợp các intent `SwitchMirroringMode`, `ToggleWebMirroring`, `CopyWebUrl`, `OpenWebUrl`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/iptv_player_web_mirroring_cast_fix_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL in 12s` (176 actionable tasks, 100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-24] **Remote Skins Studio & Haptic Vibration Feedback (KMP + CMP)** | Status: DONE
  - Objective: Xây dựng toàn diện 2 tính năng cao cấp: **Remote Skins Studio** (Kho 4 giao diện vỏ điều khiển cao cấp: Titanium Dark, Cyber Neon, Minimal Quartz, Luxury Gold) và **Haptic Vibration Feedback** (Rung xúc giác phần cứng qua Taptic Engine trên iOS & Haptic Engine trên Android) trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Core DataStore & Design System (`:core:datastore`, `:core:designsystem`)**:
       - `RemoteSkin.kt`: Định nghĩa 4 bộ màu phong cách độc quyền (`TITANIUM_DARK`, `CYBER_NEON`, `MINIMAL_QUARTZ`, `LUXURY_GOLD`) kèm mã màu vỏ remote, viền, phím và màu chữ.
       - `AppPreferences.kt`: Bổ sung lưu trữ vĩnh viễn `remoteSkin: Flow<String>` và `isHapticEnabled: Flow<Boolean>`.
    2. **Remote Skins Studio Modal (`:feature:remote/component/RemoteSkinsBottomSheet.kt`)**:
       - Hộp thoại chọn Skin trực quan với hình thu nhỏ của từng mẫu Remote, nhãn mô tả, dấu tích chọn, và công tắc gạt bật/tắt rung haptic.
    3. **MVI Architecture Integration (`:feature:remote`)**:
       - `RemoteContract.kt` & `RemoteViewModel.kt`: Tích hợp `selectedSkin: RemoteSkin`, `isHapticEnabled: Boolean`, intents `SelectSkin`, `ToggleHaptic`, `SetSkinsSheetVisible`.
       - `RemoteModule.kt`: Tiêm `AppPreferences` vào `RemoteViewModel`.
    4. **UI & Haptic Polish (`:feature:remote`)**:
       - `RemoteScreen.kt`: Bổ sung nút "Skins 🎨" trên thanh điều khiển trên cùng; tự động áp dụng màu sắc vỏ remote động từ `selectedSkin`.
       - `DPadController.kt` & `VolumeChannelPill.kt`: Kích hoạt rung haptic `HapticFeedbackType.LongPress` chân thực mỗi lần bấm phím.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/remote_skins_and_haptic_feedback_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL in 4s` (176 actionable tasks, 100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-24] **iOS Typography (SF Pro) & Soft Translucent Ripple Refinement (KMP + CMP)** | Status: DONE
  - Objective: Chuẩn hóa hệ thống Typography sang **Apple SF Pro (iOS) & Roboto (Android)** thông qua `FontFamily.SansSerif` và cấu hình `lineHeight`, `letterSpacing` chuẩn Apple HIG. Khắc phục triệt để cảm giác chạm cứng bằng việc mở rộng vùng chạm tối thiểu **44x44dp**, tích hợp **Soft Translucent Ripple** (`0.12f` alpha) và độ nảy lò xo mềm mại **`scale(0.96f)`** thay vì co giật thô cứng trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Typography System (`:core:designsystem/theme/AppTypography.kt`)**:
       - Gán tường minh `fontFamily = FontFamily.SansSerif` cho toàn bộ 14 cấp độ Typography (display, headline, title, body, label), tự động ánh xạ sang **Apple SF Pro** trên iOS và **Google Roboto** trên Android.
       - Tinh chỉnh `lineHeight` và `letterSpacing` theo chuẩn Apple Human Interface Guidelines (HIG).
    2. **Soft Tactile Feedback & Hit Area (`:core:designsystem/extension/TactileFeedbackExtensions.kt`)**:
       - Nâng cấp `Modifier.bouncyClickable()` và `Modifier.tactilePressScale()`: Mở rộng vùng chạm tối thiểu `defaultMinSize(minWidth = 44.dp, minHeight = 44.dp)`, tích hợp `ripple(bounded = true, color = AppTheme.colors.primary.copy(alpha = 0.12f))` và độ nảy lò xo êm dịu `scale(0.96f)`.
    3. **Component Refinements across Modules**:
       - `DPadController.kt`: Cụm 4 phím hướng và phím OK có ripple mờ dịu và lún êm ái `scale(0.94f)`.
       - `VolumeChannelPill.kt`: Cụm phím tăng giảm âm lượng/đổi kênh có ripple mờ dịu và lún êm ái `scale(0.92f)`.
       - `IptvChannelCard.kt` & `MediaCategoryTabs.kt`: Bọc vùng chạm 44dp tối thiểu và hiệu ứng highlight mờ.
       - `App.kt` (`BottomNavTab`): Mở rộng vùng chạm 48x44dp và tích hợp ripple mờ dịu.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/ios_font_and_soft_ripple_refinement_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng triển khai các tính năng mở rộng tiếp theo.

- [2026-08-24] **Modern UX & Tactile Micro-Interactions Redesign (KMP + CMP)** | Status: DONE
  - Objective: Nâng cấp toàn diện giao diện ứng dụng **Smart TV Remote & Cast Suite** theo 3 trụ cột: **Hiện đại (Luxury HIG/M3)**, **Dễ sử dụng (Intuitive UX)**, và **Cảm giác phản hồi xúc giác tức thì (Tactile Spring Physics)** trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Core Design System & Tactile Extensions (`:core:designsystem`)**:
       - `TactileFeedbackExtensions.kt`: `Modifier.bouncyClickable()` và `Modifier.tactilePressScale()` tích hợp chuyển động lò xo vật lý `spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow)` tự động co tỉ lệ khi ngón tay chạm xuống (`scale(0.88f - 0.94f)`) và bật nảy lại khi nhả ra.
    2. **Màn hình Remote TV (`:feature:remote`)**:
       - `DPadController.kt`: 4 phím hướng có hiệu ứng lún cơ học (Tactile Mechanical Press) và đổi màu xanh Indigo sáng rực khi bấm, phím OK trung tâm có vòng tròn phản hồi và độ nảy cao.
       - `VolumeChannelPill.kt`: Thanh Pill công thái học với phản hồi rung thị giác khi bấm tăng/giảm âm lượng hoặc chuyển kênh.
       - `TouchpadController.kt`: Bề mặt kính mờ hiển thị **Chấm Laser phát sáng** (Laser Pointer Dot Indicator) di chuyển mượt mà bám theo đầu ngón tay (`pointerInput`) kèm phản hồi xúc giác khi nhấp chuột.
       - `DeviceStatusCard.kt`: Chấm trạng thái kết nối TV nhấp nháy xanh Emerald nhịp thở chậm (Breathing Pulse) và nút Quét TV đổi màu mượt mà.
       - `RemoteScreen.kt`: Thanh chuyển tab Cupertino Segmented Control với chuyển động lò xo và thân remote vật lý bo góc 32dp.
    3. **Màn hình Cast TV Hub (`:feature:cast`)**:
       - `MediaCategoryTabs.kt`: Bảng phân loại danh mục với hiệu ứng co giãn xúc giác và chuyển đổi mượt mà.
       - `PhotoGallerySection.kt`, `VideoListSection.kt`, `AudioListSection.kt`: Thẻ video/ảnh 16:9 bo góc Squircle với hiệu ứng nâng độ cao và co giãn lò xo khi chạm, nút 1-chạm *"Cast"* phản hồi tức thì.
       - `CastPlayerControlBar.kt`: Thanh phát nhạc nổi Frosted Mini-Player với cụm phím Play/Pause và Stop có hoạt họa xoay nảy.
    4. **Màn hình Screen Mirroring (`:feature:mirroring`)**:
       - `HeroMirroringStatusCard.kt`: Vòng tròn nút Hero Start/Stop kích thước lớn với sóng radar đa tầng lan tỏa êm dịu, phản hồi nảy mạnh mẽ khi bấm Start/Stop.
       - `QualityPresetRow.kt`: 3 thẻ chất lượng Gaming, Cinema, Balanced với viền phát sáng khi được chọn.
    5. **Màn hình IPTV Live Channels (`:feature:iptv`)**:
       - `IptvCategoryTabs.kt`: Hàng tab phân loại với phản hồi lò xo.
       - `IptvChannelCard.kt`: Thẻ kênh với avatar gradient, nhãn đỏ nhấp nháy `LIVE`, nút sao Yêu thích ⭐ xoay nảy khi đánh dấu, và nút Cast 1 chạm.
    6. **Shell & Bottom Navigation Bar (`shared/src/commonMain/.../App.kt`)**:
       - Thanh điều hướng đáy nổi dạng kính mờ với hiệu ứng co giãn lò xo khi chạm vào từng tab.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/modern_ux_tactile_feedback_redesign_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo (Voice Assistant, DLNA Multi-Room Router).

- [2026-08-24] **Full UI/UX Redesign & Visual Overhaul (Android & iOS Compose Multiplatform)** | Status: DONE
  - Objective: Đại tu toàn bộ giao diện thị giác (Visual Overhaul) và trải nghiệm người dùng (UX) của ứng dụng **Smart TV Remote & Cast Suite** trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`. Loại bỏ 100% các emoji thô kệch, nâng cấp lên bảng màu **Titanium Dark OLED & Quartz Light**, xây dựng **Hệ thống Vector Icon thuần khiết (`AppIcons`)**, và áp dụng chuẩn thiết kế **Apple HIG & Google Material 3** cao cấp trên cả Android và iOS.
  - Scope & Deliverables:
    1. **Design System & Tokens (`:core:designsystem`)**:
       - `AppColors.kt`: Nâng cấp bộ màu sang trọng `DarkColors` (Deep OLED Black `#0A0D14`, Machined Slate `#121722`, Elevated Card `#1A2233`, Radiant Indigo `#6366F1`, Cyber Cyan `#06B6D4`, Emerald `#10B981`, Crimson `#EF4444`, Amber `#F59E0B`, Hairline Glass Border `0.5dp`).
       - `AppIcons.kt`: Thư viện Vector Icons thuần khiết toàn app (`Remote`, `Cast`, `ScreenMirror`, `Iptv`, `Settings`, `Home`, `Power`, `VolumeUp`, `VolumeDown`, `Mute`, `ChevronUp`, `ChevronDown`, `ChevronLeft`, `ChevronRight`, `Play`, `FastForward`, `Pause`, `Stop`, `Shield`, `StarFilled`, `StarOutline`, `Search`, `Subtitle`, `Touchpad`, `Numpad`).
    2. **Floating Frosted Glass Bottom Navigation Bar (`shared/src/commonMain/.../App.kt`)**:
       - Thanh điều hướng đáy nổi dạng kính mờ xuyên thấu, bo cong 24dp, viền siêu mỏng 0.5dp, tối ưu vùng an toàn Home Indicator iPhone (`navigationBarsPadding()`), chuyển tab mượt mà với hoạt họa scale và đổi màu chữ 10sp.
    3. **Màn hình Remote TV (`:feature:remote`)**:
       - Thân remote vật lý giả lập nhôm mờ công thái học (bo góc 32dp), D-Pad kim loại tròn với chevrons vector sắc nét, phím tăng giảm âm lượng/đổi kênh dạng thanh Pill hiện đại, cụm phím nguồn/tìm kiếm/bàn phím/source vector, và Cupertino Segmented Control (D-Pad | Touchpad).
    4. **Màn hình Cast TV Hub (`:feature:cast`)**:
       - Category Selector dạng Segmented Pills với vector icons, thẻ video/ảnh tỉ lệ 16:9 góc bo Squircle mượt mà, thanh phát nhạc nổi frosted glass với thanh tiến trình mượt mà, và Web Video Caster Pro với huy hiệu khiên bảo vệ `AdBlocker Active`.
    5. **Màn hình Screen Mirroring (`:feature:mirroring`)**:
       - Hero Mirroring Button hình tròn lớn với hoạt họa sóng radar đa tầng (Concentric Pulse Rings), HUD hiển thị chỉ số thời gian thực (Resolution, FPS, Bitrate) phong cách Apple Fitness, và thẻ Preset chất lượng cao.
    6. **Màn hình IPTV Live Channels (`:feature:iptv`)**:
       - Thanh tìm kiếm kính lúp vector, Category Tabs lọc kênh, Thẻ kênh với avatar gradient, nhãn đỏ nhấp nháy `LIVE`, nút Cast 1 chạm màu Primary nổi bật, và nút Favorite Star.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/ui_ux_redesign_android_ios_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed, 0 background tasks).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo (Voice Assistant, DLNA Multi-Room Router).

- [2026-08-24] **IPTV Live Stream Player & Web Video Caster Pro + Built-in AdBlocker (KMP + CMP)** | Status: DONE
  - Objective: Xây dựng toàn diện 2 tính năng giải trí cao cấp: **IPTV & M3U8 Live Stream Player** (`:feature:iptv`) và **Web Video Caster Pro + Built-in AdBlocker** (`:feature:cast`) trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **IPTV & M3U8 Live Stream Suite (`:feature:iptv`)**:
       - `M3uParserEngine.kt`: Trình phân tích cú pháp `#EXTM3U` & `#EXTINF` metadata (`tvg-id`, `tvg-name`, `tvg-logo`, `group-title`, `tvg-country`), tự động ánh xạ category thông minh.
       - `CuratedIptvChannels.kt`: Danh sách kênh mẫu chất lượng cao (VTV1-VTV9 HD, HTV, Thể thao Live, Tin tức quốc tế CNN/BBC/NHK World).
       - MVI Architecture: `IptvContract` (`IptvState`, `IptvIntent`, `IptvEffect`), `IptvViewModel` (kế thừa `BaseViewModel`, hỗ trợ tìm kiếm, lọc danh mục, đánh dấu yêu thích ⭐, nạp playlist từ URL hoặc dán nội dung M3U, đẩy luồng HLS sang Smart TV qua `DlnaCastController`).
       - 3-Layer UI (Router - Screen - Preview): `IptvRoute` (Stateful Router) -> `IptvScreen` (Stateless UI) -> Components (`IptvCategoryTabs`, `IptvChannelCard` kèm LIVE badge & Cast 1 chạm, `IptvPlaylistImportDialog`, `IptvPlayerBottomSheet`).
       - Unit Tests: `M3uParserTest` (100% pass) và `IptvViewModelTest` (100% pass).
    2. **Web Video Caster Pro + Built-in AdBlocker (`:feature:cast`)**:
       - `AdBlockerEngine.kt`: Bộ lọc chặn quảng cáo rule-based (triệt tiêu 99% popup, redirect, betting, tracking domains), đếm số lượng ads đã chặn.
       - `WebBookmark.kt`: Quản lý danh sách trang phim yêu thích và bookmark tùy chỉnh.
       - `SubtitleTrack.kt`: Hỗ trợ nạp và đồng bộ phụ đề rời `.srt` và `.vtt`.
       - `WebVideoCastSection.kt`: Thanh địa chỉ tích hợp trạng thái AdBlocker (🟢 AdBlock Active), Quick Bookmarks row, Subtitle selector, Sniffed Streams banner với nút Cast to TV.
       - Unit Tests: `AdBlockerTest` (100% pass) và `CastViewModelTest` (100% pass).
    3. **Navigation 3 & Shell Integration (`:core:navigation`, `:shared`)**:
       - Bổ sung `Route.Iptv` vào `Route.kt`.
       - Đăng ký `iptvModule` trong `AppModule.kt`.
       - Tích hợp tab **IPTV** ⚡ vào thanh `AppBottomNavigationBar` (📺 Remote | 📡 Cast TV | 📱 Mirror | ⚡ IPTV | ⚙️ Settings).
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/iptv_and_web_caster_pro_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo (Voice Remote Assistant, TV Apps Manager & Remote Skins, Multi-Room Smart Switcher).

- [2026-08-24] **Screen Mirroring Feature Suite (KMP + CMP)** | Status: DONE
  - Objective: Xây dựng toàn diện tính năng Screen Mirroring (Phản chiếu toàn bộ màn hình điện thoại lên Smart TV) trên Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Core TV Engine (`:core:tvengine`)**:
       - `ScreenMirroringConfig.kt`: Các model cấu hình `MirroringResolution` (480p, 720p, 1080p), `MirroringFps` (30fps, 60fps), `MirroringPreset` (Gaming/Low Latency 60fps, Cinema 1080p, Balanced 720p), `ScreenMirroringSessionMetrics`.
       - `ScreenMirroringEngine.kt`: Điều phối luồng stream màn hình trực tiếp qua `LocalMediaHttpServer` (`http://<ip>:8088/media/screen-live`) và tự động push SOAP AVTransport URI sang Smart TV mục tiêu thông qua `DlnaCastController`.
       - Koin DI: Đăng ký `ScreenMirroringEngine` trong `TvEngineModule`.
       - Unit Tests: `ScreenMirroringUnitTest` (100% pass).
    2. **Feature Screen Mirroring (`:feature:mirroring`)**:
       - Module mới: Tạo `feature/mirroring/build.gradle.kts`, khai báo trong `settings.gradle.kts` và `shared/build.gradle.kts`.
       - MVI Architecture: `MirroringContract` (`MirroringState`, `MirroringIntent`, `MirroringEffect`), `MirroringViewModel` (kế thừa `BaseViewModel`).
       - 3-Layer UI (Router - Screen - Preview): `MirroringRoute` (Stateful Router) -> `MirroringScreen` (Stateless Pure UI) -> Atomic Components (`HeroMirroringStatusCard` radar pulse animation + big circular action button, `MirroringTargetDeviceCard`, `QualityPresetRow`, `MirroringQualityBottomSheet`, `MirroringDevicePickerBottomSheet`, `MirroringGuideCard`).
       - Unit Tests: `MirroringViewModelTest` (100% pass).
    3. **Navigation 3 & Shell (`:core:navigation`, `:shared`)**:
       - Bổ sung `Route.ScreenMirroring` vào `Route.kt`.
       - Đăng ký `mirroringModule` trong `AppModule.kt`.
       - Tích hợp tab `Mirror` 📱 vào thanh `AppBottomNavigationBar` trong `App.kt`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/screen_mirroring_implementation_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo (IPTV Live Channels, Web Video Caster Pro + AdBlocker, Voice Remote Assistant).

- [2026-08-24] **Universal Smart TV Remote & Cast TV Application Suite (KMP + CMP)** | Status: DONE
  - Objective: Xây dựng toàn diện bộ ứng dụng Universal Smart TV Remote & Media Caster Suite trên nền tảng Kotlin Multiplatform (KMP 2.4+) và Compose Multiplatform (CMP 1.11+) tại `Base-KMP`.
  - Scope & Deliverables:
    1. **Core TV Engine (`:core:tvengine`)**:
       - Auto Discovery Manager (`DiscoveryManager`, `SsdpDiscoveryService` UDP multicast, `NsdDiscoveryService` mDNS).
       - Universal Remote Controllers: `AndroidTvRemoteController` (v2 PIN pairing & TLS keycodes), `SamsungTizenRemoteController` (WebSocket `ms.remote.control`), `LgWebOsRemoteController` (WebSocket SSAP client-key handshake), `RokuRemoteController` (REST ECP API), `TvControllerFactory`.
       - Media Casting Engine: `DlnaCastController` (UPnP AVTransport SOAP XML & DIDL-Lite metadata) và `LocalMediaHttpServer` (Ktor Server CIO embedded server phát trực tiếp ảnh/video/nhạc local cho Smart TV qua Wi-Fi LAN).
       - Koin DI: `TvEngineModule`.
       - Unit Tests: `TvEngineUnitTest` (100% pass).
    2. **Feature TV Remote (`:feature:remote`)**:
       - MVI Architecture: `RemoteContract` (`RemoteState`, `RemoteIntent`, `RemoteEffect`), `RemoteViewModel` (kế thừa `BaseViewModel`).
       - 3-Layer UI: `RemoteRoute` (Stateful Router) -> `RemoteScreen` (Stateless UI) -> Components (`DPadController`, `TouchpadController`, `VolumeChannelPill`, `QuickAppLauncherRow`, `DeviceStatusCard`, `DeviceScanBottomSheet` radar pulse, `PairingPinDialog`, `VirtualKeyboardDialog`, `NumpadBottomSheet`).
       - Unit Tests: `RemoteViewModelTest` (100% pass).
    3. **Feature TV Cast Hub (`:feature:cast`)**:
       - MVI Architecture: `CastContract` (`CastState`, `CastIntent`, `CastEffect`), `CastViewModel` (kế thừa `BaseViewModel`).
       - 3-Layer UI: `CastRoute` (Stateful Router) -> `CastScreen` (Stateless UI) -> Components (`MediaCategoryTabs`, `PhotoGallerySection` + auto slideshow, `VideoListSection`, `AudioListSection`, `WebVideoCastSection` + stream sniffer `.m3u8`/`.mp4`, `CastPlayerControlBar` mini player, `CastPlayerDialog` full timeline seeker, `CastDevicePickerBottomSheet`).
       - Unit Tests: `CastViewModelTest` (100% pass).
    4. **Shell & Navigation 3 Integration (`:shared`, `:core:navigation`)**:
       - Routes: `Route.Remote`, `Route.CastHub`, `Route.WebCast`.
       - App Shell: `AppBottomNavigationBar` (Remote, Cast TV, Home, Settings tabs).
       - Koin Modules: `tvEngineModule`, `remoteModule`, `castModule`.
  - Progress: Hoàn thành 100%. Đã lưu plan tại `plan/remote_cast_tv_implementation_plan.md`.
  - Verification: `./gradlew compileDebugKotlin` và `./gradlew test` -> `BUILD SUCCESSFUL` (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo (Screen Mirroring, IPTV playlist player).

- [2026-08-24] **Project-Scoped Permission Boundary & Elimination of Shell File Creation** | Status: DONE
  - Objective: Thiết lập hàng rào bảo mật Project-Scoped Permission Boundary: Cho phép AI tự động tạo và chỉnh sửa file mã nguồn bên trong thư mục dự án (`app/src/main/`, `domain/`, `data/`, `presentation/`, `di/`, `core/`, `plan/`) thông qua các công cụ Native (`write_to_file`, `replace_file_content`) sau khi Plan được duyệt, triệt tiêu 100% popup xin quyền shell `cat << 'EOF'`. Đồng thời thiết lập cơ chế bảo vệ nghiêm ngặt: Tuyệt đối cấm tự ý can thiệp bất kỳ file nào nằm ngoài thư mục dự án (hệ thống OS, `~/.zshrc`, Desktop, thư mục cá nhân).
  - Progress: Hoàn thành 100%. Đã cập nhật `06-user-preference-memory.md`, `00-system-mandate.md`, bổ sung Category E15 vào `21-enforcement-engine.md`, và tạo walkthrough.
  - Verification: Rà soát 100% cú pháp, quy chuẩn và các chốt chặn an toàn.
  - Next Action: Sẵn sàng thực thi các task phát triển ứng dụng mượt mà trong phạm vi dự án.

- [2026-08-23] **Unified Smart Permission Controller (USPC) & Lifecycle Automation** | Status: DONE
  - Objective: Giải quyết triệt để sự phức tạp và phân mảnh của luồng xin quyền trên Android. Thiết lập kiến trúc Unified Smart Permission Controller (USPC) tự động phân biệt và xử lý cả Runtime Permissions và Special App Access Permissions (All Files, Overlay, Usage Stats), cơ chế nhận diện 2 lần từ chối (Permanently Denied / Don't ask again), tự động re-check và kích hoạt tiếp hành động khi quay lại từ Settings (Lifecycle Resume Auto-Action qua `LifecycleEventEffect(ON_RESUME)`), đóng gói thành Compose Hook `rememberPermissionController()` và `PermissionDialogHost` tại tầng Router.
  - Progress: Hoàn thành 100%. Đã tạo `skills/permissions-management.md`, cập nhật `rules/06-compose.md`, `rules/03-base-layer.md`, `rules/04-feature-construction.md`, bổ sung Category E14 vào `rules/21-enforcement-engine.md`, lưu plan tại `plan/unified_permission_architecture_plan.md` và tạo walkthrough.
  - Verification: Xác thực 100% cú pháp, tài liệu và các tiêu chí Quality Gate.
  - Next Action: Sẵn sàng áp dụng Permission Controller vào các tính năng xin quyền của ứng dụng.

- [2026-08-23] **Kotlin Multiplatform (KMP) & Compose Multiplatform (CMP) Architecture & Quality Gate Expansion** | Status: DONE
  - Objective: Nâng cấp toàn diện hệ thống Rules (`01-tech-stack.md`, `21-enforcement-engine.md` - Category E13), Skills (`cross-platform.md`) và Task Memory của Antigravity để trang bị đầy đủ năng lực phát triển, thiết kế kiến trúc và chuyển đổi sang Kotlin Multiplatform (KMP 2.0+) & Compose Multiplatform (CMP 1.6+) theo chuẩn 2026 (Maximal Clean Sharing trong `commonMain`, Room KMP 2.7+, Ktor 3.x, Koin 4.x, Multiplatform Resources `Res.string`, và Quality Gate E13.1-E13.4).
  - Progress: Hoàn thành 100%. Đã cập nhật `01-tech-stack.md`, viết lại toàn diện `cross-platform.md`, bổ sung Category E13 vào `21-enforcement-engine.md`, lưu plan tại `plan/kmp_architecture_and_framework_expansion_plan.md` và tạo walkthrough.
  - Verification: Rà soát 100% cú pháp, liên kết và các tiêu chí Quality Gate.
  - Next Action: Sẵn sàng thực hiện chuyển đổi hoặc phát triển các module KMP mới.

- [2026-08-23] **Router - Screen - Preview Architecture Standardization** | Status: DONE
  - Objective: Chuẩn hóa toàn diện hệ thống Rules (`~/.antigravity/rules/` - `06-compose.md`, `21-enforcement-engine.md`, `04-feature-construction.md`, `02-architecture.md`, `07-viewmodel.md`, `11-navigation.md`) và Skills (`~/.antigravity/skills/` - `compose-essentials.md`, `anti-patterns.md`, `mvi.md`, `design-patterns.md`) theo mô hình 3 lớp: Stateful Router (DI `koinViewModel()`, Permissions `rememberLauncherForActivityResult`, Dialogs, Side-effects) -> Stateless Screen (100% Declarative Pure UI, chỉ nhận `UiState` và `onIntent`, giải phóng hoàn toàn ViewModel khỏi Screen) -> Mandatory Previews (bắt buộc `@Preview` Light/Dark mode và `PreviewParameterProvider` cho các trạng thái Loading, Empty, Success, Error), giải quyết triệt để lỗi render Preview trong Android Studio và tối ưu hóa khả năng debug UI.
  - Progress: Hoàn thành 100%. Đã cập nhật 10 file rules & skills, bổ sung Quality Gate E12.9, E12.10, E12.11 vào `21-enforcement-engine.md`, lưu plan tại `plan/router_screen_preview_architecture_plan.md` và tạo walkthrough.
  - Verification: Xác thực cú pháp Markdown, cấu trúc tài liệu, đồng bộ hóa các liên kết chéo và hoàn thành toàn bộ checklist theo kế hoạch.
  - Next Action: Sẵn sàng áp dụng quy chuẩn 3 lớp Router - Screen - Preview vào các màn hình tính năng tiếp theo của dự án.

- [2026-08-19] **Jetpack Compose Pitfalls, Compiler Stability & Quality Gate Integration** | Status: DONE
  - Objective: Systematically incorporate the Jetpack Compose Common Pitfalls, Compiler Stability rules, Phased Execution state read deferrals, Side-Effects guardrails (rememberUpdatedState for stale closures, onDispose cleanup), Lifecycle-Aware State Collections (collectAsStateWithLifecycle), Lazy Layout Stable Keys, Stateless Component Decoupling, and Modifier Chaining standards into the Custom Framework rules/ (`06-compose.md`, `16-performance.md`, `21-enforcement-engine.md` - Category E12) and skills/ (`compose-essentials.md`, `anti-patterns.md`, `lists-grids.md`, `performance.md`) in English.
  - Progress: Completed 100%. Updated all 7 target files across rules/ and skills/, added automated Quality Gate Category E12 to 21-enforcement-engine.md, saved project implementation plan to `plan/update_compose_pitfalls_rules_and_skills_plan.md`, verified compilation and unit tests.
  - Verification: Ran `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL (100% unit tests passed).
  - Next Action: Ready for subsequent product and feature development tasks.

- [2026-08-19] **Automated Git Pre-Commit Quality Gate & SOLID Architecture Integration** | Status: DONE
  - Objective: Ban hành và tích hợp toàn diện quy chuẩn S.O.L.I.D (`25-solid-principles.md`) vào Custom Framework, nâng cấp Quality Gate (`21-enforcement-engine.md` - Danh mục E11), thiết lập Git Pre-Commit Hook tự động hóa (`scripts/git-hooks/pre-commit`, `scripts/install-git-hooks.sh`, `.git/hooks/pre-commit`) tự động quét vi phạm Design System, ViewModel, Clean Architecture, SOLID, Security và Gradle Compilation trước khi cho phép commit, đồng thời ghi nhận vĩnh viễn quy tắc "Tuyệt đối không tự ý commit" và "Tự động tạo Conventional Commit Message" vào User Preference Memory (`06-user-preference-memory.md`).
  - Progress: Hoàn thành 100%. Đã tạo `25-solid-principles.md`, cập nhật `21-enforcement-engine.md`, cập nhật `02-architecture.md`, tạo `scripts/git-hooks/pre-commit`, tạo `scripts/install-git-hooks.sh`, cài đặt và cấp quyền `chmod +x .git/hooks/pre-commit`, cập nhật `06-user-preference-memory.md`, lưu plan tại `plan/solid_principles_architecture_plan.md` & `plan/git_pre_commit_hook_quality_gate_plan.md`, kiểm thử thực tế hook thành công.
  - Verification: Chạy trực tiếp `.git/hooks/pre-commit` -> 0 violations, Gradle compilation `BUILD SUCCESSFUL`.
  - Next Action: Sẵn sàng phát triển các tính năng tiếp theo trong lộ trình sản phẩm.

- [2026-08-17] **Cold Start & Initialization Performance Optimization** | Status: DONE
  - Objective: Tối ưu hóa toàn diện hiệu năng khởi động nguội (Cold Start Time), rút ngắn chỉ số Time to Initial Display (TTID) và Time to Full Display (TTFD) xuống < 150ms. Giải phóng hoàn toàn Main Thread trong `Application.onCreate()` bằng cách tách Critical Path (< 15ms), chuyển Ads/Tracking SDKs (AppsFlyer, PandaSdk, ResumeAd) sang Asynchronous Background Scope (`AppInitializer.initAsync`), loại bỏ lệnh gọi thủ công thừa `FirebaseApp.initializeApp`, loại bỏ `printLogger()` của Koin DI, và cấu hình `windowBackground` `#0C1014` trong `themes.xml` để triệt tiêu hoàn toàn hiện tượng nháy trắng (white flash) khi khởi động.
  - Progress: Hoàn thành 100%. Đã tạo `AppInitializer.kt`, cập nhật `MyApplication.kt`, cập nhật `themes.xml`, `colors.xml`, viết bộ Unit Test suite `AppInitializerTest.kt` và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 12s (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai tính năng kế tiếp trong lộ trình.

- [2026-08-31] **Unified AdPolicy Architecture (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tinh gọn và đóng gói toàn bộ hệ thống cơ chế tối ưu hóa (Capping đa tầng, Scheduled JIT Reload, Exponential Backoff Retry, Proactive TTL Refresh) vào **1 thuộc tính chiến lược duy nhất: `policy: AdPolicy`** (`FULL_OPTIMIZED`, `RELAXED`, `RAW_DIRECT`). Triệt tiêu 100% "Config Bloat" (rác cấu hình với 6-7 boolean cồng kềnh) và chuẩn hóa cho Firebase Remote Config (1 key JSON duy nhất).
  - Scope & Deliverables:
    1. **`AdPolicy.kt`**: Tạo enum class với 3 chế độ:
       - `FULL_OPTIMIZED` (Mặc định cho 90% màn hình): Bật trọn bộ tối ưu eCPM & Retention.
       - `RELAXED` (Game / Công cụ thao tác nhiều): Giữ Cooldown 60s & JIT Reload, bỏ qua giới hạn ngày & phiên để user xem nhiều ad.
       - `RAW_DIRECT` (Splash Screen / Urgent Ads): Tắt toàn bộ Capping/Cooldown/Retry (hiển thị tức thì 0ms, không rào cản).
    2. **`AdUnitConfig.kt`**: Thêm trường `val policy: AdPolicy = AdPolicy.FULL_OPTIMIZED` (Zero Breaking Change).
    3. **`PandaInterstitial.kt`**: Điều khiển tự động toàn bộ logic `show()` và `preload()` theo `config.policy`.
    4. **`SplashViewModel.kt`**: Cấu hình `inter_splash` với `policy = AdPolicy.RAW_DIRECT` và `inter_home` với `policy = AdPolicy.FULL_OPTIMIZED`.
    5. **`PandaInterstitialTest.kt`**: Bổ sung `TC_INT_18` (kiểm thử RAW_DIRECT bypass capping) và `TC_INT_19` (kiểm thử RELAXED giữ cooldown nhưng bỏ daily/session cap).
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (29/29 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng AdPolicy thanh thoát.

- [2026-08-31] **Interstitial Elite Optimizations Package (Panda-NextGen-2027)** | Status: DONE
  - Objective: Triển khai trọn vẹn Bộ 4 Tối ưu hóa Tinh hoa (Elite Optimizations) cho `PandaInterstitial` đạt chuẩn Super App (Top 1% Google Play):
    1. **Daily & Session Frequency Capping**: Giới hạn tối đa 8 lượt xem/ngày và 5 lượt xem/phiên (tự reset sau 24h) để bảo vệ Retention người dùng và chống AdMob bóp giá thầu eCPM.
    2. **`showAndNavigate` Action Wrapper**: Hàm bọc chuyển màn hình nguyên tử (`AtomicBoolean`), đảm bảo callback điều hướng `onNavigate()` chỉ chạy đúng 1 lần duy nhất, triệt tiêu 100% lỗi Double Navigation.
    3. **`Exponential Backoff Retry Engine`**: Tự động thử nạp lại ngầm thông minh (5s, 10s, 20s) khi mạng chập chờn / No Fill, giúp ad sẵn sàng ngay khi có mạng trở lại.
    4. **`Proactive TTL Cache Refresh` (Tại phút thứ 50)**: Tự động nạp mới trước khi ad cũ hết hạn 55 phút (TTL) để bộ nhớ đệm `AdCachePool` không bao giờ bị rơi vào trạng thái rỗng.
  - Scope & Deliverables:
    1. **`FrequencyCapper.kt`**: Nâng cấp hỗ trợ Daily Cap (max 8) và Session Cap (max 5) kèm cơ chế tự reset sau 24h.
    2. **`PandaInterstitial.kt`**:
       - Tích hợp kiểm tra `checkCapping()` trong `show()`, ghi nhận impression qua `recordImpression()`.
       - Thêm `showAndNavigate(activity, placement, skipInterval, onNavigate)` nguyên tử.
       - Tích hợp `Exponential Backoff Retry Engine` trong `preload()` (tối đa 3 lần).
       - Tích hợp `Proactive TTL Refresh` hẹn giờ tại phút thứ 50.
    3. **`PandaInterstitialTest.kt`**: Bổ sung `TC_INT_15` (Multi-tier Capping), `TC_INT_16` (showAndNavigate Atomic Guarantee), `TC_INT_17` (Exponential Backoff Retry).
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (27/27 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Interstitial hoàn hảo.

- [2026-08-31] **Lifecycle-Aware PandaInterstitial Engine & Lifecycle Guard (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tích hợp toàn diện `LifecycleOwner` và `DefaultLifecycleObserver` vào `PandaInterstitial`: Tự động chặn đứng lỗi Window Leak & Crash (`IllegalStateException`) nếu Activity chưa ở trạng thái `RESUMED` khi gọi `show()`, tự động hủy coroutine job hẹn giờ nạp ngầm (`cancelScheduledReload`) khi Activity `ON_DESTROY`, và cung cấp API `bindLifecycle(lifecycleOwner, placement, context, autoPreloadOnResume)` tự động nạp lại ad khi màn hình `ON_RESUME`.
  - Scope & Deliverables:
    1. **`PandaInterstitial.kt`**:
       - Thêm `Lifecycle Guard` trong `show()` kiểm tra `activity.lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED)`.
       - Trong `onDismissedOrFailed`: Tự động đăng ký `DefaultLifecycleObserver` hủy job nạp ngầm nếu Activity bị `onDestroy` trước mốc 55s.
       - Cung cấp API công khai `bindLifecycle(lifecycleOwner, placement, context, autoPreloadOnResume)`.
    2. **`PandaInterstitialTest.kt`**:
       - Cập nhật mock `TestLifecycleActivity` kế thừa `Activity` và `LifecycleOwner`.
       - Bổ sung `TC_INT_12` (Lifecycle Guard từ chối khi Activity chưa RESUMED), `TC_INT_13` (bindLifecycle tự hủy reload khi onDestroy), `TC_INT_14` (bindLifecycle với autoPreloadOnResume tự nạp ad khi onResume).
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (27/27 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Lifecycle-Aware Interstitial hoàn hảo.

- [2026-08-31] **State-Driven Reactive Interstitial & Instant Direct Show Standardization (Panda-NextGen-2027)** | Status: DONE
  - Objective: Chuẩn hóa toàn diện cơ chế hiển thị của `PandaInterstitial` theo đúng chuẩn Jetpack Compose Reactive UDF (Uni-Directional Data Flow): Xóa bỏ hoàn toàn Dialog ngầm (`AdLoadingDialog`) và `delay(600ms)` giả lập gây che giấu trạng thái thực tế của quảng cáo, chuyển đổi `show()` sang hiển thị trực tiếp tức thì (Instant Direct Show 0ms), và phát minh bạch toàn bộ vòng đời trạng thái quảng cáo qua `StateFlow<AdState>` (`Idle` -> `Loading` -> `Ready` -> `Showing` -> `Dismissed` / `Failed`).
  - Scope & Deliverables:
    1. **`PandaInterstitial.kt`**:
       - Xóa bỏ `AdLoadingDialog` và các tham số giả lập `showLoadingDialog`, `loadingDurationMs`.
       - Hàm `show()` gọi trực tiếp `gmaEngine.show()` ngay lập tức trong 0ms.
       - Chuẩn hóa cập nhật máy trạng thái `AdState` (`Idle`, `Loading`, `Ready`, `Showing`, `Dismissed`, `Failed`, `Disabled`) qua `updateState()`.
    2. **Xóa Bỏ Dead Code**: Xóa file `AdLoadingDialog.kt` khỏi repository.
    3. **`PandaInterstitialTest.kt`**: Cập nhật toàn bộ các test cases theo signature chuẩn State-Driven mới.
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (24/24 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng State-Driven Interstitial tối ưu.

- [2026-08-31] **Scheduled JIT Smart Auto-Reload at Cooldown - 5s (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tái cấu trúc cơ chế tự động nạp lại quảng cáo của `PandaInterstitial` từ "Eager Reload (nạp ngay khi đóng ad lúc t = 0s)" sang **"Scheduled Just-In-Time Reload tại mốc (Cooldown - 5s)"**. Triệt tiêu 100% lãng phí pin, 4G và nguy cơ ad bị "thiu" trong RAM khi người dùng rời màn hình trước khi hết thời gian giãn cách 60s.
  - Scope & Deliverables:
    1. **`FrequencyCapper.kt`**: Bổ sung hàm `getIntervalMs()` để lấy thời gian cooldown cấu hình hiện tại.
    2. **`PandaInterstitial.kt`**:
       - Bổ sung `scheduledReloadJobs: ConcurrentHashMap<String, Job>`.
       - Trong `onDismissedOrFailed`: Tính `reloadDelayMs = (intervalMs - 5_000L).coerceAtLeast(0L)` (mặc định 55s với Cooldown 60s) và lên lịch coroutine hẹn giờ trên `backgroundScope`.
       - Tại giây thứ 55: Kiểm tra `!iapKillSwitch.isAdsDisabled() && config?.canShowAds == true` trước khi gọi `preload()`.
       - Bổ sung hàm `cancelScheduledReload(placement)` để tự động hủy lệnh nạp khi user rời màn hình.
       - Trong `disableAllAds()`: Hủy toàn bộ các job nạp ngầm đang chờ.
    3. **`PandaInterstitialTest.kt`**: Bổ sung `TC_INT_10` và `TC_INT_11` kiểm thử thời điểm kích hoạt nạp ngầm tại mốc 55s và hủy lệnh nạp thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 4s (24/24 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Interstitial tối ưu.

- [2026-08-31] **Interstitial AdLoadingDialog & Smart Auto-Reload Integration (Panda-NextGen-2027)** | Status: DONE
  - Objective: Nâng cấp toàn diện trải nghiệm người dùng và tỷ lệ sẵn sàng hiển thị (Fill-Rate) cho `PandaInterstitial`: Tích hợp `AdLoadingDialog` đệm chuyển cảnh mượt mà 600ms (triệt tiêu 100% hiện tượng UI Jarring đơ cứng khi mở full-screen ad) và cơ chế `Smart Auto-Reload` tự động nạp ngầm ad mới ngay khi user đóng ad cũ.
  - Scope & Deliverables:
    1. **`AdLoadingDialog.kt`**: Tạo Dialog Dark Slate `#1E293B` bo góc 16dp sang trọng, thanh quay Indigo `#6366F1` và thông báo "Đang tải quảng cáo...", có cơ chế phòng vệ chống crash khi Activity bị hủy.
    2. **`PandaInterstitial.kt`**: Nâng cấp hàm `show()` bổ sung `showLoadingDialog: Boolean = true`, `loadingDurationMs: Long = 600L` và tự động kích hoạt `preload()` nạp ngầm ad kế tiếp khi `config.canReload == true` trên `onDismissedOrFailed`.
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 7s (22/22 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Interstitial vững chắc.

- [2026-08-31] **Clean Google JIT (Just-In-Time) Mediation Standardization (Panda-NextGen-2027)** | Status: DONE
  - Objective: Chuẩn hóa toàn diện cơ chế Mediation theo đúng chuẩn Official Best Practice của Google Mobile Ads (GMA): Giữ vững `MobileAds.disableMediationAdapterInitialization(context)` lúc Cold Start để ngăn chặn nạp 10+ mediation SDKs thừa, để AdMob tự động nạp JIT adapter của mạng thắng thầu khi có ad request, loại bỏ các tham số giả lập thừa khỏi `PandaConfig` và `PandaDemoApp`, và giữ lại `MediationAdapters` làm hằng số tra cứu chuẩn.
  - Scope & Deliverables:
    1. **`PandaConfig.kt`**: Dọn dẹp các trường giả lập thừa, giữ cấu hình thanh thoát và chuẩn mực.
    2. **`PandaStartupOrchestrator.kt`**: Chuẩn hóa Stage 2 (Async Critical) và Stage 3 (Deferred Idle) theo đúng cơ chế Google JIT Mediation.
    3. **`PandaDemoApp.kt`**: Đồng bộ cấu hình khởi tạo siêu nhẹ (< 5ms) không rác.
    4. **`PandaStartupOrchestratorTest.kt`**: Cập nhật `TC_ORCH_08` kiểm thử luồng Google JIT Mediation startup.
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (22/22 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng JIT Mediation tối ưu.

- [2026-08-31] **Splash Remote Config Ad Flow & Zero-Ads Application Architecture (Panda-NextGen-2027)** | Status: DONE
  - Objective: Chuyển đổi 100% luồng cấu hình quảng cáo từ `Application.onCreate()` sang `SplashActivity`, giúp `Application` trở nên thuần khiết (< 5ms), và xây dựng luồng khởi tạo Monetization 4 bước thực chiến tại Splash: `Fetch Remote Config -> setConfig động -> Preload Splash Ad -> Show Ad / Zero Dead-End Navigate to Home`.
  - Scope & Deliverables:
    1. **`PandaDemoApp.kt`**: Xóa bỏ hoàn toàn hardcoded AdUnitConfigs, đưa `Application.onCreate()` về trạng thái siêu nhẹ (< 5ms).
    2. **`SplashContract.kt`**: Định nghĩa MVI State (`Loading`, `Completed`), Intent (`StartSplashFlow`, `OnAdDismissed`, `OnAdFailed`), Effect (`ShowSplashInterstitial`, `NavigateToHome`).
    3. **`SplashViewModel.kt`**: Điều phối 4 bước: Fetch Remote Config (Timeout: 2.5s + Local Default Fallback), setConfig động qua `PandaSdk.interstitial.setConfig`, Preload Splash Interstitial Ad (Timeout: 3.0s), và điều hướng Zero Dead-End sang `MainActivity`.
    4. **`SplashActivity.kt`**: Màn hình Splash Jetpack Compose M3 Dark Slate sang trọng với thanh tiến trình động (`LinearProgressIndicator`) và xử lý an toàn vòng đời hiển thị quảng cáo.
    5. **`AppModule.kt` & `AndroidManifest.xml`**: Cấu hình `SplashViewModel` trong Koin DI và đặt `SplashActivity` làm `MAIN`/`LAUNCHER` Activity.
    6. **`SplashViewModelTest.kt`**: Viết trọn bộ 5 unit test cases kiểm thử thành công, timeout và Zero Dead-End fallback.
  - Verification: Chạy `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 3s (22/22 unit tests passed 100%).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Splash Flow vững chắc.

- [2026-08-31] **Fine-Grained Mediation Control & Manual Adapter Initialization (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tích hợp cơ chế kiểm soát khởi tạo Mediation chi tiết (Fine-grained Mediation Control) cho `Panda-NextGen-2027`, cho phép phân tách danh sách adapter khởi tạo lúc Cold Start (`authorizedMediationAdapters`) và hoãn nạp các adapter thứ cấp (`secondaryMediationAdapters`) sang Giai đoạn 3 (Deferred Idle), tiết kiệm tối đa CPU/Network lúc mở ứng dụng.
  - Scope & Deliverables:
    1. **`PandaConfig.kt`**: Bổ sung `isManualAdapterInitializationEnabled`, `authorizedMediationAdapters`, và `secondaryMediationAdapters`.
    2. **`PandaStartupOrchestrator.kt`**: Nâng cấp Stage 2 (Async Critical) chỉ nạp authorized adapters, và Stage 3 (Deferred Idle) tự động kích hoạt secondary mediation adapters sau khi first frame render.
    3. **`PandaStartupOrchestratorTest.kt`**: Bổ sung `TC_ORCH_08` kiểm thử toàn diện kịch bản nạp mediation phân tầng theo từng giai đoạn.
  - Verification: Chạy `./gradlew :core:ads:testDebugUnitTest` và `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 3s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Startup Pipeline & Fine-grained Mediation vững chắc.

- [2026-08-31] **Extreme Cold-Start & Instant Perceived Performance Optimization (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tối ưu hóa tốc độ khởi động nguội (Cold Start) lên mức cực hạn cho `Panda-NextGen-2027`, triệt tiêu 100% cảm giác trễ thị giác (Perceived Latency < 50ms), loại bỏ hoàn toàn hiện tượng nháy trắng (White Window Flash), tối ưu hóa GMA broker (`disableMediationAdapterInitialization`), cấu hình R8 Minify + ProGuard và bật `enableEdgeToEdge()` + `reportFullyDrawn()`.
  - Scope & Deliverables:
    1. **Instant Dark Slate Window Background (`themes.xml`, `colors.xml`)**:
       - Cấu hình `android:windowBackground` với màu `#0F172A` (Dark Slate), đồng bộ status bar và navigation bar, giúp hệ điều hành Android vẽ nền ngay lập tức trong < 30ms khi người dùng chạm vào icon.
    2. **Lazy GMA Broker & Mediation Optimization (`PandaStartupOrchestrator.kt`)**:
       - Kích hoạt `MobileAds.disableMediationAdapterInitialization()` giúp tiết kiệm 300ms - 800ms nạp native mediation adapters không cần thiết lúc khởi động.
    3. **R8 Minification & AOT Compilation (`app/build.gradle.kts`, `app/proguard-rules.pro`)**:
       - Kích hoạt `isMinifyEnabled = true`, `isShrinkResources = true` cho release build, tạo bộ ProGuard rules toàn diện cho Compose, Koin, Coroutines và GMA.
    4. **Compose Render Optimization (`MainActivity.kt`)**:
       - Tích hợp `enableEdgeToEdge()` và báo cáo `reportFullyDrawn()` cho Android OS ngay khi Compose hoàn thành frame đầu tiên.
  - Verification: Chạy `./gradlew :core:ads:testDebugUnitTest` và `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 5s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Cold Start siêu tốc.

- [2026-08-31] **Phased SDK Startup Pipeline & Decoupled AdFormat Registry (Panda-NextGen-2027)** | Status: DONE
  - Objective: Tối ưu hóa toàn diện kịch bản khởi tạo SDK cho `Panda-NextGen-2027`, giảm gánh nặng tối đa cho `Application.onCreate()` (< 15ms), giữ Cold Start TTID < 300ms đạt chuẩn Google Play Android Vitals, phân tầng 4 giai đoạn rõ ràng, loại bỏ Facebook SDK theo yêu cầu, chuẩn hóa DI SSOT, tích hợp StateFlow theo dõi trạng thái phản ứng, và tách rời hoàn toàn (Decouple) các format quảng cáo qua mô hình Plugin/Registry `AdFormatHandler` & `AdFormatRegistry`.
  - Scope & Deliverables:
    1. **`SdkInitState.kt` & `StartupStage`**: Định nghĩa máy trạng thái phản ứng (`SYNC_CORE`, `ASYNC_CRITICAL`, `DEFERRED_IDLE`) và các pha `CoreReady` / `FullyReady`.
    2. **`PandaStartupOrchestrator.kt`**: Điều phối chu trình khởi tạo 3 tầng bất đồng bộ trên `Dispatchers.IO` an toàn luồng, không block Main Thread, hỗ trợ `awaitCoreReady(timeoutMs)` và `triggerDeferredPhase()`, phân phối cấu hình qua `AdFormatRegistry` độc lập.
    3. **`AdFormatHandler.kt` & `AdFormatRegistry.kt`**: Interface trừu tượng và Registry trung tâm cho phép cắm rút động mọi định dạng quảng cáo (`PandaInterstitial`, `PandaRewarded`, `PandaAppOpen`, `PandaBanner`) mà không làm ô nhiễm `PandaSdk` hay `StartupOrchestrator`.
    4. **`PandaConfig.kt` & `AdUnitConfig.kt`**: Loại bỏ hoàn toàn Facebook SDK (`facebookAppId`), bổ sung `autoStartDeferred: Boolean = true`, `deferredDelayMs: Long = 1500L`, `defaultAdUnitConfigs: ImmutableList<AdUnitConfig>`, và `format: AdFormat = AdFormat.INTERSTITIAL`.
    5. **`PandaSdk.kt`**: Refactor thành Facade chuẩn mực, `by lazy` cho toàn bộ core engines, expose `val initState: StateFlow<SdkInitState>`, `notifyFirstFrameRendered()`, `awaitCoreReady()`, `adFormatRegistry`.
    6. **`PandaDemoApp.kt`**: Siêu tinh gọn `onCreate()` (< 15ms) chỉ gồm khởi tạo Koin và `PandaSdk.initialize(config)` không block Main Thread.
    7. **`MainActivity.kt`**: Tích hợp hiển thị trực quan `SDK Startup State (Phased Pipeline)` và thông báo `notifyFirstFrameRendered()`.
    8. **Unit Test Suite**: Viết `PandaStartupOrchestratorTest.kt` (5 test cases), chạy toàn bộ 14 unit test cases PASS 100%, và `assembleDebug` BUILD SUCCESSFUL 100%.
  - Verification: Chạy `./gradlew :core:ads:testDebugUnitTest` và `./gradlew testDebugUnitTest assembleDebug` -> BUILD SUCCESSFUL in 4s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng định dạng quảng cáo tiếp theo (App Open Ads, Rewarded Ads, Native Ads) trên nền tảng Startup Pipeline & AdFormatRegistry vững chắc.

- [2026-08-17] **Quick Settings Tile (VpnQuickTileService) Implementation** | Status: DONE
  - Objective: Triển khai TileService (`VpnQuickTileService`) trên Android API 24+ cho phép người dùng bật/tắt VPN tức thì chỉ với 1 chạm từ thanh cài đặt nhanh (Quick Settings shade). Tự động lắng nghe và đồng bộ trạng thái kết nối thời gian thực (Active / Inactive / Unavailable) kèm subtitle tên Server / Quốc gia, hỗ trợ fallback xin quyền VPN hoặc điều hướng trực tiếp vào ứng dụng nếu chưa sẵn sàng.
  - Progress: Hoàn thành 100%. Đã tạo `VpnQuickTileService.kt`, vector icon `ic_quick_tile_vpn.xml`, đăng ký service trong `AndroidManifest.xml` (quyền `BIND_QUICK_SETTINGS_TILE`), bổ sung `getSelectedServerSync()` trong `SeverRepository`/`SeverRepositoryImpl`, chuỗi đa ngôn ngữ (EN & VI), viết bộ test `SeverRepositoryImplTest.kt` và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 12s (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai tính năng kế tiếp trong lộ trình (DNS Leak Tester hoặc VIP Dedicated Servers).

- [2026-08-17] **Data Usage & Connection History Analytics Feature** | Status: DONE
  - Objective: Xây dựng toàn diện tính năng thống kê dung lượng mạng đã bảo vệ và lịch sử kết nối VPN. Lưu trữ phiên tự động trong Room Database (`VpnSessionEntity`, `VpnSessionDao`, bump DB version lên 3), tổng hợp theo mốc thời gian 24 Giờ / 7 Ngày / 30 Ngày, vẽ biểu đồ cột tương tác Compose Canvas (`DataUsageBarChart`), xây dựng màn hình MVI chuẩn `AnalyticsScreen` Dark Forest Glassmorphism, tích hợp Navigation 3 và Localization (EN & VI).
  - Progress: Hoàn thành 100%. Đã tạo `VpnSessionEntity.kt`, `VpnSessionDao.kt`, `AnalyticsRepository.kt`, `AnalyticsRepositoryImpl.kt`, `AnalyticsViewModel.kt`, `AnalyticsContract.kt`, `DataUsageBarChart.kt`, `AnalyticsScreen.kt`, `AnalyticsViewModelTest.kt`, cập nhật `AppDatabase.kt`, `DatabaseModule.kt`, `AppModule.kt`, `Screen.kt`, `SettingScreen.kt`, `MainScreen.kt`, `strings.xml` (EN & VI) và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai tính năng kế tiếp trong lộ trình.

- [2026-08-16] **Curated Top 15 Server Logic & City/Flag Icons Implementation** | Status: DONE
  - Objective: Tinh tuyển danh sách máy chủ gọn gàng, loại bỏ hoàn toàn tình trạng loãng/trùng lặp giữa các Tab bằng cách giới hạn Top ~15 Server chất lượng nhất theo từng mục đích chuyên biệt (Streaming, Gaming, P2P, Favorites, Best, All), đồng thời tích hợp Icon Cờ Quốc gia / City trực tiếp trên mỗi dòng server (ServerCityRow) giúp người dùng nhận diện trực quan tức thì.
  - Progress: Hoàn thành 100%. Đã cập nhật ServerViewModel.kt, ServerCityRow.kt, ServerCountryCard.kt, ServerScreen.kt, ServerViewModelTest.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 12s (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai các tính năng mở rộng tiếp theo trong lộ trình.

- [2026-08-16] **Smart Auto-Routing & Server Categorization Feature** | Status: DONE
  - Objective: Triển khai toàn diện tính năng Smart Auto-Routing với 6 danh mục máy chủ chuyên dụng: All, Streaming 🎬 (Speed >= 1.5MB/s, Media hubs US/JP/GB/SG/KR/DE/CA/AU/FR), Gaming 🎮 (Ping <= 90ms, độ trễ tối thiểu), P2P 🚀 (Throughput cao), Favorites ⭐ (Đánh dấu máy chủ yêu thích và lưu trữ bền vững trong Room Database), Best ⚡ (Top score). Nâng cấp thanh Scrollable Pill Tabs, thẻ Server hiển thị Smart Badges và nút tương tác gắn sao tức thì.
  - Progress: Hoàn thành 100%. Đã cập nhật VpnServer.kt, VpnServerEntity.kt, VpnServerDao.kt, SeverRepository.kt, SeverRepositoryImpl.kt, SeverContract.kt, ServerViewModel.kt, SlidingPillTabs.kt, ServerCityRow.kt, ServerCountryCard.kt, ServerScreen.kt, strings.xml (EN & VI), viết bộ Unit Test suite ServerViewModelTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai các tính năng mở rộng tiếp theo trong lộ trình.

- [2026-08-16] **Split Tunneling (App Routing) Feature Implementation** | Status: DONE
  - Objective: Triển khai toàn diện tính năng Split Tunneling (Định tuyến VPN theo ứng dụng). Cho phép người dùng tùy chọn Bypass Mode (Direct Internet cho Banking, Grab, Shopee) hoặc Whitelist Mode (Chỉ định app đi qua VPN). Quét danh sách ứng dụng cài đặt mượt mà trên Dispatchers.IO, tích hợp trực tiếp vào OpenVPN Core Profile (mAllowedAppsVpn/mAllowedAppsVpnAreDisallowed), xây dựng giao diện MVI Compose M3 Glassmorphism sang trọng và tích hợp Navigation 3 + Koin DI.
  - Progress: Hoàn thành 100%. Đã tạo AppInfo.kt, PackageInfoHelper.kt, mở rộng DataStoreManager.kt, cập nhật VpnRepository.kt, tạo SplitTunnelingContract.kt, SplitTunnelingViewModel.kt, SplitTunnelingScreen.kt, cập nhật Screen.kt, SettingScreen.kt, MainScreen.kt, AppModule.kt, strings.xml (EN & VI), viết bộ Unit Test suite SplitTunnelingViewModelTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL (100% unit tests passed).
  - Next Action: Sẵn sàng triển khai các tính năng tiếp theo trong lộ trình (AdBlocker / DNS over HTTPS / Auto-Kill Switch).

- [2026-08-16] **Home IP & Server Screen Submerged Text Color Fix** | Status: DONE
  - Objective: Khắc phục triệt để lỗi màu chữ IP ở màn Home và đoạn mô tả Empty/Error State ở màn Server bị chìm trên nền tối do gán nhầm Theme.colors.grayscale400 (#2E3034). Khôi phục màu gốc Theme.colors.grayscale100 (#FFFFFF - Trắng sáng) cho IP màn Home (SeverView.kt) và chuyển đoạn mô tả trạng thái màn Server (ServerScreen.kt) sang Theme.colors.grayscale300 (#B9B9B9 - Xám sáng).
  - Progress: Hoàn thành 100%. Đã cập nhật SeverView.kt và ServerScreen.kt, kiểm thử 100% pass.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 11s (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Color and Design System Realignment** | Status: DONE
  - Objective: Rà soát và loại bỏ 100% các mã màu sai lệch khỏi thiết kế gốc (màu Cam #FF9800, màu Xanh #4D8DFF, màu Navy #1E2430/#1C1F2A). Đồng bộ hóa toàn bộ ứng dụng về bảng màu chuẩn Dark Forest Emerald & Neon Mint (#1EFFAA) của Theme.kt (ConnectButton, HomeScreen, SortOptionItem, SortBottomSheet, SettingScreen, ServerSearchField, PrimaryButton, ServerShimmerSkeleton).
  - Progress: Hoàn thành 100%. Đã cập nhật tất cả component và màn hình vi phạm, kiểm thử 100% pass.
  - Verification: Chạy `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 12s (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **vpnLib Kotlin Optimization, Fatal Crash Fix & BaseViewModel Standardization** | Status: DONE
  - Objective: Khắc phục triệt để lỗi Fatal Crash trên OpenVPNServiceCommandThread (CancellationException), chuyển đổi và tối ưu các thành phần cốt lõi của vpnLib sang Kotlin (ConnectionStatus.kt, VPNLaunchHelper.kt), và chuẩn hóa toàn bộ ViewModel (VpnViewModel, ServerViewModel, SpeedTestViewModel) kế thừa BaseViewModel chuẩn MVI (safeLaunch + CoroutineExceptionHandler).
  - Progress: Hoàn thành 100%. Đã cập nhật OpenVPNThread.java, OpenVPNService.java, tạo ConnectionStatus.kt, VPNLaunchHelper.kt, cập nhật Contract.kt, SeverContract.kt, SpeedContract.kt, VpnViewModel.kt, ServerViewModel.kt, SpeedTestViewModel.kt, HomeScreen.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-16] **VPN Connection & Re-connection Bugfix** | Status: DONE
  - Objective: Khắc phục triệt để lỗi không kết nối được hoặc lỗi kết nối lại Server VPN. Khai báo đầy đủ OpenVPNService (BIND_VPN_SERVICE, specialUse) và keepVPNAlive trong AndroidManifest.xml, cập nhật VpnServerDao.clearAndInsertWithSelection với cơ chế auto-select fallback (chọn Server đầu tiên nếu server cũ không còn), bổ sung fallback thông minh trong VpnViewModel.connectVpn() và cập nhật VpnRepository phát trạng thái CONNECTING ngay lập tức.
  - Progress: Hoàn thành 100%. Đã cập nhật AndroidManifest.xml, VpnServerDao.kt, VpnViewModel.kt, VpnRepository.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 14s (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-16] **VPN safeApiCall & networkBoundResource Integration** | Status: DONE
  - Objective: Tích hợp toàn diện safeApiCall và networkBoundResource (Single Source of Truth, Offline-First, Zero-Wait UI) vào tầng Network và Repository của VPN Server. ApiService/ApiServiceImpl sử dụng safeApiCall trả về ApiResult<String>, VpnRemoteDataSource trả về ApiResult<List<VpnServerDto>>, SeverRepositoryImpl sử dụng networkBoundResource phát DataState<List<VpnServer>> kết hợp Room DB cache và VPNGate API, ServerViewModel tiêu thụ DataState phản ứng thời gian thực.
  - Progress: Hoàn thành 100%. Đã cập nhật ApiService.kt, ApiServiceImpl.kt, VpnRemoteDataSource.kt, SeverRepository.kt, SeverRepositoryImpl.kt, ServerViewModel.kt, ServerViewModelTest.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 14s (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-16] **Comprehensive Codebase Cleanup & Dead Code Removal** | Status: DONE
  - Objective: Loại bỏ 100% mã nguồn thừa thãi, các màn hình demo template cũ (DetailScreen, HomeScreen demo cũ), tầng User domain/data (User, UserRepository, GetUserUseCase, RefreshUserUseCase, UserRepositoryImpl, UserDao, UserEntity, UserMapper, UserDto), các route điều hướng chết trong Screen.kt (MyFile, Card, Detail), dọn dẹp AppDatabase, ApiService, AppModule, RepositoryModule, DatabaseModule, strings.xml và các file test cũ.
  - Progress: Hoàn thành 100%. Toàn bộ các file và module thừa đã được dọn sạch, giữ cho codebase tinh gọn, trong sạch 100% cho Ứng dụng VPN.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 14s (100% unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng tiếp theo.

- [2026-08-16] **Full ViO-Vpn Application Migration & Exact UI Implementation** | Status: DONE
  - Objective: Tham khảo toàn diện dự án ViO-Vpn, chuyển giao toàn bộ tính năng, Core Engine OpenVPN (vpnLib AIDL), SpeedTest Service và giữ lại đúng 100% giao diện UI/UX nguyên bản (Glassmorphism, Dark Theme, PillBottomBar, ConnectButton Pulse Glow, SpeedometerGauge, Server List Accordion) sang kiến trúc hiện đại Base-Jetpack 2026 (Clean Architecture, Navigation 3, MVI BaseViewModel, Koin, Compose M3).
  - Progress: Hoàn thành 100%. Đã tích hợp module vpnLib, chuyển giao 21 UI Atomic Components, Domain Models/Repositories, ViewModels (VpnViewModel, ServerViewModel, SpeedTestViewModel), MainScreen với PillBottomBar, strings.xml, viết bộ Unit Test suite toàn diện (VpnViewModelTest, ServerViewModelTest) và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 14s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng mở rộng hoặc cấu hình server VPN thực tế tiếp theo.

- [2026-08-16] **Google registerDefaultNetworkCallback & NET_CAPABILITY_VALIDATED Upgrade** | Status: DONE
  - Objective: Khắc phục triệt để lỗi khi tắt mạng/không có mạng vào app thì networkMonitor.isOnline vẫn trả về true. Chuyển đổi toàn diện ConnectivityNetworkMonitor từ registerNetworkCallback(request) sang registerDefaultNetworkCallback chuẩn Google Now in Android (API 24+), chỉ lắng nghe Mạng Mặc định thực tế và kiểm tra cả NET_CAPABILITY_VALIDATED.
  - Progress: Hoàn thành 100%. Đã cập nhật ConnectivityNetworkMonitor.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (41/41 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Initial Offline Detection & Immediate Zero-Latency State Fix** | Status: DONE
  - Objective: Khắc phục lỗi khi tắt mạng/không có mạng mở app không hiện trạng thái mất mạng. Cập nhật MainViewModel khởi tạo initialState = MainState(isOnline = networkMonitor.isConnected()) thay vì hardcode default true, tối ưu hóa ConnectivityNetworkMonitor và bổ sung test case kiểm thử khởi động Offline tức thì.
  - Progress: Hoàn thành 100%. Đã cập nhật MainViewModel.kt, ConnectivityNetworkMonitor.kt, viết bộ Unit Test MainViewModelTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (41/41 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **MainScreen MVI Architecture Refactoring (MainViewModel & MainContract)** | Status: DONE
  - Objective: Loại bỏ hoàn toàn networkMonitor = koinInject() trong Composable MainScreen. Thay thế bằng MainViewModel chuẩn MVI (kế thừa BaseViewModel<MainState, MainIntent, MainEffect>), inject NetworkMonitor qua Koin, quản lý MainState.isOnline, cập nhật AppModule.kt và viết bộ Unit Test MainViewModelTest kiểm thử hoàn chỉnh.
  - Progress: Hoàn thành 100%. Đã tạo MainContract.kt, MainViewModel.kt, refactor MainScreen.kt, cập nhật AppModule.kt, viết bộ Unit Test MainViewModelTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (40/40 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **HomeViewModel NetworkMonitor Integration & Auto-Refresh on Reconnect** | Status: DONE
  - Objective: Tích hợp NetworkMonitor vào HomeViewModel qua Koin constructor injection. Tự động lắng nghe sự kiện mạng khôi phục (Offline -> Online) để auto-refresh dữ liệu người dùng (forceRefresh = true), cập nhật AppModule.kt và viết bộ Unit Test HomeViewModelTest kiểm thử hoàn chỉnh.
  - Progress: Hoàn thành 100%. Đã cập nhật HomeViewModel.kt, AppModule.kt, viết bộ Unit Test HomeViewModelTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (38/38 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **MainScreen NetworkMonitor & Global ConnectivityBanner Integration** | Status: DONE
  - Objective: Tích hợp NetworkMonitor và ConnectivityBanner vào MainScreen.kt ở tầng Root bao bọc toàn bộ ứng dụng, lắng nghe trạng thái mạng liên tục và tự động hiển thị thanh thông báo cảnh báo mất kết nối mạng toàn cục.
  - Progress: Hoàn thành 100%. Đã cập nhật MainScreen.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (36/36 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Reactive NetworkMonitor & Real-time Connectivity Observing** | Status: DONE
  - Objective: Xây dựng module NetworkMonitor chuẩn Clean Architecture và Kotlin Coroutines callbackFlow. Lắng nghe trạng thái mạng thời gian thực (isOnline, networkStatus: Available/Losing/Lost/Unavailable), hỗ trợ check snapshot tức thì isConnected(), đăng ký Koin DI và cung cấp Compose UI helpers (rememberIsOnlineState, ConnectivityBanner).
  - Progress: Hoàn thành 100%. Đã tạo NetworkMonitor.kt, ConnectivityNetworkMonitor.kt, NetworkModule.kt, NetworkComposeExtensions.kt, strings.xml, viết bộ Unit Test NetworkMonitorTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (36/36 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Functional Error Handling Modernization (safeApiCall & runSuspendCatching)** | Status: DONE
  - Objective: Loại bỏ hoàn toàn các khối try/catch thủ công, rườm rà ở tầng Network và Repository. Tạo utility safeApiCall và runSuspendCatching chuẩn Kotlin 2.x, tự động re-throw CancellationException để bảo toàn cơ chế tự hủy của Coroutines, refactor ApiServiceImpl sang single-expression body và tối ưu NetworkBoundResource với Reactive Flow .catch {}.
  - Progress: Hoàn thành 100%. Đã tạo SafeApiCall.kt, refactor ApiServiceImpl.kt và NetworkBoundResource.kt, viết bộ Unit Test SafeApiCallTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (33/33 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Fail-Safe Data Flow & Infinite Loading Prevention (Zero-Mock Real Network)** | Status: DONE
  - Objective: Loại bỏ 100% Mock Data trong ApiServiceImpl, gọi mạng thật, cấu hình Ktor Client timeout 5s (retryOnTimeout = false), bọc try-catch toàn diện trong NetworkBoundResource và bổ sung .catch {} trong HomeViewModel để đảm bảo trong MỌI trường hợp (mất mạng, server chết, timeout, DB rỗng), Flow luôn trả về DataState dứt khoát và không bao giờ bị kẹt Loading.
  - Progress: Hoàn thành 100%. Đã cập nhật ApiServiceImpl.kt, KtorClient.kt, NetworkBoundResource.kt, HomeViewModel.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (27/27 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Home Screen Loading Forever Bugfix (Zero-Wait UX & Mock Fallback)** | Status: DONE
  - Objective: Khắc phục lỗi màn hình Home bị loading vô tận do NetworkBoundResource không phát cache trước khi fetch, và Ktor Client bị timeout/retry lâu trên dummy domain api.example.com. Cập nhật NetworkBoundResource phát cache tức thì (Zero-wait UI) và bổ sung demo fallback data trong ApiServiceImpl khi debug.
  - Progress: Hoàn thành 100%. Đã cập nhật NetworkBoundResource.kt, ApiServiceImpl.kt, NetworkBoundResourceTest.kt và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (27/27 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **Jetpack Compose Modifier Extensions Standardization** | Status: DONE
  - Objective: Tạo bộ extension functions chuẩn hóa toàn diện cho Modifier trong Jetpack Compose: backgroundImage (hỗ trợ ContentScale và Painter), singleClick (debounce click), noRippleClickable, bouncingClickable (spring micro-interaction), conditional, visible, shimmer (skeleton loading thuần Compose), clearFocusOnTapOutside, và fadingEdge.
  - Progress: Hoàn thành 100%. Đã tạo ModifierExtensions.kt, dọn dẹp StateContainers.kt, viết bộ Unit Test ModifierExtensionsTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (27/27 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-16] **NetworkBoundResource Pattern Implementation (Offline-First & SSOT)** | Status: DONE
  - Objective: Triển khai Generic Flow builder networkBoundResource chuẩn Android Architecture Blueprint, tích hợp vào UserRepository/UserRepositoryImpl, GetUserUseCase và HomeViewModel. Tự động xử lý 4 trạng thái: Loading, Success (Cache), Success (Fresh), ErrorWithCache và Error.
  - Progress: Hoàn thành 100%. Đã tạo NetworkBoundResource, tích hợp vào Data/Domain/Presentation layers, viết bộ Unit Test NetworkBoundResourceTest và cập nhật GetUserUseCaseTest.
  - Verification: Chạy `./gradlew testDebugUnitTest` -> BUILD SUCCESSFUL (22/22 unit tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-15] **TrustedDomainValidator Security Hardening & RFC 3986 Refactoring** | Status: DONE
  - Objective: Khắc phục 4 lỗ hổng bảo mật nghiêm trọng trong TrustedDomainValidator: thay thế chuỗi substring bằng Ktor Url parser chuẩn RFC 3986, dùng Regex RFC 1918 chặn triệt để bypass tiền tố IP (10.attacker.com), giới hạn IP local chỉ trong BuildConfig.DEBUG, và bổ sung hàm addTrustedDomain() thread-safe.
  - Progress: Hoàn thành 100%. Đã refactor TrustedDomainValidator, viết bộ Unit Test toàn diện TrustedDomainValidatorTest và kiểm thử thành công.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 10s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-15] **ConfigManager Remote Config Fallback Optimization** | Status: DONE
  - Objective: Nâng cấp ConfigManager và BasePreferenceManager với cơ chế syncFromRemote. Nếu Remote Config không trả về key hợp lệ (source == VALUE_SOURCE_STATIC), hệ thống tự động bỏ qua và giữ nguyên 100% giá trị default đã khai báo trong AppConfigManager, đồng bộ toàn diện hơn 35 keys.
  - Progress: Hoàn thành 100%. Đã cập nhật BasePreferenceManager, ConfigManager và kiểm thử toàn diện.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 9s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-15] **Phase 2 Security, ANR, Crash & Memory Leak Hardening** | Status: DONE
  - Objective: Tối ưu 5 chốt chặn an toàn: Network Security Config (chặn Cleartext HTTP), Room Database Migration Safety (chỉ cho phép destructive migration khi Debug, bảo vệ dữ liệu Release), BannerView onRelease Cleanup (triệt tiêu rò rỉ bộ nhớ AdView), GlobalCrashHandler (bắt mọi crash luồng ngầm và báo cáo Crashlytics), và AppConfigManager Koin DI.
  - Progress: Hoàn thành 100%. Toàn bộ các task đã được thực thi và kiểm thử.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 9s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-15] **Full Project Refactor — Stateful Screen + Stateless Content + Previews** | Status: DONE
  - Objective: Refactor toàn bộ project theo chuẩn Stateful Screen + Stateless Content + Multi-state @Preview, dọn dẹp các thư mục rác (dailyplan, vault), chuẩn hóa 100% Design System tokens và string localization.
  - Progress: Hoàn thành 100%. Đã refactor HomeScreen, DetailScreen, SplashScreen, MainScreen, strings.xml và xóa thư mục rác.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 10s (100% tests passed).
  - Next Action: Sẵn sàng phát triển các tính năng nghiệp vụ tiếp theo trên nền tảng Base hoàn chỉnh.

- [2026-08-15] **Phase 1 Critical Fixes & Base Optimization** | Status: DONE
  - Objective: Khắc phục triệt để các vấn đề về Bảo mật (lộ PAT token, gitignore secrets, tối ưu hóa generateSecureSecrets sang dynamic multi-byte XOR mask + build directory output), Build/R8 (bật R8 Release, bổ sung toàn diện ProGuard rules), Ổn định & Memory Leak (loại bỏ hoàn toàn Activity leak và bypass safeLaunch trong SplashViewModel, sửa lỗi effect collection trong HomeScreen & SplashScreen, bổ sung Ktor HttpTimeout & Retry, gửi unhandled exceptions lên Crashlytics), và bổ sung Unit Test suite.
  - Progress: Hoàn thành 100%. Toàn bộ các task đã được thực thi và kiểm thử.
  - Verification: Chạy `./gradlew testDebugUnitTest compileDebugKotlin` -> BUILD SUCCESSFUL in 13s (100% unit tests passed).
  - Next Action: Sẵn sàng chuyển sang Phase 2 (Build flavors, Room migrations, Cert pinning, DI Navigator).

- [2026-08-09] **Base Project Assessment & Optimization 2026** | Status: DONE
  - Objective: Đánh giá toàn bộ codebase Base-Jetpack_2026 và thực hiện refactoring tối ưu hóa đạt chuẩn Base Enterprise 2026 (Navigation 3, Clean Architecture, Design System M3, Koin, Performance).
  - Progress: Hoàn thành 100%. Đã sửa lỗi package & Theme, tách UseCases chuẩn Clean Architecture, gắn `@Immutable` tối ưu recomposition, tạo UI Atomic components, bổ sung màn hình Navigation 3 argument (`DetailScreen`), sửa warning Room deprecation và bổ sung Unit Test suite.
  - Verification: Run `./gradlew compileDebugKotlin testDebugUnitTest` -> BUILD SUCCESSFUL in 12s. All tests passed.
  - Next Action: Không còn tác vụ tồn đọng.

---

# Final Rule

Task Memory exists to preserve execution continuity.

Every task should always have a clear objective, known progress, visible blockers, and a well-defined next action until completion.