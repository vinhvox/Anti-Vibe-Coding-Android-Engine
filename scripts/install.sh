#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Automated Community Installer
# Target: macOS / Linux / WSL
# ==============================================================================

set -euo pipefail

# Explicit Constants (Gate E28.7) & Self-Documenting Identifiers (Gate E28.6)
readonly REPO_URL="https://github.com/vinhvox/Anti-Vibe-Coding-Android-Engine.git"
readonly TARGET_BRANCH="main"
readonly GIT_CLONE_DEPTH=1

readonly TARGET_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"
readonly GEMINI_CONFIG_DIR="$HOME/.gemini"
readonly GEMINI_MANDATE_FILE="$GEMINI_CONFIG_DIR/GEMINI.md"
readonly CLI_SKILLS_DIR="$GEMINI_CONFIG_DIR/antigravity-cli/skills"
readonly CUSTOM_SKILLS_SYMLINK="$CLI_SKILLS_DIR/custom_skills"

readonly MANDATE_SIGNATURE="00-system-mandate.md"
readonly QA_SEPARATION_SIGNATURE="0.1 MANDATORY ZERO-COMPROMISE DEV"
readonly LATEST_RULES_RANGE_SIGNATURE="Rules Engine (00-45)"
readonly BOUNDED_QA_SIGNATURE="Gate E40"

readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_RESET='\033[0m'

is_auto_confirm=false
is_update_requested=false
temp_markdown_file=""
backup_dir=""

cleanup_install_temp_resources() {
    if [ -n "$temp_markdown_file" ] && [ -f "$temp_markdown_file" ]; then
        rm -f "$temp_markdown_file"
    fi
}
trap cleanup_install_temp_resources EXIT

for argument in "$@"; do
    case "$argument" in
        -y|--yes)
            is_auto_confirm=true
            ;;
        --update)
            is_auto_confirm=true
            is_update_requested=true
            ;;
    esac
done

echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"
echo -e "${COLOR_BLUE}  ANTIGRAVITY ANDROID OS — THE PRAGMATIC CTO ENGINE   ${COLOR_RESET}"
echo -e "${COLOR_BLUE}  Version 2026 | Jetpack Compose M3 | Navigation 3    ${COLOR_RESET}"
echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"
echo ""

# 1. Check prerequisites
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Checking system requirements..."
command -v git >/dev/null 2>&1 || { echo -e "${COLOR_RED}❌ Git is required but not installed. Aborting.${COLOR_RESET}"; exit 1; }

script_source_path="${BASH_SOURCE[0]:-}"
SCRIPT_ROOT_DIR=""
if [ -n "$script_source_path" ] && [ -f "$script_source_path" ]; then
    SCRIPT_ROOT_DIR="$( cd "$( dirname "$script_source_path" )/.." 2>/dev/null && pwd || true )"
    if [ "$SCRIPT_ROOT_DIR" = "$TARGET_DIR" ]; then
        SCRIPT_ROOT_DIR=""
    fi
fi

# 2. Check existing installation directory (Non-interactive safe for curl | bash)
if [ -d "$TARGET_DIR" ]; then
    echo -e "${COLOR_YELLOW}⚠️ Existing configuration found at $TARGET_DIR.${COLOR_RESET}"

    if [ "$is_update_requested" = true ] && [ -n "$SCRIPT_ROOT_DIR" ] && [ -f "$SCRIPT_ROOT_DIR/scripts/update.sh" ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Delegating to fast updater ($SCRIPT_ROOT_DIR/scripts/update.sh)..."
        exec bash "$SCRIPT_ROOT_DIR/scripts/update.sh"
    elif [ "$is_update_requested" = true ] && [ -f "$TARGET_DIR/scripts/update.sh" ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Delegating to installed fast updater ($TARGET_DIR/scripts/update.sh)..."
        exec bash "$TARGET_DIR/scripts/update.sh"
    fi

    should_backup_and_update=false
    if [ "$is_auto_confirm" = true ] || [ ! -t 0 ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Non-interactive / auto-confirm mode detected. Proceeding with automatic backup and update..."
        should_backup_and_update=true
    else
        user_confirmation=""
        read -p "Do you want to backup and update? (y/n) " -n 1 -r user_confirmation
        echo ""
        if [[ $user_confirmation =~ ^[Yy]$ ]]; then
            should_backup_and_update=true
        fi
    fi

    if [ "$should_backup_and_update" = true ]; then
        backup_dir="${TARGET_DIR}_backup_$(date +%Y%m%d%H%M%S)"
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Backing up to $backup_dir..."
        mv "$TARGET_DIR" "$backup_dir"
    else
        echo -e "${COLOR_RED}Installation cancelled by user.${COLOR_RESET}"
        exit 0
    fi
fi

# 3. Clone or Copy
if [ -n "$SCRIPT_ROOT_DIR" ] && [ -f "$SCRIPT_ROOT_DIR/rules/00-system-mandate.md" ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Installing from local repository ($SCRIPT_ROOT_DIR) to $TARGET_DIR..."
    mkdir -p "$TARGET_DIR"
    cp -R "$SCRIPT_ROOT_DIR/brain" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/rules" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/workflow" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/skills" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/memory" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/bin" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/scripts" "$TARGET_DIR/"
    cp -R "$SCRIPT_ROOT_DIR/templates" "$TARGET_DIR/"
    cp "$SCRIPT_ROOT_DIR/INDEX.md" "$TARGET_DIR/"
    cp "$SCRIPT_ROOT_DIR/.context-digest.md" "$TARGET_DIR/"
    if [ -f "$SCRIPT_ROOT_DIR/README.md" ]; then
        cp "$SCRIPT_ROOT_DIR/README.md" "$TARGET_DIR/"
    fi
    if [ -d "$SCRIPT_ROOT_DIR/.git" ]; then
        cp -R "$SCRIPT_ROOT_DIR/.git" "$TARGET_DIR/"
    fi
else
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Cloning Antigravity OS from $REPO_URL..."
    git clone --depth "$GIT_CLONE_DEPTH" --branch "$TARGET_BRANCH" "$REPO_URL" "$TARGET_DIR"
fi

# Restore customized 01-project-memory.md and user-created memory files from backup_dir if applicable
if [ -n "$backup_dir" ] && [ -d "$backup_dir/memory" ]; then
    if [ -f "$backup_dir/memory/01-project-memory.md" ] && [ -f "$TARGET_DIR/memory/01-project-memory.md" ]; then
        if ! cmp -s "$backup_dir/memory/01-project-memory.md" "$TARGET_DIR/memory/01-project-memory.md"; then
            cp "$backup_dir/memory/01-project-memory.md" "$TARGET_DIR/memory/01-project-memory.md"
            echo -e "${COLOR_GREEN}==>${COLOR_RESET} Preserved custom 01-project-memory.md from $backup_dir"
        fi
    fi

    for backed_up_memory_path in "$backup_dir/memory"/*; do
        [ -e "$backed_up_memory_path" ] || continue
        memory_file_name="$(basename "$backed_up_memory_path")"
        if [ ! -e "$TARGET_DIR/memory/$memory_file_name" ]; then
            cp -R "$backed_up_memory_path" "$TARGET_DIR/memory/$memory_file_name"
            echo -e "${COLOR_GREEN}==>${COLOR_RESET} Restored custom memory file: $memory_file_name"
        fi
    done
fi

# 4. Set permissions
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Setting executable permissions..."
find "$TARGET_DIR/scripts" \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} + 2>/dev/null || true
find "$TARGET_DIR/bin" -type f -exec chmod +x {} + 2>/dev/null || true

# 5. Antigravity CLI (agy) Auto-Hook
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Configuring Antigravity CLI (agy) integration..."
mkdir -p "$GEMINI_CONFIG_DIR"
mkdir -p "$CLI_SKILLS_DIR"

# Auto-link skills for /skills discovery
if [ -d "$TARGET_DIR/skills" ]; then
    if [ ! -L "$CUSTOM_SKILLS_SYMLINK" ] || [ "$(readlink "$CUSTOM_SKILLS_SYMLINK")" != "$TARGET_DIR/skills" ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Linking skills to Antigravity CLI ($CUSTOM_SKILLS_SYMLINK)..."
        rm -rf "$CUSTOM_SKILLS_SYMLINK"
        ln -s "$TARGET_DIR/skills" "$CUSTOM_SKILLS_SYMLINK" 2>/dev/null || true
    fi
fi

write_mandate_header() {
    local destination_file="$1"
    cat > "$destination_file" << EOF
# 0. ABSOLUTE MANDATE: DEFAULT CUSTOM FRAMEWORK
ALL operations, rules, workflows, memory, skills, and execution pipelines MUST default to and strictly follow the custom framework located at:
$TARGET_DIR/

* **Highest System Mandate:** file://$TARGET_DIR/rules/00-system-mandate.md
* **System Entrypoint Workflow:** file://$TARGET_DIR/workflow/00-master-workflow.md
* **Rules Engine (00-45):** file://$TARGET_DIR/rules/
* **Workflow Engine (00-10):** file://$TARGET_DIR/workflow/
* **Memory Engine (00-09):** file://$TARGET_DIR/memory/
* **Context Digest (High-Density Blueprint):** file://$TARGET_DIR/.context-digest.md
* **Ask-CTO Meta-Router:** file://$TARGET_DIR/skills/ask-cto/SKILL.md
* **Subagent Modes (Dev vs. QA):** file://$TARGET_DIR/skills/subagent-modes/SKILL.md

**Mandatory Pipeline:** User Request -> Brain -> Memory -> Workflow -> Skills -> Rules -> Implementation (\`dev-builder\` + Gate E39 Mirror Self-Review) -> Independent QA Audit (\`qa-enforcer\` + Gate E40 Bounded 3-Round Convergence) -> Reflection -> Memory Update.

---

# 0.1 MANDATORY ZERO-COMPROMISE DEV ↔ QA SEPARATION (ACTIVE IMMEDIATELY ACROSS ALL SESSIONS)
**ABSOLUTE RULE: QA NEVER COMPROMISES WITH DEV. SELF-REVIEW IS STRICTLY FORBIDDEN.**
For EVERY active or new coding, bug-fixing, or refactoring task across all workspaces:
1. **Register Adversarial Subagents (\`define_subagent\`)**: If not yet defined in the active conversation, immediately register:
   - \`dev-builder\` (\`enable_write_tools = true\`): Implements production code, executes Mandatory 4-Step Dev Mirror Self-Review (Gate E39: \`view_file\` physical read-back ➔ 5-Mirror self-refactor ➔ \`🪞 Dev Mirror Self-Review\` block), performs Systemic Codebase Sweeps (\`Gate E40.3\`), and runs Gradle verification. Forbidden from arguing with QA rejection reports.
   - \`qa-enforcer\` (\`enable_write_tools = false\`): Hard Read-Only lock. Prosecutorial QA & Security Auditor that NEVER compromises with Dev, bans soft warnings, and audits 4 Mandatory Fronts (Gate E38 Vitals: Zero-Crash/ANR/Leak, Gates E1–E40 Architecture/Conventions/UI, Gate E31 6-Dimension Edge Cases, Gates E20, E39 & E40 Real Test Evidence, Mirror & Bounded 3-Round Convergence).
2. **Blind-Context QA Dispatch (\`invoke_subagent\`)**: Before claiming any task or wave is complete, the Orchestrator MUST invoke \`qa-enforcer\` in a **100% blind fresh context** (passing ONLY Spec + Exact Diff + Raw Test Logs).
3. **Binary Guillotine Verdict, Bounded 3-Round Convergence & Circuit Breaker (\`Gate E40\`)**:
   - \`qa-enforcer\` outputs strictly **\`VERDICT: APPROVED\`** (0 defects) or **\`VERDICT: REJECTED\`** (\`[CLUSTER-ID] [Gate EXX] [file:line]\`) under \`MAX_QA_ROUNDS = 3\`.
   - Round 1 groups identical root causes into Pattern-Clustered \`[CLUSTER-XX]\` items (\`Gate E40.3\`), and \`dev-builder\` MUST execute a Systemic Codebase Sweep across all modified files via Rule 41 (Minimal Failing Test ➔ Fix ➔ Regression Sweep) without negotiation.
   - Rounds 2–3 enforce Delta-Only Scope (\`Gate E40.2\`) and Zero Moving Goalposts (\`Gate E40.4\`). If Round 3 still fails, trigger **\`🛑 CIRCUIT BREAKER TRIGGERED: ARCHITECTURAL PIVOT REQUIRED\`** (\`Gate E40.1\`) and escalate to the User.

---

EOF
}

write_default_role_footer() {
    local destination_file="$1"
    cat >> "$destination_file" << 'EOF'
# ROLE: Chief Technology Officer (CTO) & Android Principal Architect
# SPECIALIZATION: Jetpack Compose, Navigation 3, Antigravity Engine & Scalable Systems
You are a visionary CTO and a seasoned Android Principal Engineer with deep expertise in Declarative UI, Reactive Programming, and Enterprise System Architecture.
EOF
}

# Auto-hook global GEMINI.md
if [ ! -f "$GEMINI_MANDATE_FILE" ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Creating global $GEMINI_MANDATE_FILE with Antigravity System Mandate..."
    write_mandate_header "$GEMINI_MANDATE_FILE"
    write_default_role_footer "$GEMINI_MANDATE_FILE"
else
    if ! grep -q "$MANDATE_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
        echo -e "${COLOR_YELLOW}⚠️ Existing $GEMINI_MANDATE_FILE detected without Antigravity Mandate.${COLOR_RESET}"
        backup_gemini_file="${GEMINI_MANDATE_FILE}.bak.$(date +%Y%m%d%H%M%S)"
        cp "$GEMINI_MANDATE_FILE" "$backup_gemini_file"
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Backed up existing GEMINI.md to $backup_gemini_file"

        temp_markdown_file="$(mktemp)"
        write_mandate_header "$temp_markdown_file"
        cat "$GEMINI_MANDATE_FILE" >> "$temp_markdown_file"
        mv "$temp_markdown_file" "$GEMINI_MANDATE_FILE"
        echo -e "${COLOR_GREEN}✅ Successfully bound Antigravity Engine to $GEMINI_MANDATE_FILE${COLOR_RESET}"
    elif ! grep -q "$QA_SEPARATION_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null \
      || ! grep -q "$LATEST_RULES_RANGE_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null \
      || ! grep -q "$BOUNDED_QA_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
        backup_gemini_file="${GEMINI_MANDATE_FILE}.bak.$(date +%Y%m%d%H%M%S)"
        cp "$GEMINI_MANDATE_FILE" "$backup_gemini_file"
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Upgrading Antigravity Mandate in $GEMINI_MANDATE_FILE (backup: $backup_gemini_file)..."

        temp_markdown_file="$(mktemp)"
        write_mandate_header "$temp_markdown_file"
        if grep -q "^# ROLE:" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
            sed -n '/^# ROLE:/,$p' "$GEMINI_MANDATE_FILE" >> "$temp_markdown_file"
        else
            write_default_role_footer "$temp_markdown_file"
        fi
        mv "$temp_markdown_file" "$GEMINI_MANDATE_FILE"
        echo -e "${COLOR_GREEN}✅ Upgraded Antigravity System Mandate in $GEMINI_MANDATE_FILE (Rules 00-45 + Gates E39/E40)${COLOR_RESET}"
    else
        echo -e "${COLOR_GREEN}✅ Antigravity System Mandate already active in $GEMINI_MANDATE_FILE${COLOR_RESET}"
    fi
fi

# 6. Run Doctor
echo ""
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Running system health check..."
if [ -f "$TARGET_DIR/scripts/doctor.sh" ]; then
    bash "$TARGET_DIR/scripts/doctor.sh" || true
fi

echo ""
echo -e "${COLOR_GREEN}======================================================${COLOR_RESET}"
echo -e "${COLOR_GREEN}  🎉 INSTALLATION COMPLETE!                           ${COLOR_RESET}"
echo -e "${COLOR_GREEN}  Antigravity Engine is active at: $TARGET_DIR        ${COLOR_RESET}"
echo -e "${COLOR_GREEN}======================================================${COLOR_RESET}"
echo ""
echo "Verification & Next Steps:"
echo "1. Run 'agy' in your terminal."
echo "   - Note: The initial ASCII terminal splash is compiled into the CLI binary."
echo "   - Type '/skills' to verify that custom skills (ask-cto, ui-ux-pro-max, app-quality-vitals, etc.) are loaded."
echo "   - Ask: 'Who are you and what rules do you follow?' to verify the CTO Persona & 40 Quality Gates."
echo "2. In your Android project root, run 'bash $TARGET_DIR/scripts/init-project.sh' to bind local project memory."
echo "3. Run '$TARGET_DIR/bin/agy-update' anytime to pull the latest rules & skills in seconds."
echo "4. Run '$TARGET_DIR/bin/agy-doctor' anytime to diagnose your environment."
echo ""
