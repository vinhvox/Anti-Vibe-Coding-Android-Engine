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
| **"UI giật lag, drop FPS khi scroll danh sách"** | `stack-heap-memory` | `rules/26-stack-vs-heap-memory-management.md`<br>`Gate E19 (Memory & Allocation)` | Kiểm tra allocation trong `@Composable` lambda, thêm `key = { it.id }` và `contentType`, chuyển lambda inline thành method reference memoized. |
| **"Mất dữ liệu khi xoay màn hình hoặc app bị kill ngầm"** | `mobile-engineering-core` | `rules/07-viewmodel.md`<br>`Domain 1 (Lifecycle & State)` | Áp dụng 3-Tier State: Hoist toàn bộ mutable input vào `SavedStateHandle` hoặc `rememberSaveable`. |
| **"Xây dựng tính năng mới từ yêu cầu mơ hồ"** | `brainstorming` ➔ `spec-driven-development` | `rules/37-ubiquitous-language-standard.md`<br>`rules/28-spec-driven-development.md` | Thực hiện Grilling session (`/grill-me`), tạo `docs/CONTEXT.md` (Ubiquitous Language), rồi lập Tri-Artifact (`spec.md`, `plan.md`, `tasks.md`). |
| **"Chia nhỏ task lập trình thế nào để không bị bug tích hợp?"** | `writing-plans` | `skills/writing-plans`<br>`Tracer-Bullet Vertical Slicing` | Cấm chia tầng ngang (DAO ➔ Repo ➔ UI). Bắt buộc chia lát cắt dọc mỏng (Tracer Bullets) từ Data đến UI cho từng luồng người dùng. |
| **"Giao diện trông thô cứng, phẳng lì, giống AI code"** | `ui-ux-pro-max` | `rules/36-ui-ux-design-standard.md`<br>`Gate E27 (Anti-AI-Design-Cliché)` | Áp dụng Subtle Border 0.5dp, Tonal Surface hierarchy, 8-Point Grid rhythm, và Typography 3 tầng. Cấm purple-on-dark và neon border. |
| **"Gặp bug khó hiểu, race condition, hoặc coroutine crash"** | `systematic-debugging` | `rules/12-error-handling.md`<br>`Domain 10 (Concurrency & Flow)` | Dừng đoán mò. Thực hiện cô lập nguyên nhân gốc rễ (Root Cause), viết test tái hiện trước khi sửa (Red-Green loop). |
| **"Thiết kế Offline-First, Cache Room & Ktor"** | `networking-ktor` & `room-database` | `rules/10-networking.md`<br>`rules/11-database.md`<br>`Domain 4 (Networking & SSOT)` | Room là Single Source of Truth (SSOT). Network chỉ đẩy vào DB, UI chỉ observe Flow từ DAO. Dùng Outbox Pattern cho offline mutation. |
| **"Navigation 3: Chuyển màn hình & Scoping ViewModel"** | `navigation-3` & `navigation-3-di` | `rules/08-navigation.md`<br>`Domain 6 (Navigation 3)` | Navigation là trạng thái (`SnapshotStateList<Screen>`). 100% route dùng `@Serializable data class Screen`. ViewModel scoped theo NavEntry. |
| **"Tách module mới, tạo Core Library hoặc SDK"** | `sdk-modular-engineering` | `rules/34-sdk-modular-architecture.md`<br>`Gate E25 (API Surface)` | `internal` by default. Cung cấp `:testing` module với Test Fakes. 0 ContentProvider auto-init, cách ly crash app mẹ. |
| **"Cần kiểm tra chất lượng trước khi đóng PR / Merge"** | `requesting-code-review` | `rules/21-enforcement-engine.md`<br>`Gates E1 — E27` | Chạy toàn bộ 27 cổng kiểm toán chất lượng. Thực thi `./gradlew test assembleDebug` thực tế trước khi claim hoàn thành. |

---

## Usage in Agent Conversations

Whenever you are unsure which skill or rule applies:
1. Announce: `"Invoking ask-cto meta-router to diagnose engineering approach..."`
2. Match the user's situation against the diagnostic matrix above.
3. Invoke the designated Primary Skill and immediately apply its mandatory gates.
