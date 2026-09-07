# Skill: Archive & Compression Management (Zip4j)

## Overview

This skill defines the standard implementation patterns for file archiving, compression, extraction, and password-protected zip handling using **Zip4j** in this project.

---

## Related Files

- Rules: `rules/02-architecture.md`, `rules/17-security.md`, `rules/21-enforcement-engine.md` (E8.2 Zip Slip Protection)
- Workflow: `workflow/05-feature-development.md`
- Data/Domain: `ArchiveRepository.kt`, `ArchiveRepositoryImpl.kt`, `ZipInspectorContent.kt`

---

## Core Architecture Principles

1. **Pure Java 16KB Alignment Safe:** Always use `Zip4j` (`net.lingala.zip4j:zip4j:2.11.5`), avoiding NDK native C/C++ compression libraries that may fail Google Play 16KB page size requirements.
2. **Zip Slip Vulnerability Protection:** Never extract a file blindly without validating that its destination path remains strictly within the target extraction directory.
3. **Dispatchers.IO:** All compression and decompression operations must run exclusively on background I/O threads via `withContext(Dispatchers.IO)`.
4. **Reactive Progress & Error Handling:** Surface real-time progress callbacks and map `ZipException` to domain-level `DataState.Error`.

---

## Implementation Patterns

### 1. Safe Extraction with Zip Slip Guard

```kotlin
suspend fun extractArchive(
    zipFile: File,
    destinationDir: File,
    password: String? = null
): Flow<DataState<Unit>> = flow {
    emit(DataState.Loading)
    withContext(Dispatchers.IO) {
        val zip = ZipFile(zipFile)
        if (zip.isEncrypted && !password.isNullOrEmpty()) {
            zip.setPassword(password.toCharArray())
        }
        
        val targetCanonicalPath = destinationDir.canonicalPath
        
        zip.fileHeaders.forEach { header ->
            val destinationFile = File(destinationDir, header.fileName)
            val destinationCanonicalPath = destinationFile.canonicalPath
            
            // 🛡️ Mandatory Zip Slip Protection
            if (!destinationCanonicalPath.startsWith(targetCanonicalPath + File.separator)) {
                throw SecurityException("Zip Slip attack detected for file: ${header.fileName}")
            }
        }
        
        zip.extractAll(destinationDir.absolutePath)
    }
    emit(DataState.Success(Unit))
}.catch { e ->
    emit(DataState.Error(e.localizedMessage ?: "Extraction failed"))
}
```

### 2. Compression with AES-256 Encryption

```kotlin
suspend fun compressFiles(
    sourceFiles: List<File>,
    destinationZip: File,
    password: String? = null,
    compressionLevel: CompressionLevel = CompressionLevel.NORMAL
): Flow<DataState<File>> = flow {
    emit(DataState.Loading)
    withContext(Dispatchers.IO) {
        val zipParameters = ZipParameters().apply {
            this.compressionMethod = CompressionMethod.DEFLATE
            this.compressionLevel = compressionLevel
            if (!password.isNullOrBlank()) {
                this.isEncryptFiles = true
                this.encryptionMethod = EncryptionMethod.AES
                this.aesKeyStrength = AesKeyStrength.KEY_STRENGTH_256
            }
        }

        val zipFile = if (password.isNullOrBlank()) {
            ZipFile(destinationZip)
        } else {
            ZipFile(destinationZip, password.toCharArray())
        }

        sourceFiles.forEach { file ->
            if (file.isDirectory) {
                zipFile.addFolder(file, zipParameters)
            } else {
                zipFile.addFile(file, zipParameters)
            }
        }
    }
    emit(DataState.Success(destinationZip))
}.catch { e ->
    emit(DataState.Error(e.localizedMessage ?: "Compression failed"))
}
```

### 3. Password & Encryption Detection

```kotlin
suspend fun isArchiveEncrypted(archiveFile: File): Boolean = withContext(Dispatchers.IO) {
    try {
        val zip = ZipFile(archiveFile)
        zip.isEncrypted
    } catch (e: Exception) {
        false
    }
}
```

---

## UI/UX Best Practices

1. **Conditional Action Visibility:**
   - Show "Extract" ONLY when file has `.zip`, `.rar`, `.7z`, `.tar`, `.gz`.
   - Show "Compress" ONLY for uncompressed files/folders.
2. **Smart Password Field:**
   - Detect encryption upfront using `isArchiveEncrypted()`.
   - If encrypted: Show password input field in `ExtractDialog`.
   - If unencrypted: Extract immediately without prompting for password.
3. **Background Notification / Progress Dialog:**
   - For archives > 50MB, show non-blocking progress UI or Foreground Service notification.
