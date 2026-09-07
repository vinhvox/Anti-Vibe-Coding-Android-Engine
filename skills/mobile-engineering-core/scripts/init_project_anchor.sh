#!/bin/bash
# ==============================================================================
# Antigravity Project Anchor & Fast-Path Context Digest Generator
# Usage: ./init_project_anchor.sh [TARGET_PROJECT_DIR]
# Purpose: Generates project-level anchor files and the high-density
#          .context-digest.md connecting any project workspace directly to the
#          Antigravity Master Framework (~/.antigravity/) and enforcing 100% of
#          the 19 Core Mobile Engineering Domains with zero token bloat.
# ==============================================================================

set -e

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"
ABS_PROJECT_DIR="$(pwd)"

echo "🚀 Initializing Antigravity Project Anchor & Fast-Path Digest in: $ABS_PROJECT_DIR"

# 1. Create project .antigravity directory and plan folder
mkdir -p "$ABS_PROJECT_DIR/.antigravity"
mkdir -p "$ABS_PROJECT_DIR/plan"

# 2. Generate .antigravity/project.json
cat << 'EOF' > "$ABS_PROJECT_DIR/.antigravity/project.json"
{
  "framework_root": "${ANTIGRAVITY_HOME:-$HOME/.antigravity}",
  "mandate": "31-mobile-engineering-core.md",
  "fast_path_digest": ".context-digest.md",
  "enforcement_gates": ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12", "E13", "E14", "E15", "E16", "E17", "E18", "E19", "E20", "E21"],
  "compliance": "19-Core-Domains",
  "auto_discovery": true
}
EOF

# 3. Copy or link the High-Density .context-digest.md
if [ -f "${ANTIGRAVITY_HOME:-$HOME/.antigravity}/.context-digest.md" ]; then
  cp "${ANTIGRAVITY_HOME:-$HOME/.antigravity}/.context-digest.md" "$ABS_PROJECT_DIR/.context-digest.md"
  echo "   - Generated $ABS_PROJECT_DIR/.context-digest.md (Fast-Path Digest)"
fi

# 4. Generate AGY.md for Agentic IDEs / CLI
cat << 'EOF' > "$ABS_PROJECT_DIR/AGY.md"
# Antigravity Project Anchor & Mandatory Compliance

This repository is governed by the **Antigravity Custom Framework** located at:
`${ANTIGRAVITY_HOME:-$HOME/.antigravity}/`

## Fast-Path Execution
- **Context Digest:** `./.context-digest.md` (Read this single file for 100% architecture, templates, and constraints in ~5.4K tokens).

## Mandatory Rules & Protocols
- **System Mandate:** `${ANTIGRAVITY_HOME:-$HOME/.antigravity}/rules/00-system-mandate.md`
- **Master Workflow:** `${ANTIGRAVITY_HOME:-$HOME/.antigravity}/workflow/00-master-workflow.md`
- **Mobile Engineering Core:** `${ANTIGRAVITY_HOME:-$HOME/.antigravity}/rules/31-mobile-engineering-core.md`
- **Enforcement Engine:** `${ANTIGRAVITY_HOME:-$HOME/.antigravity}/rules/21-enforcement-engine.md` (Gates E1 - E21)

Every engineering request in this project MUST execute:
`Phase 0 (Project Discovery via .context-digest.md)` -> `Intent Detection` -> `Brain` -> `Memory` -> `Workflow` -> `Enforcement Gate E21`.
EOF

echo "✅ Antigravity Project Anchor successfully established!"
echo "   - Created $ABS_PROJECT_DIR/.antigravity/project.json"
echo "   - Created $ABS_PROJECT_DIR/.context-digest.md"
echo "   - Created $ABS_PROJECT_DIR/AGY.md"
echo "   - Created $ABS_PROJECT_DIR/plan/ folder"
