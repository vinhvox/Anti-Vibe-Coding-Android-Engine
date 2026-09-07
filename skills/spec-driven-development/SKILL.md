---
name: spec-driven-development
description: Spec-Driven Development (SDD) standard for Modern Android, Jetpack Compose, and Kotlin Multiplatform. Defines the Tri-Artifact Standard (spec.md, plan.md, tasks.md), 5-State UI Matrix, Gherkin behavioral verification, and Zero Spec Drift rules learned from GitHub Spec Kit.
---

# Spec-Driven Development (SDD) Skill

This skill guides the creation, maintenance, and verification of software features using **Spec-Driven Development (SDD)**, synthesized from GitHub's Spec Kit standard (`github/spec-kit`).

## Core Principles

1. **Specifications as Executable Truth**: Never write code from loose prompts ("vibe coding"). All non-trivial features must have a living specification contract.
2. **Ubiquitous Language (`CONTEXT.md`) Alignment**: All entities, state names, and user actions in the spec must strictly map to the project's domain dictionary (`rules/37-ubiquitous-language-standard.md`).
3. **The Tri-Artifact Standard**:
   - **`spec.md` (What & Why)**: Requirements, Domain Models, 5-State Matrix, Gherkin Acceptance Criteria.
   - **`plan.md` (How)**: Clean Architecture layer mapping, MVI Contracts, File touchpoints (`[NEW]`, `[MODIFY]`), Living ADR Summary (`docs/adr/`), Memory & Risk budget.
   - **`tasks.md` (Checklist)**: Tracer-Bullet vertical slices (thin end-to-end tasks from Data to UI) with validation commands.
4. **Tracer-Bullet Vertical Slicing**: Banned horizontal task slicing (building all DAOs, then all Repos, then UI). Mandate thin, independently verifiable vertical slices.
5. **5-State UI Matrix**: Every declarative screen must explicitly account for `Loading`, `Content/Success`, `Empty`, `Error`, and `Offline`.
6. **Zero Spec Drift**: If scope changes during implementation, update `spec.md` first before modifying code.

## References

- Comprehensive Guide & Templates: [spec-driven-development.md](~/.antigravity/skills/spec-driven-development.md)
- Ubiquitous Language Standard: [37-ubiquitous-language-standard.md](~/.antigravity/rules/37-ubiquitous-language-standard.md)
- System Rule: [28-spec-driven-development.md](~/.antigravity/rules/28-spec-driven-development.md)
- Enforcement Gate: [21-enforcement-engine.md#CATEGORY-E18](~/.antigravity/rules/21-enforcement-engine.md)

