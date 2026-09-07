# Skill: Secure Vault & File Encryption (AndroidX Security Crypto)

## Overview

This skill defines the architectural and implementation patterns for secure file storage, vault management, biometric authentication, and AES-256-GCM encryption in Android using `androidx.security:security-crypto`.

---

## Related Files

- Rules: `rules/02-architecture.md`, `rules/17-security.md`, `rules/21-enforcement-engine.md` (E8.1 No Hardcoded Secrets)
- Domain/Data: `VaultRepository.kt`, `VaultRepositoryImpl.kt`
- Presentation: `VaultScreen.kt`, `VaultViewModel.kt`, `VaultContract.kt`

---

## Security Architecture

```text
Original File (Storage) 
      │
      ▼ [MasterKey (Android Keystore)]
EncryptedFile (AES256_GCM_HKDF_4KB)
      │
      ▼ (Saved into private app storage)
App Internal Files Dir (/data/data/.../files/vault/)
      │
      ▼ (Original file securely wiped from public storage)
Public Storage Sanitized
```

---

## Implementation Patterns

### 1. MasterKey Creation

```kotlin
private fun getMasterKey(context: Context): MasterKey {
    return MasterKey.Builder(context)
        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        .setRequestStrongBoxBacked(true) // Attempt hardware StrongBox if available
        .build()
}
```

### 2. Encrypting File into Vault

```kotlin
suspend fun encryptToVault(
    context: Context,
    sourceFile: File,
    vaultDirectory: File
): Flow<DataState<VaultItem>> = flow {
    emit(DataState.Loading)
    withContext(Dispatchers.IO) {
        val masterKey = getMasterKey(context)
        val encryptedFileName = "${UUID.randomUUID()}.vault"
        val encryptedFile = File(vaultDirectory, encryptedFileName)

        val secureFile = EncryptedFile.Builder(
            context,
            encryptedFile,
            masterKey,
            EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
        ).build()

        // Read source, write encrypted output
        sourceFile.inputStream().use { input ->
            secureFile.openFileOutput().use { output ->
                input.copyTo(output)
            }
        }

        // Secure wipe of original file after successful encryption
        if (sourceFile.exists() && encryptedFile.length() > 0) {
            sourceFile.delete()
        }

        emit(DataState.Success(
            VaultItem(
                id = encryptedFileName,
                originalName = sourceFile.name,
                originalPath = sourceFile.absolutePath,
                fileSize = encryptedFile.length(),
                encryptedPath = encryptedFile.absolutePath
            )
        ))
    }
}.catch { e ->
    emit(DataState.Error("Encryption failed: ${e.localizedMessage}"))
}
```

### 3. Decrypting & Restoring File from Vault

```kotlin
suspend fun decryptFromVault(
    context: Context,
    vaultItem: VaultItem,
    targetDirectory: File
): Flow<DataState<File>> = flow {
    emit(DataState.Loading)
    withContext(Dispatchers.IO) {
        val masterKey = getMasterKey(context)
        val encryptedFile = File(vaultItem.encryptedPath)
        val decryptedFile = File(targetDirectory, vaultItem.originalName)

        val secureFile = EncryptedFile.Builder(
            context,
            encryptedFile,
            masterKey,
            EncryptedFile.FileEncryptionScheme.AES256_GCM_HKDF_4KB
        ).build()

        secureFile.openFileInput().use { input ->
            decryptedFile.outputStream().use { output ->
                input.copyTo(output)
            }
        }

        // Delete encrypted copy if restore succeeded
        if (decryptedFile.exists() && decryptedFile.length() > 0) {
            encryptedFile.delete()
        }

        emit(DataState.Success(decryptedFile))
    }
}.catch { e ->
    emit(DataState.Error("Decryption failed: ${e.localizedMessage}"))
}
```

---

## Biometric Auth & PIN Access Flow

1. **BiometricPrompt Support:**
   - Integrate `BiometricPrompt` with `BIOMETRIC_STRONG or DEVICE_CREDENTIAL`.
   - On authentication success: Proceed to unlock Vault.
2. **PIN Fallback:**
   - Store hashed PIN using PBKDF2/Argon2 or EncryptedSharedPreferences.
   - Never store plain text PINs.
3. **Session Auto-Lock:**
   - When the user puts the app in the background (`onStop`/`Lifecycle.Event.ON_PAUSE`), reset Vault session state to locked immediately.
