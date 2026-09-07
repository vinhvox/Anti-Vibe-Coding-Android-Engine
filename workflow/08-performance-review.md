---
name: performance-review
description: Phase 8 workflow to objectively measure, profile, and evaluate app performance across Compose recomposition, Memory, CPU, Database, Network, and Battery usage.
triggers:
  - "performance review"
  - "kiểm tra hiệu năng"
  - "profile app"
prerequisites:
  - ".antigravity/workflow/07-testing-validation.md"
next_step: ".antigravity/workflow/09-security-review.md"
---
# 08-performance-review.md

# Purpose

This document defines the performance review workflow.

Performance review evaluates whether an implementation meets the project's performance standards before release.

Optimization should only occur when objective measurements identify performance issues.

Always measure before optimizing.

---

# Philosophy

Performance is a feature.

Optimization without measurement is premature optimization.

Review performance objectively using metrics and profiling tools.

---

# Core Principles

Always:

Measure before optimizing.

Profile before changing.

Optimize bottlenecks.

Preserve readability.

Avoid micro-optimizations without evidence.

---

# Performance Review Workflow

Every implementation follows this workflow.

```text
Implementation
        │
        ▼
Identify Critical Paths
        │
        ▼
Collect Metrics
        │
        ▼
Analyze Bottlenecks
        │
        ▼
Review UI Performance
        │
        ▼
Review Memory
        │
        ▼
Review CPU
        │
        ▼
Review I/O
        │
        ▼
Review Network
        │
        ▼
Review Battery
        │
        ▼
Optimization Decision
        │
        ▼
Ready
```

---

# Step 1 — Identify Critical Paths

Determine the performance-sensitive areas.

Examples:

- App startup
- Navigation
- Screen rendering
- Scrolling
- Search
- Database access
- Network requests
- Media playback

Focus on user-visible performance.

---

# Step 2 — Collect Metrics

Gather objective metrics before making changes.

Examples:

- Startup time
- Frame time
- Memory usage
- CPU usage
- Database latency
- API response time
- APK size

Never rely on assumptions.

---

# Step 3 — Analyze Bottlenecks

Identify the root cause.

Possible bottlenecks:

- Main thread blocking
- Excessive recomposition
- Inefficient SQL queries
- Large object allocations
- Redundant network requests
- Expensive image decoding

Fix causes, not symptoms.

---

# Step 4 — UI Performance Review

Verify:

- Smooth scrolling
- Stable frame rate
- Minimal overdraw
- Efficient Compose recomposition
- Lazy loading used where appropriate

The UI should remain responsive.

---

# Step 5 — Compose Performance Review

Inspect:

- Stable parameters
- remember usage
- rememberSaveable usage
- derivedStateOf
- key in LazyColumn/LazyGrid
- Lazy layouts
- State hoisting
- Immutable UiState

Avoid unnecessary recompositions.

---

# Step 6 — Memory Review

Verify:

- No memory leaks
- No unnecessary allocations
- Objects released appropriately
- Bitmap usage optimized
- Cache size appropriate

Memory should remain stable over time.

---

# Step 7 — CPU Review

Verify:

- Heavy work off Main thread
- Efficient algorithms
- Minimal repeated computations
- Appropriate coroutine dispatchers

CPU-intensive work should not affect UI responsiveness.

---

# Step 8 — Database Review

Inspect:

- Indexed queries
- Efficient DAO operations
- Batch operations where applicable
- Minimal database access

Avoid redundant queries.

---

# Step 9 — Network Review

Verify:

- Request batching where appropriate
- Compression enabled
- Response caching
- Retry strategy
- Timeout configuration

Network usage should be efficient and resilient.

---

# Step 10 — Storage Review

Inspect:

- File operations
- Disk I/O
- Cache usage
- Temporary file cleanup

Avoid unnecessary disk operations.

---

# Step 11 — Battery Review

Verify:

- Background work minimized
- Wake locks avoided
- Efficient scheduling
- Network usage optimized
- Sensor usage minimized

Performance should not unnecessarily impact battery life.

---

# Step 12 — Benchmark Review

Run relevant benchmarks when available.

Examples:

- Macrobenchmark
- Baseline Profile
- Startup Benchmark
- Scroll Benchmark

Benchmark results should guide optimization.

---

# Step 13 — Optimization Decision

Only optimize when:

- Metrics exceed project thresholds
- Bottlenecks identified
- User experience is affected

Do not optimize speculative issues.

---

# Deliverables

Performance review should produce:

- Metrics Summary
- Bottleneck Analysis
- Optimization Recommendations
- Benchmark Results
- Remaining Risks

---

# Review Checklist

Before completing performance review:

□ Critical paths identified

□ Metrics collected

□ Bottlenecks analyzed

□ UI performance acceptable

□ Compose reviewed

□ Memory reviewed

□ CPU reviewed

□ Database reviewed

□ Network reviewed

□ Storage reviewed

□ Battery reviewed

□ Benchmarks reviewed

---

# Anti-patterns

Do not:

Optimize without measurement.

Do not:

Trade readability for insignificant gains.

Do not:

Ignore user-visible performance.

Do not:

Perform heavy work on the Main thread.

Do not:

Prematurely optimize every function.

Do not:

Ignore benchmark results.

---

# Decision Priority

When reviewing performance:

1. User experience

2. Main thread responsiveness

3. Frame stability

4. Memory efficiency

5. CPU efficiency

6. Database efficiency

7. Network efficiency

8. Battery efficiency

---

# Exit Criteria

Performance review is complete only if:

✓ Critical paths reviewed

✓ Performance metrics acceptable

✓ No significant bottlenecks remain

✓ UI remains responsive

✓ Memory stable

✓ CPU usage acceptable

✓ Network efficient

✓ Battery impact acceptable

✓ Benchmark targets satisfied (when applicable)

---

# Final Rule

Performance should be guided by measurement, not intuition.

The goal is not to create the fastest possible code, but to deliver a consistently responsive, efficient, and maintainable application.