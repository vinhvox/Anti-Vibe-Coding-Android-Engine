#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Uninstaller Script
# ==============================================================================

set -e

TARGET_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}======================================================${NC}"
echo -e "${RED}  ANTIGRAVITY OS — UNINSTALLATION                     ${NC}"
echo -e "${RED}======================================================${NC}"
echo ""

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Antigravity is not installed at $TARGET_DIR.${NC}"
    exit 0
fi

read -p "Are you sure you want to completely remove Antigravity from $TARGET_DIR? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    BACKUP_DIR="${HOME}/.antigravity_uninstalled_backup_$(date +%Y%m%d%H%M%S)"
    echo -e "${BLUE}==>${NC} Creating safety archive at $BACKUP_DIR..."
    cp -R "$TARGET_DIR" "$BACKUP_DIR"
    
    echo -e "${BLUE}==>${NC} Removing $TARGET_DIR..."
    rm -rf "$TARGET_DIR"
    
    echo -e "${GREEN}✅ Antigravity OS successfully removed.${NC}"
    echo -e "A safety backup was saved to: $BACKUP_DIR"
else
    echo -e "${BLUE}Uninstallation cancelled.${NC}"
fi
