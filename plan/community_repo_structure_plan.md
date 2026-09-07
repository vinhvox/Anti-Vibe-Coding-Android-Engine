# KẾ HOẠCH TRIỂN KHAI: ĐÓNG GÓI REPOSITORY MÃ NGUỒN MỞ ANTIGRAVITY ANDROID OS
> **Scope:** Thư mục hiện tại (`file:///Users/vio/Documents/ViO/antigravity-android-os/`)  
> **Cam kết cốt lõi:** **TUYỆT ĐỐI KHÔNG CHỈNH SỬA BẤT KỲ FILE NÀO TRONG `~/.antigravity/`**  
> **Trạng thái:** Chờ người dùng phê duyệt (Approval Gate)

---

## 1. MỤC TIÊU (GOAL DESCRIPTION)
Khởi tạo và đóng gói toàn bộ hệ sinh thái **Antigravity AI Engine (Android Framework)** thành một GitHub Repository mã nguồn mở hoàn chỉnh, tiêu chuẩn quốc tế ngay tại thư mục hiện hành (`/Users/vio/Documents/ViO/antigravity-android-os/`), sẵn sàng để `git push` lên GitHub cho cộng đồng lập trình viên Android toàn cầu sử dụng.

---

## 2. NGUYÊN TẮC AN TOÀN & BẢO TOÀN DỮ LIỆU
> [!IMPORTANT]
> **BẢO MẬT & CÁCH LY TUYỆT ĐỐI `~/.antigravity/`:**
> 1. Thư mục cá nhân của bạn tại `~/.antigravity/` chỉ đóng vai trò là **nguồn tham chiếu chỉ đọc (READ-ONLY SOURCE)**.
> 2. Mọi thao tác ghi tệp (`write_to_file`) **chỉ được phép thực hiện bên trong thư mục hiện tại**: `/Users/vio/Documents/ViO/antigravity-android-os/`.
> 3. Không có bất kỳ lệnh nào chạm vào hoặc làm biến đổi cấu hình đang hoạt động của bạn tại `~/.antigravity/`.

> [!TIP]
> **TIÊU CHUẨN KHỬ NHIỄM (SANITIZATION STANDARD):**
> * Toàn bộ các chuỗi `/Users/vio/.antigravity/` được chuyển đổi thành biến môi trường động `${ANTIGRAVITY_HOME:-$HOME/.antigravity}` hoặc `~/.antigravity`.
> * Toàn bộ thông tin dự án cá nhân trong bộ nhớ được di chuyển thành tệp mẫu `templates/memory/*.template.md`.

---

## 3. CẤU TRÚC THƯ MỤC REPOSITORY MẪU SẼ TẠO

```
antigravity-android-os/
├── .github/
│   ├── workflows/
│   │   └── lint-and-validate.yml         # CI tự động kiểm tra cú pháp rules & links
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md                 # Mẫu báo cáo lỗi
│       └── feature_request.md            # Mẫu đề xuất rule / skill mới
├── bin/
│   └── agy-doctor                        # CLI tiện ích kiểm tra môi trường
├── brain/                                # 11 Động cơ nhận thức (Đã khử nhiễm path)
│   ├── 00-master-cognition.md
│   ├── 01-communication-engine.md
│   ├── ...
│   └── 11-learning-engine.md
├── rules/                                # 37 Quy tắc chuẩn & Gates E1-E28 (Đã khử nhiễm path)
│   ├── 00-system-mandate.md
│   ├── 01-architecture-standard.md
│   ├── 21-enforcement-engine.md
│   ├── 31-mobile-engineering-core.md
│   ├── 36-ui-ux-design-standard.md
│   └── 37-ubiquitous-language-standard.md
├── workflow/                             # 10 Quy trình kỹ thuật chuyên biệt (Đã khử nhiễm path)
│   ├── 00-master-workflow.md
│   ├── 01-requirement-analysis-workflow.md
│   └── ...
├── skills/                               # Bộ kỹ năng chuyên sâu (Đã khử nhiễm path)
│   ├── ask-cto/
│   ├── ui-ux-pro-max/
│   ├── mobile-engineering-core/
│   ├── app-quality-vitals/
│   ├── stack-heap-memory/
│   ├── ponytail-minimalist/
│   ├── spec-driven-development/
│   └── systematic-debugging/
├── memory/                               # Tầng ký ức tổng quát (Generic Core)
│   ├── 00-memory-core.md
│   ├── 01-project-memory.md              # Cấu hình chuẩn Android Modern Generic
│   ├── 02-session-memory.md
│   ├── 03-task-memory.md
│   ├── 04-decision-memory.md
│   ├── 05-pattern-memory.md
│   └── 06-user-preference-memory.md      # Quy tắc kỹ thuật phổ quát (Zero-Crash, Anti-AI Slop)
├── templates/                            # Mẫu khởi tạo cho người dùng mới
│   ├── project-memory.template.md        # File mẫu để dev điền thông tin app của họ
│   └── user-preference.template.md       # File mẫu để dev điền sở thích cá nhân
├── scripts/                              # Bộ công cụ tự động hóa
│   ├── install.sh                        # One-line installer cho macOS & Linux
│   ├── doctor.sh                         # Chẩn đoán môi trường (JDK 17+, Android SDK, agy CLI)
│   └── uninstall.sh                      # Gỡ cài đặt sạch sẽ
├── docs/                                 # Tài liệu kiến trúc chuyên sâu
│   ├── architecture-overview.md          # Sơ đồ 8 tầng nhận thức
│   └── quickstart.md                     # Hướng dẫn tích hợp trong 2 phút
├── .context-digest.md                    # Bản tóm lược siêu nén (~5.4K tokens)
├── INDEX.md                              # Bảng chỉ mục toàn diện
├── README.md                             # Trang chủ GitHub chuẩn mực quốc tế
├── LICENSE                               # Giấy phép Apache 2.0
├── CONTRIBUTING.md                       # Hướng dẫn đóng góp cộng đồng
└── install.sh -> scripts/install.sh      # Symlink hoặc shortcut installer ở root
```

---

## 4. DANH SÁCH CÁC BƯỚC THỰC THI (TRACER-BULLET VERTICAL SLICES)

### Lát cắt 1: Thiết lập Bộ khung Gốc & Hồ sơ Open-Source
- [NEW] `LICENSE`: Cấp phép mã nguồn mở Apache 2.0.
- [NEW] `CONTRIBUTING.md`: Hướng dẫn cộng đồng cách đóng góp rules và skills.
- [NEW] `.github/workflows/lint-and-validate.yml`: GitHub Action kiểm tra tính toàn vẹn markdown và cross-links.

### Lát cắt 2: Khử nhiễm & Xuất bản 4 Trụ Cột Core (`brain/`, `rules/`, `workflow/`, `skills/`)
- Đọc nội dung từ `~/.antigravity/` ➔ Thực hiện làm sạch biến đường dẫn tuyệt đối `/Users/vio/.antigravity` thành `${ANTIGRAVITY_HOME:-$HOME/.antigravity}` ➔ Ghi vào thư mục cục bộ của dự án.
- Tinh chỉnh `rules/00-system-mandate.md` và `workflow/00-master-workflow.md` để tự động nhận diện thư mục cài đặt linh hoạt.

### Lát cắt 3: Chuẩn hóa Memory & Tạo Templates Cho Cộng Đồng
- [NEW] `memory/templates/project-memory.template.md`: Bản mẫu chuẩn để bất kỳ dự án Android nào cũng có thể kế thừa.
- [NEW] `memory/templates/user-preference.template.md`: Bản mẫu thiết lập phong cách lập trình.
- [NEW] `memory/01-project-memory.md`: Bản cấu hình gốc tổng quát (Modern Jetpack Compose 2026, Navigation 3, Clean Architecture, Koin, Ktor).

### Lát cắt 4: Bộ Cài Đặt Tự Động (One-Line Installer & Doctor)
- [NEW] `scripts/install.sh`: Script tự động clone hoặc link vào `$HOME/.antigravity`, kiểm tra biến môi trường và tạo shortcut.
- [NEW] `scripts/doctor.sh`: Kiểm tra sự tồn tại của JDK 17+, Android SDK, Git, và Antigravity CLI.

### Lát cắt 5: Biên Soạn `README.md` Đẳng Cấp Quốc Tế
- Soạn thảo `README.md` với:
  - Hero Header & Badges (Jetpack Compose, Navigation 3, Zero-Crash Vitals).
  - Tuyên ngôn giá trị: **"The Anti-Vibe-Coding Android Engine"** — So sánh trực quan giữa AI thông thường và Antigravity CTO Engine.
  - Sơ đồ nhận thức 8 tầng (Mermaid diagrams).
  - Quickstart: Cài đặt chỉ với 1 dòng lệnh terminal.

---

## 5. KẾ HOẠCH KIỂM THỬ & XÁC MINH (VERIFICATION PLAN)

### 1. Kiểm tra Khử Nhiễm Tuyệt Đối (Sanitization Audit):
```bash
# Quét toàn bộ repo cục bộ, đảm bảo không còn bất kỳ dấu vết nào của /Users/vio/
grep -rn "/Users/vio" . --exclude-dir=plan --exclude-dir=.git
# Kết quả mong đợi: Trống (0 kết quả)
```

### 2. Kiểm tra Tính Toàn Vẹn `~/.antigravity/`:
```bash
# Xác nhận thư mục ~/.antigravity không bị thay đổi thời gian sửa đổi (mtime)
stat -f "%Sm" /Users/vio/.antigravity
```

### 3. Kiểm tra Chạy Thử Script Cài Đặt:
```bash
# Kiểm tra cú pháp shell script
bash -n scripts/install.sh
bash -n scripts/doctor.sh
```

---

## 6. XÁC NHẬN TỪ NGƯỜI DÙNG (APPROVAL GATE)

Kính mời bạn xem xét bản kế hoạch trên. Nếu bạn đồng ý với cấu trúc và phương án khử nhiễm này, vui lòng phản hồi để tôi tiến hành khởi tạo từng lát cắt mã nguồn một cách tuần tự và an toàn!
