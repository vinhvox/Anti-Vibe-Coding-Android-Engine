# 05-design-system.md

# Purpose

This document defines the rules for using the project's Design System.

The Design System (`com.panda.base.app.core.ui.theme`) is the single source of truth for UI.

Every screen, component, and feature MUST search, import, and reuse elements from `core/ui/theme` (`AppTheme.colors`, `AppTheme.typography`, `Heading1`, `Heading2`).

Never create arbitrary UI styles or hardcoded colors/typography when `core/ui/theme` already provides them.

---

# Core Principles

Design consistency is more valuable than local optimization.

Reuse before creating.

Inspect `core/ui/theme` BEFORE implementing any Compose UI.

NO `Scaffold` RULE:
Do NOT wrap screens in Material 3 `Scaffold`. The application root (`MainActivity`) already wraps content in `MyAppTheme`. All screens MUST use `Box(modifier = Modifier.fillMaxSize().background(AppTheme.colors.background))` or `Column` containers.

NO HARDCODED UI STRINGS RULE:
NEVER hardcode string literals inside Composable function parameters (e.g. `Heading1(text = "Clean Space")`). ALL user-facing strings MUST be defined inside `app/src/main/res/values/strings.xml` and retrieved using `stringResource(id = R.string.xxx)` in UI Composables.

ENGLISH STRINGS ONLY MANDATE:
ALL string resources defined in `app/src/main/res/values/strings.xml` MUST be written in English by default. Never use Vietnamese or hardcode non-English copy in default `strings.xml`. Any secondary translations MUST be isolated in dedicated localization files (e.g., `values-vi/strings.xml`).


---

# String Resource Mandate

All text presented to users must support localization and clean separation of UI logic and copy.

Preferred:
```kotlin
Heading1(text = stringResource(id = R.string.cleaner_title))
Body2(text = stringResource(id = R.string.cleaner_subtitle_desc))
```

Avoid:
```kotlin
Heading1(text = "Clean Space") // FORBIDDEN!
```

---

# Design System Discovery

Before writing any UI code, inspect the project for:

## Theme

- AppTheme
- MaterialTheme
- ColorScheme

## Typography

- AppTypography
- Typography
- TextStyles

## Colors

- AppColors
- ColorTokens
- Material Color Scheme

## Shapes

- AppShapes
- Material Shapes

## Dimensions

- AppSpacing
- AppDimensions

## Components

- Buttons
- TextFields
- Cards
- Dialogs
- TopBars
- BottomSheets
- Loading
- Empty State
- Error State

Do not create new UI until this inspection is complete.

---

# UI Construction Order

Every screen MUST follow this order.

```text
Inspect Theme
      ↓
Inspect Design Tokens
      ↓
Inspect Existing Components
      ↓
Map UI Elements
      ↓
Implement Screen
```

Never skip the inspection phase.

---

# Design Tokens

The Design System owns:

- Colors
- Typography
- Shapes
- Elevation
- Dimensions
- Spacing
- Corner Radius
- Icon Size
- Animation Duration

Do not redefine these values inside feature code.

---

# Typography Rules

Always reuse typography tokens from `AppTypography` (`DefaultAppTypography`) and `AppText` helper composables.

Mandatory Typography Composables from `com.panda.base.app.core.ui.theme`:
- `Heading1`: Large Page Titles (32sp Bold)
- `Heading2`: Section Titles (24sp SemiBold)
- `Heading3`: Card Titles (20sp SemiBold)
- `Subtitle1` / `Subtitle2`: Card Subtitles & Item Labels (16sp/14sp Medium)
- `Body1` / `Body2`: Body Content (16sp/14sp Normal)
- `Caption`: Helper & Timestamp Text (12sp Normal)
- `AppText`: Custom styled text wrapper using `AppTheme.colors` and `AppTypography`

Preferred:

```kotlin
Heading3(text = stringResource(R.string.title))
Body2(text = stringResource(R.string.subtitle), color = AppTheme.colors.darkGray)
```

Avoid:

```kotlin
Text(
    text = "Title",
    fontSize = 22.sp,
    fontWeight = FontWeight.Bold,
    color = Color.Black
)
```

Never write raw `Text(...)` composables with hardcoded font sizes or colors inside feature UI code.

---

# Color Rules

Colors must come from:

- MaterialTheme.colorScheme
- AppColors
- Design Tokens

Never hardcode:

```kotlin
Color(0xFF2196F3)
```

inside feature UI.

Bad:

```kotlin
Text(
    color = Color.Red
)
```

Good:

```kotlin
Text(
    color = AppColors.Error
)
```

---

# Spacing Rules

Use spacing tokens.

Preferred:

```kotlin
Modifier.padding(AppSpacing.Medium)
```

Avoid:

```kotlin
Modifier.padding(13.dp)
```

If a spacing token does not exist:

Evaluate whether it should become part of the Design System.

---

# Shape Rules

Prefer:

```kotlin
AppShapes.Small

AppShapes.Medium

AppShapes.Large
```

Avoid:

```kotlin
RoundedCornerShape(17.dp)
```

inside feature code.

---

# Icon Rules

Before adding an icon:

Inspect:

- Existing icon pack
- Icon size tokens
- Tint rules

Preferred:

```kotlin
Modifier.size(AppDimensions.IconMedium)
```

Avoid:

```kotlin
Modifier.size(27.dp)
```

---

# Button Rules

Before creating a button:

Search for:

- PrimaryButton
- SecondaryButton
- OutlineButton
- TextButton
- LoadingButton

Reuse existing components whenever possible.

Never duplicate button styling inside a screen.

---

# TextField Rules

Always reuse the project's TextField implementation.

Preferred:

```kotlin
AppTextField(...)
```

Avoid repeatedly configuring:

- Shape
- Border
- Focus color
- Typography
- Placeholder
- Padding

inside every screen.

---

# Card Rules

Search existing:

- AppCard
- ElevatedCard
- Surface
- ListItem

Do not create multiple card styles representing the same semantic meaning.

---

# Loading Rules

Before creating loading UI:

Search existing:

- LoadingView
- ProgressIndicator
- Skeleton
- Shimmer

Prefer project-standard loading components.

---

# Empty State Rules

Search existing:

- EmptyState
- NoDataView
- PlaceholderView

Reuse before creating.

---

# Error State Rules

Search existing:

- ErrorView
- RetryView
- ErrorDialog

Maintain a consistent error experience.

---

# Component Mapping

Before implementation, create a component map.

Example:

```text
Title
    ↓
AppTypography.TitleLarge

Subtitle
    ↓
AppTypography.BodyMedium

Primary Action
    ↓
PrimaryButton

Input
    ↓
AppTextField

Loading
    ↓
LoadingView

Empty
    ↓
EmptyState

Top Bar
    ↓
AppTopBar
```

Only begin coding after this mapping is complete.

---

# Reusable Components

A UI component should move into the Design System when:

✓ Used by multiple screens

✓ Visually identical

✓ Behavior is consistent

✓ Improves maintainability

Otherwise:

Keep it feature-specific.

---

# Feature Components

Feature-specific components may exist.

However they should still reuse:

- Typography
- Colors
- Shapes
- Dimensions
- Icons

Never create a completely independent design language.

---

# Accessibility Rules

Ensure:

- Touch target ≥ 48dp
- ContentDescription when required
- Sufficient color contrast
- Support Dynamic Font Size
- Keyboard accessibility where applicable

Accessibility is part of the Design System.

---

# Theme Rules

Support:

- Light Theme
- Dark Theme
- Dynamic Color (if enabled)

Do not hardcode values that break theming.

---

# Review Checklist

Before completing a screen:

□ No hardcoded colors

□ No hardcoded typography

□ No hardcoded spacing

□ No hardcoded UI string literals (100% stringResource)

□ No duplicated button styles

□ No duplicated TextField styles

□ Existing components reused

□ Supports Dark Theme

□ Supports accessibility

□ Consistent with Design System

---

# Anti-patterns

Do not:

Text("Hardcoded String")

Do not:

Text
↓
fontSize = 17.sp

Do not:

Button
↓
Custom colors everywhere

Do not:

Spacer
↓
19.dp

Do not:

RoundedCornerShape(15.dp)

inside every screen.

Avoid one-off UI implementations.

---

# Decision Priority

When implementing UI:

1. Existing Design System

2. Existing reusable component

3. Existing design tokens

4. Feature component

5. New Design System component

Never reverse this order.

---

# ENFORCEMENT: Mandatory Self-Audit Before Completion

Before reporting ANY UI-related task as complete, the AI MUST perform the following self-audit.
Failure to pass ALL checks means the task is NOT complete.

## Step 1: Scan for Hardcoded Colors

Search the modified files for the regex pattern `Color\(0x`.
If ANY match is found inside `presentation/` layer code:
- The code is REJECTED.
- Replace with the appropriate `AppTheme.colors.*` token.
- If no suitable token exists, CREATE one in `core/ui/theme/` FIRST.

## Step 2: Scan for Hardcoded Dimensions

Search modified files for raw `.dp` values used in `padding()`, `size()`, `RoundedCornerShape()`, `Spacer()`, `height()`, `width()`.
- If values are not from `AppSpacing.*`, `AppShapes.*`, or `AppDimensions.*`, the code is REJECTED.
- Common values (4, 8, 12, 16, 24, 32, 48) MUST map to spacing tokens.
- If tokens don't exist yet, CREATE them before using.

## Step 3: Scan for Hardcoded Strings

Search modified files for `Text("` or `text = "` patterns inside Composable functions.
- If ANY hardcoded user-facing string is found (not a log message or debug), the code is REJECTED.
- Replace with `stringResource(R.string.xxx)`.
- Add the string to `strings.xml` in English, and `values-vi/strings.xml` in Vietnamese.

## Step 4: Scan for Raw Text() Composables

Search for `Text(` composables with inline `fontSize`, `fontWeight`, `color` parameters.
- Must use project typography composables: `Heading1`, `Heading2`, `Heading3`, `Subtitle1`, `Subtitle2`, `Body1`, `Body2`, `Caption`, or `AppText`.
- Raw `Text()` with manual styling is REJECTED unless inside a Design System component definition.

## Step 5: Verify Dark Theme Compatibility

All colors used MUST come from `AppTheme.colors` which supports both Light/Dark.
Any `Color.White`, `Color.Black`, `Color.Red`, or direct `Color()` constructor bypasses theming and is REJECTED.

## Enforcement Priority

This self-audit is MANDATORY and has the same priority as the build verification (`./gradlew compileDebugKotlin`).
No UI task may be reported as complete until this audit passes with ZERO violations.

---

# Final Rule

The Design System is the foundation of every UI.

A feature should adapt to the Design System.

The Design System should not adapt to individual features.