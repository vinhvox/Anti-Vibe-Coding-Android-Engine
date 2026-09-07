# Contributing to Antigravity Android Framework

Thank you for your interest in contributing to the **Antigravity Android Framework**! We welcome contributions from developers, architects, and designers who believe in disciplined, production-grade engineering and want to eliminate "Vibe Coding" and fragile AI-generated code.

---

## Code of Conduct

By participating in this project, you agree to abide by our standards of professional, constructive, and respectful collaboration. We focus on engineering excellence, objective evidence, and product viability.

---

## Architectural Principles

Before contributing rules, workflows, or skills, make sure your contribution adheres to our core pillars:
1. **Structural Safety Over Patchwork:** We do not accept PRs that introduce lazy try-catch sprawl or defensive paranoia. Safety must be enforced structurally through Kotlin's type system, Flow immutability, and lifecycle awareness.
2. **Human-Grade UI/UX:** UI contributions must adhere to [Rule 36 (UI/UX Design Standard)](rules/36-ui-ux-design-standard.md): subtle 0.5dp borders, tonal surfaces, 8-pt grid, and an absolute ban on cliché AI aesthetics (purple-on-dark neon glows, vibrating pill badges).
3. **Evidence-Based Engineering:** Every proposed rule or architectural guideline must be verifiable through automated tests, compiler checks, or the 28 Quality Gates (E1–E28).

---

## How to Contribute

### 1. Contributing a New Skill
Skills live in the `skills/` directory. Each skill folder MUST contain:
- `SKILL.md` with standard YAML frontmatter (`name`, `description`).
- Concrete, actionable blueprints (no vague guidelines or placeholders).
- A checklist or enforcement gates.

### 2. Contributing or Updating Rules
Rules live in `rules/`:
- Keep rules concise, unambiguous, and enforceable.
- If proposing a new Quality Gate, add it to `rules/21-enforcement-engine.md` with an exact automated or manual audit procedure.

### 3. Improving Workflows or Brain Engines
- Cognitive engines in `brain/` govern how AI agents reason. Changes must preserve the 11-engine cognitive sequence and prioritize user intent alignment over autonomous assumptions.

---

## Pull Request Guidelines

1. **Fork and Branch:** Create a feature branch with a descriptive name (`git checkout -b feat/new-security-gate`).
2. **Sanitization:** Ensure no hardcoded paths (e.g. `/Users/...` or personal machine directories) are committed. Always use `${ANTIGRAVITY_HOME:-$HOME/.antigravity}` or relative paths.
3. **Cross-Link Integrity:** Run link and markdown validation to ensure all internal links between rules, skills, and workflows resolve properly.
4. **Descriptive PR:** Explain the rationale (WHY), the problem solved, and link any related issues.
