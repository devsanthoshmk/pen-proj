#!/usr/bin/env bash
# =============================================================================
# DocGen System — Setup Script
# Run this once in your project directory to initialize everything.
# =============================================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║     DocGen Multi-Agent System — Setup                ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ─── 1. Check Node.js ────────────────────────────────────────────────────────
echo -e "${CYAN}[1/7] Checking Node.js...${NC}"
if ! command -v node &>/dev/null; then
  echo -e "${RED}ERROR: Node.js not found. Install it first:${NC}"
  echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
  echo "  sudo apt-get install -y nodejs"
  exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo -e "${RED}ERROR: Node.js v18+ required. Found: $(node --version)${NC}"
  exit 1
fi
echo -e "${GREEN}  ✓ Node.js $(node --version)${NC}"

# ─── 2. Check OpenCode ───────────────────────────────────────────────────────
echo -e "${CYAN}[2/7] Checking OpenCode...${NC}"
if ! command -v opencode &>/dev/null; then
  echo -e "${YELLOW}  OpenCode not found. Installing...${NC}"
  curl -fsSL https://opencode.ai/install | bash
  export PATH="$HOME/.local/bin:$PATH"
fi
echo -e "${GREEN}  ✓ OpenCode $(opencode --version 2>/dev/null || echo 'installed')${NC}"

# ─── 3. Check ANTHROPIC_API_KEY ──────────────────────────────────────────────
echo -e "${CYAN}[3/7] Checking API key...${NC}"
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo -e "${YELLOW}  ANTHROPIC_API_KEY not set in environment.${NC}"
  echo -e "  Add this to your ~/.bashrc or ~/.zshrc:"
  echo -e '  export ANTHROPIC_API_KEY="sk-ant-..."'
  echo ""
  read -p "  Enter your Anthropic API key now (or press Enter to skip): " KEY_INPUT
  if [ -n "$KEY_INPUT" ]; then
    export ANTHROPIC_API_KEY="$KEY_INPUT"
    echo "export ANTHROPIC_API_KEY=\"$KEY_INPUT\"" >> ~/.bashrc
    echo -e "${GREEN}  ✓ API key saved to ~/.bashrc${NC}"
  else
    echo -e "${YELLOW}  ⚠ Skipped. Set ANTHROPIC_API_KEY before running opencode.${NC}"
  fi
else
  echo -e "${GREEN}  ✓ ANTHROPIC_API_KEY is set${NC}"
fi

# ─── 4. Initialize git ───────────────────────────────────────────────────────
echo -e "${CYAN}[4/7] Initializing git repository...${NC}"
if [ ! -d ".git" ]; then
  git init
  echo -e "${GREEN}  ✓ Git repository initialized${NC}"
else
  echo -e "${GREEN}  ✓ Git repository already exists${NC}"
fi

# ─── 5. Create docs directory structure ──────────────────────────────────────
echo -e "${CYAN}[5/7] Creating directory structure...${NC}"
mkdir -p docs/chapters docs/memory-snapshots
touch docs/.gitkeep docs/chapters/.gitkeep docs/memory-snapshots/.gitkeep

cat > .gitignore << 'EOF'
node_modules/
*.log
.env
/tmp/
*.svg
*.png
!docs/**/*.png
EOF

echo -e "${GREEN}  ✓ Directory structure created${NC}"

# ─── 6. Install mermaid CLI ──────────────────────────────────────────────────
echo -e "${CYAN}[6/7] Pre-installing Mermaid CLI (speeds up first diagram validation)...${NC}"
if npx --yes @mermaid-js/mermaid-cli --version &>/dev/null 2>&1; then
  echo -e "${GREEN}  ✓ Mermaid CLI available${NC}"
else
  echo -e "${YELLOW}  ⚠ Mermaid CLI will be installed on first use (npx auto-install)${NC}"
fi

# ─── 7. Verify MCP memory config ─────────────────────────────────────────────
echo -e "${CYAN}[7/7] Checking opencode.json MCP config...${NC}"
if [ -f "opencode.json" ]; then
  if grep -q '"ai-memory"' opencode.json; then
    echo -e "${GREEN}  ✓ ai-memory MCP server configured${NC}"
    echo -e "${YELLOW}  ⚠ IMPORTANT: The MCP server name in opencode.json is 'ai-memory'${NC}"
    echo -e "  If your already-configured MCP has a different name, update opencode.json:${NC}"
    echo -e "  Change all 'ai-memory' references to match your server name."
    echo -e "  Also update the 'ai-memory_*' tool glob patterns in agent configs."
  fi
else
  echo -e "${RED}  ERROR: opencode.json not found in current directory.${NC}"
  echo "  Make sure you are running this script from the docgen-system directory."
  exit 1
fi

# ─── Initial git commit ───────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}Creating initial git commit...${NC}"
git add -A
git commit -m "chore: initialize docgen multi-agent system" 2>/dev/null || \
  echo -e "${YELLOW}  (nothing to commit or git user not configured)${NC}"

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✓ Setup complete!                                   ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo "Next steps:"
echo ""
echo "  1. ⚠  UPDATE YOUR MCP SERVER NAME (if needed):"
echo "     Open opencode.json and check that 'ai-memory' matches your MCP config."
echo "     If your server has a different name, update all 'ai-memory_*' references."
echo ""
echo "  2. START OPENCODE in this directory:"
echo "     opencode"
echo ""
echo "  3. In the TUI, press Tab to select the 'architect' agent."
echo ""
echo "  4. Start a document by telling the architect your topic:"
echo "     'Create a comprehensive technical report on [your topic]'"
echo ""
echo "  Docs:    https://opencode.ai/docs/agents/"
echo "  Discord: https://opencode.ai/discord"
echo ""
