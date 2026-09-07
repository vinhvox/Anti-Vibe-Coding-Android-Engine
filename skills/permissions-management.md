# Android Permission Management & Lifecycle Automation Architecture

Comprehensive engineering guide for managing **Runtime Permissions**, **Special App Access Permissions**, and **Lifecycle-Aware State Automation** in Modern Android, Jetpack Compose, and MVI Architecture.

---

## 1. The Core Problems with Android Permissions

In Android application development, permissions are fragmented and complex:

1. **Permission Fragmentation:**
   - **Standard Runtime Permissions:** `POST_NOTIFICATIONS`, `CAMERA`, `RECORD_AUDIO`, `ACCESS_FINE_LOCATION`, `READ_MEDIA_IMAGES` are requested inside the app using `ActivityResultContracts.RequestPermission()`.
   - **Special App Access Permissions:** `MANAGE_EXTERNAL_STORAGE` (All Files Access), `SYSTEM_ALERT_WINDOW` (Overlay), `PACKAGE_USAGE_STATS` (Usage Access), `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`, `SCHEDULE_EXACT_ALARM`, and `BIND_NOTIFICATION_LISTENER_SERVICE` CANNOT be requested via in-app system popups. They REQUIRE redirecting the user to dedicated OS Settings pages.

2. **The "Don't Ask Again" / 2-Strike Permanent Denial Rule:**
   - On Android 11+, if a user denies a runtime permission twice (or ticks "Don't ask again"), `shouldShowRequestPermissionRationale()` evaluates to `false`.
   - Once permanently denied, the Android OS **silently rejects** subsequent `RequestPermission()` calls without displaying any system UI.
   - If the app does not detect this condition, the UI appears frozen/unresponsive. The app MUST guide the user to App Details Settings (`Settings.ACTION_APPLICATION_DETAILS_SETTINGS`).

3. **The Lifecycle Resume Gap:**
   - When the user is redirected to OS Settings to enable a permission, upon returning to the app (`ON_RESUME`), the app frequently loses track of the ongoing user action, forcing the user to tap the action button all over again.

---

## 2. The Unified Smart Permission Architecture (USPC)

To solve these problems, the application enforces the **4-Tier Permission Architecture**:

```text
                                [ User triggers Action ]
                                           │
                                           ▼
                         [ Check Permission Status ]
                                           │
                  ┌────────────────────────┴────────────────────────┐
                  ▼                                                 ▼
             [ GRANTED ]                                      [ NOT GRANTED ]
                  │                                                 │
                  ▼                                                 ▼
         [ Execute Action ]                               [ Check Permission Type ]
                                                                    │
                                    ┌───────────────────────────────┴───────────────────────────────┐
                                    ▼                                                               ▼
                        [ RUNTIME PERMISSION ]                                            [ SPECIAL PERMISSION ]
                                    │                                                               │
                    ┌───────────────┴───────────────┐                                               │
                    ▼                               ▼                                               ▼
          [ First Time / Rationale ]    [ Permanently Denied ]                              [ Show Special Dialog ]
                    │                           (>= 2 Rejects)                                      │
                    ▼                               │                                               ▼
          [ Show System Popup ]                     ▼                                     [ Open Specific Settings ]
                    │                         [ Show Dialog ]                               (All Files / Overlay...)
                    ▼                               │                                               │
          [ Granted? ]                              ▼                                               ▼
            ├── YES ──> [ Execute Action ]    [ Open App Settings ] ──────────┐            [ User returns to App ]
            └── NO  ──> [ Re-eval Rationale ]       │                         │                     │
                                                    └─────────────────────────┼─────────────────────┘
                                                                              ▼
                                                                  [ Lifecycle ON_RESUME ]
                                                                              │
                                                                              ▼
                                                                [ Auto Re-check & Execute ]
```

---

## 3. Permission Taxonomy (`AppPermission`)

Define a centralized, type-safe contract for all permissions across the application:

```kotlin
sealed interface AppPermission {
    val titleRes: Int
    val descriptionRes: Int
    val icon: ImageVector

    // 1. STANDARD RUNTIME PERMISSIONS (System Popups)
    data object Notification : AppPermission {
        @RequiresApi(Build.VERSION_CODES.TIRAMISU)
        const val PERMISSION = Manifest.permission.POST_NOTIFICATIONS
        override val titleRes = R.string.perm_notification_title
        override val descriptionRes = R.string.perm_notification_desc
        override val icon = Icons.Outlined.Notifications
    }

    data object Camera : AppPermission {
        const val PERMISSION = Manifest.permission.CAMERA
        override val titleRes = R.string.perm_camera_title
        override val descriptionRes = R.string.perm_camera_desc
        override val icon = Icons.Outlined.CameraAlt
    }

    data object Location : AppPermission {
        const val PERMISSION = Manifest.permission.ACCESS_FINE_LOCATION
        override val titleRes = R.string.perm_location_title
        override val descriptionRes = R.string.perm_location_desc
        override val icon = Icons.Outlined.LocationOn
    }

    // 2. SPECIAL APP ACCESS PERMISSIONS (Settings Redirects)
    data object AllFilesAccess : AppPermission {
        override val titleRes = R.string.perm_storage_title
        override val descriptionRes = R.string.perm_storage_desc
        override val icon = Icons.Outlined.Folder
        
        fun isGranted(): Boolean = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else true

        fun createSettingsIntent(context: Context): Intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION).apply {
                data = Uri.parse("package:${context.packageName}")
            }
        } else {
            createAppSettingsIntent(context)
        }
    }

    data object DrawOverlays : AppPermission {
        override val titleRes = R.string.perm_overlay_title
        override val descriptionRes = R.string.perm_overlay_desc
        override val icon = Icons.Outlined.Layers

        fun isGranted(context: Context): Boolean = Settings.canDrawOverlays(context)

        fun createSettingsIntent(context: Context): Intent =
            Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION).apply {
                data = Uri.parse("package:${context.packageName}")
            }
    }

    data object UsageStats : AppPermission {
        override val titleRes = R.string.perm_usage_title
        override val descriptionRes = R.string.perm_usage_desc
        override val icon = Icons.Outlined.QueryStats

        fun isGranted(context: Context): Boolean {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
            return mode == AppOpsManager.MODE_ALLOWED
        }

        fun createSettingsIntent(): Intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
    }

    companion object {
        fun createAppSettingsIntent(context: Context): Intent =
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.fromParts("package", context.packageName, null)
            }
    }
}
```

---

## 4. Reusable Compose Hook: `rememberPermissionController()`

This hook is instantiated strictly at the **Router layer (`*Route`)**. It orchestrates launchers, tracks permanent denials, and auto-executes the action upon `ON_RESUME`:

```kotlin
sealed interface PermissionDialogType {
    data class Rationale(val permission: AppPermission) : PermissionDialogType
    data class Settings(val permission: AppPermission) : PermissionDialogType
}

@Stable
class PermissionControllerState(
    val request: (AppPermission) -> Unit,
    val dialogState: PermissionDialogType?,
    val dismissDialog: () -> Unit,
    val openSettings: (AppPermission) -> Unit
)

@Composable
fun rememberPermissionController(
    onPermissionGranted: (AppPermission) -> Unit = {},
    onPermissionDenied: (AppPermission) -> Unit = {}
): PermissionControllerState {
    val context = LocalContext.current
    val activity = context as? Activity
    
    var activePermission by remember { mutableStateOf<AppPermission?>(null) }
    var dialogState by remember { mutableStateOf<PermissionDialogType?>(null) }
    var waitingForResumeCheck by remember { mutableStateOf(false) }

    // SharedPreferences to track if permission was requested at least once
    val prefs = remember { context.getSharedPreferences("permission_tracker", Context.MODE_PRIVATE) }

    // 1. Activity Result Launcher for Standard Runtime Permissions
    val runtimeLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        val perm = activePermission ?: return@rememberLauncherForActivityResult
        if (isGranted) {
            dialogState = null
            onPermissionGranted(perm)
        } else {
            val hasRequestedBefore = prefs.getBoolean(perm.toString(), false)
            prefs.edit().putBoolean(perm.toString(), true).apply()

            val permString = when (perm) {
                is AppPermission.Notification -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) Manifest.permission.POST_NOTIFICATIONS else ""
                is AppPermission.Camera -> Manifest.permission.CAMERA
                is AppPermission.Location -> Manifest.permission.ACCESS_FINE_LOCATION
                else -> ""
            }

            val showRationale = activity != null && permString.isNotEmpty() &&
                ActivityCompat.shouldShowRequestPermissionRationale(activity, permString)

            if (!showRationale && hasRequestedBefore) {
                // Permanently Denied (> 2 rejections or "Don't ask again") -> Prompt Settings
                dialogState = PermissionDialogType.Settings(perm)
            } else {
                // First rejection -> Show In-App Rationale
                dialogState = PermissionDialogType.Rationale(perm)
            }
            onPermissionDenied(perm)
        }
    }

    // 2. Settings Launcher
    val settingsLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) {
        // Will be verified on ON_RESUME
    }

    // 3. Lifecycle ON_RESUME Auto-Recheck & Auto-Trigger Action
    LifecycleEventEffect(Lifecycle.Event.ON_RESUME) {
        if (waitingForResumeCheck && activePermission != null) {
            val perm = activePermission!!
            val isNowGranted = when (perm) {
                is AppPermission.AllFilesAccess -> perm.isGranted()
                is AppPermission.DrawOverlays -> perm.isGranted(context)
                is AppPermission.UsageStats -> perm.isGranted(context)
                is AppPermission.Notification -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
                    } else true
                }
                is AppPermission.Camera -> {
                    ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
                }
                is AppPermission.Location -> {
                    ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                }
            }

            if (isNowGranted) {
                dialogState = null
                waitingForResumeCheck = false
                onPermissionGranted(perm)
            }
        }
    }

    return remember(runtimeLauncher, settingsLauncher, dialogState) {
        PermissionControllerState(
            request = { perm ->
                activePermission = perm
                when (perm) {
                    is AppPermission.AllFilesAccess -> {
                        if (perm.isGranted()) onPermissionGranted(perm) else dialogState = PermissionDialogType.Settings(perm)
                    }
                    is AppPermission.DrawOverlays -> {
                        if (perm.isGranted(context)) onPermissionGranted(perm) else dialogState = PermissionDialogType.Settings(perm)
                    }
                    is AppPermission.UsageStats -> {
                        if (perm.isGranted(context)) onPermissionGranted(perm) else dialogState = PermissionDialogType.Settings(perm)
                    }
                    is AppPermission.Notification -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            if (ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
                                onPermissionGranted(perm)
                            } else {
                                runtimeLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                            }
                        } else {
                            onPermissionGranted(perm)
                        }
                    }
                    is AppPermission.Camera -> {
                        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
                            onPermissionGranted(perm)
                        } else {
                            runtimeLauncher.launch(Manifest.permission.CAMERA)
                        }
                    }
                    is AppPermission.Location -> {
                        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                            onPermissionGranted(perm)
                        } else {
                            runtimeLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                        }
                    }
                }
            },
            dialogState = dialogState,
            dismissDialog = { dialogState = null },
            openSettings = { perm ->
                waitingForResumeCheck = true
                val intent = when (perm) {
                    is AppPermission.AllFilesAccess -> perm.createSettingsIntent(context)
                    is AppPermission.DrawOverlays -> perm.createSettingsIntent(context)
                    is AppPermission.UsageStats -> perm.createSettingsIntent()
                    else -> AppPermission.createAppSettingsIntent(context)
                }
                settingsLauncher.launch(intent)
            }
        )
    }
}
```

---

## 5. Unified Design System Dialog Host (`PermissionDialogHost.kt`)

```kotlin
@Composable
fun PermissionDialogHost(
    controller: PermissionControllerState,
    modifier: Modifier = Modifier
) {
    when (val state = controller.dialogState) {
        is PermissionDialogType.Rationale -> {
            AppConfirmDialog(
                title = stringResource(state.permission.titleRes),
                message = stringResource(state.permission.descriptionRes),
                confirmText = stringResource(R.string.permission_allow_btn),
                dismissText = stringResource(R.string.permission_cancel_btn),
                onConfirm = {
                    controller.dismissDialog()
                    controller.request(state.permission)
                },
                onDismiss = controller.dismissDialog,
                modifier = modifier
            )
        }
        is PermissionDialogType.Settings -> {
            AppConfirmDialog(
                title = stringResource(state.permission.titleRes),
                message = stringResource(R.string.permission_settings_guide_msg, stringResource(state.permission.titleRes)),
                confirmText = stringResource(R.string.permission_open_settings_btn),
                dismissText = stringResource(R.string.permission_cancel_btn),
                onConfirm = {
                    controller.dismissDialog()
                    controller.openSettings(state.permission)
                },
                onDismiss = controller.dismissDialog,
                modifier = modifier
            )
        }
        null -> Unit
    }
}
```

---

## 6. Usage at Router Layer (`*Route.kt`)

```kotlin
@Composable
fun HomeRoute(
    viewModel: HomeViewModel = koinViewModel(),
    onNavigateToDetail: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    // 1. One-line Smart Permission Controller
    val permissionController = rememberPermissionController(
        onPermissionGranted = { perm ->
            when (perm) {
                is AppPermission.AllFilesAccess -> viewModel.onIntent(HomeIntent.StartStorageScan)
                is AppPermission.Notification -> viewModel.onIntent(HomeIntent.EnableNotificationAlerts)
                else -> Unit
            }
        }
    )

    // 2. Pure Stateless Screen
    HomeScreen(
        uiState = uiState,
        onIntent = { intent ->
            when (intent) {
                is HomeIntent.RequestStoragePermission -> {
                    permissionController.request(AppPermission.AllFilesAccess)
                }
                is HomeIntent.RequestNotificationPermission -> {
                    permissionController.request(AppPermission.Notification)
                }
                else -> viewModel.onIntent(intent)
            }
        },
        onNavigateToDetail = onNavigateToDetail,
        modifier = modifier
    )

    // 3. Automated Dialog Host
    PermissionDialogHost(controller = permissionController)
}
```
