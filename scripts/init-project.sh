#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Project Workspace Initializer
# Run this script inside the root directory of your Android / KMP project
# ==============================================================================

set -e

ANTIGRAVITY_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  ANTIGRAVITY OS — PROJECT WORKSPACE INITIALIZER      ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

# 1. Verify Antigravity global installation
if [ ! -d "$ANTIGRAVITY_DIR" ]; then
    echo -e "${RED}❌ Global Antigravity framework not found at $ANTIGRAVITY_DIR.${NC}"
    echo "Please run the Quickstart installer first:"
    echo "curl -fsSL https://raw.githubusercontent.com/vinhvox/Anti-Vibe-Coding-Android-Engine/main/scripts/install.sh | bash"
    exit 1
fi

# 2. Check if current directory is an Android or Git project
PROJECT_ROOT="$(pwd)"
if [ ! -f "$PROJECT_ROOT/settings.gradle.kts" ] && [ ! -f "$PROJECT_ROOT/settings.gradle" ] && [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${YELLOW}⚠️ Warning: No settings.gradle(.kts) or .git directory found in $PROJECT_ROOT.${NC}"
    read -p "Do you still want to initialize Antigravity in this directory? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Initialization cancelled.${NC}"
        exit 0
    fi
fi

# 3. Create .antigravity/memory directory & initialize project-memory.md
echo -e "${BLUE}==>${NC} Setting up project memory in $PROJECT_ROOT/.antigravity/memory..."
mkdir -p "$PROJECT_ROOT/.antigravity/memory"

if [ ! -f "$PROJECT_ROOT/.antigravity/memory/01-project-memory.md" ]; then
    if [ -f "$ANTIGRAVITY_DIR/templates/memory/project-memory.template.md" ]; then
        cp "$ANTIGRAVITY_DIR/templates/memory/project-memory.template.md" "$PROJECT_ROOT/.antigravity/memory/01-project-memory.md"
        echo -e "${GREEN}✅ Initialized .antigravity/memory/01-project-memory.md${NC}"
    else
        echo -e "${YELLOW}⚠️ Template not found, creating placeholder project memory.${NC}"
        cat > "$PROJECT_ROOT/.antigravity/memory/01-project-memory.md" << EOF
# Project Memory: $(basename "$PROJECT_ROOT")
## Tech Stack
- UI: Jetpack Compose M3
- Architecture: MVI / UDF + Clean Architecture
- Navigation: Navigation 3
- Concurrency: Kotlin Coroutines & Flow
- Quality Gates: E1 - E29 Compliant
EOF
    fi
else
    echo -e "${YELLOW}ℹ️ Project memory already exists at .antigravity/memory/01-project-memory.md (preserved)${NC}"
fi

# 4. Bind local project GEMINI.md
PROJECT_GEMINI="$PROJECT_ROOT/GEMINI.md"
if [ ! -f "$PROJECT_GEMINI" ]; then
    echo -e "${BLUE}==>${NC} Binding project-level GEMINI.md..."
    cat > "$PROJECT_GEMINI" << EOF
# Project Mandate: Antigravity Android Engine
This workspace adheres to the Antigravity Android Engine standard located at:
$ANTIGRAVITY_DIR/

* **System Mandate:** file://$ANTIGRAVITY_DIR/rules/00-system-mandate.md
* **Enforcement Gates (E1 - E29):** file://$ANTIGRAVITY_DIR/rules/21-enforcement-engine.md
* **Project Memory:** file://$PROJECT_ROOT/.antigravity/memory/01-project-memory.md

All code modifications must satisfy the 38 Standards and 29 Quality Gates (E1–E29).
EOF
    echo -e "${GREEN}✅ Created project GEMINI.md${NC}"
else
    echo -e "${YELLOW}ℹ️ Existing project GEMINI.md found (preserved).${NC}"
fi

# 5. Success summary
echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}  🎉 PROJECT INITIALIZED SUCCESSFULLY!                ${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""
echo "Next steps:"
echo "1. Edit .antigravity/memory/01-project-memory.md with your project specifics."
echo "2. Launch your AI assistant ('agy' in terminal) and ask:"
echo "   'Who are you and what rules do you follow?'"
echo "3. Run 'agy /skills' to explore available architectural workflows."
echo ""
