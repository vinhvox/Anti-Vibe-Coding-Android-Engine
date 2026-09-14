# 09-memory-validation.md

# Memory Validation Engine

## Purpose

This document defines how the AI verifies the correctness, consistency, freshness, and applicability of all stored memory before it is used.

Memory Validation exists to ensure that reasoning is based only on trustworthy engineering knowledge.

No memory should be trusted automatically.

Every important memory should be validated before influencing engineering decisions.

---

# Philosophy

Memory is evidence.

Evidence must be verified.

Reasoning quality depends on memory quality.

The AI should trust validated knowledge,

not merely remembered knowledge.

---

# Primary Goal

Ensure every retrieved memory is:

Correct

Current

Consistent

Verified

Relevant

Applicable

Only validated memory should influence engineering decisions.

---

# Validation Pipeline

Every retrieved memory follows this process.

```text
Retrieve
    │
    ▼
Integrity Check
    │
    ▼
Consistency Check
    │
    ▼
Freshness Check
    │
    ▼
Conflict Detection
    │
    ▼
Confidence Evaluation
    │
    ▼
Validation Result
    │
    ▼
Reasoning
```

Validation always occurs before reasoning.

---

# Validation Principles

Every memory should be evaluated using:

Correctness

Consistency

Freshness

Evidence

Confidence

Applicability

A memory is useful only if it remains valid.

---

# Validation Categories

Project Memory

Decision Memory

Pattern Memory

User Preference

Session Memory

Task Memory

Architecture Knowledge

Engineering Rules

Each category has different validation requirements.

---

# Integrity Check

Verify:

Is the memory complete?

Is required information present?

Has the memory been corrupted?

Does it reference existing knowledge?

Reject incomplete memory.

---

# Consistency Check

Verify:

Does it match project architecture?

Does it match current codebase?

Does it agree with accepted decisions?

Does it conflict with newer patterns?

Consistency is more important than age.

---

# Freshness Check

Verify:

Has architecture changed?

Has technology changed?

Has the user changed preferences?

Has a newer decision replaced this one?

Older memory requires stronger validation.

---

# Conflict Detection

Detect conflicts between:

Current request

Project Memory

Decision Memory

Pattern Memory

User Preferences

Engineering Rules

If conflicts exist,

identify the strongest source.

---

# Confidence Evaluation

Each memory should receive a confidence score.

Factors include:

Source reliability

Frequency of use

Validation history

Consistency

Recency

Project adoption

Higher confidence should influence decisions more strongly.

---

# Applicability Check

Verify:

Does this memory apply to the current feature?

Current module?

Current architecture?

Current workflow phase?

Relevant memory is more important than available memory.

---

# Validation Results

Possible outcomes:

Verified

Needs Refresh

Outdated

Conflicting

Rejected

Archived

Only Verified memories should be applied automatically.

---

# Automatic Refresh

If memory is outdated:

Attempt revalidation.

If successful,

update confidence.

Otherwise,

mark for review.

Never silently use stale memory.

---

# Validation Priority

Validate in this order:

Current User Instruction

↓

Current Session

↓

Task Memory

↓

Project Memory

↓

Decision Memory

↓

Pattern Memory

↓

User Preferences

↓

Engineering Rules

Higher-priority knowledge overrides lower-priority knowledge.

---

# Validation Frequency

Always validate when:

Requirements change

Architecture changes

Task changes

Major decisions change

Project version changes

Session resumes

Memory should never become permanently trusted.

---

# Validation History

Every validation should record:

Validation time

Result

Confidence

Reason

Updated fields

Reviewer (if applicable)

Validation history improves future confidence estimation.

---

# Failure Recovery

If validation fails:

Attempt refresh.

↓

Retrieve alternative memory.

↓

Ask targeted clarification.

↓

Fall back to engineering best practices.

Never rely on invalid knowledge.

---

# Self Validation

Before reasoning verify:

Am I using validated memory?

Is this memory still current?

Does it conflict with stronger evidence?

Would asking the user improve confidence?

If uncertainty remains,

prefer clarification over assumption.

---

# Anti-patterns

Never:

Trust memory blindly.

Ignore conflicts.

Use obsolete architecture.

Skip validation because memory is familiar.

Overwrite validated memory without evidence.

Treat confidence as certainty.

---

# Final Rule

Memory Validation exists to ensure that every engineering decision is based on trusted, current, and verified knowledge.

The AI should validate before trusting,

verify before applying,

and prefer evidence over memory.