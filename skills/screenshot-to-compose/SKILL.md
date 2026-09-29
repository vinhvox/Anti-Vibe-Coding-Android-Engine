---
name: screenshot-to-compose
description: "Converts UI screenshots, mockups, and design images into pixel-accurate, production-grade Jetpack Compose code. Enforces a 4-stage optical deconstruction pipeline: Optical Deconstruction & Color Extraction, Spatial Spacing & Typography Measurement, Modular Component Construction, and Visual Verification against the target image."
---

# Screenshot to Jetpack Compose Skill (Pixel-Accurate Vision-to-Code)

## Purpose
Convert static UI screenshots, mockups, or wireframes into clean, idiomatic, pixel-accurate Jetpack Compose code that matches the original design with 95%+ visual fidelity.

---

## Why Direct One-Shot Prompts Fail
When an LLM attempts to write code directly from an image in a single pass, it suffers from **Optical Hallucination**:
1. **Color Drifting**: Replaces custom brand tints with generic `MaterialTheme.colorScheme` or `Color.Gray`.
2. **Spacing Distortion**: Guesses margins (e.g., 16dp everywhere) instead of noticing subtle 8dp/12dp/24dp vertical rhythms.
3. **Corner & Elevation Blunders**: Fails to capture pill-shaped buttons (`CircleShape`), custom card radii (`24.dp`), or subtle drop shadows.
4. **Typography Mismatches**: Guesses font weights (bold vs medium) and line heights, causing text to wrap awkwardly.

---

## The Mandatory 4-Stage Vision-to-Code Pipeline

Every request involving a screenshot or UI image MUST follow these 4 stages in strict order:

```text
[Input Image]
      │
      ▼
Stage 1: Optical Deconstruction & Spec Extraction (NO CODE YET)
      │
      ▼
Stage 2: Design Token & Resource Alignment
      │
      ▼
Stage 3: Modular Composable Implementation (@Preview first)
      │
      ▼
Stage 4: Visual Regression Audit (Diff against Original)
```

---

### Stage 1: Optical Deconstruction (Spec Sheet Generation)
Before writing any Compose code, analyze the image and output a structured **Visual Spec Sheet**:

1. **Screen Anatomy & Hierarchy**:
   - Status Bar / Window Insets handling.
   - Top Header / App Bar (Title, actions, profile avatar, back button).
   - Main Content Body (Scrollable column, horizontal card carousel, grid, hero section).
   - Bottom Bar / Floating Action Button / Sticky CTA.

2. **Color Palette Extraction**:
   - Extract exact Hex codes for:
     - `Background`: e.g. `#0F172A` (Dark slate) or `#F8FAFC` (Light surface)
     - `Card / Container Surface`: e.g. `#1E293B`
     - `Primary Brand Accent`: e.g. `#6366F1` (Indigo)
     - `Text Primary`: e.g. `#F8FAFC` (High contrast)
     - `Text Secondary / Muted`: e.g. `#94A3B8`
     - `Borders & Dividers`: e.g. `#334155`
     - `Gradients`: (Start Color -> End Color, Angle/Offset)

3. **Typography & Font Weight Matrix**:
   - Hero Headline (e.g., 28sp - 32sp, Bold / ExtraBold)
   - Section Title (e.g., 18sp - 20sp, SemiBold)
   - Body Text (e.g., 14sp - 15sp, Regular / Medium)
   - Meta / Caption / Badge (e.g., 11sp - 12sp, Medium / SemiBold, Uppercase/Letter spacing)

4. **Spatial Geometry & Shapes**:
   - Horizontal Screen Margins (Typically 16dp, 20dp, or 24dp).
   - Vertical Gap between cards/sections (8dp, 12dp, 16dp, 24dp).
   - Card Corner Radii (`RoundedCornerShape(12.dp)`, `16.dp`, `24.dp`, or `CircleShape`).
   - Inner Padding of cards (Vertical vs Horizontal).
   - Elevation & Shadows (Flat border vs soft elevation).

5. **Icon & Asset Inventory (Mandatory Vector Drawables)**:
   - List every icon visible (e.g., Search, Bell, ChevronRight, Bookmark).
   - Identify whether an icon is a standard Material Icon or a custom vector/illustration.
   - **STRICT BAN**: NEVER use inline emojis (🔥, ⭐, 🚀, 🔍) or unicode glyphs inside strings to represent icons. Emojis render inconsistently across OEM devices (Samsung, Xiaomi, Pixel) and break layout parity.
   - **MANDATORY**: ALWAYS create a dedicated XML Vector Drawable file (`res/drawable/ic_*.xml`) for custom icons or use official Material Icons, rendered via `Icon(painter = painterResource(R.drawable.ic_*), contentDescription = ...)`.

---

### Stage 2: Token Alignment
Map the extracted spec to project tokens:
- Use `AppTheme.colors.*` (or defined semantic color tokens).
- Use `AppSpacing.*` or 8dp-grid constants (`4.dp`, `8.dp`, `12.dp`, `16.dp`, `24.dp`, `32.dp`).
- Use `AppTypography.*` or define specific `TextStyle` with accurate `fontSize`, `fontWeight`, and `lineHeight`.

---

### Stage 3: Modular Composable Implementation
Do NOT write one massive 400-line Composable function. Break the screen down into atomic, reusable parts:

1. **Leaf / Micro Components**:
   - Metric badge, chip tag, user avatar with status dot, icon button with pill background.
2. **Section Cards / Rows**:
   - ProfileHeaderCard, BalanceHeroCard, TransactionListItem.
3. **Screen Orchestrator**:
   - `Scaffold` with `safeDrawing` or status bars insets.
   - `LazyColumn` or `verticalScroll` container.
   - Sticky bottom action button if applicable (`imePadding()`).
4. **Interactive States & Previews**:
   - Provide `@Preview(showBackground = true)` for each component and the full screen (Light & Dark theme).

---

### Stage 4: Visual Regression Audit Checklist
Before declaring the UI complete, verify against the original image:
- [ ] **Proportions**: Does each element occupy the same relative visual weight as the photo?
- [ ] **Margins**: Are edge paddings consistent with the design?
- [ ] **Contrast**: Is text clearly legible against card and background surfaces?
- [ ] **Bo góc (Corner Radius)**: Are pill buttons truly round? Are card corners matching the mockup?
- [ ] **Alignment**: Are badges centered? Are numbers aligned with labels?
- [ ] **Touch Targets**: All clickable items have at least 48x48dp interactive bounds (`minimumInteractiveComponentSize()`).

---

## Pro-Tips for Users
When uploading an image to Antigravity:
1. Provide the highest resolution screenshot available.
2. If certain components are interactive (e.g. tabs, toggles, scrollable lists), mention their behavior.
3. Ask Antigravity to: **"Phân tích Spec thị giác trước, sau đó code từng Component con kèm Preview"**.
