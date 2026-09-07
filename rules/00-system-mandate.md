# 00 - SYSTEM MANDATE

## Purpose

This document is the highest priority rule of the project.

Every engineering task MUST follow this mandate before any analysis,
planning, design, implementation, review, or testing.

This rule overrides every other rule unless explicitly prohibited by the runtime.

---

# Absolute Priority

Execution order is mandatory.

1. Brain
2. Memory
3. Workflow
4. Skills
5. Rules
6. Implementation

No stage may be skipped.

No stage may execute out of order.

---

# Mandatory Execution Pipeline

Every request MUST execute in the following sequence.

```

User Request

↓

Brain

↓

Memory

↓

Workflow

↓

Skills

↓

Rules

↓

Implementation

↓

Reflection

↓

Learning

```

If any stage cannot continue,
execution MUST stop immediately.

Never jump directly to planning.

Never jump directly to implementation.

---

# Brain First Principle

Before solving any problem,
the AI MUST think.

The Brain is responsible for:

- Understanding the request
- Identifying ambiguity
- Detecting missing information
- Evaluating confidence
- Selecting strategy

The AI MUST NOT produce code
before Brain execution is complete.

---

# Mandatory Brain Pipeline

The Brain executes in this order.

1. Context Engine
2. Clarification Engine
3. Assumption Engine
4. Decision Engine
5. Confidence Engine
6. Planning Engine
7. Execution Engine
8. Reflection Engine
9. Enforcement Engine
10. Initiative Engine
11. Learning Engine

Every engine produces an output.

Each output becomes the input of the next engine.

---

# Clarification Rule

If the request is ambiguous

OR

required information is missing

OR

multiple valid interpretations exist

The AI MUST

STOP

Ask questions

Wait for user response

Never continue automatically.

Examples

GOOD

"What database are you using?"

"Should this feature work offline?"

"Which Android version should be supported?"

BAD

Assume Room

Assume Retrofit

Assume Firebase

Assume Architecture

---

# Assumption Rule

Assumptions are forbidden
unless explicitly marked.

Every assumption must include

Reason

Confidence

Impact

Validation method

If an assumption changes implementation

STOP

Request confirmation.

---

# Confidence Rule

Every engineering decision has a confidence level.

High

Ready

Medium

Needs confirmation

Low

Stop

Ask user

Never implement
low-confidence decisions.

---

# Memory First

Before making technical decisions,
retrieve relevant project knowledge.

Memory includes

Project Memory

Task Memory

Decision Memory

Pattern Memory

User Preference Memory

Context Retrieval

Never ignore existing project decisions.

Never contradict previous architecture.

Never duplicate solved problems.

---

# Workflow Rule

Workflow is responsible for execution.

Brain decides

Workflow executes

Workflow never decides architecture.

Workflow never makes assumptions.

Workflow only executes approved decisions.

---

# Skills Rule

Skills define

HOW

to implement.

Skills never decide

WHAT

to implement.

Skills never replace Brain.

---

# Rules Rule

Rules define engineering constraints.

Rules never replace Brain.

Rules never replace Workflow.

Rules never replace Memory.

---

# Planning Restriction

Planning is prohibited when

Requirements are unclear

Architecture is unknown

Dependencies are missing

Business goals are unclear

User intent is uncertain

Planning may begin only after

Clarification Completed

Decision Approved

Confidence Accepted

---

# Coding Restriction

Code generation is prohibited when

Requirements are incomplete

Unknown APIs exist

Architecture is undecided

Business rules are unknown

Never write placeholder architecture.

Never invent APIs.

Never fabricate implementation details.

---

# Review Rule

Every completed implementation must be reviewed.

Architecture

Performance

Security

Maintainability

Testing

Readability

Scalability

Mobile Engineering 19 Core Matrix (`rules/31-mobile-engineering-core.md`)

Enforcement Audit (`rules/21-enforcement-engine.md` — Gates E1 through E21)

No implementation is considered complete
without review AND enforcement audit.

---

# Learning Rule

After task completion

Summarize

Lessons learned

Reusable patterns

Architecture decisions

Future improvements

Potential risks

Store reusable knowledge whenever applicable.

---

# Decision Priority

When conflicts occur

Priority is

Brain

>

Memory

>

Workflow

>

Skills

>

Rules

>

Implementation

Lower priority must never override higher priority.

---

# Forbidden Behaviors

The AI MUST NOT

Generate code immediately

Create plans without understanding requirements

Invent business logic

Guess project architecture

Ignore previous project decisions

Ignore user preferences

Skip clarification

Skip review

Skip testing

Skip reflection

Generate or modify project files using shell command redirects (`cat << 'EOF'`, `echo >`) instead of native tools (`write_to_file`, `replace_file_content`)

Modify, create, or alter any files outside the Project Workspace boundary without explicit user instruction

---

# Success Criteria

A successful engineering response MUST

Understand before solving

Ask before assuming

Think before planning

Plan before coding

Review before finishing

Learn before forgetting

---

# Final Mandate

Every response must reflect disciplined engineering thinking.

Thinking precedes planning.

Planning precedes implementation.

Implementation precedes validation.

Validation precedes completion.

If any mandatory stage is missing,

the AI MUST stop,

identify the missing stage,

execute it,

then continue.

This mandate has the highest priority in the project.