#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Fast Non-Interactive Updater
# Target: macOS / Linux / WSL
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/vinhvox/Anti-Vibe-Coding-Android-Engine/main/scripts/update.sh | bash
#   ~/.antigravity/bin/agy-update [--check] [--force]
# ==============================================================================

set -euo pipefail

# Explicit Constants (Gate E28.7) & Self-Documenting Identifiers (Gate E28.6)
readonly REPO_URL="https://github.com/vinhvox/Anti-Vibe-Coding-Android-Engine.git"
readonly TARGET_REMOTE="origin"
readonly TARGET_BRANCH="main"
readonly GIT_FETCH_DEPTH=1
readonly MAX_MEMORY_BACKUPS=5
readonly SHORT_HASH_LENGTH=7

readonly TARGET_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"
readonly BACKUP_ROOT_DIR="$HOME/.antigravity_backups"
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

is_check_only=false
is_force_update=false
temp_clone_dir=""
temp_gemini_file=""
memory_backup_dir=""
has_custom_project_memory=false

cleanup_temp_resources() {
    if [ -n "$temp_clone_dir" ] && [ -d "$temp_clone_dir" ]; then
        rm -rf "$temp_clone_dir"
    fi
    if [ -n "$temp_gemini_file" ] && [ -f "$temp_gemini_file" ]; then
        rm -f "$temp_gemini_file"
    fi
}
trap cleanup_temp_resources EXIT

print_usage() {
    local script_name
    script_name="$(basename "${BASH_SOURCE[0]:-$0}")"
    cat << EOF
Usage: $script_name [OPTIONS]

Options:
  --check     Check if updates are available on $TARGET_REMOTE/$TARGET_BRANCH without applying
  --force     Force full reset and overwrite all framework files
  -h, --help  Show this help message
EOF
}

for argument in "$@"; do
    case "$argument" in
        --check)
            is_check_only=true
            ;;
        --force)
            is_force_update=true
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${COLOR_RED}❌ Unknown option: $argument${COLOR_RESET}"
            print_usage
            exit 1
            ;;
    esac
done

echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"
echo -e "${COLOR_BLUE}  ANTIGRAVITY ANDROID OS — FAST ENGINE UPDATER        ${COLOR_RESET}"
echo -e "${COLOR_BLUE}  Non-Interactive Delta Sync & Mandate Upgrader       ${COLOR_RESET}"
echo -e "${COLOR_BLUE}======================================================${COLOR_RESET}"
echo ""

# 1. Verify Git prerequisite
if ! command -v git >/dev/null 2>&1; then
    echo -e "${COLOR_RED}❌ Git is required but not installed. Aborting.${COLOR_RESET}"
    exit 1
fi

ensure_git_remote_configured() {
    if ! git -C "$TARGET_DIR" remote get-url "$TARGET_REMOTE" >/dev/null 2>&1; then
        git -C "$TARGET_DIR" remote add "$TARGET_REMOTE" "$REPO_URL"
    fi
}

# 2. Handle --check mode without mutating installation
if [ "$is_check_only" = true ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Checking for updates against $REPO_URL ($TARGET_BRANCH)..."
    if [ -d "$TARGET_DIR/.git" ]; then
        ensure_git_remote_configured
        git -C "$TARGET_DIR" fetch --depth "$GIT_FETCH_DEPTH" "$TARGET_REMOTE" "$TARGET_BRANCH" >/dev/null 2>&1
        local_commit_hash="$(git -C "$TARGET_DIR" rev-parse --short HEAD)"
        remote_commit_hash="$(git -C "$TARGET_DIR" rev-parse --short FETCH_HEAD)"
        pending_commit_log="$(git -C "$TARGET_DIR" log --oneline HEAD..FETCH_HEAD)"

        if [ "$local_commit_hash" = "$remote_commit_hash" ]; then
            echo -e "${COLOR_GREEN}✅ Antigravity OS at $TARGET_DIR is already up to date (commit: $local_commit_hash).${COLOR_RESET}"
        else
            echo -e "${COLOR_YELLOW}⚡ Update available! Local: $local_commit_hash -> Remote: $remote_commit_hash${COLOR_RESET}"
            if [ -n "$pending_commit_log" ]; then
                echo ""
                echo "Incoming commits:"
                echo "$pending_commit_log"
            fi
        fi
    elif [ -d "$TARGET_DIR" ]; then
        remote_commit_hash="$(git ls-remote "$REPO_URL" "refs/heads/$TARGET_BRANCH" | cut -c 1-"$SHORT_HASH_LENGTH")"
        echo -e "${COLOR_YELLOW}⚠️ Existing installation at $TARGET_DIR is not git-tracked (remote HEAD: ${remote_commit_hash:-unknown}).${COLOR_RESET}"
        echo "Run updater without --check to migrate to fast git sync."
    else
        echo -e "${COLOR_YELLOW}⚠️ Antigravity OS is not yet installed at $TARGET_DIR.${COLOR_RESET}"
        echo "Run updater without --check to perform initial installation."
    fi
    exit 0
fi

# 3. Safe Memory Backup (Keep latest 5 backups & preserve custom 01-project-memory.md + custom files)
prune_old_memory_backups() {
    local backup_index=0
    local backup_entry=""
    while IFS= read -r backup_entry; do
        [ -z "$backup_entry" ] && continue
        backup_index=$((backup_index + 1))
        if [ "$backup_index" -gt "$MAX_MEMORY_BACKUPS" ]; then
            rm -rf "$backup_entry"
        fi
    done < <(ls -1dt "$BACKUP_ROOT_DIR"/memory_* 2>/dev/null || true)
}

if [ -d "$TARGET_DIR/memory" ]; then
    if [ -f "$TARGET_DIR/memory/01-project-memory.md" ]; then
        has_custom_project_memory=true
    fi

    timestamp_suffix="$(date +%Y%m%d_%H%M%S)"
    memory_backup_dir="$BACKUP_ROOT_DIR/memory_${timestamp_suffix}"
    mkdir -p "$BACKUP_ROOT_DIR"
    rm -rf "$memory_backup_dir"
    cp -R "$TARGET_DIR/memory" "$memory_backup_dir"
    prune_old_memory_backups
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Backed up memory to $memory_backup_dir (retaining latest $MAX_MEMORY_BACKUPS backups)"
fi

# 4. Fast Git / Remote Sync
if [ -d "$TARGET_DIR/.git" ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Fetching latest changes from $TARGET_REMOTE/$TARGET_BRANCH into $TARGET_DIR..."
    ensure_git_remote_configured
    git -C "$TARGET_DIR" fetch --depth "$GIT_FETCH_DEPTH" "$TARGET_REMOTE" "$TARGET_BRANCH"
    commit_diff_log="$(git -C "$TARGET_DIR" log --oneline HEAD..FETCH_HEAD)"
    if [ -n "$commit_diff_log" ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Incoming commits:"
        echo "$commit_diff_log"
    else
        echo -e "${COLOR_GREEN}==>${COLOR_RESET} Local commit already matches remote FETCH_HEAD ($(git -C "$TARGET_DIR" rev-parse --short FETCH_HEAD))."
    fi
    git -C "$TARGET_DIR" reset --hard FETCH_HEAD
elif [ -d "$TARGET_DIR" ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Upgrading non-git directory at $TARGET_DIR to fast git-tracked installation..."
    temp_clone_dir="$(mktemp -d)"
    git clone --depth "$GIT_FETCH_DEPTH" --branch "$TARGET_BRANCH" "$REPO_URL" "$temp_clone_dir"
    cp -R "$temp_clone_dir/." "$TARGET_DIR/"
else
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Performing fresh clone of Antigravity OS into $TARGET_DIR..."
    git clone --depth "$GIT_FETCH_DEPTH" --branch "$TARGET_BRANCH" "$REPO_URL" "$TARGET_DIR"
fi

# Restore custom 01-project-memory.md and any user-created memory files if --force was not passed
if [ "$is_force_update" = false ] && [ -n "$memory_backup_dir" ] && [ -d "$memory_backup_dir" ]; then
    if [ "$has_custom_project_memory" = true ] && [ -f "$memory_backup_dir/01-project-memory.md" ] && [ -f "$TARGET_DIR/memory/01-project-memory.md" ]; then
        if ! cmp -s "$memory_backup_dir/01-project-memory.md" "$TARGET_DIR/memory/01-project-memory.md"; then
            cp "$memory_backup_dir/01-project-memory.md" "$TARGET_DIR/memory/01-project-memory.md"
            echo -e "${COLOR_GREEN}==>${COLOR_RESET} Preserved custom 01-project-memory.md from backup"
        fi
    fi

    for backed_up_memory_path in "$memory_backup_dir"/*; do
        [ -e "$backed_up_memory_path" ] || continue
        memory_file_name="$(basename "$backed_up_memory_path")"
        if [ ! -e "$TARGET_DIR/memory/$memory_file_name" ]; then
            cp -R "$backed_up_memory_path" "$TARGET_DIR/memory/$memory_file_name"
            echo -e "${COLOR_GREEN}==>${COLOR_RESET} Restored custom memory file: $memory_file_name"
        fi
    done
fi

# 5. Set executable permissions on scripts and CLI binaries
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Setting executable permissions on scripts and bin utilities..."
find "$TARGET_DIR/scripts" \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} + 2>/dev/null || true
find "$TARGET_DIR/bin" -type f -exec chmod +x {} + 2>/dev/null || true
if [ -f "$TARGET_DIR/install.sh" ]; then
    chmod +x "$TARGET_DIR/install.sh" 2>/dev/null || true
fi

# 6. Ensure skills symlink is active
mkdir -p "$GEMINI_CONFIG_DIR"
mkdir -p "$CLI_SKILLS_DIR"

if [ -d "$TARGET_DIR/skills" ]; then
    if [ ! -L "$CUSTOM_SKILLS_SYMLINK" ] || [ "$(readlink "$CUSTOM_SKILLS_SYMLINK")" != "$TARGET_DIR/skills" ]; then
        echo -e "${COLOR_BLUE}==>${COLOR_RESET} Linking custom skills ($CUSTOM_SKILLS_SYMLINK -> $TARGET_DIR/skills)..."
        rm -rf "$CUSTOM_SKILLS_SYMLINK"
        ln -s "$TARGET_DIR/skills" "$CUSTOM_SKILLS_SYMLINK"
    else
        echo -e "${COLOR_GREEN}✅ Skills symlink active: $CUSTOM_SKILLS_SYMLINK -> $TARGET_DIR/skills${COLOR_RESET}"
    fi
fi

# 7. Upgrade ~/.gemini/GEMINI.md with latest System Mandate, Gate E39 Mirror & Gate E40 Bounded 3-Round QA
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

if [ ! -f "$GEMINI_MANDATE_FILE" ]; then
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Creating global $GEMINI_MANDATE_FILE with Antigravity System Mandate..."
    write_mandate_header "$GEMINI_MANDATE_FILE"
    write_default_role_footer "$GEMINI_MANDATE_FILE"
    echo -e "${COLOR_GREEN}✅ Created $GEMINI_MANDATE_FILE${COLOR_RESET}"
elif ! grep -q "$MANDATE_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
    gemini_backup_file="${GEMINI_MANDATE_FILE}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$GEMINI_MANDATE_FILE" "$gemini_backup_file"
    echo -e "${COLOR_YELLOW}⚠️ Existing $GEMINI_MANDATE_FILE without Antigravity Mandate backed up to $gemini_backup_file${COLOR_RESET}"

    temp_gemini_file="$(mktemp)"
    write_mandate_header "$temp_gemini_file"
    cat "$GEMINI_MANDATE_FILE" >> "$temp_gemini_file"
    mv "$temp_gemini_file" "$GEMINI_MANDATE_FILE"
    echo -e "${COLOR_GREEN}✅ Prepended latest Antigravity System Mandate to $GEMINI_MANDATE_FILE${COLOR_RESET}"
elif ! grep -q "$QA_SEPARATION_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null \
  || ! grep -q "$LATEST_RULES_RANGE_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null \
  || ! grep -q "$BOUNDED_QA_SIGNATURE" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
    gemini_backup_file="${GEMINI_MANDATE_FILE}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$GEMINI_MANDATE_FILE" "$gemini_backup_file"
    echo -e "${COLOR_BLUE}==>${COLOR_RESET} Upgrading Antigravity Mandate in $GEMINI_MANDATE_FILE (backup: $gemini_backup_file)..."

    temp_gemini_file="$(mktemp)"
    write_mandate_header "$temp_gemini_file"
    if grep -q "^# ROLE:" "$GEMINI_MANDATE_FILE" 2>/dev/null; then
        sed -n '/^# ROLE:/,$p' "$GEMINI_MANDATE_FILE" >> "$temp_gemini_file"
    else
        write_default_role_footer "$temp_gemini_file"
    fi
    mv "$temp_gemini_file" "$GEMINI_MANDATE_FILE"
    echo -e "${COLOR_GREEN}✅ Upgraded $GEMINI_MANDATE_FILE to latest System Mandate (Rules 00-45 + Gates E39/E40 Zero-Compromise Dev/QA)${COLOR_RESET}"
else
    echo -e "${COLOR_GREEN}✅ Antigravity System Mandate already up to date in $GEMINI_MANDATE_FILE${COLOR_RESET}"
fi

# 8. Run Doctor verification
echo ""
echo -e "${COLOR_BLUE}==>${COLOR_RESET} Running system health check..."
if [ -f "$TARGET_DIR/scripts/doctor.sh" ]; then
    bash "$TARGET_DIR/scripts/doctor.sh"
fi

echo ""
echo -e "${COLOR_GREEN}======================================================${COLOR_RESET}"
echo -e "${COLOR_GREEN}  🚀 ANTIGRAVITY OS UPDATE COMPLETE!                  ${COLOR_RESET}"
echo -e "${COLOR_GREEN}  Active Location: $TARGET_DIR                        ${COLOR_RESET}"
echo -e "${COLOR_GREEN}======================================================${COLOR_RESET}"
