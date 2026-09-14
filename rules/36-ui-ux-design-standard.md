# 36 - WORLD-CLASS UI/UX & HAUTE COUTURE DESIGN STANDARD (THE BESPOKE CRAFT MANDATE)

## Purpose
This document establishes the official **Haute Couture UI/UX Standard** across the entire Antigravity Engine.

Its mission is to **permanently eradicate "AI Slop" and cheap AI fingerprints** (generic dark purple crypto aesthetics, glowing neon outlines, floating biscuit pills, gradient text fills, cookie-cutter card spam) and mandate **bespoke, refined, human-grade, and expensive-looking UI/UX design** (Linear, Apple, Stripe caliber) across all Jetpack Compose screens and components.

---

# 1. THE 5 FORBIDDEN AI DESIGN CLICHÉS (THE "AI SLOP" HALL OF SHAME)

UNLESS explicitly requested by the user, the AI is STRICTLY PROHIBITED from generating:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. ❌ NO PURPLE ON DARK       │ Banned purple/violet accents on dark theme backgrounds │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 2. ❌ NO GLOWING NEON BORDERS │ Banned glowing colored borders or bright outlines      │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 3. ❌ NO BISCUIT PILL BADGES  │ Banned generic floating pill badges with pulsing dots  │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 4. ❌ NO GRADIENT KEYWORDS    │ Banned rainbow/gradient text on single title words     │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 5. ❌ NO COOKIE-CUTTER CARDS  │ Banned nested identical gray cards with uniform padding │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. THE 5 HAUTE COUTURE PRINCIPLES (GIAO DIỆN CÓ GU & ĐẮT GIÁ)

### Principle 1: Optical Depth & 0.5dp Specular Hairlines (Chiều Sâu Quang Học)
* **The Law:** Expensive design never uses thick borders (`2dp`+) or heavy pitch-black drop shadows. It achieves depth through **M3 Tonal Layering** and **0.5dp translucent specular hairlines**.
* **Tonal Hierarchy:**
  - Base Screen Canvas: `AppTheme.colors.surface` or `surfaceContainerLowest` (e.g., Warm Obsidian `#121316` or Slate Charcoal `#0F141C`).
  - Structural Cards: `AppTheme.colors.surfaceContainerLow` / `surfaceContainer`.
  - Floating Sheets / Dialogs: `AppTheme.colors.surfaceContainerHigh`.
* **The 0.5dp Hairline Stroke:**
  ```kotlin
  border = BorderStroke(
      width = 0.5.dp,
      color = AppTheme.colors.outlineVariant.copy(alpha = 0.35f) // Machined aluminum feel
  )
  ```

---

### Principle 2: Editorial Typography & Intentional Tracking (Đỉnh Cao Typography)
* **Large Display / Headlines:** Large titles MUST use **tight negative tracking** (`letterSpacing = -0.5.sp` to `-1.sp`). Negative letter-spacing compacts the glyphs, producing an authoritative, editorial, high-fashion magazine aesthetic.
* **Overlines / Metadata:** Small all-caps labels MUST use **generous positive tracking** (`letterSpacing = 1.0.sp` to `1.5.sp`) paired with `labelSmall` or `labelMedium`.
* **Tabular Numbers (`tnum`):** All financial, statistical, and countdown displays MUST enable tabular figures (`FontFeatureSettings = "tnum"`). Numbers must never wobble or jitter during updates.

---

### Principle 3: Chromatic Restraint & The 90/10 Rule (Sự Tiết Chế Màu Sắc)
* **The Law:** "Luxury whispers; it never shouts." Cheap AI designs splash 5 bright colors across one screen. Haute Couture design enforces the **90/10 Rule**:
  - **90% Sophisticated Neutrals:** Rich charcoals, warm graphites, off-whites, and muted slates.
  - **10% (or 5%) Intentional Brand Accent:** Exactly ONE primary brand hue used strictly for actionable primary CTAs and critical status indicators.
* **WCAG AA Compliance:** Text contrast must strictly achieve $\ge 4.5:1$ against its immediate container in both Light and Dark themes.

---

### Principle 4: Asymmetric Spatial Rhythm & Gestalt Grouping (Nhịp Thở Không Gian)
* **The Law:** Banish uniform `padding(16.dp)` on everything. Create dynamic visual rhythm using intentional contrast:
  - **Micro-Clustering (Gestalt Proximity):** Group tightly related items (Avatar + Name + Timestamp) with `4dp` or `8dp` gaps.
  - **Macro-Breathing Room:** Separate distinct semantic sections with generous negative space (`28dp` to `40dp`).
  - **Dynamic Asymmetry:** Contrast compact horizontal chip rails with spacious hero metrics. Let the eye rest.

---

### Principle 5: Tactile Physics & Micro-Interactions (Cảm Giác Xúc Giác Hữu Cơ)
* **Tactile Press Scale:** Interactive elements must feel physical. On press, scale down smoothly to `0.97f` using natural spring physics:
  ```kotlin
  val scale by animateFloatAsState(
      targetValue = if (isPressed) 0.97f else 1f,
      animationSpec = spring(dampingRatio = 0.75f, stiffness = 400f),
      label = "tactile_press"
  )
  Modifier.graphicsLayer { scaleX = scale; scaleY = scale }
  ```
* **Frosted Glass Top Bar:** Sticky headers must use subtle blur (`Modifier.blur(20.dp)`) with a semi-transparent tonal background (`alpha = 0.85f`), allowing scrolled content to softly dissolve behind the app bar.
* **Organic Skeletons:** Loading states MUST use subtle tonal shimmer pulses matching container colors—never harsh white sweeps or abrupt spinning circles.

---

# 3. PRODUCTION DROP-IN BESPOKE BLUEPRINTS

### A. Bespoke Haute Couture Surface Card
```kotlin
@Composable
fun BespokeCard(
    modifier: Modifier = Modifier,
    onClick: (() -> Unit)? = null,
    shape: Shape = RoundedCornerShape(AppShapes.large),
    containerColor: Color = AppTheme.colors.surfaceContainerLow,
    content: @Composable ColumnScope.() -> Unit
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    
    val scale by animateFloatAsState(
        targetValue = if (onClick != null && isPressed) 0.98f else 1f,
        animationSpec = spring(dampingRatio = 0.75f, stiffness = 450f),
        label = "card_scale"
    )

    Surface(
        onClick = onClick ?: {},
        enabled = onClick != null,
        shape = shape,
        color = containerColor,
        border = BorderStroke(
            width = 0.5.dp,
            color = AppTheme.colors.outlineVariant.copy(alpha = 0.35f)
        ),
        interactionSource = interactionSource,
        modifier = modifier
            .fillMaxWidth()
            .graphicsLayer {
                scaleX = scale
                scaleY = scale
            }
            .then(
                if (onClick != null) Modifier.minimumInteractiveComponentSize() else Modifier
            )
    ) {
        Column(
            modifier = Modifier.padding(horizontal = 20.dp, vertical = 18.dp),
            content = content
        )
    }
}
```

---

### B. Editorial Typography Header with Negative Tracking
```kotlin
@Composable
fun EditorialHeader(
    title: String,
    overline: String? = null,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        overline?.let {
            Text(
                text = it.uppercase(),
                style = AppTheme.typography.labelSmall.copy(
                    letterSpacing = 1.2.sp, // Generous positive tracking for overline
                    fontWeight = FontWeight.SemiBold,
                    color = AppTheme.colors.onSurfaceVariant
                )
            )
            Spacer(modifier = Modifier.height(6.dp))
        }

        Text(
            text = title,
            style = AppTheme.typography.headlineLarge.copy(
                fontWeight = FontWeight.Bold,
                letterSpacing = (-0.75).sp, // Tight negative tracking for authoritative elegance
                lineHeight = 36.sp
            ),
            color = AppTheme.colors.onSurface
        )
    }
}
```

---

### C. Tabular Financial / Metric Display
```kotlin
@Composable
fun TabularMetricDisplay(
    value: String,
    currencySymbol: String = "$",
    modifier: Modifier = Modifier
) {
    Row(
        verticalAlignment = Alignment.FirstBaseline,
        modifier = modifier
    ) {
        Text(
            text = currencySymbol,
            style = AppTheme.typography.titleLarge.copy(
                fontWeight = FontWeight.Medium,
                color = AppTheme.colors.onSurfaceVariant
            )
        )
        Spacer(modifier = Modifier.width(4.dp))
        Text(
            text = value,
            style = AppTheme.typography.displayMedium.copy(
                fontWeight = FontWeight.SemiBold,
                letterSpacing = (-1.0).sp,
                fontFeatureSettings = "tnum" // Tabular figures guarantee zero layout jitter
            ),
            color = AppTheme.colors.onSurface
        )
    }
}
```

---

# 4. REVIEW & ENFORCEMENT (GATE E27)

Every UI screen, component, or layout must pass **GATE E27** in `rules/21-enforcement-engine.md`:
* `E27.1`: Anti-AI-Design-Cliché Gate (No purple on dark, glowing borders, or pill badges).
* `E27.2`: Optical Depth & 0.5dp Hairline Gate (Tonal surface hierarchy + 0.5dp stroke).
* `E27.3`: Editorial Typography & Negative Tracking Gate (Tight negative tracking on display headers, tabular `tnum` numbers).
* `E27.4`: Chromatic Restraint & 90/10 Ratio Gate (Monochrome dominance with surgical accent).
* `E27.5`: Asymmetric Spatial Breathing Room Gate (Tight micro-groupings vs. 28-40dp section space).
* `E27.6`: Tactile Physics & Spring Feedback Gate (0.97f press scale & organic micro-interactions).
