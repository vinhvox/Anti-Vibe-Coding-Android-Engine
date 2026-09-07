#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Automated Community Installer
# Target: macOS / Linux / WSL
# ==============================================================================

set -e

REPO_URL="https://github.com/vinhvox/Anti-Vibe-Coding-Android-Engine.git"
TARGET_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  ANTIGRAVITY ANDROID OS — THE PRAGMATIC CTO ENGINE   ${NC}"
echo -e "${BLUE}  Version 2026 | Jetpack Compose M3 | Navigation 3    ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

# 1. Check prerequisites
echo -e "${BLUE}==>${NC} Checking system requirements..."
command -v git >/dev/null 2>&1 || { echo -e "${RED}❌ Git is required but not installed. Aborting.${NC}"; exit 1; }

# 2. Check installation directory
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠️ Existing configuration found at $TARGET_DIR.${NC}"
    read -p "Do you want to backup and update? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="${TARGET_DIR}_backup_$(date +%Y%m%d%H%M%S)"
        echo -e "${BLUE}==>${NC} Backing up to $BACKUP_DIR..."
        mv "$TARGET_DIR" "$BACKUP_DIR"
    else
        echo -e "${RED}Installation cancelled by user.${NC}"
        exit 0
    fi
fi

# 3. Clone or Copy
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

if [ -f "$SCRIPT_DIR/rules/00-system-mandate.md" ]; then
    # Local installation from cloned repo
    echo -e "${BLUE}==>${NC} Installing from local repository ($SCRIPT_DIR) to $TARGET_DIR..."
    mkdir -p "$TARGET_DIR"
    cp -R "$SCRIPT_DIR/brain" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/rules" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/workflow" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/skills" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/memory" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/bin" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/scripts" "$TARGET_DIR/"
    cp -R "$SCRIPT_DIR/templates" "$TARGET_DIR/"
    cp "$SCRIPT_DIR/INDEX.md" "$TARGET_DIR/"
    cp "$SCRIPT_DIR/.context-digest.md" "$TARGET_DIR/"
else
    # Remote installation via git clone
    echo -e "${BLUE}==>${NC} Cloning Antigravity OS from $REPO_URL..."
    git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
fi

# 4. Set permissions
echo -e "${BLUE}==>${NC} Setting executable permissions..."
find "$TARGET_DIR/scripts" -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
find "$TARGET_DIR/bin" -type f -exec chmod +x {} + 2>/dev/null || true

# 5. Run Doctor
echo ""
echo -e "${BLUE}==>${NC} Running system health check..."
if [ -f "$TARGET_DIR/scripts/doctor.sh" ]; then
    bash "$TARGET_DIR/scripts/doctor.sh" || true
fi

echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}  🎉 INSTALLATION COMPLETE!                           ${NC}"
echo -e "${GREEN}  Antigravity Engine is active at: $TARGET_DIR        ${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""
echo "Next steps:"
echo "1. In your Android project root, your AI coding agent will automatically detect and load this framework."
echo "2. Run 'bash $TARGET_DIR/scripts/doctor.sh' anytime to diagnose your environment."
echo "3. Copy templates from $TARGET_DIR/templates/memory/ into your project if you want customized project memory."
echo ""
