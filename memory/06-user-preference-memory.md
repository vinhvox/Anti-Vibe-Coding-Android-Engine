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

- **The 100% Pure XML Modern Android Architecture Mandate (QUY TẮC KIẾN TRÚC 100% PURE XML HIỆN ĐẠI):**
  - **Nhận Diện Đa Hình (Tri-Paradigm Support):** Hệ thống Antigravity chính thức hỗ trợ song song 3 mô hình sản phẩm:
    1. *100% Jetpack Compose:* Toàn bộ UI bằng Declarative Compose M3 & Navigation 3.
    2. *Hybrid Interoperability:* Giao thoa XML & Compose (`ComposeView` + `AndroidView` + Rule 43).
    3. *100% Pure XML:* Toàn bộ UI bằng XML Views, ViewBinding, `ListAdapter`, Navigation SafeArgs và `WindowInsetsCompat` (Rule 44).
  - **Trụ Cột 1: ViewBinding An Toàn Vòng Đời (Gate E36.1):**
    - Trong Fragment: Mọi biến ViewBinding bắt buộc phải là nullable `private var _binding: FragmentXxxBinding? = null` và BẮT BUỘC gán `_binding = null` trong `onDestroyView()`. Tuyệt đối cấm dùng `val binding` bất biến ở class level để triệt tiêu 100% Leaked Fragment Views.
  - **Trụ Cột 2: Thu Thập StateFlow Theo Vòng Đời Trong XML (Gate E36.1 & E35.4):**
    - Bắt buộc dùng `viewLifecycleOwner.lifecycleScope.launch { viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) { ... } }`. Cấm dùng `lifecycleScope.launch` trần trụi không có `repeatOnLifecycle`.
  - **Trụ Cột 3: RecyclerView 120 FPS Engineering (Gate E36.2):**
    - Bắt buộc dùng `ListAdapter<T, VH>` kết hợp `DiffUtil.ItemCallback` tính toán khác biệt trên luồng nền. Tuyệt đối cấm dùng `RecyclerView.Adapter` cũ với `notifyDataSetChanged()`.
    - Gọi `setHasFixedSize(true)` khi kích thước cố định; chia sẻ `RecyclerView.RecycledViewPool` khi có nested lists.
  - **Trụ Cột 4: Android 15+ Enforced Edge-to-Edge Trong XML (Gate E36.3):**
    - Gọi `enableEdgeToEdge()` trong Activity.
    - Bắt buộc xử lý Insets qua `ViewCompat.setOnApplyWindowInsetsListener` kết hợp `WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.ime()` và `view.updatePadding(...)` để bàn phím và thanh điều hướng không bao giờ che khuất UI.
  - **Trụ Cột 5: Điều Hướng Type-Safe Với Navigation SafeArgs (Gate E36.4):**
    - Sử dụng XML Navigation Graph (`nav_graph.xml`) và plugin SafeArgs. Cấm truyền nhận tham số qua chuỗi string keys thủ công.
  - **Trụ Cột 6: Material 3 XML Theming & Accessibility:**
    - Kế thừa `Theme.Material3.DayNight.NoActionBar`; 100% màu nền/chữ trong XML dùng thuộc tính ngữ nghĩa (`?attr/colorSurface`, `?attr/colorOnSurface`). Cấm hardcode `@color/white` hoặc hex `#FFFFFF`. Nút bấm tối thiểu 48dp x 48dp.

- **The Hybrid XML & Jetpack Compose Interoperability Architecture Mandate (QUY TẮC KIẾN TRÚC GIAO THOA HYBRID XML & COMPOSE):**
  - **Nhận Diện Sản Phẩm:** Toàn bộ các sản phẩm và codebase được xác định là hệ thống Hybrid (vận hành song song cả XML Views, ViewBinding và Jetpack Compose). AI phải áp dụng đồng thời các chốt chặn an toàn cho cả hai thế giới.
  - **Trụ Cột 1: Nhúng Compose vào XML (`ComposeView` - Gate E35.1):**
    - Trong Fragment: Mọi `ComposeView` BẮT BUỘC phải gọi `setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)` trong `onCreateView`. Tuyệt đối cấm dùng mặc định `DisposeOnDetachedFromWindow` để không bị rò rỉ bộ nhớ hoặc crash `IllegalStateException` khi Fragment nằm trong Backstack.
    - Trong `RecyclerView.ViewHolder`: Bắt buộc sử dụng `ViewCompositionStrategy.DisposeOnDetachedFromWindowOrReleasedFromPool` (hoặc `DisposeOnViewTreeLifecycleDestroyed`) để Composition tự động thu hồi khi item được trả về pool.
  - **Trụ Cột 2: Nhúng XML View vào Compose (`AndroidView` - Gate E35.3):**
    - Tách biệt tuyệt đối giữa `factory` (chỉ chạy 1 lần duy nhất để tạo View) và `update` (cập nhật thuộc tính khi state thay đổi, cấm tạo mới View).
    - BẮT BUỘC cung cấp khối `onRelease` (hoặc `DisposableEffect`) để giải phóng phần cứng và tài nguyên (`adView.destroy()`, `playerView.player = null`, `mapView.onDestroy()`).
  - **Trụ Cột 3: Quản Trị An Toàn ViewBinding Trong Fragment (Gate E35.2):**
    - Mọi Fragment XML sử dụng ViewBinding bắt buộc phải giải phóng biến binding trong `onDestroyView()` (`_binding = null`). Cấm giữ biến `binding` kiểu `val` vĩnh viễn gây rò rỉ toàn bộ cây View XML (Leaked Fragment View).
  - **Trụ Cột 4: Mô Hình UDF & Shared ViewModel (Gate E35.4):**
    - Dùng chung 1 `BaseViewModel` duy nhất phát `StateFlow<UiState>` bất biến.
    - Bên Compose Screen: Thu thập an toàn bằng `val state by viewModel.uiState.collectAsStateWithLifecycle()`.
    - Bên XML Fragment: Thu thập bằng `viewLifecycleOwner.lifecycleScope.launch { viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) { ... } }`. Cấm dùng `lifecycleScope.launch` trần trụi không có `repeatOnLifecycle`.
  - **Trụ Cột 5: Đồng Bộ Hóa Design System (Theme Bridge):**
    - Đặt các token màu cốt lõi tại `res/values/colors.xml`.
    - `Theme.Material3` (XML) và `AppTheme` (Compose) phải ánh xạ 1-1 với nhau, đảm bảo khi chuyển đổi Dark/Light mode, giao diện XML và Compose hoàn toàn đồng nhất.

- **The Modern Android Best Practices 2025–2026 Master Mandate (QUY TẮC THỰC HÀNH ANDROID HIỆN ĐẠI 2025–2026):**
  - **Trụ Cột 1: Kiến Trúc Tổng Thể & UDF (Clean Architecture + MVI):**
    - Phân tách rành mạch 3 tầng: Presentation (UI + ViewModel) -> Domain (UseCases, Purity) -> Data (Repositories, Room, Ktor).
    - Dòng dữ liệu một chiều (UDF): UI phát Event/Intent thuần -> ViewModel cập nhật StateFlow bất biến -> UI hiển thị. Cấm 2-way binding.
    - Single Source of Truth (SSOT) & Offline-First: UI chỉ đọc từ Local Room DB qua `Flow<List<T>>`; API Network (Ktor) chỉ ghi vào Local DB.
    - Đóng gói lỗi biên I/O bằng `AppResult<T>`, cấm throw Exception qua lại giữa các tầng kiến trúc.
  - **Trụ Cột 2: Jetpack Compose 2026 & Tối Ưu Hóa Recomposition:**
    - Phân tách bắt buộc `StatefulScreen` (lắng nghe ViewModel/Navigation) và `StatelessContent` (thuần UI + lambdas, hỗ trợ 100% `@Preview`).
    - Trì hoãn đọc State (Phase Deferral): Đọc state tần số cao (scroll, drag, animation) trong Modifier lambda (`Modifier.offset { ... }` hoặc `Modifier.graphicsLayer { ... }`) để bỏ qua Recomposition, chạy thẳng vào Layout/Draw Phase.
    - Bắt buộc khai báo `key = { it.id }` và `contentType = { it.type }` trong mọi `LazyColumn`/`LazyRow` để tái sử dụng Composable Node, duy trì 120 FPS.
    - Thiết kế thích ứng (Adaptive UI) co giãn linh hoạt theo `WindowSizeClasses` (Compact, Medium, Expanded) trên điện thoại, foldables và tablet.
  - **Trụ Cột 3: Điều Hướng Thế Hệ Mới (Navigation 3 & Type Safety):**
    - State-Driven Navigation: Quản lý toàn bộ Backstack như một `List<NavKey>` phản ứng trong router/store.
    - Định tuyến an toàn kiểu dữ liệu 100% bằng Kotlin `@Serializable` objects/classes. Tuyệt đối cấm nối chuỗi URL thủ công.
    - Tự động dọn dẹp và thu hồi ViewModel/Store theo phạm vi vòng đời của Navigation Entry (`NavEntry`) khi bị pop khỏi backstack.
  - **Trụ Cột 4: Coroutines, Flow & An Toàn Bất Đồng Bộ:**
    - Thu thập Flow theo vòng đời bằng `collectAsStateWithLifecycle()` trong Compose và `repeatOnLifecycle` ngoài Views để tự động ngắt flow khi vào background.
    - Bảo toàn tuyệt đối `CancellationException`: Cấm nuốt trong `catch (e: Exception)`; bắt buộc dùng `if (e is CancellationException) throw e`.
    - Phân biệt rành mạch: `StateFlow` cho UI state liên tục, `Channel` / `SharedFlow(replay = 0)` cho One-off events (Toast, Navigation), `Mutex` cho single-flight token refresh / DB write lock.
  - **Trụ Cột 5: Dependency Injection Nhẹ Nhàng Với Koin 4.0:**
    - Ưu tiên Constructor-based Injection trực quan, không cần code generation (`kapt`/`ksp`), tối ưu thời gian khởi động (Startup TTID).
    - Xác thực tính toàn vẹn phụ thuộc ngay tại Unit Test bằng `appModule.verify()`, triệt tiêu lỗi thiếu definition lúc runtime.
  - **Trụ Cột 6: Tầng Dữ Liệu Hiện Đại (Room, DataStore & Ktor Client):**
    - Room Database: Luôn trả về `Flow<List<T>>` tại DAO; bật `exportSchema = true` và viết test migration; cấm `fallbackToDestructiveMigration()` trên bản phát hành.
    - Jetpack DataStore: Thay thế hoàn toàn `SharedPreferences` cũ kỹ, đảm bảo bất đồng bộ, transactional và zero ANR.
    - Ktor Client: Cấu hình `ContentNegotiation` với `kotlinx.serialization` (zero reflection), `HttpTimeout` và Exponential Backoff Retry.
  - **Trụ Cột 7: Kiểm Thử Hiện Đại & Ma Trận 5 Trạng Thái UI:**
    - Dùng Turbine để kiểm thử tuần tự từng emission của Flow/StateFlow (`appFlow.test { ... }`).
    - Ưu tiên Test Fakes in-memory hơn Mocking frameworks (MockK/Mockito) để tăng tốc độ và tính ổn định của test suite.
    - Kiểm soát thời gian ảo chính xác với `runTest` và `StandardTestDispatcher`.
    - Bắt buộc kiểm thử và cung cấp Preview cho đủ 5 trạng thái UI: `Loading`, `Content`, `Empty`, `Error`, `Offline`.
  - **Trụ Cột 8: Hiệu Năng, Process Death & Căn Chỉnh Bộ Nhớ 16KB:**
    - Triệt tiêu heap allocation trong thân Composable (dùng `remember { ... }` hoặc đẩy tính toán về ViewModel).
    - Sống sót qua Process Death bằng cách chỉ lưu primitive IDs (`id: String`, `pageIndex: Int`) trong `SavedStateHandle`, rehydrate từ Room DB.
    - Bắt buộc căn chỉnh trang nhớ 16KB (`-Wl,-z,max-page-size=16384`) cho mọi file C++ `.so` trên Android 15+.
    - Bật R8 FullMode và đóng gói `consumer-rules.pro` ở các module độc lập.

- **The Google Play Developer Program Policies 2025–2026 Master Mandate (QUY TẮC CHÍNH SÁCH GOOGLE PLAY BẮT BUỘC 2025–2026):**
  - **Trụ Cột 1: Bảo Mật & Chống Lạm Dụng Mã Độc (Gate E29.1, E29.2, E29.3, E29.4):**
    - *Zero Dynamic Code Loading (Zero DCL):* Tuyệt đối cấm tải, giải nén và thực thi mã nhị phân ngoài (`.dex`, `.jar`, `.so`) từ server từ xa tại runtime. 100% mã nguồn phải đóng gói trong Android App Bundle (AAB).
    - *Target SDK & 16KB Page Alignment:* Target SDK phải luôn nằm trong hạn 1 năm của bản Android mới nhất; 100% native C++ `.so` phải căn chỉnh trang nhớ 16KB (Android 15+).
    - *Android 14+ FGS:* Chỉ khởi chạy Foreground Service khi có hành động người dùng chủ động và khai báo đúng `foregroundServiceType`.
    - *Container & Surface Defense:* Khai báo `REQUIRE_SECURE_ENV` và bật `FLAG_SECURE` (`SecureScreenEffect`) trên màn hình thanh toán, auth, thông tin nhạy cảm.
  - **Trụ Cột 2: Quyền Riêng Tư & Dữ Liệu Người Dùng (Gate E29.6, Gate E34.5):**
    - *Bắt Buộc Link Web Xóa Tài Khoản (Account Deletion URL):* Mọi ứng dụng có tính năng tạo tài khoản bắt buộc phải cung cấp cả luồng xóa trong app VÀ đường link web công khai xóa tài khoản / dữ liệu (`AccountPolicyManager.ACCOUNT_DELETION_WEB_URL`) mà không bắt user phải cài lại app.
    - *Zero-Permission Photo Picker:* Bắt buộc dùng `ActivityResultContracts.PickVisualMedia` hệ thống để chọn ảnh/video; cấm xin quyền `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE`.
    - *Data Safety Accuracy:* Khai báo đúng 100% mục đích thu thập dữ liệu (Analytics, Fraud, Personalization) và cơ chế mã hóa trong quá trình truyền tải (Encryption in transit).
  - **Trụ Cột 3: Kiếm Tiền & Chuẩn Quảng Cáo Better Ads (Gate E29.7):**
    - *Google Play In-App Billing:* 100% giao dịch vật phẩm ảo, nâng cấp VIP, mở khóa tính năng phải qua Google Play Billing API.
    - *Better Ads Standards:* Quảng cáo xen kẽ (interstitial) toàn màn hình bắt buộc phải có nút đóng/bỏ qua xuất hiện trước 15 giây; cấm quảng cáo bất ngờ ngắt ngang luồng thao tác của người dùng; cấm hiển thị quảng cáo ngoài ứng dụng (màn hình khóa, launcher).
  - **Trụ Cột 4: Trí Tuệ Nhân Tạo Tạo Sinh (GenAI Policy - Gate E29.8):**
    - *In-App Flagging Mechanism:* Bắt buộc có nút báo cáo nội dung vi phạm (`GenAiReportContentDialog`) trực tiếp trên từng câu trả lời/hình ảnh do AI sinh ra.
    - *Moderation Guardrails:* Bắt buộc tích hợp bộ lọc kiểm duyệt prompt đầu vào và kết quả đầu ra chống nội dung khiêu dâm, CSAM, tự hại, thù địch, tin giả.
  - **Trụ Cột 5: Chính Sách Gia Đình & Trẻ Em (Gate E29.10):**
    - Nếu đối tượng bao gồm trẻ em (dưới 13 tuổi): Chỉ được dùng SDK quảng cáo đạt chứng nhận (Google Play Certified Ad SDKs); cấm thu thập Android Advertising ID (AAID) và định danh phần cứng; bắt buộc có màn hình xác minh tuổi trung lập (`NeutralAgeVerificationScreen`).
  - **Trụ Cột 6: Chức Năng Tối Thiểu & Trải Nghiệm Ứng Dụng (Gate E29.9, Gate E34.1):**
    - Cấm tuyệt đối app chỉ là vỏ bọc WebView đơn thuần hoặc app trùng lặp/spam. Giữ tỷ lệ crash $< 1.09\%$ và ANR $< 0.47\%$.
  - **Trụ Cột 7: Xác Minh Danh Tính & Thử Nghiệm 20 Testers:**
    - Doanh nghiệp phải hoàn thành xác minh D-U-N-S; tài khoản cá nhân mới tạo sau tháng 11/2023 bắt buộc phải chạy Closed Testing tối thiểu 20 tester liên tục 14 ngày trước khi gửi duyệt Production.

- **The Android 15/16 Best Quality & Core Vitals Enforcement Mandate (QUY TẮC CHẤT LƯỢNG ANDROID 15/16 & CHỐT CHẶN GOOGLE PLAY VITALS):**
  - **Khóa Cứng 4 Ngưỡng Đỏ Google Play Vitals (Rule 27 & Gate E34.1):**
    - *Crash Rate (User-perceived):* Bắt buộc $< 0.05\%$ (1 crash / 2,000 phiên). Tuyệt đối không để vượt ngưỡng phạt Google Play $\ge 1.09\%$ ($\ge 8\%$ trên từng dòng máy).
    - *ANR Rate (User-perceived):* Bắt buộc $< 0.02\%$ (1 ANR / 5,000 phiên). Ngưỡng phạt Google Play $\ge 0.47\%$.
    - *Cold Start TTID:* Bắt buộc $< 600\text{ms}$ (Warm Start $< 300\text{ms}$). Ngưỡng phạt Google Play $\ge 5,000\text{ms}$.
    - *Slow Rendering Frames:* Bắt buộc $< 1.0\%$ khung hình trễ quá 16ms/8.3ms, $0.0\%$ Frozen Frames quá 700ms. Ngưỡng phạt $\ge 50\%$.
  - **Tuân Thủ Tuyệt Đối Nền Tảng Android 15 & 16 (Gate E34.2, E34.3, E34.5):**
    - *16KB Memory Page Alignment:* 100% thư viện native C++ `.so` bắt buộc phải được biên dịch căn chỉnh 16KB (`-Wl,-z,max-page-size=16384`). Nghiêm cấm tích hợp thư viện 4KB gây crash SIGSEGV trên phần cứng mới.
    - *Enforced Edge-to-Edge:* Bắt buộc gọi `enableEdgeToEdge()` và tiêu thụ `WindowInsets.safeDrawing`, kết hợp `Modifier.imePadding()` để bàn phím và thanh điều hướng không bao giờ che khuất UI.
    - *Zero-Permission Photo Picker:* Bắt buộc dùng `ActivityResultContracts.PickVisualMedia` hệ thống để chọn ảnh, cấm xin quyền `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES` bừa bãi.
  - **Tối Ưu Khởi Động Với Baseline Profiles (Gate E34.4):**
    - Mọi bản build phát hành Release bắt buộc phải đóng gói file `baseline-prof.txt` từ module `:baselineprofile` để Play Store biên dịch trước (AOT), giảm 40% thời gian khởi động lạnh.

- **The Autonomous Agentic Engineering & Scientific Closed-Loop Mandate (QUY TẮC KỸ NGHỆ TÁC TỬ TỰ CHỦ & GỠ LỖI KHOA HỌC KHÉP KÍN):**
  - **Triệt Tiêu 100% Vibe Debugging (Cấm Đoán Mò):** Tuyệt đối CẤM việc nhìn stacktrace rồi đoán mò, sửa code production khi chưa có test tái hiện, hoặc dùng `try-catch` / null coalescing để bưng bít triệu chứng.
  - **Chu Trình 4 Bước Khoa Học Bắt Buộc (The 4-Step Scientific Loop - Rule 41 & Gate E33.1/E33.2):**
    1. *Hypothesis:* Đưa ra 1 giả thuyết kỹ thuật duy nhất dựa trên stacktrace và bất biến hệ thống.
    2. *Minimal Failing Test:* Viết 1 test case siêu nhỏ chứng minh lỗi được tái hiện (RED state). Cấm sửa code production khi chưa có test đỏ.
    3. *Single-Variable Fix:* Chỉ can thiệp đúng 1 biến số / 1 nhánh logic bị lỗi, không sửa lan man.
    4. *Regression Sweep:* Chạy lại toàn bộ test suite (`./gradlew testDebugUnitTest`) chứng minh 0 tác dụng phụ.
  - **Kiểm Định Đối Kháng Độc Lập (Dual-Agent Adversarial Verification - Rule 42 & Gate E33.4):**
    - Cấm tác giả tự duyệt code của chính mình mà không qua kiểm định độc lập (chống Confirmation Bias).
    - Mọi tính năng lớn hoặc Refactor cốt lõi phải vượt qua bài kiểm tra của Red Team qua 4 Chaos Vectors (Dữ liệu bẩn, Bất đồng bộ / Race conditions, Môi trường runtime khắc nghiệt, Tuân thủ 100% Gates E1-E33) trước khi bàn giao.
  - **Truy Vết Sống Giữa Spec Và Test (Living Executable Traceability - Rule 28, 33 & Gate E33.3):**
    - 100% kịch bản Gherkin trong Spec phải có `@Scenario("ID")` ánh xạ 1-1 với test function trong mã nguồn. Cấm tồn tại bất kỳ kịch bản nào trên giấy mà không có test tương ứng (Zero Spec Drift).

- **The Senior Refactoring Safety Net Mandate (QUY TẮC REFACTOR: BẮT BUỘC VIẾT CHARACTERIZATION TESTS TRƯỚC KHI ĐỤNG VÀO CODE):**
  - **Cấm Tuyệt Đối Lao Vào Sửa Code Ngay (No Cowboy Refactoring):** Khi nhận nhiệm vụ Refactor, Cleanup, Tối ưu hóa hoặc Migrate bất kỳ class/hàm/module nào, AI TUYỆT ĐỐI CẤM chỉnh sửa code production trước khi có bộ test bảo vệ.
  - **Quy Trình 5 Bước Bắt Buộc (The 5-Step Refactoring Safety Net):**
    1. *Bước 1 - Viết Characterization (Pinning) Tests Trước:* Viết bộ test khóa chặt toàn bộ hành vi quan sát được (observable behavior) hiện tại của code cũ (input/output, state transitions, edge cases) trước khi sửa dù chỉ 1 ký tự.
    2. *Bước 2 - Xác Lập Mốc Xanh (Green Baseline):* Chạy test trên code cũ chưa sửa (`./gradlew testDebugUnitTest`), đảm bảo 100% test PASS.
    3. *Bước 3 - Refactor Trong Micro-Steps:* Thực hiện từng bước biến đổi cấu trúc cực nhỏ (tách hàm, đổi tên, chuẩn hóa pattern, gỡ phụ thuộc).
    4. *Bước 4 - Chạy Test Sau Mỗi Bước (Red Stop Rule):* Chạy lại test ngay sau mỗi micro-step. Nếu test ĐỎ -> Dừng lại và REVERT ngay lập tức về trạng thái xanh gần nhất, không được sửa mò trên test đỏ.
    5. *Bước 5 - Chứng Minh Không Hồi Quy (Zero Regression Evidence):* Chạy toàn bộ test suite và cung cấp bằng chứng `BUILD SUCCESSFUL` chứng minh hành vi nghiệp vụ được bảo toàn 100%.

- **The Deep Problem Understanding & 6-Dimension Adversarial Boundary Mandate (QUY TẮC HIỂU SÂU BẢN CHẤT BÀI TOÁN & ĐỘNG NÃO KỊCH BẢN BIÊN 6 CHIỀU):**
  - **Cấm Tuyệt Đối Căn Bệnh Happy-Path Myopia:** Tuyệt đối CẤM việc chỉ đọc lướt yêu cầu bề mặt rồi vội vàng viết code cho kịch bản lý tưởng (mạng 200 OK, user nhập liệu chuẩn chỉ, không ai bấm nhầm).
  - **Phân Rã Bản Chất Theo Nguyên Lý Gốc (First-Principles Deconstruction):** Trước khi viết bất kỳ dòng code nào, AI bắt buộc phải trả lời 3 câu hỏi:
    1. Người dùng thực sự đang giải quyết vấn đề gì và trong bối cảnh thực tế nào?
    2. Các bất biến hệ thống (System Invariants) nào tuyệt đối không bao giờ được sai? (Số dư $\ge$ 0, không trùng lặp giao dịch, tính toán tiền tệ chính xác).
    3. Các điểm nghẽn hoặc trạng thái suy thoái (degradation) nào có thể xảy ra?
  - **Động Não Kịch Bản Biên Qua Ma Trận 6 Chiều Bắt Buộc (The 6-Dimension Test Boundary Matrix):**
    1. *Data Boundaries:* Empty, Blank, Whitespace, 0, 1, Boundary N, Max, Overflow, Chuỗi dài 500-1000 ký tự, Unicode, Emojis, Bidi RTL/LTR, Malformed JSON.
    2. *State Machine & Transitions:* Re-entrancy, Illegal transition (Retry khi đang Loading), Hủy giữa chừng, Stale state.
    3. *Timing & Concurrency:* Rapid multi-tap < 400ms, Parallel race conditions, Out-of-order responses (cũ về sau mới), Timeout, 401 token refresh concurrency race.
    4. *Hostile OS & Environment:* Process Death (LMK), Offline, Captive portal trả về HTML, Disk full `ENOSPC`, JIT permission revoked.
    5. *Adversarial User Behavior:* Spam click liên tục, Xoay/gập màn hình liên tục khi tải, Paste 10,000 ký tự, Thoát app khi giao dịch đang gửi.
    6. *Business Invariants & Security:* Không xử lý trùng lặp (Idempotency), Giữ toàn vẹn dữ liệu, Chống rò rỉ dữ liệu nhạy cảm.
  - **Bắt Buộc Liệt Kê Test Cases Đầy Đủ Trước Khi Viết Code:** Trình bày danh sách test cases cụ thể bao phủ toàn bộ các chiều trên trong kế hoạch trước khi bắt tay vào code.

- **Haute Couture UI/UX Design & Bespoke Craft Mandate (QUY TẮC THIẾT KẾ GIAO DIỆN CÓ GU, ĐẮT GIÁ & TRIỆT TIÊU MÙI AI):**
  - **Triệt Tiêu 100% "Mùi AI" Rẻ Tiền (Anti-AI-Slop):** Tuyệt đối CẤM: Nền tím tối lạm dụng (purple on dark), viền phát sáng neon, badge hình viên thuốc (biscuit pills) có chấm nhấp nháy, chữ đổ gradient lòe loẹt, và card lồng card lặp đi lặp lại ngột ngạt.
  - **Bí Quyết 1 - Chiều Sâu Quang Học & Viền Tơ 0.5dp:** Bắt buộc dùng viền siêu mảnh **0.5dp** bán trong suốt (`AppTheme.colors.outlineVariant.copy(alpha = 0.35f)`) kết hợp phân tầng Material 3 Surface Containers (`surfaceContainerLowest` -> `surfaceContainerLow` -> `surfaceContainerHigh`). Cấm viền thô >= 2dp và shadow lem nhem.
  - **Bí Quyết 2 - Đỉnh Cao Typography & Tracking:** Tiêu đề lớn (Display/Headline) bắt buộc dùng **tracking âm** (`letterSpacing = -0.5.sp` đến `-1.sp`) để tạo độ nén quyền lực, uy quyền như tạp chí bìa cứng. Label/Overline in hoa dùng tracking dương (+1.2sp). Mọi số liệu tài chính/thống kê bắt buộc bật `fontFeatureSettings = "tnum"` (Tabular Figures) để số không nhảy giật layout.
  - **Bí Quyết 3 - Sự Tiết Chế Màu Sắc 90/10:** "Sang trọng thì thầm, không gào thét". 90% giao diện dùng màu trung tính thượng cấp (Warm Obsidian, Slate Charcoal, Titanium, Off-white), chỉ điểm xuyết 10% (hoặc 5%) màu thương hiệu có chủ đích.
  - **Bí Quyết 4 - Nhịp Thở Không Gian Bất Đối Xứng:** Xóa bỏ thói quen `padding(16.dp)` đều chằn chặn. Nhóm các phần tử liên quan rất gần nhau (4-8dp), mở toang khoảng thở giữa các phân đoạn lớn (28-40dp).
  - **Bí Quyết 5 - Cảm Giác Xúc Giác & Động Học Lò Xo:** Nút bấm khi nhấn giữ phải lún nhẹ (scale xuống 0.97f) bằng lò xo tự nhiên (`spring(stiffness = Spring.StiffnessMediumLow)`). Top Bar dùng hiệu ứng kính mờ (Frosted Glass / blur 20dp). Skeleton loading dùng shimmer êm dịu cùng tông nền.

- **Automated ProGuard & R8 Rules Synthesis Mandate (QUY TẮC TỰ ĐỘNG QUÉT & SINH PROGUARD/R8 RULES):**
  - **Tự Động Đọc & Phân Tích Codebase 100%:** Khi người dùng yêu cầu cấu hình ProGuard / R8 hoặc chuẩn bị đóng gói Release, AI tự động quét toàn bộ `libs.versions.toml`, `build.gradle.kts`, DTOs, Room Entities, và Navigation 3 Routes trong workspace.
  - **Phân Tách 2 Tầng Rules Chuẩn Mực:**
    1. Tầng Module/SDK: Tự động sinh file `consumer-rules.pro` (tự đóng gói keep rules cho DTOs, Entities, DAOs để App mẹ không phải cấu hình tay).
    2. Tầng App Mẹ: Tự động sinh `proguard-rules.pro` (cấu hình R8 FullMode, Coroutines internals, và strip log trên Release).
  - **Xác Thực Build Release Thực Tế:** Bắt buộc chạy `./gradlew assembleRelease` để chứng minh 0 lỗi missing keep rules trước khi bàn giao.

- **The 8 AI Blind Spots Defense Mandate (QUY TẮC PHÒNG VỆ 8 ĐIỂM MÙ KỸ THUẬT):**
  1. *Lazy Layout Keys*: Bắt buộc chỉ định `key = { it.id }` và `contentType` trong `LazyColumn`/`LazyRow` để triệt tiêu recomposition toàn phần và giật lag danh sách.
  2. *Duplicate Click Lock*: Khóa ngay trạng thái ở ViewModel (`if (state.value.isLoading) return@safeLaunch`) và áp dụng debounce 400ms trên các hành động điều hướng.
  3. *Form State Survival*: Dùng `rememberSaveable` hoặc hoist vào `SavedStateHandle` cho toàn bộ input người dùng để sống sót qua xoay màn hình, đổi theme và Process Death.
  4. *Keyboard Auto-Scroll*: Kết hợp `Modifier.imePadding()` với scroll container và `BringIntoViewRequester` để bàn phím không che mất ô nhập liệu ở đáy màn hình.
  5. *Modern API & Navigation 3 Purity*: 100% dùng Material 3 API gốc và `@Serializable data class Screen` trong Navigation 3 (cấm Accompanist cũ và route chuỗi).
  6. *Localization & Plurals*: 100% dùng `pluralStringResource` và `stringResource` có placeholder, cấm nối chuỗi thủ công `$count items` hay `"$ " + price`.
  7. *Mandatory Vector Drawables (Cấm Icon Emoji / String Glyphs)*: Tuyệt đối CẤM chèn emoji (🔥, ⭐, 🚀, 🔍, ⚠️, 🗑️) hoặc ký tự unicode vào chuỗi text để làm icon. BẮT BUỘC tạo file XML Vector Drawable trong `res/drawable/` (ví dụ: `ic_fire.xml`, `ic_star.xml`) hoặc dùng Material Icons, hiển thị qua `Icon(painterResource(R.drawable.ic_*))`. Tránh hoàn toàn việc mỗi hãng máy (Samsung, Xiaomi, Pixel) hiển thị một kiểu emoji khác nhau hoặc vỡ layout.
  8. *Zero-Fluff Direct Communication*: Trình bày trực tiếp, súc tích, chuẩn CTO, không mở đầu bằng văn mẫu sáo rỗng.

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

- **The Mandatory Consult-Before-Code Protocol (QUY TẮC BẮT BUỘC: KHẢO SÁT ➔ ĐÁNH GIÁ ➔ GIẢI PHÁP & LỘ TRÌNH ➔ DỪNG LẠI CHỜ DUYỆT TRƯỚC KHI CODE):**
  - CẤM TUYỆT ĐỐI việc vội vã bắt tay vào sửa/tạo code ngay trong lượt phản hồi đầu tiên (Turn 1) rồi mới báo cáo lại sau.
  - Khi nhận bất kỳ câu hỏi, yêu cầu hoặc tính năng mới từ người dùng, AI BẮT BUỘC phải thực hiện tuần tự 4 bước sau:
    1. 🔍 **Tìm hiểu & Khảo sát (Investigation & Codebase Context)**: Đọc và khảo sát codebase thực tế, trace callers, kiểm tra file liên quan, hiểu rõ hiện trạng và nguyên nhân gốc rễ, tuyệt đối không đoán mò.
    2. 🎯 **Đánh giá Kỹ thuật CTO/PO (Technical Assessment & Trade-offs)**: Phân tích dưới góc nhìn CTO (hiệu năng, recomposition, memory leak, 19 Core Domains) và PO (trải nghiệm người dùng, 5-State UI Matrix, Edge Cases, luồng xử lý lỗi).
    3. 💡 **Giải pháp & Lộ trình triển khai (Proposed Solution & Roadmap)**: Đề xuất phương án tối ưu nhất (kèm so sánh nếu có nhiều lựa chọn) và kế hoạch triển khai từng bước chi tiết (step-by-step roadmap/checklist).
    4. 🛑 **CHỐT CHẶN CỨNG (Absolute Hard Stop - Chờ duyệt)**: Dừng lại hoàn toàn, trình bày rõ ràng 3 phần trên cho người dùng và **chờ người dùng xác nhận/đồng ý ("Proceed", "Làm đi", "OK") mới được phép bắt đầu can thiệp vào code**.

- **3rd-Party Library Consent & 16KB Page Alignment Audit Rule (QUY TẮC PHÊ DUYỆT THƯ VIỆN BÊN THỨ 3 & KIỂM TRA 16KB):**
  - Tất cả các thư viện bên thứ 3 (3rd-party dependencies) muốn thêm vào dự án đều **bắt buộc phải đề xuất và xin phép người dùng trước trong bước lên Plan**.
  - Phải kiểm tra và đảm bảo thư viện an toàn tuyệt đối (không chứa virus/mã độc) và tuân thủ tương thích chuẩn căn chỉnh trang nhớ 16KB (16KB Memory Page Alignment compliance trên Android 15+).

- **Plan Artifact Project Storage Location Rule (QUY TẮC LƯU FILE PLAN VÀO DỰ ÁN):**
  - Tất cả các kế hoạch (Plan) sau khi lập xong phải được lưu thành file Markdown trực tiếp vào thư mục `plan/` trong thư mục gốc của project (ví dụ: `file:///Users/vio/Documents/ViO/Base-Jetpack_2026/plan/`).

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

- **Mandatory Git Discipline & Zero Permission-Spam Mandate (QUY TẮC KỶ LUẬT GIT, CẤM TỰ COMMIT & HẠN CHẾ XIN QUYỀN GIT):**
  - **Tuyệt đối không tự ý commit (Zero Auto-Commit):** AI tuyệt đối KHÔNG BAO GIỜ được tự ý chạy lệnh `git commit` sau các bước nhỏ, task nhỏ, hoặc tự động tạo commit trong quá trình thực thi.
  - **Hạn chế tối đa xin quyền Git (Zero Git Permission Spam):** Cấm chạy các lệnh git (`git add`, `git commit`, `git push`, `git checkout`, v.v.) làm xuất hiện popup xin quyền gây phiền nhiễu và gián đoạn luồng làm việc của người dùng.
  - **Chỉ xin quyền / đề xuất Git khi thực sự cần thiết:**
    1. Khi người dùng chủ động yêu cầu rõ ràng ("commit code", "tạo commit", "push code", v.v.).
    2. Khi hoàn thành toàn bộ một tính năng lớn/cột mốc quan trọng, AI chỉ thông báo tóm tắt thay đổi và HỎI người dùng xem có muốn commit hay không, chứ KHÔNG tự tiện chạy lệnh git trước khi có sự đồng ý.
    3. Mọi quyền quản lý version control để người dùng chủ động thực hiện trên IDE/Terminal của họ hoặc chỉ can thiệp khi được ủy quyền rõ ràng.

- **Mandatory Background Task Cleanup & Non-Lingering Process Rule (QUY TẮC BẮT BUỘC DỌN DẸP TIẾN TRÌNH NGẦM & ĐÓNG TASK NGAY KHI XONG):**
  - Khi chạy bất kỳ lệnh CLI/Gradle nào trong background (background task), sau khi kiểm tra xong output hoặc xác thực build/test thành công, AI **bắt buộc phải kiểm tra `manage_task(Action="list")` và lập tức gọi `manage_task(Action="kill", TaskId=...)`** để đóng luồng I/O và giải phóng hoàn toàn tiến trình ngầm.
  - Tuyệt đối KHÔNG ĐƯỢC để task ngầm ở trạng thái `running` kéo dài trên giao diện UI sau khi công việc đã hoàn thành.
  - Khi chạy lệnh Gradle hoặc build tool, ưu tiên cấu hình timeout hoặc đóng subshell ngay khi lệnh trả về kết quả.

- **The Absolute Hard-Stop Gate in /plan & Planning Mode (QUY TẮC CHỐT CHẶN CỨNG: DỪNG LẠI CHỜ DUYỆT PLAN TUYỆT ĐỐI):**
  - Khi người dùng sử dụng `/plan` hoặc yêu cầu lập kế hoạch kỹ thuật, AI **BẮT BUỘC PHẢI THỰC HIỆN CHỐT CHẶN CỨNG (ABSOLUTE HARD STOP)**:
    1. Chỉ được dùng các công cụ đọc (`view_file`, `grep_search`, `find_by_name`, `read_url_content`) để khảo sát mã nguồn.
    2. Tạo Implementation Plan Artifact với `RequestFeedback = true` và `UserFacing = true` (đồng thời lưu vào thư mục `plan/` của dự án).
    3. **DỪNG LẠI NGAY LẬP TỨC (HARD STOP):** Kết thúc lượt phản hồi mà **KHÔNG ĐƯỢC PHÉP** gọi thêm bất kỳ tool nào chỉnh sửa file (`write_to_file`, `replace_file_content`) hoặc chạy lệnh shell sửa đổi hệ thống trong cùng lượt đó.
    4. **CHỜ DUYỆT TƯỜNG MINH:** Chỉ khi người dùng bấm nút **Proceed** trên Plan Artifact hoặc gửi tin nhắn xác nhận đồng ý ("OK", "Làm đi", "Duyệt"), AI mới được phép bắt tay vào chỉnh sửa code production.
    5. Mọi hành vi "vừa lên plan vừa tự động code luôn trong cùng một lượt" đều bị coi là vi phạm nghiêm trọng kỷ luật kỹ nghệ và bị cấm 100%.

- **Project-Scoped Auto-Approval & Strict Out-of-Project Isolation Mandate (QUY TẮC ỦY QUYỀN TRONG DỰ ÁN & CÁCH LY TUYỆT ĐỐI NGOÀI DỰ ÁN):**
  - **Trong phạm vi Dự án (In-Project Workspace):** Sau khi Kế hoạch (Plan) đã được người dùng phê duyệt, AI được phép tự động tạo và chỉnh sửa file mã nguồn trong các thư mục của dự án (`app/src/main/`, `domain/`, `data/`, `presentation/`, `di/`, `core/`, `plan/`) thông qua các công cụ Native (`write_to_file`, `replace_file_content`) mà không cần hỏi lại từng file đơn lẻ.
  - **Chấm dứt Shell File Creation:** CẤM TUYỆT ĐỐI việc dùng `run_command` chạy các lệnh shell redirect (`cat << 'EOF' > ...`, `echo >`, `tee`) để ghi mã nguồn, nhằm triệt tiêu 100% popup xin quyền shell phiền phức.
  - **Cách ly tuyệt đối Ngoài Dự án (Strict Out-of-Project Boundary):** AI TUYỆT ĐỐI KHÔNG ĐƯỢC TỰ Ý tạo, sửa, ghi đè hoặc xóa bất kỳ file nào nằm NGOÀI THƯ MỤC DỰ ÁN (như file hệ thống OS, `~/.zshrc`, `~/.bash_profile`, Desktop, các thư mục cá nhân). Mọi thao tác ngoài project bắt buộc phải dừng lại và có sự đồng ý rõ ràng từ người dùng.

- **Quick Tag Directive: #policy (QUY TẮC PHÍM TẮT #policy - KIỂM TOÁN CHÍNH SÁCH GOOGLE PLAY):**
  - Khi người dùng gửi tin nhắn chứa `#policy` hoặc yêu cầu kiểm tra chính sách, AI lập tức kích hoạt bộ máy kiểm toán **Google Play Policy & Device/Network Abuse Audit Engine** (theo `rules/38-device-network-abuse-policy.md` và Gate `E29` trong `rules/21-enforcement-engine.md`).
  - Quét toàn diện 6 Trụ cột:
    1. *E29.1 (Zero DCL):* Cấm tuyệt đối tải mã nhị phân động (`.dex`, `.jar`, `.so`), cấm self-update ngoài Google Play.
    2. *E29.2 (Android 14+ FGS):* Kiểm tra `android:foregroundServiceType`, hành vi do user kích hoạt, có thể dừng được, di chuyển tác vụ có thể hoãn sang `WorkManager`.
    3. *E29.3 (REQUIRE_SECURE_ENV):* Bảo vệ chống môi trường giả lập, dual-space, app cloner độc hại bằng `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />`.
    4. *E29.4 (FLAG_SECURE):* Bảo vệ màn hình nhạy cảm bằng `SecureScreenEffect`, cấm phá vỡ `FLAG_SECURE` của app khác.
    5. *E29.5 (WebView Hardening):* Cấm `addJavascriptInterface` trên WebView load URL không an toàn / không kiểm duyệt.
    6. *E29.6 (UIDT & Anti-Proxy):* Ràng buộc API chuyển dữ liệu người dùng khởi xướng, cấm lạm dụng Proxy/VPN ngầm hoặc gian lận ad/game.
- **Zero-Tolerance for AI False Safety Claims & Pre-Flight Vitals Audit Gate (QUY TẮC CẤM CAM KẾT SUÔNG VỀ AN TOÀN - TRIỆT TIÊU CRASH, ANR, LEAK TRƯỚC KHI XUẤT CODE):**
  - **Bối cảnh & Bài học thực tế:** Người dùng thường xuyên phải nhắc nhở AI về việc đảm bảo không crash, ANR, leak do AI thường cam kết suông ("chắc chắn an toàn") nhưng khi chạy thực tế trên thiết bị lại vi phạm nghiêm trọng.
  - **CẤM TUYỆT ĐỐI CAM KẾT BẰNG LỜI (Ban Verbal Guarantees Without Static Audit):** AI tuyệt đối không bao giờ được khẳng định "code này an toàn 100% không crash/ANR/leak" nếu chưa thực hiện **Bảng kiểm điểm tĩnh 3 Trụ Cột (3-Pillar Pre-Flight Audit Checklist)**:
    1. **Trụ cột 1 - Chống Crash (Zero-Crash Gate):**
       - Kiểm tra biên kiểu Nullable (loại bỏ `!!`, bắt buộc null-safe `?.`, `?:` hoặc `requireNotNull` có message).
       - Không nuốt `CancellationException` trong Coroutine (bắt buộc re-throw hoặc dùng `safeLaunch`).
       - Mọi tương tác I/O, mạng, JSON, Room, SDK bên thứ ba PHẢI bọc trong `Result<T>` hoặc `runCatchingSafe`.
       - Xử lý đầy đủ 5-State UI Matrix (đặc biệt là Error và Empty State).
    2. **Trụ cột 2 - Chống Treo Máy (Zero-ANR Gate):**
       - Quỹ thời gian Main Thread: Tối đa 5ms. Bắt buộc offload mọi tác vụ Room, I/O, crypto, nén zip, parse JSON sang `Dispatchers.IO` hoặc `Dispatchers.Default`.
       - CẤM TUYỆT ĐỐI `runBlocking` trên Main Thread hoặc Composable.
       - CẤM tính toán nặng trực tiếp trong body Composable mà không bọc `remember { ... }`.
    3. **Trụ cột 3 - Chống Rò Rỉ Bộ Nhớ (Zero-Leak Gate):**
       - CẤM truyền `Activity` Context vào ViewModel, Repository hay Singleton; chỉ dùng `ApplicationContext` khi thực sự cần.
       - Trong Compose UI: Bắt buộc dùng `collectAsStateWithLifecycle()` thay vì `collectAsState()`.
       - Coroutine bắt buộc gắn với vòng đời: `viewModelScope` trong ViewModel, `rememberCoroutineScope()` trong UI. Cấm `GlobalScope`.
       - Hủy đăng ký listener/callback khi rời composition (`DisposableEffect(Unit) { onDispose { ... } }`).
  - **The Single Source of Truth Preference & Ban on Ad-hoc SharedPreferences (QUY TẮC DUY NHẤT SSOT QUA APPCONFIGMANAGER):**
    - Tuyệt đối CẤM tự ý tạo các file `SharedPreferences` mới khi dự án đã có `DataStoreManager` / `AppConfigManager` làm SSOT.
    - Mọi cấu hình, cờ tính năng, tracking timestamp hay số liệu local đều bắt buộc phải được định nghĩa tập trung qua `AppConfigManager` (kế thừa `BasePreferenceManager`) và `KeyLocalConfig` để đảm bảo 100% tính nhất quán kiến trúc, quản lý tập trung và an toàn bất đồng bộ.

- **Seamless ADB Testing & Execution Policy (QUY TẮC KIỂM THỬ ADB LIỀN MẠCH & TỰ ĐỘNG CHẤP NHẬN):**
  - **Chế độ ADB Testing liền mạch (Seamless Mode):** Khi bước vào phiên kiểm thử / chẩn đoán / tự động hóa thiết bị qua ADB, toàn bộ chuỗi lệnh bắt đầu bằng `adb` (`command(adb)`) được ủy quyền thực thi tự động, không yêu cầu xác nhận lặp lại ở từng lệnh đơn lẻ để quá trình test của AI diễn ra xuyên suốt, không bị ngắt quãng.
  - **Cơ chế Whitelist Vĩnh viễn (Persist to settings.json):** Lệnh `command(adb)` được cấu hình cố định trong danh sách whitelist quyền (`permissions.allow`) của Antigravity CLI để tự động phê duyệt mọi tiền tố `adb` (`adb exec-out`, `adb shell`, `adb logcat`, `adb push/pull`, `adb devices`).
  - **Phạm vi an toàn:** AI tập trung thực hiện các luồng kiểm thử, trích xuất UI hierarchy (`uiautomator dump`), chụp màn hình (`screencap`), bắt log và thao tác input có chủ đích theo yêu cầu phiên làm việc; không tự ý xóa dữ liệu hệ điều hành hay can thiệp ngoài phạm vi ứng dụng đang kiểm thử.

- **Quick Tag Directive: #rever / #reverse / #revers (QUY TẮC PHÍM TẮT #rever - THẨM ĐỊNH TĨNH & DỊCH NGƯỢC APK/APKS TỰ ĐỘNG TOÀN DIỆN):**
  - **Kích hoạt & Định danh:** Nhận diện các trigger `#rever`, `#reverse`, hoặc `#revers` kèm đường dẫn file `.apk`, `.apks`, `.xapk`.
  - **Ủy quyền tự động liền mạch (Seamless Execution - Tự động cấp mọi quyền):** AI được cấp quyền thực thi tự động xuyên suốt từ đầu đến cuối đối với toàn bộ chuỗi lệnh (giải nén, JADX decompile, AXML parsing, regex pattern scan) mà không dừng lại xin xác nhận trung gian, đảm bảo phiên kiểm toán diễn ra 100% tự chủ và tức thì.
  - **Tự động định danh theo Package Name (Auto Package-Named Report):** Trích xuất chính xác `package_name` của app và tự động xuất file báo cáo Markdown độc lập tại `./<package_name>_audit_report.md` trong thư mục làm việc, đồng thời hiển thị bảng tóm lược cho người dùng.

- **The Zero-Compromise Dev & QA Adversarial Separation Mandate (QUY TẮC PHÂN TÁCH ĐỐI KHÁNG TUYỆT ĐỐI DEV & QA — QA KHÔNG BAO GIỜ THỎA HIỆP VỚI DEV):**
  - **Tập trung tối đa vào cặp đối kháng cốt lõi `dev-builder` (Write) vs. `qa-enforcer` (Read-Only):** Loại bỏ hoàn toàn tình trạng tự viết code rồi tự review trên cùng một phiên làm việc gây thiên kiến tự duyệt (Confirmation Bias).
  - **4 Chốt Chặn Chống Thỏa Hiệp (4 Anti-Compromise Locks):**
    1. *Blind-Context Isolation (Cô lập ngữ cảnh mù):* Subagent `qa-enforcer` BẮT BUỘC được khởi tạo bằng `define_subagent` và chạy qua `invoke_subagent` trên một **Fresh Context mới 100%**. QA không nhận lịch sử hội thoại hay lời trần tình của Dev; QA chỉ nhận: (1) Yêu cầu gốc / `spec.md`, (2) `git diff` thực tế của các file vừa sửa, và (3) Log kết quả chạy test.
    2. *Hard Read-Only Lock (`enable_write_tools = false`):* Tước bỏ hoàn toàn quyền ghi file của `qa-enforcer` ở tầng công cụ. QA tuyệt đối không được tự ý sửa code hộ Dev hay hạ thấp điều kiện assert trong test.
    3. *Binary Guillotine Verdict (Phán quyết nhị phân — Cấm cảnh báo mềm):* Cấm QA dùng từ ngữ giảm nhẹ (*minor, nitpick, optional, tạm chấp nhận*). Phán quyết của QA chỉ có 2 trạng thái: **`VERDICT: APPROVED` (0 lỗi)** hoặc **`VERDICT: REJECTED` (Bác bỏ toàn bộ)**. Chỉ cần 1 vi phạm Gate (`E1–E38`), thiếu 1 kịch bản biên trong ma trận 6 chiều, hoặc thiếu log test thật là lập tức `REJECTED`.
    4. *No-Argue Remediation Loop (Lệnh cấm cãi & Quyền phủ quyết tối thượng):* Phán quyết của QA là quyền phủ quyết tối thượng (Absolute Veto). Khi bị `REJECTED`, `dev-builder` bị cấm biện minh hay xin miễn trừ, bắt buộc phải sửa triệt để 100% các mục `[DEFECT-ID]` theo chuẩn Rule 41 (viết test tái hiện đỏ ➔ sửa code xanh) và nộp lại cho đến khi `qa-enforcer` cấp chứng chỉ `VERDICT: APPROVED`.

- **Self-Documenting Identifier, Coding Convention, Least-Privilege Access Modifiers & Compose Modifier Hygiene Mandate (QUY TẮC ĐẶT TÊN TỰ MÔ TẢ, CODING CONVENTION, ACCESS MODIFIER TỐI THIỂU & COMPOSE MODIFIER — GATES E4.6 & E28.6–E28.10):**
  - **1. Cấm biến 1 ký tự & viết tắt tối nghĩa (`Gate E28.6`):**
    - Cấm tuyệt đối biến cục bộ, tham số hàm, vòng lặp, lambda hoặc `catch` dùng 1 chữ cái (`x, c, p, d, w, g, s, r, b, n, h, e, k, v, a, f, q, t`) hoặc từ viết tắt 2–3 ký tự mơ hồ (`rt, pc, fc, st, bh, nh, fh, fs, t0, dt, ctx, req, cfg, bg, fb, cd, mv, mc, cb, cCfg, sCfg, bJob, rJob, cJob`).
    - Bắt buộc dùng tên `camelCase` tự mô tả kèm đơn vị (`placementConfig`, `activeRuntime`, `startTimeMs`, `elapsedDeltaMs`, `cancellationException`, `throwable`, `viewContext`).
  - **2. Cấm số/chuỗi cấu hình trôi nổi trong logic (`Zero Magic Literals — Gate E28.7`):**
    - Cấm viết trực tiếp các con số thời gian, giới hạn retry, kích thước trang, hệ số alpha trong hàm logic (`delay(3000)`, `retry > 3`, `alpha = 0.38f`). Bắt buộc tách thành `private const val` viết hoa `UPPER_SNAKE_CASE` có hậu tố đơn vị và dấu `_` phân cách hàng nghìn (`private const val RETRY_DELAY_MS = 3_000L`, `private const val MAX_RETRY_ATTEMPTS = 3`).
  - **3. Đặt tên Boolean khẳng định & Bất biến 100% trong `data class` (`Gate E28.8`):**
    - Mọi biến, thuộc tính, tham số hoặc hàm trả về `Boolean` bắt buộc có tiền tố khẳng định (`is*`, `has*`, `can*`, `should*`, `was*`, `allows*`, `supports*`); cấm đặt tên danh từ trống (`loading`, `error`) hoặc phủ định kép (`isNotDisabled`).
    - Cấm tuyệt đối từ khóa `var` và các kiểu tập hợp khả biến (`MutableList`, `MutableSet`, `MutableMap`) lọt vào `data class` của `UiState`, `Intent`, `Effect`, hoặc `Domain Model`.
  - **4. Bắt buộc Named Arguments khi gọi hàm nhiều tham số cùng kiểu (`Gate E28.9`):**
    - Bắt buộc ghi rõ tên tham số (`forceRefresh = true`, `includeArchived = false`) tại nơi gọi hàm khi truyền từ $\ge 2$ tham số `Boolean`, $\ge 2$ tham số cùng kiểu đứng cạnh nhau, hoặc hàm có $\ge 4$ tham số trở lên.
  - **5. Đóng kín Access Modifier tối đa cho CẢ App lẫn SDK (`Strict Least-Privilege Visibility — Gate E28.10`):**
    - Áp dụng `internal` / `private` mặc định cho toàn bộ dự án (cả App/Feature module lẫn SDK module): Mọi class triển khai (`*ViewModel`, `*RepositoryImpl`, `*DataSource`, `*Dao`, `*Entity`, `*Dto`, `*Mapper`, `*UseCase`, Koin `*Module`) bắt buộc khai báo **`internal`** trừ khi cần mở qua ranh giới module.
    - Mọi hàm phụ trợ, sub-composable, hàm `@Preview`, và hằng số trong phạm vi 1 file bắt buộc là **`private`**.
    - Trong `BaseViewModel`, biến `_state` bắt buộc là **`private`** (chỉ cập nhật qua `protected fun setState { copy(...) }`), cấm mở `open class` hoặc `protected var` làm rò rỉ trạng thái.
  - **6. Quy chuẩn nhận & truyền `modifier: Modifier = Modifier` trong Compose (`Gate E4.6`):**
    - **Root-Only `modifier`:** Mọi `@Composable` tái sử dụng (`*Screen`, `*Content`, `*Card`, `*Item`, `*Component`) bắt buộc nhận `modifier: Modifier = Modifier` và **chỉ gắn biến `modifier` (chữ `m` thường) đúng 1 lần duy nhất vào node gốc ngoài cùng (Root Layout)**. Tất cả các node con bên trong cấm dùng lại biến `modifier` của hàm mà phải khởi tạo mới từ `Modifier` (chữ `M` hoa).
    - **Thứ tự tham số hàm `@Composable` chuẩn:** `(1) State/Data bắt buộc` ➔ `(2) Callbacks/Intents bắt buộc` ➔ `(3) modifier: Modifier = Modifier` (luôn là tham số optional đầu tiên) ➔ `(4) Các tham số optional khác` ➔ `(5) Content slot @Composable () -> Unit` (luôn ở cuối cùng).

- **The Mandatory Dev Mirror Self-Review Protocol (QUY TẮC BẮT BUỘC DEV TỰ SOI GƯƠNG LẠI CHÍNH CODE CỦA MÌNH TRƯỚC KHI BÀN GIAO — RULE 42 & GATE E39):**
  - **Phân Định Rạch Ròi (Cấm Tự Nghiệm Thu vs. Bắt Buộc Tự Soi Gương):**
    - *Self-Approval (Tự ký duyệt thay QA):* CẤM TUYỆT ĐỐI. `dev-builder` không bao giờ được thay thế `qa-enforcer`.
    - *Mirror Self-Review (Tự soi gương lại bản nháp đầu tiên):* BẮT BUỘC 100% đối với **cả subagent `dev-builder` VÀ Main Agent** sau mỗi lần viết/sửa code. Triệt tiêu hoàn toàn hội chứng "First-Draft Dump" (viết code xong ném đi ngay không đọc lại).
  - **Chu Trình 4 Bước Tự Soi Gương Bắt Buộc (The 4-Step Mirror Protocol — Gate E39):**
    1. *Bước 1 — Đọc Lại File Thực Tế Trên Đĩa (`Physical Read-Back — E39.1`):* Ngay sau khi hoàn tất `write_to_file` / `replace_file_content` (Draft 1), bắt buộc phải gọi `view_file` (và `git diff` nếu cần) để đọc lại 100% các file vừa tạo/sửa bằng đôi mắt phản biện mới, kiểm tra tổng thể mặt chữ, cấu trúc ghép nối và import.
    2. *Bước 2 — Rà Soát Qua 5 Gương Phản Chiếu (`5-Mirror Lens Audit — E39.2`):*
       - **Gương 1 (Minimalism — Rule 32):** Có import thừa, biến trung gian vô ích, hàm wrapper rỗng hay lặp code không?
       - **Gương 2 (Coding Conventions, Naming & Access Modifiers — Gates E28.6–E28.10):** Có lọt biến 1 ký tự / viết tắt tối nghĩa (`E28.6`), số magic literal (`E28.7`), tên boolean thiếu `is/has/can/should` hoặc `var`/`MutableList` trong `data class` (`E28.8`), thiếu named arguments (`E28.9`), thiếu `internal`/`private` access modifier (`E28.10`), hay comment rác không?
       - **Gương 3 (Vitals Survival — Gate E38):** Có điểm nào tiềm ẩn Crash (`!!`, nuốt `CancellationException`, thiếu `Result<T>`), ANR (tính toán/I/O trên Main, thiếu `remember` trong `@Composable`), hay Leak (`Activity` Context, thiếu `collectAsStateWithLifecycle`, quên `onDispose` / `_binding = null`) không?
       - **Gương 4 (Architecture, Compose Modifier & UI Purity — Gates E1–E4.6, E25, E35, E36):** Đã chuẩn `_state.update { copy(...) }`, đủ 5-State UI, 100% token `AppTheme`, XML Vector Drawables (0 emoji), `LazyColumn` có `key`/`contentType`, vùng chạm $\ge 48\text{dp}$, `modifier` chỉ gắn 1 lần ở Root node & đúng thứ tự tham số `@Composable` (`E4.6`) chưa?
       - **Gương 5 (6-Dimension Edge Cases — Gate E31):** Đã chặn chuỗi rỗng/tràn, bấm liên thanh `< 400ms`, đua bất đồng bộ và khôi phục `SavedStateHandle` sau Process Death chưa?
    3. *Bước 3 — Tự Gọt Giũa Ngay Lập Tức (`Draft 1 ➔ Clean Draft 2`):* Tự sửa sạch mọi điểm gợn phát hiện được trong lúc soi gương trước khi chạy bộ test cuối cùng.
    4. *Bước 4 — Xuất Biên Bản Tự Soi Gương (`Mirror Evidence Block — E39.3`):* Bắt buộc in mục **`🪞 Dev Mirror Self-Review`** trong báo cáo bàn giao/hoàn thành, nêu rõ: (a) Danh sách file đã đọc lại bằng `view_file`, (b) Các lỗi/điểm gợn ở bản nháp 1 đã tự phát hiện và tự gọt giũa sang bản nháp 2, và (c) Trạng thái vượt qua 5 Gương trước khi chuyển sang `qa-enforcer`.

- **The Bounded 3-Round QA Convergence & Circuit-Breaker Mandate (QUY TẮC HỘI TỤ QA TỐI ĐA 3 VÒNG & CẦU DAO NGẮT MẠCH — RULE 42 & GATE E40):**
  - **Bối cảnh & Lý do cốt lõi:** Hai Agent `dev-builder` và `qa-enforcer` khi nói chuyện qua lại rất dễ rơi vào vòng lặp vô tận (có thể kẹt > 50 vòng tốn hàng đống token mà không xong việc). Thống kê thực tế chỉ ra rằng ở các vòng sau, Reviewer hiếm khi bắt thêm được bug thực sự mới, và **59% lỗi bị nhai đi nhai lại thực chất đã nằm ở đó ngay từ lượt review đầu tiên** nhưng bị báo lẻ tẻ hoặc dịch chuyển tiêu chuẩn (Moving Goalposts).
  - **4 Định Luật Hội Tụ QA Bắt Buộc (The 4 Laws of Bounded QA Convergence — Gate E40):**
    1. *Định Luật 1 — Giới Hạn Tối Đa 3 Vòng & Cầu Dao Ngắt Mạch (`Max 3 Rounds & Circuit Breaker — Gate E40.1`):*
       - Khóa cứng số vòng kiểm định tối đa cho mỗi Task/PR là `MAX_QA_ROUNDS = 3`.
       - Nếu hết Vòng 3 mà `qa-enforcer` vẫn phán quyết `VERDICT: REJECTED`: BẮT BUỘC kích hoạt cầu dao **`🛑 CIRCUIT BREAKER TRIGGERED: ARCHITECTURAL PIVOT REQUIRED`**, lập tức **DỪNG VIỆC VÁ CODE (STOP PATCHING)**, tổng hợp báo cáo giải phẫu nguyên nhân gốc rễ qua 3 vòng và đề xuất 2 phương án đổi hướng tiếp cận/kiến trúc mới (Architectural Pivot Options), sau đó **HARD STOP** chờ người dùng quyết định. Tuyệt đối cấm tự ý chạy sang Vòng 4.
    2. *Định Luật 2 — Chỉ Review Diff Mới Ở Vòng 2 & 3 (`Delta-Only Scope — Gate E40.2`):*
       - **Vòng 1:** Quét toàn diện 100% phạm vi các file tạo mới/sửa đổi (Full-Scope Audit).
       - **Vòng 2 & Vòng 3:** Khoanh vùng nghiêm ngặt — `qa-enforcer` chỉ được phép kiểm tra: (a) Các cụm lỗi `[CLUSTER-XX]` từ vòng trước đã được giải quyết dứt điểm chưa, và (b) Phần **Delta Diff** (những dòng code vừa mới sửa đổi ở vòng hiện tại cùng các hàm gọi trực tiếp tới chúng). Cấm quét lại từ đầu những vùng code không hề thay đổi.
    3. *Định Luật 3 — Gom Bug Theo Loại & Quét Sạch Hệ Thống (`Pattern-Clustered Defect Batching & Systemic Sweep — Gate E40.3`):*
       - **Phía `qa-enforcer`:** Cấm tuyệt đối kiểu bắt lỗi nhỏ giọt (mỗi vòng nhả ra 1 vị trí). Ngay tại Vòng 1, nếu phát hiện 1 loại lỗi vi phạm Gate, phải gom toàn bộ mọi vị trí xuất hiện lỗi cùng loại trên tất cả các file vào một cụm duy nhất: `[CLUSTER-01] [Gate EXX.X] [Tên Loại Lỗi] -> [fileA:line1, fileA:line2, fileB:line3]`.
       - **Phía `dev-builder`:** Khi nhận 1 `[CLUSTER-XX]`, cấm chỉ sửa đối phó đúng dòng được chỉ điểm. Bắt buộc phải thực hiện **Quét Sạch Toàn Cục (Systemic Codebase Sweep)** để diệt tận gốc 100% các chỗ tương tự trong toàn bộ code vừa viết ngay trong 1 lần fix.
    4. *Định Luật 4 — Không Dịch Chuyển Đích & Không Nhai Lại Chuyện Cũ (`Zero Moving Goalposts & No Re-Litigation — Gate E40.4 = 4A + 4B`):*
       - **4A (Cấm đào bới lỗi mới trên code cũ ở Vòng 2–3):** Bất kỳ đoạn code nào đã có mặt từ Vòng 1, không bị sửa đổi ở Vòng 2–3 và không bị bắt lỗi ở Vòng 1 sẽ được đóng băng (Grandfathered). `qa-enforcer` bị CẤM TUYỆT ĐỐI việc ở Vòng 2–3 lại lôi code cũ của Vòng 1 ra bắt lỗi mới để tránh hiện tượng dịch chuyển đích đến (59% lỗi thực chất nằm ở đó từ Vòng 1).
       - **4B (Sổ cái trạng thái tinh gọn — Không tranh luận lại chuyện cũ):** Ở Vòng 2–3, các cụm lỗi cũ chỉ được ghi nhận ngắn gọn trên bảng trạng thái (`[CLUSTER-01]: RESOLVED ✅` hoặc `UNRESOLVED ❌ [vị trí còn sót]`), cấm viết lại diễn giải dài dòng hay nhai đi nhai lại các lỗi đã đóng.

---

# Final Rule

User Preference Memory exists to improve long-term collaboration.

The AI should adapt to how the user prefers to work,

while always respecting explicit instructions, project standards, and sound engineering practices.