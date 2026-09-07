# Skill: Internationalization & Localization (i18n & l10n)

## Overview

This skill defines the rules and best practices for multi-language support, string resource organization, dynamic locale switching, and formatting standards across Android and Jetpack Compose.

---

## Related Files

- Rules: `rules/05-design-system.md`, `rules/21-enforcement-engine.md` (E1.3 No Hardcoded Strings)
- Resources: `app/src/main/res/values/strings.xml` (Default/English), `app/src/main/res/values-vi/strings.xml` (Vietnamese)

---

## Core Rules

1. **Zero Hardcoded Strings:** Absolutely no user-facing raw string literals inside `@Composable` functions or ViewModels.
2. **Dual-Language Parity:** Whenever a string key is added to `values/strings.xml`, its Vietnamese counterpart MUST be simultaneously added to `values-vi/strings.xml`.
3. **Plurals & Format Arguments:** Use `<plurals>` for count-dependent strings and standard `%1$s`, `%2$d` placeholders.
4. **Dynamic Context-Free String Resolution:** Prefer `stringResource(R.string.key, args...)` directly in Composables. Avoid passing `Context` to ViewModels to resolve strings.

---

## Implementation Patterns

### 1. Resource Declaration Structure

```xml
<!-- res/values/strings.xml (English) -->
<resources>
    <string name="action_compress">Compress</string>
    <string name="action_extract">Extract</string>
    <string name="dialog_compress_title">Compress %1$s files</string>
    <string name="error_file_not_found">File not found: %1$s</string>
</resources>

<!-- res/values-vi/strings.xml (Vietnamese) -->
<resources>
    <string name="action_compress">Nén tập tin</string>
    <string name="action_extract">Giải nén</string>
    <string name="dialog_compress_title">Nén %1$s tập tin</string>
    <string name="error_file_not_found">Không tìm thấy tập tin: %1$s</string>
</resources>
```

### 2. Usage in Compose

```kotlin
@Composable
fun CompressDialogHeader(fileCount: Int) {
    AppText(
        text = stringResource(R.string.dialog_compress_title, fileCount),
        style = AppTheme.typography.heading2,
        color = AppTheme.colors.textPrimary
    )
}
```

### 3. Error Strings in MVI Architecture

To keep ViewModels pure Kotlin and decoupled from Android `Context`:

```kotlin
// In Domain / Core UI State:
sealed interface UiText {
    data class DynamicString(val value: String) : UiText
    data class StringResource(@StringRes val resId: Int, val args: List<Any> = emptyList()) : UiText
    
    @Composable
    fun asString(): String {
        return when (this) {
            is DynamicString -> value
            is StringResource -> stringResource(resId, *args.toTypedArray())
        }
    }
}
```

---

## Audit Checklist

- [ ] Does every new string have an entry in both `values/strings.xml` and `values-vi/strings.xml`?
- [ ] Are formatting placeholders typed correctly (`%s`, `%d`)?
- [ ] Is `stringResource()` used instead of hardcoded strings in Compose?
- [ ] Are date/number/currency formatters locale-aware (`NumberFormat.getInstance(Locale.getDefault())`)?
