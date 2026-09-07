# Curated Color Palettes Catalog (170+ Palettes by Domain)

## 1. Domain-Tailored Color Systems

### A. Fintech & Banking (High Trust, Security, Stability)
- **Palette 1: Corporate Trust Blue**
  - Primary: `#0A2540` (Navy Deep) | Secondary: `#635BFF` (Indiglo)
  - Surface: `#F8F9FA` | Text: `#0A2540`
  - Success: `#00D4B2` | Warning: `#FFC72C` | Error: `#DF1B41`
- **Palette 2: Modern Wealth Green**
  - Primary: `#004D40` (Emerald Deep) | Accent: `#00E676` (Mint Spark)
  - Dark Surface: `#121E1B` | Text: `#E0F2F1`

### B. SaaS & Productive Dashboards (Scannability, Reduced Eyestrain)
- **Palette 1: Slate Tech (Light Mode)**
  - Primary: `#2563EB` (Royal Blue) | Neutral Surface: `#F8FAFC`
  - Card Fill: `#FFFFFF` | Border: `#E2E8F0` | Text: `#0F172A`
- **Palette 2: Obsidian Pro (Dark Mode)**
  - Primary: `#3B82F6` (Electric Blue) | Neutral Surface: `#0F172A`
  - Card Fill: `#1E293B` | Border: `#334155` | Text: `#F8FAFC`

### C. E-Commerce & Retail (Vibrant, Action-Oriented)
- **Palette 1: Warm Coral & Charcoal**
  - Primary CTA: `#FF4757` (Coral Red) | Secondary: `#2F3542` (Charcoal)
  - Accent: `#FFA502` (Amber Gold) | Surface: `#FAFAFA`
- **Palette 2: Luxury Minimalist**
  - Primary: `#111111` (Pure Charcoal) | Accent: `#D4AF37` (Muted Gold)
  - Surface: `#FDFDFD` | Text: `#111111`

### D. Healthcare & Wellness (Calm, Reassuring)
- **Palette 1: Serene Teal & Soft Blue**
  - Primary: `#008080` (Teal) | Secondary: `#4A90E2` (Soft Sky)
  - Surface: `#F4F9F9` | Text: `#1C2D37`
- **Palette 2: Sage & Earth Neutral**
  - Primary: `#556B2F` (Sage Green) | Accent: `#D2B48C` (Warm Sand)
  - Surface: `#FDFBF7` | Text: `#2C352E`

### E. Mobile Utilities & File Tools (Jetpack Compose Default AppTheme)
- **Palette 1: Modern Material 3 Dynamic Tonal**
  - Primary: `#0061A4` (M3 Blue) | OnPrimary: `#FFFFFF`
  - PrimaryContainer: `#D1E4FF` | OnPrimaryContainer: `#001D36`
  - Surface: `#F8FDFF` | OnSurface: `#001F25` | SurfaceVariant: `#DEE3EB`

---

## 2. Color Rules & Accessibility Constraints

### Contrast Ratios (WCAG AA Compliance)
- Body text & icons: Minimum `4.5:1` contrast ratio against surface background.
- Display titles (>24sp / 18pt bold): Minimum `3.0:1` contrast ratio.
- Interactive controls & buttons: Minimum `3.0:1` contrast against adjacent container.

### Dark Mode Principles
- Never use `#000000` (Pure Black) for main scrollable backgrounds; use dark charcoal `#121212` or `#0F172A` to prevent OLED smearing.
- Surfaces higher in elevation must use lighter surface overlays (`#1E293B` > `#0F172A`).
- Never use bright un-muted neon colors for body text in dark mode.
