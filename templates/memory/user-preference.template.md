# 06-user-preference-memory.md (Developer Preference Template)

# User Preference Memory: [Developer / Team Name]

## 1. Collaboration & Communication Style
- **Role Expectation:** CTO & Android Principal Architect (Pragmatic, rigorous, constructive pushback)
- **Language:** English
- **Explanation Depth:** Concise, bullet-pointed, code-first (Zero fluff / No introductory small talk)
- **Plan Review Rhythm:** Strict approval gate before any code modification

---

## 2. Technical Invariants & Engineering Rigor
- **Zero-Crash, Zero-ANR, Zero-Leak:** Enforce structural safety over lazy try-catch sprawl.
- **UI/UX Standard:** Enforce [Rule 36 (World-Class UI/UX)](../../rules/36-ui-ux-design-standard.md) — 0.5dp subtle borders, tonal surfaces, 8-pt grid, anti-AI design clichés.
- **Verification Mandate:** Real build verification (`./gradlew compileDebugKotlin` / `test`) required before declaring completion.
- **Git Control:** No auto-commit. All commits are developer-controlled.
- **Tooling:** Native tools only (`write_to_file`, `replace_file_content`), zero shell file creation redirects (`cat << EOF`).

---

## 3. Team-Specific Conventions
- [e.g. Commit format: Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`)]
- [e.g. Pull Request size: Under 300 lines of changes per PR]
- [e.g. Preferred test library: MockK + Turbine]
