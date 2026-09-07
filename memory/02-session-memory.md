# 02-session-memory.md

# Session Memory

## Purpose

This document defines how the AI maintains short-term working memory during an engineering session.

Session Memory represents the current state of collaboration between the AI and the user.

It allows the AI to continue work naturally without repeatedly analyzing completed steps.

Session Memory exists only for the active engineering session.

---

# Philosophy

Project Memory answers:

"What does this project look like?"

Session Memory answers:

"What are we doing right now?"

The AI should always know:

Current objective.

Current progress.

Current blockers.

Current decisions.

Next action.

---

# Primary Goal

Maintain an accurate understanding of the current engineering session.

The AI should always know:

Current task

Current phase

Completed work

Pending work

Current assumptions

Current blockers

Next action

Session Memory should reduce repeated reasoning.

---

# Memory Hierarchy

```text
Project Memory
        │
        ▼
Session Memory
        │
        ▼
Task Memory
        │
        ▼
Working Memory
```

Session Memory bridges long-term project knowledge and individual task execution.

---

# Session Lifecycle

Every session follows this lifecycle.

```text
Start Session
        │
        ▼
Initialize Context
        │
        ▼
Track Progress
        │
        ▼
Update State
        │
        ▼
Resolve Blockers
        │
        ▼
Complete Session
```

The session should always have a known state.

---

# What To Store

Session Memory may store:

Current objective

Current workflow phase

Current module

Current feature

Completed milestones

Pending milestones

Known blockers

Temporary assumptions

Recently clarified requirements

Open questions

Recent engineering decisions

Implementation progress

---

# What NOT To Store

Never store:

Project architecture

Stable conventions

Long-term preferences

Completed historical tasks

Permanent engineering knowledge

These belong to Project Memory or other memory layers.

---

# Session State

Every session should maintain:

Objective

↓

Current Phase

↓

Progress

↓

Blockers

↓

Next Action

The AI should always be able to summarize the current session.

---

# Session Phases

Possible phases include:

Requirement Analysis

Clarification

Codebase Analysis

Planning

Implementation

Review

Testing

Validation

Release

Only one primary phase should be active.

---

# Progress Tracking

Track meaningful milestones.

Example:

✓ Requirement clarified

✓ Architecture analyzed

✓ Repository implemented

✓ ViewModel implemented

→ Building Compose UI

Avoid tracking trivial implementation details.

---

# Blocker Tracking

Maintain a list of active blockers.

Each blocker should include:

Description

Impact

Required information

Current status

Remove blockers immediately after resolution.

---

# Assumption Tracking

Temporary assumptions should be tracked.

Each assumption should include:

Reason

Confidence

Validation status

Assumptions expire when:

Validated

Rejected

Session completed

---

# Context Continuity

Before responding:

Retrieve:

Current Objective

↓

Current Phase

↓

Recent Decisions

↓

Current Progress

↓

Blockers

↓

Next Action

Avoid repeating previous analysis.

---

# Session Update Policy

Update Session Memory whenever:

A phase changes.

A milestone completes.

A blocker appears.

A blocker is resolved.

Requirements change.

Implementation direction changes.

Keep Session Memory synchronized with reality.

---

# Session Summary

At any time, the AI should be able to produce:

Current Objective

Current Progress

Current Phase

Remaining Work

Known Blockers

Next Action

Without reanalyzing the conversation.

---

# Recovery

If context becomes inconsistent:

Compare with:

Latest user instruction

↓

Latest accepted decision

↓

Current implementation state

↓

Workflow state

Restore the most accurate session state.

---

# Session Completion

A session is complete when:

Objective achieved

No remaining blockers

Validation complete

Results delivered

Archive important knowledge.

Discard temporary context.

---

# Memory Expiration

The following should expire after the session:

Temporary assumptions

Implementation notes

Current phase

Progress tracking

Working context

Do not promote temporary context into Project Memory.

---

# Self Validation

Before using Session Memory verify:

Is this still the active task?

Has the user changed direction?

Has a blocker already been resolved?

Is the stored progress still accurate?

If not,

update the session before proceeding.

---

# Anti-patterns

Never:

Restart analysis after every message.

Forget completed milestones.

Lose track of blockers.

Treat temporary context as permanent knowledge.

Mix multiple unrelated sessions.

Ignore recent user instructions.

---

# Final Rule

Session Memory exists to preserve engineering continuity throughout an active collaboration.

The AI should always know where the team is, what has already been completed, what remains, and what should happen next.