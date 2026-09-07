# 19-build.md

# Purpose

This document defines the project's build architecture and release configuration.

The build system should be:

- Fast
- Reproducible
- Secure
- Maintainable
- Scalable
- CI-friendly

Every build should produce deterministic and reliable artifacts.

---

# Core Principles

The build system is part of the architecture.

Every build configuration must be:

- Explicit
- Versioned
- Repeatable

Avoid manual build steps.

---

# Build Stack

Approved technologies:

- Gradle Kotlin DSL
- Version Catalog
- KSP
- AGP (latest stable)
- Kotlin (latest stable)

Avoid:

- Groovy build scripts
- kapt (unless unavoidable)
- Legacy dependency management

---

# Module Organization

Modules should follow feature-based architecture.

Example:

```text
app/

core/

feature/

domain/

data/

designsystem/

benchmark/

build-logic/
```

Avoid a monolithic application module.

---

# Version Catalog

All dependencies must be managed through:

```text
gradle/libs.versions.toml
```

Never hardcode dependency versions inside module build files.

Preferred:

```kotlin
implementation(libs.androidx.core.ktx)
```

Avoid:

```kotlin
implementation("androidx.core:core-ktx:1.17.0")
```

---

# Convention Plugins

Common build logic belongs inside:

```text
build-logic/
```

Avoid duplicating Gradle configuration across modules.

Examples:

- Android Library
- Android Application
- Compose
- Koin
- Ktor
- Room
- Testing

---

# Build Types

Supported build types:

- debug
- release

Optional:

- benchmark

Avoid unnecessary custom build types.

---

# Product Flavors

Use flavors only when required.

Examples:

```text
development

staging

production
```

Flavors should represent environments, not features.

---

# Build Configuration

Configuration values should come from:

- BuildConfig
- Version Catalog
- Gradle Properties

Avoid hardcoded values.

---

# Secrets Management

Never commit:

- API Keys
- Signing Keys
- Tokens
- Passwords

Use:

- local.properties
- Gradle Properties
- Environment Variables
- CI Secret Store

Never store secrets in source control.

---

# Signing

Release signing should be externalized.

Never commit:

- Keystore
- Passwords

Support secure CI signing.

---

# Dependency Management

Dependencies should:

- Be centralized
- Be updated regularly
- Remove unused libraries
- Avoid duplicates

Review dependency health regularly.

---

# Build Performance

Optimize:

- Configuration Cache
- Build Cache
- Incremental Compilation
- KSP
- Parallel Execution

Avoid unnecessary Gradle plugins.

---

# Incremental Build

Every module should support incremental builds.

Avoid invalidating the entire project unnecessarily.

---

# Resource Management

Enable:

- Resource shrinking
- Code shrinking

for Release builds.

Avoid unused resources.

---

# R8 Rules

Keep rules should:

- Be minimal
- Be documented
- Be reviewed regularly

Avoid broad keep rules.

---

# Build Variants

Each variant should have:

- Independent configuration
- Independent endpoints
- Independent analytics if required

Avoid runtime environment switching.

---

# Environment Configuration

Support:

```text
Development

↓

Staging

↓

Production
```

through build configuration.

Avoid hardcoded environments.

---

# CI/CD Compatibility

Builds should run identically:

Local

↓

CI

↓

Release

Avoid environment-specific behavior.

---

# Static Analysis

Run during CI:

- ktlint
- Detekt
- Android Lint

Builds should fail on critical violations.

---

# Testing

CI should execute:

- Unit Tests
- Instrumentation Tests (when configured)
- Lint
- Static Analysis

Avoid releasing untested builds.

---

# Versioning

Application version should follow:

```text
Major.Minor.Patch
```

Increase:

Major

- Breaking changes

Minor

- New features

Patch

- Bug fixes

VersionCode should always increase.

---

# Release Builds

Release builds must:

- Enable R8
- Remove debug logging
- Disable debugging
- Enable resource shrinking
- Use production configuration

Never release debug artifacts.

---

# Benchmark Module

Performance benchmarks should be isolated.

Preferred:

```text
benchmark/
```

Do not mix benchmark code with production modules.

---

# Reproducible Builds

Two identical source trees should produce identical build outputs.

Avoid time-dependent build logic.

---

# Documentation

Every custom Gradle configuration should be documented.

Avoid unexplained build scripts.

---

# Review Checklist

Before completing build configuration:

□ Version Catalog used

□ Convention Plugins applied

□ Secrets externalized

□ Release signing secured

□ Build cache enabled

□ Configuration cache supported

□ Build variants verified

□ Static analysis configured

□ CI compatible

□ Release optimized

---

# Anti-patterns

Do not:

Hardcode dependency versions

Do not:

Commit keystore files

Do not:

Commit API keys

Do not:

Duplicate Gradle configuration

Do not:

Use kapt without justification

Do not:

Disable R8 in Release

---

# Decision Priority

When modifying the build system:

1. Reproducibility

2. Maintainability

3. Security

4. Performance

5. Scalability

6. CI compatibility

7. Developer experience

---

# Final Rule

The build system should be deterministic, secure, fast, and easy to maintain.

Every build configuration must support scalable development while minimizing manual effort and reducing the risk of release errors.