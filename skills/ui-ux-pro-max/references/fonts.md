# Font Pairings & Typographic System (150+ Pairings)

## 1. Expressive Typographic Pairings

### A. Corporate Tech & Modern SaaS
- **Header Font:** Inter / Plus Jakarta Sans (Weight: 700/800, Tracking: `-0.02em`)
- **Body Font:** Inter / System UI (Weight: 400/500, Line Height: `1.5`)
- **Use Case:** Dashboards, Admin Panels, Developer Tools, Productivity Apps.

### B. Fintech & Modern Banking
- **Header Font:** Outfit / Manrope (Weight: 700, Tracking: `-0.01em`)
- **Body Font:** Manrope / Public Sans (Weight: 400, Line Height: `1.5`)
- **Numeric Font:** Tabular figures (`fontFeatureSettings = "tnum"`) for financial balance values.

### C. Editorial & Luxury Retail
- **Header Font:** Playfair Display / Fraunces (Weight: 600/700, Serif)
- **Body Font:** Lora / Source Serif Pro (Weight: 400, Line Height: `1.6`)
- **Use Case:** News Reader, E-Commerce Luxury Items, High-end Articles.

### D. Clean Minimalist & Mobile Tools
- **Header Font:** Roboto / SF Pro Display (Weight: 600)
- **Body Font:** Roboto / SF Pro Text (Weight: 400/500, Line Height: `1.45`)
- **Use Case:** Jetpack Compose Default Mobile Utilities, File Managers, Utility Tools.

---

## 2. Typographic Scale Rules (Sp & Dp Hierarchy)

| Level | Size (sp) | Line Height (sp) | Weight | Letter Spacing / Tracking |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | 36sp | 44sp | Bold (700) | `-0.025em` (`-0.5sp`) |
| **Display Medium**| 28sp | 36sp | Bold (700) | `-0.02em` (`-0.4sp`) |
| **Headline Large** | 24sp | 32sp | SemiBold (600)| `-0.01em` (`-0.2sp`) |
| **Headline Medium**| 20sp | 28sp | SemiBold (600)| `0em` |
| **Title Medium** | 16sp | 24sp | Medium (500) | `0.01em` (`0.1sp`) |
| **Body Large** | 16sp | 24sp | Normal (400) | `0.01em` (`0.1sp`) |
| **Body Medium** | 14sp | 20sp | Normal (400) | `0.015em` (`0.2sp`) |
| **Label Small** | 11sp | 16sp | Medium (500) | `0.02em` (`0.3sp`) |

---

## 3. Typographic Constraints & Anti-Patterns
- Never combine more than 2 distinct font families in a single application.
- Display headings must always use negative or neutral letter-spacing. Never apply positive tracking to large bold titles.
- Caption / Label text (sizes < 12sp) must always use medium/semibold weight and positive tracking for legibility.
