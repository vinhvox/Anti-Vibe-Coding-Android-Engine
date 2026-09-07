# 29-ui-layout-defense.md

# DEFENSIVE & AESTHETIC JETPACK COMPOSE LAYOUT MANDATE

## Purpose

This document establishes the official **Defensive & Aesthetic Jetpack Compose Layout Standard** across the entire Antigravity Engine.

Its mission is to eliminate visual regressions, awkward proportions, layout collisions (overlapping views), text clipping, and un-responsive row overflows. Every UI component and screen generated MUST look modern, balanced, defensive, and production-ready.

---

# 1. THE 5 CORE LAWS OF DEFENSIVE COMPOSE LAYOUT

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. ANTI-COLLISION LAW        │ All Box children MUST have explicit Modifier.align()    │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 2. ROW TRUNCATION DEFENSE    │ Dynamic Text in Rows MUST have weight(1f) + Ellipsis    │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 3. RESPONSIVE FLOW WRAPPING  │ Variable chips/tags MUST use FlowRow or LazyRow         │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 4. 8-POINT GRID & PROPORTION │ Strict 4/8/12/16/24/32/48dp tokens; zero arbitrary dp   │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 5. VISUAL HIERARCHY & LUXURY │ 3-Tier Typo (Hero > Body > Meta), 0.5dp Subtle Borders  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. LAW 1: ANTI-COLLISION & ANCHORED BOX CONTAINERS

### The Problem
Using `Box` without explicit alignment causes children to stack on top of each other, resulting in unreadable text and broken buttons.

### Mandatory Rules
1. **Multi-Child Box Alignment**: Every child in a `Box` with $\ge 2$ children MUST specify an explicit `Modifier.align(...)` unless it is a single background decoration + 1 single layout container (`Column` or `Row`).
2. **Badge & Floating Button Anchoring**:
   ```kotlin
   // PREFERRED: Explicit alignment & padding
   Box(modifier = Modifier.fillMaxWidth()) {
       CardContent(modifier = Modifier.fillMaxWidth())
       StatusBadge(
           modifier = Modifier
               .align(Alignment.TopEnd)
               .padding(AppSpacing.Small)
       )
   }
   ```
3. **Window Insets Safety**: All top-level screens and custom AppBars MUST respect system bars (`WindowInsets.safeDrawing`, `WindowInsets.statusBars`, `WindowInsets.navigationBars`) to prevent notch/pill overlap.

---

# 3. LAW 2: ROW TRUNCATION & WEIGHT DEFENSE

### The Problem
When a `Row` contains an Icon, a dynamic Title, and an Action Button, long text strings push the Action Button out of the viewport or compress adjacent icons into zero width.

### Mandatory Rules
1. **Dynamic Text Weighting**: Any dynamic `Text` / `AppText` in a `Row` alongside fixed-size siblings (Icons, Badges, Buttons) MUST include `Modifier.weight(1f)`.
2. **Exhaustive Ellipsis Guard**: All dynamic titles, subtitles, and list item descriptions MUST define `maxLines` and `overflow = TextOverflow.Ellipsis`.

```kotlin
// PREFERRED: Defensive Row with Weight & Ellipsis
Row(
    modifier = Modifier.fillMaxWidth(),
    verticalAlignment = Alignment.CenterVertically
) {
    AppIcon(
        painter = painterResource(R.drawable.ic_folder),
        modifier = Modifier.size(AppDimensions.IconMedium)
    )
    Spacer(Modifier.width(AppSpacing.Medium))
    
    // Dynamic text consumes available space without pushing the button out
    Column(modifier = Modifier.weight(1f)) {
        AppText(
            text = item.title,
            style = AppTypography.TitleMedium,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )
        AppText(
            text = item.subtitle,
            style = AppTypography.BodySmall,
            color = AppTheme.colors.onSurfaceVariant,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )
    }
    
    Spacer(Modifier.width(AppSpacing.Small))
    PrimaryButton(
        text = stringResource(R.string.action_open),
        onClick = { onAction(item) }
    )
}
```

---

# 4. LAW 3: RESPONSIVE FLOW & WRAPPING (CHIPS & TAGS)

### The Problem
Placing multiple chips, badges, or action tags into a standard horizontal `Row` causes items past the screen boundary to be invisibly clipped.

### Mandatory Rules
1. **Chips / Tags Collections**: When displaying a dynamic or variable collection of tags, filter chips, or metadata badges, ALWAYS use **`FlowRow`** (with `horizontalArrangement` and `verticalArrangement`) or a horizontally scrollable **`LazyRow`**.
2. **Never use a rigid `Row`** for more than 2 dynamic text chips unless wrapped in `Modifier.horizontalScroll()`.

```kotlin
// PREFERRED: Responsive FlowRow
FlowRow(
    modifier = Modifier.fillMaxWidth(),
    horizontalArrangement = Arrangement.spacedBy(AppSpacing.Small),
    verticalArrangement = Arrangement.spacedBy(AppSpacing.ExtraSmall),
    maxItemsInEachRow = 4
) {
    categories.forEach { category ->
        AppFilterChip(
            selected = category.isSelected,
            onClick = { onSelect(category) },
            label = category.name
        )
    }
}
```

---

# 5. LAW 4: 8-POINT GRID & PROPORTION SYSTEM

### The Problem
Arbitrary padding (e.g., `10.dp`, `13.dp`, `22.dp`, `55.dp`) creates visual disharmony and makes the app feel unpolished.

### Mandatory Rules
1. **Strict Spacing Scale**: All padding, margins, spacers, and arrangement gaps MUST strictly use the **8-Point Grid** tokens:
   - `AppSpacing.ExtraSmall` = `4.dp` (Tight chip padding, micro gaps)
   - `AppSpacing.Small` = `8.dp` (Element internal padding, tag spacing)
   - `AppSpacing.Medium` = `12.dp` / `16.dp` (Standard card padding, icon-text gap)
   - `AppSpacing.Large` = `24.dp` (Section separation)
   - `AppSpacing.ExtraLarge` = `32.dp` / `48.dp` (Page header top padding, empty state illustration margins)
2. **Zero Hardcoded Dimension Numbers**: Raw `.dp` values in presentation files are strictly rejected by the Enforcement Engine.
3. **Card Corner Radius Consistency**:
   - `AppShapes.Large` / `16.dp` - `20.dp` for Cards & Surfaces (Squircle style)
   - `AppShapes.Medium` / `12.dp` for Dialogs & Action Buttons
   - `AppShapes.Small` / `8.dp` for Chips & Badges

---

# 6. LAW 5: VISUAL HIERARCHY & LUXURY AESTHETICS

### The Problem
Flat, monolithic UIs where every text label looks identical and containers lack depth.

### Mandatory Rules
1. **3-Tier Visual Hierarchy**:
   * **Tier 1 (Hero/Primary)**: Bold, highest contrast (`AppTheme.colors.onSurface`), headline/title typography.
   * **Tier 2 (Secondary/Body)**: Medium weight, softer contrast (`AppTheme.colors.onSurfaceVariant`).
   * **Tier 3 (Tertiary/Metadata)**: Regular weight, small font (`12sp`), subtle outline color (`AppTheme.colors.outline`).
2. **Subtle Elevation & Glass Borders**:
   * All elevated cards and floating surfaces MUST include a subtle `0.5.dp` border for crisp visual separation on both Light and Dark themes:
     ```kotlin
     Modifier
         .clip(AppShapes.Large)
         .background(AppTheme.colors.surface)
         .border(
             width = 0.5.dp,
             color = AppTheme.colors.outline.copy(alpha = 0.15f),
             shape = AppShapes.Large
         )
     ```
3. **Tactile Spring Micro-Interactions**:
   * Interactive cards and buttons MUST provide tactile feedback via `Modifier.bouncyClickable()` or standard Material 3 ripple to provide immediate, satisfying responsiveness.

---

# 7. ENFORCEMENT & COMPLIANCE

* This rule is strictly guarded by **CATEGORY E19 (UI Aesthetics & Layout Defense Gate)** in `rules/21-enforcement-engine.md`.
* No UI code may be marked complete if it contains unweighted row text, unanchored box children, or clipped chip rows.
