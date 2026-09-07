# 24-rtk-token-killer.md

# RTK (RUST TOKEN KILLER) LOG COMPRESSION & PROXY RULE

## Purpose

This rule mandates the use of **RTK (Rust Token Killer)** at `~/.local/bin/rtk` to proxy and compress shell command execution logs, reducing LLM token consumption by 60–90% while preserving 100% of essential technical context.

---

## 1. Primary Binary Location

- **Binary Path**: `~/.local/bin/rtk`
- **Version**: `0.45.0` (or higher)

---

## 2. Command Execution Guidelines

Whenever executing shell commands, prefix supported terminal commands with `rtk` (or `~/.local/bin/rtk`):

| Raw Terminal Command | RTK Proxy Command | Savings Optimization |
| :--- | :--- | :--- |
| `git status`, `git diff`, `git log` | `rtk git ...` | Strips verbose headers, whitespace, and unchanged context |
| `./gradlew build`, `./gradlew test` | `rtk gradlew ...` | Strips progress bars, ASCII art, and keeps failure tracebacks |
| `npm run test`, `npx ...` | `rtk npm ...`, `rtk npx ...` | Filters npm boilerplate and shows compact error outputs |
| `cargo test`, `cargo build` | `rtk cargo ...` | Compresses Rust compiler/test outputs |
| `ls -la` | `rtk ls` | Compact token-optimized file listing |
| Generic test suite execution | `rtk test <command>` | Filters output to show only failed tests & stack traces |
| Generic build / run command | `rtk err <command>` | Strips stdout noise and isolates error/warning outputs |

---

## 3. Benefits & Integration

1. **Token Economy**: Reduces token overhead during TDD cycles and Evidence Verification (`rules/22-superpowers-tdd.md`).
2. **Context Window Optimization**: Keeps the AI Context Window clean for large codebase files.
3. **Audit & Analytics**: Run `rtk gain` to view cumulative token savings across sessions.
