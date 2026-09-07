# 36 - World-Class UI/UX & Anti-AI-Design-Cliché Standard (The Human-Grade Aesthetic Mandate)

## Purpose

This document establishes the official **World-Class UI/UX & Aesthetic Polish Standard** across the entire Antigravity Engine, integrating the full intelligence of the `ui-ux-pro-max` design system.

Its mission is to permanently eliminate robotic, flat, generic, and unpolished "AI-generated slop" and mandate human-grade, expressive, visually stunning, and function-driven UI/UX design across all Jetpack Compose screens and components.

---

# 1. THE 6 FORBIDDEN AI DESIGN CLICHES (STRICTLY BANNED)

UNLESS explicitly requested by the user, the AI is STRICTLY PROHIBITED from generating:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. ❌ NO PURPLE ON DARK       │ Banned purple/violet accents on dark theme backgrounds │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 2. ❌ NO NEON BORDER ACCENTS  │ Banned glowing colored borders around dark containers  │
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 3. ❌ NO BISCUIT PILL BADGES  │ Banned generic floating biscuit badges with pulsing dot│
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 4. ❌ NO OVER-NESTED CARDS    │ Banned 3+ layers of nested cards creating claustrophobia│
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 5. ❌ NO GRADIENT KEYWORDS    │ Banned CSS/Brush gradient text on single title keywords│
├───────────────────────────────┼────────────────────────────────────────────────────────┤
│ 6. ❌ NO COOKIE-CUTTER SLOP   │ Banned identical generic gray cards across all domains │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. THE 6 CORE LAWS OF HUMAN-GRADE UI/UX

## Rule 36.1: Visual Depth & Subtle Stroke Mandate
- **Rule:** Every Card, Modal, and Floating Container MUST have visual depth:
  1. A subtle **0.5dp — 1dp** semi-transparent border (`AppTheme.colors.outlineVariant.copy(alpha = 0.5f)`).
  2. Multi-tier tonal surface background (`surfaceContainerLowest`, `surfaceContainer`, `surfaceContainerHigh`) rather than a single flat gray/black sheet.

---

## Rule 36.2: 3-Tier Expressive Typography Hierarchy
- **Rule:** Every screen must exhibit a clear, dynamic typographical hierarchy:
  1. **Hero Display (Headline):** 28–34sp, Bold/SemiBold, tight letter-spacing (`-0.5sp`) for strong visual anchoring.
  2. **Section Title:** 18–22sp, SemiBold, high readability.
  3. **Body Text:** 14–16sp, Regular, comfortable line-height (1.4–1.5x) for fatigue-free scanning.
  4. **Meta / Caption:** 11–12sp, Medium, muted auxiliary color (`onSurfaceVariant`) meeting WCAG AA contrast (4.5:1).

---

## Rule 36.3: Strict 8-Point Grid & Optical Alignment
- **Rule:** All padding, margins, gaps, and component heights MUST adhere strictly to the 8-point geometric grid:
  - `4dp` (Micro / Icon gap)
  - `8dp` (Tight / Inner container)
  - `16dp` (Standard / Content margin)
  - `24dp` (Loose / Group separator)
  - `32dp` (Section / Hero padding)
- **Optical Alignment:** Icons, avatar badges, and text baselines MUST align along optical centers, never mathematical top-edge bounding boxes.

---

## Rule 36.4: Domain-Tailored Personality & Aesthetics
- **Rule:** Visual styling must reflect the target industry vertical (refer to `skills/ui-ux-pro-max`):
  - **Fintech & Banking:** Deep Navy / Slate with Emerald Green accents, tabular numbers, subtle surfaces, high trust.
  - **E-Commerce:** High contrast, prominent vibrant CTA buttons, smooth 16–20dp corner rounding, clean product aspect ratios.
  - **SaaS & Utilities:** High data density, compact spacing, clean borders, instant feedback.
  - **Health & Wellness:** Calm sage/teal tones, generous whitespace, soft rounded shapes.
  - **Media & Entertainment:** Immersive dark surfaces, edge-to-edge imagery, subtle backdrop blur.

---

## Rule 36.5: Micro-Interactions & State Polish
- **Rule:** Every interactive element must provide tactile, polished feedback:
  - Smooth ripple effects on tap (`clickable(interactionSource = ..., indication = ripple())`).
  - Fluid shimmer skeletons for loading states instead of abrupt spinning circles.
  - Smooth animated transitions for state changes (`AnimatedVisibility`, `animateContentSize`).

---

# 3. DROP-IN POLISHED COMPOSE BLUEPRINTS

### A. Polished Human-Grade Surface Card Blueprint
```kotlin
@Composable
fun PolishedCard(
    modifier: Modifier = Modifier,
    onClick: (() -> Unit)? = null,
    content: @Composable ColumnScope.() -> Unit
) {
    val interactionSource = remember { MutableInteractionSource() }

    Surface(
        onClick = onClick ?: {},
        enabled = onClick != null,
        shape = AppShapes.large, // 16.dp rounding
        color = AppTheme.colors.surfaceContainer,
        border = BorderStroke(
            width = 0.5.dp,
            color = AppTheme.colors.outlineVariant.copy(alpha = 0.5f) // Subtle 0.5dp border
        ),
        interactionSource = interactionSource,
        modifier = modifier
            .fillMaxWidth()
            .then(
                if (onClick != null) {
                    Modifier.minimumInteractiveComponentSize()
                } else Modifier
            )
    ) {
        Column(
            modifier = Modifier.padding(AppSpacing.large), // 16.dp
            content = content
        )
    }
}
```

### B. Expressive 3-Tier Typography Header Blueprint
```kotlin
@Composable
fun ExpressiveSectionHeader(
    title: String,
    subtitle: String? = null,
    badgeText: String? = null,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            AppText(
                text = title,
                style = AppTypography.headlineMedium.copy(
                    fontWeight = FontWeight.Bold,
                    letterSpacing = (-0.5).sp
                ),
                color = AppTheme.colors.onBackground,
                modifier = Modifier.weight(1f, fill = false),
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )

            badgeText?.let { badge ->
                Surface(
                    shape = AppShapes.small,
                    color = AppTheme.colors.secondaryContainer,
                    modifier = Modifier.padding(start = AppSpacing.small)
                ) {
                    AppText(
                        text = badge,
                        style = AppTypography.labelSmall.copy(fontWeight = FontWeight.SemiBold),
                        color = AppTheme.colors.onSecondaryContainer,
                        modifier = Modifier.padding(horizontal = AppSpacing.small, vertical = AppSpacing.extraSmall)
                    )
                }
            }
        }

        subtitle?.let {
            Spacer(modifier = Modifier.height(AppSpacing.extraSmall))
            AppText(
                text = it,
                style = AppTypography.bodyMedium,
                color = AppTheme.colors.onSurfaceVariant,
                lineHeight = 20.sp,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
        }
    }
}
```

---

# 4. REVIEW & ENFORCEMENT (GATE E27)

Every UI implementation must pass **GATE E27** in `rules/21-enforcement-engine.md`:
- `E27.1`: Anti-AI-Design-Cliché Gate
- `E27.2`: Visual Depth & Subtle Border Gate
- `E27.3`: Typography Hierarchy & Contrast Gate
- `E27.4`: 8-Point Grid Visual Rhythm Gate
- `E27.5`: Domain-Tailored Aesthetics Gate
- `E27.6`: Micro-Interactions & State Polish Gate
