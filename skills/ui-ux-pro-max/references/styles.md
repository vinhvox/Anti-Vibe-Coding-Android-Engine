# UI Styles & Visual Layout Patterns Catalog (240+ Styles)

## 1. Primary Design Systems & Visual Paradigms

### A. Material Design 3 (Google M3)
- **Use Cases:** Default choice for Android Jetpack Compose, cross-platform apps requiring system integration.
- **Key Characteristics:** Dynamic Color (Monet), Tonal Elevation, Material You color roles (Primary, Secondary, Tertiary, Surface, Container roles).
- **Surface Elevation:** Uses tonal color fills instead of heavy drop shadows.
- **Corner Radii:** Expressive shapes (Extra Small: 4dp, Small: 8dp, Medium: 12dp, Large: 16dp, Extra Large: 28dp, Full: 50%).

### B. Minimalist & Clean Functional Design
- **Use Cases:** E-Commerce, Productivity tools, Reader apps, Document management.
- **Key Characteristics:** Maximum whitespace, high contrast display fonts, 1px subtle surface borders, zero drop shadows.
- **Color Usage:** 90% neutral surfaces (white, off-white, dark gray), 10% high-intent accent color reserved for primary CTAs.

### C. Glassmorphism & Frosted Surfaces
- **Use Cases:** Overlay headers, bottom sheets, sticky action bars, media players.
- **Key Characteristics:** Semi-transparent surface fills (`rgba(255,255,255, 0.7)` or `rgba(30,30,30, 0.75)`), backdrop blur (`16px-24px`), ultra-subtle border stroke (`rgba(255,255,255, 0.15)`).
- **Rule:** Never use glassmorphism on scrollable main body cards. Use ONLY for floating UI layers.

### D. Bento Grid Layouts
- **Use Cases:** Dashboards, Feature highlights, Landing page hero sections, Category hubs.
- **Key Characteristics:** Asymmetric grid cards, varied card span sizes (1x1, 2x1, 2x2), consistent gap spacing (12dp-16dp), subtle elevation.
- **Rule:** Each card MUST present a distinct content type (e.g., metric, chart, action shortcut, preview thumbnail). Do not stuff unrelated decorative icons.

### E. Editorial & Typography-First Design
- **Use Cases:** News apps, Blogs, Luxury e-commerce, Portfolio applications.
- **Key Characteristics:** Large expressive serifs or bold display sans-serifs, asymmetric column grids, generous line height (1.5-1.6x), quote blocks, drop caps.

---

## 2. Component Layout Patterns

### A. Defensive Screen Containers
- **Loading State:** Shimmer animation skeletons matching exact component dimensions (never generic full-screen spinners).
- **Empty State:** High-quality illustration/icon, clear descriptive header, helpful explanation, primary action button to resolve empty state.
- **Error State:** Human-readable error description, retry action CTA, offline indicator if connection lost.

### B. Action Placement Rules
- **Primary CTA:** Bottom right or full-width sticky bottom bar for mobile screens (thumb zone accessibility).
- **Secondary Actions:** Text buttons or subtle tonal surface buttons.
- **Destructive Actions:** Outlined red/error container button with confirmation sheet/dialog.
