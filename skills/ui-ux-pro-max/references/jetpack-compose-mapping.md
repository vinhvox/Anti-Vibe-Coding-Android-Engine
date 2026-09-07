# Jetpack Compose Material 3 Implementation Mapping Guide

## 1. Design Tokens to Jetpack Compose Material 3 Mapping

When implementing UI in Kotlin Jetpack Compose for Android applications, map `ui-ux-pro-max` design tokens directly to Material 3 themes and composables:

```kotlin
// Map Color Tokens to ColorScheme
val AppColorScheme = lightColorScheme(
    primary = Color(0xFF0061A4),
    onPrimary = Color(0xFFFFFFFF),
    primaryContainer = Color(0xFFD1E4FF),
    onPrimaryContainer = Color(0xFF001D36),
    surface = Color(0xFFF8FDFF),
    onSurface = Color(0xFF001F25),
    surfaceVariant = Color(0xFFDEE3EB),
    onSurfaceVariant = Color(0xFF42474E),
    outline = Color(0xFF72777F)
)

// Map Spacing Tokens to AppSpacing Object
object AppSpacing {
    val extraSmall = 4.dp
    val small = 8.dp
    val medium = 12.dp
    val large = 16.dp
    val extraLarge = 24.dp
    val huge = 32.dp
}

// Map Typography Tokens to Typography
val AppTypography = Typography(
    displayLarge = TextStyle(
        fontSize = 36.sp,
        lineHeight = 44.sp,
        fontWeight = FontWeight.Bold,
        letterSpacing = (-0.5).sp
    ),
    headlineMedium = TextStyle(
        fontSize = 20.sp,
        lineHeight = 28.sp,
        fontWeight = FontWeight.SemiBold,
        letterSpacing = 0.sp
    ),
    bodyLarge = TextStyle(
        fontSize = 16.sp,
        lineHeight = 24.sp,
        fontWeight = FontWeight.Normal,
        letterSpacing = 0.1.sp
    )
)
```

---

## 2. Recomposition Stability & Performance Guardrails

1. **Model Stability Annotations:**
   - Annotate UI models with `@Immutable` or `@Stable` to prevent unnecessary recompositions:
   ```kotlin
   @Immutable
   data class UserProfileUiState(
       val username: String = "",
       val avatarUrl: String = "",
       val isLoading: Boolean = false
   )
   ```

2. **Lambda Memoization:**
   - Always memoize click handlers or callbacks passed down to sub-composables:
   ```kotlin
   val onClickMemoized = remember(itemId) { { onAction(ItemIntent.Select(itemId)) } }
   ```

3. **Lazy Layout Keys:**
   - Always provide unique `key` parameters for `LazyColumn` and `LazyRow` items:
   ```kotlin
   LazyColumn {
       items(items = fileList, key = { file -> file.id }) { file ->
           FileItemRow(file = file)
       }
   }
   ```
