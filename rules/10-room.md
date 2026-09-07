# 10-room.md

# Purpose

This document defines the persistence architecture using Room.

The database is the single source of truth for local data.

Room should provide:

- Reliable persistence
- Offline support
- Predictable data flow
- Easy migration
- Testability
- High performance

The agent MUST follow these rules when implementing local storage.

---

# Core Principles

Room belongs exclusively to the Data Layer.

Presentation and Domain must never depend on Room.

Preferred architecture:

```text
UI
    ↓
ViewModel
    ↓
UseCase
    ↓
Repository
    ↓
LocalDataSource
    ↓
DAO
    ↓
Room Database
```

Never bypass Repository.

---

# Layer Responsibilities

Presentation

Responsible for:

- Rendering state

Never:

- Query Room
- Access DAO
- Read Entity

---

Domain

Responsible for:

- Business models
- Business rules

Never know:

- Room
- Entity
- DAO

---

Data

Responsible for:

- Entity
- DAO
- Database
- Mapping
- Cache strategy

---

# Entity Rules

Entities represent persistence only.

Example:

```kotlin
@Entity(tableName = "audio_files")
data class AudioEntity(
    @PrimaryKey
    val id: Long,
    val name: String,
    val duration: Long
)
```

Entity must NOT:

- Contain UI state
- Contain Compose annotations
- Contain business logic

---

# Domain Separation

Preferred flow:

```text
Database

↓

Entity

↓

Mapper

↓

Domain

↓

Presentation
```

Never expose Entity outside Data Layer.

---

# DAO Rules

Each Entity should have its own DAO.

Example:

```text
AudioDao

FolderDao

SettingDao

HistoryDao
```

Avoid:

```text
DatabaseDao
```

containing unrelated queries.

---

# DAO Responsibilities

DAO is responsible for:

- CRUD
- Queries
- Transactions

DAO must NOT:

- Perform business logic
- Build UI models
- Execute network requests

---

# Repository Rules

Repository coordinates:

- Room
- Remote API
- Cache
- Synchronization

Repository decides where data comes from.

Presentation must never decide.

---

# Query Rules

Prefer explicit queries.

Good:

```kotlin
@Query("""
SELECT *
FROM audio_files
WHERE id = :id
""")
```

Avoid ambiguous queries.

Keep SQL readable.

---

# Return Types

DAO may return:

- Flow
- Entity
- List<Entity>
- PagingSource
- Primitive

Repository returns:

Domain Models.

Never Entity.

---

# Flow Rules

Observe database changes using Flow.

Example:

```kotlin
@Query(...)
fun observeFiles(): Flow<List<AudioEntity>>
```

Avoid polling.

---

# Transactions

Use @Transaction when:

- Multiple tables
- Parent-child inserts
- Batch updates
- Atomic operations

Never manually simulate transactions.

---

# Relationships

Use Room relations only when appropriate.

Example:

```text
Folder

↓

Files
```

Avoid deeply nested relationships.

Prefer explicit loading for large datasets.

---

# Index Rules

Every frequently queried column should be evaluated for indexing.

Examples:

- id
- path
- folderId
- createdTime
- modifiedTime

Avoid unnecessary indexes.

Indexes improve reads but increase write cost.

---

# Primary Key Rules

Every Entity must define a stable PrimaryKey.

Avoid mutable primary keys.

Prefer:

```text
Long

UUID

Stable String
```

---

# Migration Rules

Never use:

```kotlin
fallbackToDestructiveMigration()
```

in production.

Every schema change should include:

- Migration
- Testing
- Verification

---

# Versioning

Database versions should increase sequentially.

Every version must document:

- Added tables
- Removed columns
- Renamed fields
- Data migration

---

# TypeConverter Rules

Use TypeConverter only when necessary.

Examples:

- Instant
- LocalDateTime
- Enum
- Uri

Avoid converting large objects.

---

# Large Data

Avoid storing:

- Bitmap
- Video
- Audio
- Large JSON

Store only references.

Example:

```text
Database

↓

File Path
```

instead of binary data.

---

# Caching Strategy

Repository decides cache policy.

Possible strategies:

```text
Local First

Remote First

Cache First

Network First

Offline First
```

Presentation should not know.

---

# Synchronization

Preferred synchronization:

```text
Remote

↓

Repository

↓

Room

↓

Flow

↓

UI
```

Room remains the source of truth.

---

# Pagination

Large datasets should use:

PagingSource

instead of loading everything into memory.

---

# Performance Rules

Avoid:

- SELECT *
- Huge transactions
- Deep joins
- Repeated queries

Load only required columns.

---

# Background Work

Database operations must run off Main Thread.

Preferred:

IO Dispatcher.

Never block UI.

---

# Database Initialization

Database should be:

Singleton.

Create only one RoomDatabase instance.

Register through Koin.

---

# Dependency Injection

Inject:

- Database
- DAO
- LocalDataSource

Never instantiate Room manually.

---

# Testing

Test:

- DAO
- Migration
- Repository
- TypeConverters

Use in-memory database when appropriate.

---

# Review Checklist

Before completing persistence code:

□ Entity separated from Domain

□ DAO focused

□ Repository returns Domain

□ Flow used correctly

□ Transactions where needed

□ Migration provided

□ Indexes evaluated

□ Singleton database

□ No Main Thread queries

□ Testable

---

# Anti-patterns

Do not:

Composable

↓

DAO

Do not:

ViewModel

↓

DAO

Do not:

Entity

↓

UI

Do not:

Database

↓

Presentation

Do not:

Store Bitmap in Room

Do not:

fallbackToDestructiveMigration()

for production.

---

# Decision Priority

When implementing persistence:

1. Existing architecture

2. Repository Pattern

3. Domain separation

4. Offline support

5. Flow observation

6. Performance

7. Testability

---

# Final Rule

Room is an implementation detail of the Data Layer.

Presentation requests business data.

Repositories decide how data is stored, synchronized, and retrieved.

Keep persistence reliable, scalable, and invisible to the UI.