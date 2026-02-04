#!/bin/bash
# CPTV Command Center - Deployment Script
#
# Usage:
#   ./deploy.sh --preview     Deploy to staging (default)
#   ./deploy.sh --production  Deploy to production (requires confirmation)

set -e

PROJECT="sidekick-bigmuddy"
SITE="cptv-command"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

cd /Users/clawdbot/Sites/cptv-command

# Parse arguments
MODE="preview"
for arg in "$@"; do
    case $arg in
        --preview)
            MODE="preview"
            ;;
        --production|--prod)
            MODE="production"
            ;;
        --help|-h)
            echo "Usage: ./deploy.sh [--preview|--production]"
            echo ""
            echo "Options:"
            echo "  --preview     Deploy to staging (default)"
            echo "  --production  Deploy to production (requires confirmation)"
            exit 0
            ;;
    esac
done

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}   CPTV COMMAND CENTER DEPLOYMENT                   ${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
echo ""

if [ "$MODE" = "preview" ]; then
    echo -e "${YELLOW}📋 Mode: STAGING (Preview)${NC}"
    echo ""
    echo "Deploying to preview channel..."
    echo ""

    npx firebase-tools hosting:channel:deploy preview \
        --expires 7d \
        --project $PROJECT \
        --only hosting:$SITE

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   ✅ STAGING DEPLOYMENT COMPLETE                   ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo ""
    echo "📋 NEXT STEPS:"
    echo ""
    echo "  1. 🎨 Craft K2: Review design at preview URL"
    echo "  2. 🔄 Watch: Run QA checklist"
    echo "  3. 👤 User: Final approval"
    echo "  4. 🚀 Run: ./deploy.sh --production"
    echo ""

elif [ "$MODE" = "production" ]; then
    echo -e "${RED}════════════════════════════════════════════════════${NC}"
    echo -e "${RED}   ⚠️  PRODUCTION DEPLOYMENT                        ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════${NC}"
    echo ""
    echo "PRE-DEPLOY CHECKLIST:"
    echo ""
    echo "  □ Craft K2 design review: APPROVED"
    echo "  □ Watch QA testing: APPROVED"
    echo "  □ User final approval: CONFIRMED"
    echo ""
    read -p "Have ALL checks passed? Type 'yes' to confirm: " confirm

    if [ "$confirm" != "yes" ]; then
        echo ""
        echo -e "${RED}❌ Deployment cancelled.${NC}"
        echo "Run ./deploy.sh --preview first and complete the QA process."
        exit 1
    fi

    echo ""
    echo -e "${GREEN}Deploying to PRODUCTION...${NC}"
    echo ""

    npx firebase-tools deploy \
        --only hosting:$SITE \
        --project $PROJECT

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   🚀 PRODUCTION DEPLOYMENT COMPLETE                ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo ""
    echo "🌐 Live at: https://$SITE.web.app"
    echo ""
fi
