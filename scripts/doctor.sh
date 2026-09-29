#!/usr/bin/env bash
# ==============================================================================
# Antigravity Android Framework — Environment Doctor
# Diagnoses JDK, Android SDK, Git, and Antigravity Configuration
# ==============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  ANTIGRAVITY OS — SYSTEM DIAGNOSTIC DOCTOR           ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

ERRORS=0
WARNINGS=0

# 1. Check Git
echo -n "Checking Git... "
if command -v git >/dev/null 2>&1; then
    GIT_VERSION=$(git --version | head -n 1)
    echo -e "${GREEN}OK${NC} ($GIT_VERSION)"
else
    echo -e "${RED}MISSING${NC} (Git is required)"
    ERRORS=$((ERRORS + 1))
fi

# 2. Check Java / JDK 17+
echo -n "Checking Java Development Kit (JDK 17+)... "
if command -v java >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    JAVA_MAJOR=$(echo "$JAVA_VERSION" | awk -F '.' '{print $1}')
    if [ "$JAVA_MAJOR" -ge 17 ] 2>/dev/null; then
        echo -e "${GREEN}OK${NC} (JDK $JAVA_VERSION)"
    else
        echo -e "${YELLOW}WARNING${NC} (Detected JDK $JAVA_VERSION. Recommended JDK 17+ for Modern Android Gradle 8+)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}MISSING${NC} (Java/JDK not found in PATH)"
    ERRORS=$((ERRORS + 1))
fi

# 3. Check Android SDK Root
echo -n "Checking Android SDK... "
if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
    echo -e "${GREEN}OK${NC} (ANDROID_HOME: $ANDROID_HOME)"
elif [ -n "$ANDROID_SDK_ROOT" ] && [ -d "$ANDROID_SDK_ROOT" ]; then
    echo -e "${GREEN}OK${NC} (ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT)"
elif [ -d "$HOME/Library/Android/sdk" ]; then
    echo -e "${GREEN}OK${NC} (Default macOS path: $HOME/Library/Android/sdk)"
elif [ -d "$HOME/Android/Sdk" ]; then
    echo -e "${GREEN}OK${NC} (Default Linux path: $HOME/Android/Sdk)"
else
    echo -e "${YELLOW}WARNING${NC} (Android SDK directory not found in standard paths or environment variables)"
    WARNINGS=$((WARNINGS + 1))
fi

# 4. Check Antigravity Framework Installation
TARGET_DIR="${ANTIGRAVITY_HOME:-$HOME/.antigravity}"
echo -n "Checking Antigravity Framework in $TARGET_DIR... "
if [ -d "$TARGET_DIR" ] && [ -f "$TARGET_DIR/rules/00-system-mandate.md" ]; then
    RULE_COUNT=$(find "$TARGET_DIR/rules" -name "*.md" | wc -l | tr -d ' ')
    SKILL_COUNT=$(find "$TARGET_DIR/skills" -maxdepth 1 -type d | wc -l | tr -d ' ')
    SKILL_COUNT=$((SKILL_COUNT - 1))
    echo -e "${GREEN}OK${NC} ($RULE_COUNT Rules, $SKILL_COUNT Skills verified)"
else
    echo -e "${YELLOW}NOT INSTALLED in $TARGET_DIR${NC} (Run scripts/install.sh to install)"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo -e "${BLUE}======================================================${NC}"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All diagnostics passed with 0 errors and 0 warnings!${NC}"
    echo -e "${GREEN}Your environment is 100% ready for Antigravity Android OS.${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️ Diagnostics passed with $WARNINGS warning(s). Review above for details.${NC}"
else
    echo -e "${RED}❌ Diagnostics failed with $ERRORS error(s) and $WARNINGS warning(s).${NC}"
    exit 1
fi
echo -e "${BLUE}======================================================${NC}"
