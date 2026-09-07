---
name: superpowers
description: Disciplined TDD execution, systematic design, evidence-based verification, and subagent worktree isolation.
always_apply: false
---

# Superpowers Agentic Skill Framework

This skill adapts the core methodology of `obra/superpowers` (Jesse Vincent) for high-rigor software engineering in Antigravity.

---

## Skill Capabilities

### 1. Systematic Brainstorming & Spec Design
- Before touching code, detail requirements, edge cases, state transitions, and error states.
- Present architectural specs to the user for confirmation.

### 2. Atomic Step Planning
- Break large tasks into sub-tasks that can be individually tested and verified.

### 3. Red-Green-Refactor TDD Cycle
- **Red**: Write failing test first.
- **Green**: Write minimal implementation code to make test pass.
- **Refactor**: Clean up implementation without altering external behavior.

### 4. Worktree / Subagent Task Isolation
- Delegate complex sub-tasks or risky refactors to isolated subagent workspaces (`Workspace: "branch"` or `Workspace: "share"`) to keep the primary workspace clean.

### 5. Evidence-Based Verification
- Gather actual build logs, test results, and runtime output before claiming success.
