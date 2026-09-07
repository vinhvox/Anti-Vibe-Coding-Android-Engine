# 06-user-preference-memory.md

# User Preference Memory

## Purpose

This document defines how the AI learns, stores, and applies stable user preferences during engineering collaboration.

User Preference Memory captures how the user prefers to work, communicate, and make engineering decisions.

Its purpose is to improve collaboration by adapting to the user's preferred workflow without changing project architecture or engineering correctness.

User preferences should improve the experience, not override engineering quality.

---

# Philosophy

Every engineer works differently.

Some prefer detailed explanations.

Some prefer direct implementation.

Some value performance over simplicity.

The AI should adapt its collaboration style while preserving technical correctness.

Learn preferences.

Respect preferences.

Do not assume preferences.

---

# Primary Goal

Understand and consistently apply the user's long-term collaboration preferences.

Examples include:

Communication style

Review style

Planning depth

Implementation style

Documentation preference

Testing expectations

Refactoring preference

Workflow preference

User Preference Memory should make future collaboration smoother.

---

# Preference Lifecycle

Every preference follows this lifecycle.

```text
Observe
    │
    ▼
Confirm
    │
    ▼
Validate Stability
    │
    ▼
Store
    │
    ▼
Apply
    │
    ▼
Revalidate
```

Only stable preferences should be retained.

---

# What To Store

User Preference Memory may store:

Preferred communication language

Preferred explanation depth

Preferred implementation style

Preferred review format

Preferred documentation format

Preferred commit style

Preferred testing expectations

Preferred code generation style

Preferred debugging workflow

Preferred planning detail

Preferred response structure

Preferred collaboration rhythm

---

# What NOT To Store

Never store:

Temporary requests

One-time instructions

Session-specific preferences

Sensitive personal information

Business secrets

Experimental preferences

Current task requirements

Temporary mood

These belong to Session Memory or should not be stored.

---

# Preference Categories

Communication

Engineering Workflow

Code Style

Review Style

Documentation

Testing

Architecture Discussion

Learning Style

Debugging

Planning

Automation

Reporting

---

# Preference Detection

A preference becomes stable only if:

The user explicitly requests it.

OR

The user consistently repeats it across multiple interactions.

One occurrence is not enough unless the user clearly states it is a permanent preference.

---

# Preference Priority

Apply preferences using this order:

Explicit instruction in current request

↓

Current session instruction

↓

Stored user preference

↓

Project standards

↓

Engineering best practices

Current requests always override stored preferences.

---

# Preference Validation

Before storing verify:

Is it stable?

Will it likely apply in future work?

Does it improve collaboration?

Does it conflict with project rules?

If uncertain,

do not store it.

---

# Preference Application

Apply preferences only when relevant.

Examples:

Use the preferred language.

Match the preferred explanation depth.

Structure responses as preferred.

Generate code according to agreed conventions.

Do not force preferences into unrelated tasks.

---

# Preference Evolution

Users change.

If the user explicitly changes a preference:

Validate.

Update the stored preference.

Deprecate the previous preference.

Never keep conflicting preferences active.

---

# Preference Conflict

If multiple preferences conflict:

Priority order:

Current user request

↓

Current session instruction

↓

Latest validated preference

↓

Default collaboration style

Never ignore an explicit request.

---

# Collaboration Adaptation

The AI should gradually adapt to:

Preferred communication pace

Preferred planning depth

Preferred implementation detail

Preferred review process

Preferred level of explanation

Adaptation should feel natural.

---

# Self Validation

Before applying a preference verify:

Is it still relevant?

Does it conflict with the current request?

Has the user recently changed it?

Is it appropriate for this task?

If not,

do not apply it.

---

# Anti-patterns

Never:

Invent preferences.

Assume one-time requests are permanent.

Store sensitive information without explicit permission.

Override explicit user instructions.

Apply preferences blindly.

Confuse project standards with user preferences.

---

# Active User Preferences

- **World-Class UI/UX Design & Anti-AI-Slop Mandate (QUY TẮC THIẾT KẾ UI/UX ĐẲNG CẤP & XÓA BỎ GIAO DIỆN AI CODE):**
  - **Triệt Tiêu 100% Mô-típ AI Sáo Rỗng (Anti-AI-Design-Clichés):** Tuyệt đối CẤM tạo giao diện có nền tím tối lạm dụng (purple on dark), viền phát sáng neon, badge hình viên thuốc (biscuit pills) nhấp nháy, gradient chữ lòe loẹt, và card lồng card 3-4 tầng ngột ngạt.
  - **Phân Tầng Độ Sâu & Viền Tinh Tế (Visual Depth & Subtle Borders):** Mọi Card/Container bắt buộc có viền mỏng **0.5dp — 1dp** bán trong suốt (`AppTheme.colors.outlineVariant.copy(alpha = 0.5f)`) và phối hợp các lớp Tonal Surface (`surfaceContainerLowest` đến `surfaceContainerHigh`) để tạo chiều sâu quang học sang trọng.
  - **Tỷ Lệ Vàng Typography 3 Tầng:** Tương phản rõ rệt giữa Hero Display (28-34sp Bold, tracking -0.5sp) > Section Title (18-22sp SemiBold) > Body (14-16sp, line-height 1.4x) > Meta (11-12sp onSurfaceVariant).
  - **Nhịp Điệu Lưới 8-Point Grid:** 100% khoảng cách bám theo tokens `4dp`, `8dp`, `16dp`, `24dp`, `32dp`.
  - **Bản Sắc Riêng Theo Ngành Dọc (Domain-Tailored Aesthetics):** Thiết kế đúng bản sắc ngành (Fintech tin cậy, E-Commerce kích thích mua sắm, SaaS tối giản dữ liệu, Media sống động).
  - **Micro-Interactions Tinh Tế:** Bắt buộc có ripple effect mượt mà và shimmer skeleton loading tự nhiên.

- **Automated ProGuard & R8 Rules Synthesis Mandate (QUY TẮC TỰ ĐỘNG QUÉT & SINH PROGUARD/R8 RULES):**
  - **Tự Động Đọc & Phân Tích Codebase 100%:** Khi người dùng yêu cầu cấu hình ProGuard / R8 hoặc chuẩn bị đóng gói Release, AI tự động quét toàn bộ `libs.versions.toml`, `build.gradle.kts`, DTOs, Room Entities, và Navigation 3 Routes trong workspace.
  - **Phân Tách 2 Tầng Rules Chuẩn Mực:**
    1. Tầng Module/SDK: Tự động sinh file `consumer-rules.pro` (tự đóng gói keep rules cho DTOs, Entities, DAOs để App mẹ không phải cấu hình tay).
    2. Tầng App Mẹ: Tự động sinh `proguard-rules.pro` (cấu hình R8 FullMode, Coroutines internals, và strip log trên Release).
  - **Xác Thực Build Release Thực Tế:** Bắt buộc chạy `./gradlew assembleRelease` để chứng minh 0 lỗi missing keep rules trước khi bàn giao.

- **The 7 AI Blind Spots Defense Mandate (QUY TẮC PHÒNG VỆ 7 ĐIỂM MÙ KỸ THUẬT):**
  1. *Lazy Layout Keys*: Bắt buộc chỉ định `key = { it.id }` và `contentType` trong `LazyColumn`/`LazyRow` để triệt tiêu recomposition toàn phần và giật lag danh sách.
  2. *Duplicate Click Lock*: Khóa ngay trạng thái ở ViewModel (`if (state.value.isLoading) return@safeLaunch`) và áp dụng debounce 400ms trên các hành động điều hướng.
  3. *Form State Survival*: Dùng `rememberSaveable` hoặc hoist vào `SavedStateHandle` cho toàn bộ input người dùng để sống sót qua xoay màn hình, đổi theme và Process Death.
  4. *Keyboard Auto-Scroll*: Kết hợp `Modifier.imePadding()` với scroll container và `BringIntoViewRequester` để bàn phím không che mất ô nhập liệu ở đáy màn hình.
  5. *Modern API & Navigation 3 Purity*: 100% dùng Material 3 API gốc và `@Serializable data class Screen` trong Navigation 3 (cấm Accompanist cũ và route chuỗi).
  6. *Localization & Plurals*: 100% dùng `pluralStringResource` và `stringResource` có placeholder, cấm nối chuỗi thủ công `$count items` hay `"$ " + price`.
  7. *Zero-Fluff Direct Communication*: Trình bày trực tiếp, súc tích, chuẩn CTO, không mở đầu bằng văn mẫu sáo rỗng.

- **Self-Documenting Code & Ban on Trivial Comments (QUY TẮC CODE TỰ TƯỜNG MINH & CẤM COMMENT RÁC/NHỎ LẺ):**
  - **Tên Phải Tự Nói Lên Ý Nghĩa (Self-Documenting Naming):** Tên biến, hàm, class, interface bắt buộc phải diễn đạt 100% mục đích và nghiệp vụ (`isUserSubscribed`, `fetchUserProfile`, `calculateDiscountAmount`).
  - **Cấm Comment Nhỏ Lẻ & Hiển Nhiên (Zero Trivial Comments):** Tuyệt đối CẤM các comment hiển nhiên, lặp lại tên hàm/biến (như `// Tải dữ liệu`, `// ID người dùng`, `// Hàm xử lý click`, `// Khởi tạo viewModel`).
  - **Chỉ Comment ở Bài Toán Phức Tạp Thực Sự (Comment for "WHY", Never "WHAT"):**
    - Chỉ được phép viết comment khi giải thích:
      1. Công thức toán học / thuật toán phức tạp.
      2. Workaround bắt buộc cho bug của OS / thư viện ngoài.
      3. Ràng buộc bất biến vi tế về phần cứng hoặc luồng đồng thời (Concurrency edge cases).
    - Mọi comment thừa thãi khác đều bị coi là rác code (Code Clutter) và phải bị xóa bỏ.

- **Zero-Crash, Zero-ANR, Zero-Leak Default Invariant & Anti-Try-Catch-Sprawl Mandate (QUY TẮC AN TOÀN MẶC ĐỊNH & CẤM LẠM DỤNG TRY-CATCH BỪA BÃI):**
  - **Mặc định Hiển nhiên (Default Invariant):** Người dùng KHÔNG CẦN phải nhắc lại câu "Hãy đảm bảo không bị crash, ANR, leak" ở mỗi prompt. Mọi đoạn code do AI viết ra bắt buộc phải đạt chuẩn Zero-Crash, Zero-ANR, Zero-Leak 100% theo mặc định.
  - **Cấm Tuyệt Đối Lạm Dụng Try-Catch (Anti-Defensive Paranoia):** Cấm bọc `try-catch` bừa bãi trong tầng Presentation (Compose UI) hoặc ViewModel/Domain để "chữa cháy" crash.
  - **Error Boundary Đúng Chỗ:** Chỉ đặt Error Handling/Result wrapper tại đúng **I/O Boundary duy nhất** (Network API, Room Database, File I/O, JSON Deserialization) thông qua `AppResult<T>`.
  - **An Toàn Từ Bản Chất Kiến Trúc (Structural Safety):**
    1. *Zero-Crash*: Đảm bảo qua Kotlin Null-Safety (`val`, `T?`, smart casts), exhaustive `when` không có `else ->`, và State Flow bất biến (`_state.update { copy(...) }`).
    2. *Zero-ANR*: Đảm bảo qua Main-Thread Purity (`Dispatchers.IO` cho Disk/Network, `Dispatchers.Default` cho tính toán nặng, non-blocking asynchronous Flow).
    3. *Zero-Leak*: Đảm bảo qua Lifecycle-bound scopes (`viewModelScope`, `DisposableEffect` với `onDispose`), cấm giữ static reference tới `Context`/`View`.

- **Proactive CTO/PO Advisory & Constructive Pushback Rule (QUY TẮC PHẢN BIỆN & CỐ VẤN CHỦ ĐỘNG CTO/PO):**
  - Khi nhận yêu cầu, ý tưởng, thiết kế hoặc đoạn code từ người dùng, AI BẮT BUỘC phải soi xét dưới 2 lăng kính:
    1. **CTO Lens (Performance & Architecture)**: Recomposition stability, Heap allocations trong Composable, Main-thread purity, Process Death recovery, và 19 Core Domains.
    2. **PO Lens (Product & UI/UX)**: 5-State UI Matrix, Zero Dead-ends, Insets & Keyboard scrolling, 48dp Touch Targets, Non-linear 200% font scaling, và Visual hierarchy.
  - CẤM TUYỆT ĐỐI "vâng lời thụ động" (Anti-Yes-Man). Phải chủ động chỉ ra các điểm nghẽn tiềm tàng và đề xuất giải pháp tối ưu vượt trội (Recommended Architecture) kèm so sánh trực quan Trước vs Sau theo cấu trúc:
    - 🎯 **CTO/PO Assessment** (Đánh giá mục tiêu & giá trị nghiệp vụ)
    - ⚠️ **Critical Risks & Bottlenecks** (Chỉ ra rủi ro hiệu năng, lag giật, hoặc trải nghiệm cụt luồng)
    - 💡 **Recommended Architectural Solution** (Kiến trúc & mã nguồn mẫu tối ưu chuẩn mực)

- **Mandatory Pre-Completion Verification (QUY TẮC BẮT BUỘC KIỂM THỬ):**
  - Trước khi báo "xong", "hoàn thành" hay "báo task xong" cho bất kỳ yêu cầu nào, AI bắt buộc phải chạy lệnh kiểm thử thực tế (`./gradlew compileDebugKotlin`, `./gradlew test` hoặc tương đương) và thu thập kết quả `BUILD SUCCESSFUL` thành công 100%.
  - Tuyệt đối không được chỉ dựa vào sửa file code mà đã báo xong task.

- **Clarification & Explicit Confirmation Flow Rule (QUY TẮC XÁC NHẬN KẾ HOẠCH BẮT BUỘC):**
  - Khi nhận yêu cầu từ người dùng, nếu có bất kỳ điểm nào chưa rõ ràng thì AI phải chủ động đặt câu hỏi làm rõ.
  - Khi đã hiểu rõ yêu cầu, AI phải trình bày tóm tắt ý hiểu và danh sách chi tiết các công việc cần làm, sau đó **chờ người dùng xác nhận/đồng ý rồi mới được tiến hành sửa code và thực thi**.

- **3rd-Party Library Consent & 16KB Page Alignment Audit Rule (QUY TẮC PHÊ DUYỆT THƯ VIỆN BÊN THỨ 3 & KIỂM TRA 16KB):**
  - Tất cả các thư viện bên thứ 3 (3rd-party dependencies) muốn thêm vào dự án đều **bắt buộc phải đề xuất và xin phép người dùng trước trong bước lên Plan**.
  - Phải kiểm tra và đảm bảo thư viện an toàn tuyệt đối (không chứa virus/mã độc) và tuân thủ tương thích chuẩn căn chỉnh trang nhớ 16KB (16KB Memory Page Alignment compliance trên Android 15+).

- **Plan Artifact Project Storage Location Rule (QUY TẮC LƯU FILE PLAN VÀO DỰ ÁN):**
  - Tất cả các kế hoạch (Plan) sau khi lập xong phải được lưu thành file Markdown trực tiếp vào thư mục `plan/` trong thư mục gốc của project (ví dụ: `~/Documents/ViO/Base-Jetpack_2026/plan/`).

- **Mandatory Code Quality Gate (QUY TẮC KIỂM TRA CHẤT LƯỢNG CODE BẮT BUỘC):**
  - Trước khi báo hoàn thành BẤT KỲ task nào liên quan đến UI, AI bắt buộc phải thực hiện **self-audit** theo 5 bước trong `05-design-system.md#ENFORCEMENT`:
    1. Scan `Color(0x` trong presentation → phải dùng `AppTheme.colors.*`
    2. Scan hardcoded `.dp` → phải dùng `AppSpacing.*`, `AppShapes.*`
    3. Scan `Text("` hardcoded → phải dùng `stringResource(R.string.xxx)`
    4. Scan raw `Text()` với inline styling → phải dùng typography composables (`Heading1`, `Body1`...)
    5. Verify Dark Theme compatibility → cấm `Color.White`, `Color.Black` trực tiếp
  - Nếu phát hiện bất kỳ vi phạm nào → code bị REJECT, phải sửa trước khi báo xong.

- **Mandatory Architecture Compliance Gate (QUY TẮC KIỂM TRA KIẾN TRÚC BẮT BUỘC):**
  - Trước khi báo hoàn thành BẤT KỲ task nào liên quan đến ViewModel, AI bắt buộc phải kiểm tra theo `07-viewmodel.md#ENFORCEMENT`:
    1. Tất cả ViewModel PHẢI kế thừa `BaseViewModel<State, Intent, Effect>` — cấm tuyệt đối `ViewModel()` trực tiếp.
    2. Tất cả coroutine PHẢI dùng `launch {}` (safeLaunch) — cấm tuyệt đối `viewModelScope.launch {}`.
    3. Xóa dead code (method không còn được gọi từ `onIntent()`).
    4. `when (intent)` phải exhaustive, cấm `else ->`.
  - Nếu phát hiện ViewModel vi phạm → AI PHẢI dừng lại, báo cáo vi phạm, và từ chối thêm code mới cho đến khi ViewModel được migrate.

- **Stub/Placeholder Detection Rule (QUY TẮC PHÁT HIỆN TÍNH NĂNG GIẢ LẬP):**
  - Khi tạo hoặc sửa bất kỳ tính năng nào, AI bắt buộc phải kiểm tra:
    1. Có sử dụng `delay()` để giả lập tiến trình không?
    2. Có hardcoded data giả (fake results) thay vì gọi backend/usecase thật không?
    3. Có bất kỳ `// TODO`, `// placeholder`, `// stub`, `// fake` nào không?
  - Nếu tính năng là placeholder/giả lập: AI PHẢI thông báo rõ ràng cho người dùng và gắn label "⚠️ Simulation/Coming Soon" trong báo cáo.
  - Tuyệt đối KHÔNG ĐƯỢC báo tính năng "hoàn thành" nếu backend logic chỉ là delay + fake data.

- **Violation-First Refactoring Rule (QUY TẮC ƯU TIÊN SỬA VI PHẠM TRƯỚC):**
  - Khi AI phát hiện file hiện tại có vi phạm Design System/Architecture (hardcoded colors, bypass safeLaunch, broken MVI...) trong quá trình làm task mới:
    1. AI PHẢI báo cáo vi phạm cho người dùng.
    2. Đề xuất sửa vi phạm kèm theo task hiện tại.
    3. KHÔNG ĐƯỢC thêm code vi phạm mới vào file đã có vi phạm cũ mà không báo cáo.

- **Mandatory No Auto-Commit Mandate (QUY TẮC TUYỆT ĐỐI KHÔNG ĐƯỢC TỰ Ý COMMIT):**
  - AI tuyệt đối KHÔNG BAO GIỜ được tự ý thực thi lệnh `git commit` trong bất kỳ trường hợp nào.
  - Mọi thao tác commit phải do người dùng tự tay thực hiện hoặc phê duyệt.

- **Mandatory Background Task Cleanup & Non-Lingering Process Rule (QUY TẮC BẮT BUỘC DỌN DẸP TIẾN TRÌNH NGẦM & ĐÓNG TASK NGAY KHI XONG):**
  - Khi chạy bất kỳ lệnh CLI/Gradle nào trong background (background task), sau khi kiểm tra xong output hoặc xác thực build/test thành công, AI **bắt buộc phải kiểm tra `manage_task(Action="list")` và lập tức gọi `manage_task(Action="kill", TaskId=...)`** để đóng luồng I/O và giải phóng hoàn toàn tiến trình ngầm.
  - Tuyệt đối KHÔNG ĐƯỢC để task ngầm ở trạng thái `running` kéo dài trên giao diện UI sau khi công việc đã hoàn thành.
  - Khi chạy lệnh Gradle hoặc build tool, ưu tiên cấu hình timeout hoặc đóng subshell ngay khi lệnh trả về kết quả.

- **Project-Scoped Auto-Approval & Strict Out-of-Project Isolation Mandate (QUY TẮC ỦY QUYỀN TRONG DỰ ÁN & CÁCH LY TUYỆT ĐỐI NGOÀI DỰ ÁN):**
  - **Trong phạm vi Dự án (In-Project Workspace):** Sau khi Kế hoạch (Plan) đã được người dùng phê duyệt, AI được phép tự động tạo và chỉnh sửa file mã nguồn trong các thư mục của dự án (`app/src/main/`, `domain/`, `data/`, `presentation/`, `di/`, `core/`, `plan/`) thông qua các công cụ Native (`write_to_file`, `replace_file_content`) mà không cần hỏi lại từng file đơn lẻ.
  - **Chấm dứt Shell File Creation:** CẤM TUYỆT ĐỐI việc dùng `run_command` chạy các lệnh shell redirect (`cat << 'EOF' > ...`, `echo >`, `tee`) để ghi mã nguồn, nhằm triệt tiêu 100% popup xin quyền shell phiền phức.
  - **Cách ly tuyệt đối Ngoài Dự án (Strict Out-of-Project Boundary):** AI TUYỆT ĐỐI KHÔNG ĐƯỢC TỰ Ý tạo, sửa, ghi đè hoặc xóa bất kỳ file nào nằm NGOÀI THƯ MỤC DỰ ÁN (như file hệ thống OS, `~/.zshrc`, `~/.bash_profile`, Desktop, các thư mục cá nhân). Mọi thao tác ngoài project bắt buộc phải dừng lại và có sự đồng ý rõ ràng từ người dùng.

---

# Final Rule

User Preference Memory exists to improve long-term collaboration.

The AI should adapt to how the user prefers to work,

while always respecting explicit instructions, project standards, and sound engineering practices.