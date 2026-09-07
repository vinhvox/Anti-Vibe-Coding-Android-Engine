# 15-debugging.md

# Purpose

This document defines the project's debugging methodology.

Debugging is a structured investigation process.

The goal is to identify root causes, implement minimal fixes, and prevent regressions.

Never debug by guessing.

---

# Core Principles

Every bug has a cause.

Never modify production code until sufficient evidence has been collected.

Fix causes, not symptoms.

---

# Debugging Workflow

Every investigation must follow this order.

```text
Bug Report
      ↓
Reproduce
      ↓
Collect Evidence
      ↓
Inspect Logs
      ↓
Narrow Scope
      ↓
Identify Root Cause
      ↓
Implement Fix
      ↓
Regression Test
      ↓
Verification
```

Never skip steps.

---

# Step 1 — Understand the Problem

Before touching code determine:

- What happened?
- What was expected?
- What actually occurred?
- Can it be reproduced?
- Does it happen consistently?

Never assume.

---

# Step 2 — Reproduce

Always reproduce the issue.

Record:

- Device
- Android Version
- Build Variant
- App Version
- Steps
- Frequency

Preferred:

```text
Always

Sometimes

Rarely

Random
```

If reproduction is impossible:

Gather more evidence first.

---

# Step 3 — Collect Evidence

Collect:

- Logcat
- Stacktrace
- Crash Report
- User Actions
- Network Logs
- Database State
- Screenshots
- Screen Recording

Do not rely on memory.

---

# Step 4 — Inspect Logs

Logs should answer:

- What happened?
- When?
- Which layer?
- Which request?
- Which thread?

Avoid adding excessive logging.

---

# Step 5 — Narrow the Scope

Reduce the possible causes.

Example:

```text
UI

↓

ViewModel

↓

UseCase

↓

Repository

↓

Remote

or

↓

Local
```

Avoid changing multiple layers simultaneously.

---

# Step 6 — Root Cause Analysis

Identify why the bug occurred.

Examples:

- Incorrect State
- Race Condition
- Null Value
- Invalid Lifecycle
- Missing Permission
- Wrong Mapping
- Cache Issue
- Navigation Issue

Fix the root cause only.

---

# Step 7 — Implement Fix

Fix the smallest possible area.

Avoid unrelated refactoring.

The fix should:

- Solve the issue
- Preserve architecture
- Avoid side effects

---

# Step 8 — Regression Testing

Verify:

- Original bug fixed
- Related functionality still works
- No new crashes
- No UI regression

Never assume.

---

# Step 9 — Verification

Confirm:

□ Expected behavior

□ Edge cases

□ Error handling

□ Loading state

□ Empty state

□ Performance

□ Memory

□ Build success

---

# Logging Rules

Log useful information.

Good:

- Screen
- Action
- Duration
- Request ID
- Error Code

Avoid logging:

- Password
- Token
- Personal Data

---

# Crash Investigation

Always inspect:

- Stacktrace
- Root Exception
- Caused By
- Thread
- Device Information

Do not fix based solely on the top stack frame.

---

# Threading Issues

Verify:

- Main Thread
- IO Thread
- Coroutine Scope
- Dispatcher

Common problems:

- Main Thread blocking
- Wrong Dispatcher
- Race conditions
- Cancellation

---

# State Debugging

Verify:

```text
Intent

↓

ViewModel

↓

UiState

↓

Composable
```

Ensure state changes follow the expected flow.

---

# Network Debugging

Check:

- URL
- Headers
- Body
- Response
- Timeout
- Retry
- Authentication

Verify server responses before changing client logic.

---

# Database Debugging

Check:

- SQL Query
- Entity Mapping
- Migration
- Transactions
- Indexes

Confirm stored data matches expectations.

---

# Compose Debugging

Inspect:

- Recomposition
- State Hoisting
- Side Effects
- remember
- rememberSaveable
- collectAsStateWithLifecycle()

Avoid assuming recomposition is the cause.

---

# Navigation Debugging

Verify:

- Destination
- Arguments
- Back Stack
- Navigation Event

Ensure navigation matches intended user flow.

---

# Performance Debugging

Measure before optimizing.

Inspect:

- Frame Time
- Startup
- Memory
- CPU
- Disk
- Network

Never optimize blindly.

---

# Memory Debugging

Investigate:

- Memory Leak
- Bitmap
- Coroutine Lifetime
- Context Reference
- ViewModel Lifetime

Release resources properly.

---

# ANR Investigation

Check:

- Main Thread
- Long-running work
- Locks
- File I/O
- Database
- Network

Never perform blocking work on Main.

---

# Root Cause Documentation

Every significant bug should document:

- Cause
- Impact
- Fix
- Prevention

Knowledge should accumulate.

---

# Review Checklist

Before closing a bug:

□ Bug reproduced

□ Evidence collected

□ Root cause identified

□ Minimal fix

□ Regression tested

□ Logs reviewed

□ Performance checked

□ No unrelated changes

□ Build successful

---

# Anti-patterns

Do not:

Bug

↓

Guess

↓

Fix

Do not:

catch(Exception)

↓

Ignore

Do not:

Rewrite entire feature

for one bug.

Do not:

Refactor unrelated files

during debugging.

Do not:

Disable functionality

to hide bugs.

---

# Decision Priority

When debugging:

1. Reproduce

2. Collect evidence

3. Narrow scope

4. Find root cause

5. Implement minimal fix

6. Verify

7. Prevent regression

---

# Final Rule

Debugging is an investigation, not experimentation.

Evidence should guide every decision.

Fix the root cause with the smallest possible change while preserving architecture and preventing future regressions.