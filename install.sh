#!/usr/bin/env bash
# install.sh — copy the webdev-pipeline into the global Claude Code config (~/.claude).
# Read-only toward your projects; it only writes into ~/.claude.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

AGENTS_DST="$CLAUDE_DIR/agents"
COMMANDS_DST="$CLAUDE_DIR/commands/wd"
PIPELINE_DST="$CLAUDE_DIR/webdev-pipeline"

echo "webdev-pipeline installer"
echo "  source: $SRC_DIR"
echo "  target: $CLAUDE_DIR"
echo

mkdir -p "$AGENTS_DST" "$COMMANDS_DST" "$PIPELINE_DST"

# 1. Agents (already named wd-*.md) -> ~/.claude/agents/
echo "Installing agents -> $AGENTS_DST"
cp -f "$SRC_DIR"/agents/wd-*.md "$AGENTS_DST"/

# 2. Commands -> ~/.claude/commands/wd/  (invoked as /wd:new-project, etc.)
echo "Installing commands -> $COMMANDS_DST"
cp -f "$SRC_DIR"/commands/wd/*.md "$COMMANDS_DST"/

# 3. Shared conventions + templates -> ~/.claude/webdev-pipeline/
echo "Installing conventions + templates -> $PIPELINE_DST"
cp -f "$SRC_DIR/CONVENTIONS.md" "$PIPELINE_DST/CONVENTIONS.md"
rm -rf "$PIPELINE_DST/templates"
cp -rf "$SRC_DIR/templates" "$PIPELINE_DST/templates"

echo
echo "Installed:"
echo "  $(ls "$AGENTS_DST"/wd-*.md | wc -l | tr -d ' ') agents (wd-*)"
echo "  3 commands: /wd:new-project  /wd:build-next  /wd:finish"
echo

# Optional dependency hint
if ! claude mcp list 2>/dev/null | grep -qi playwright; then
  cat <<'EOF'
NOTE: Playwright MCP was not detected. Screenshot/visual-QA agents will still run
but will skip screenshots. To enable them:

    claude mcp add playwright npx @playwright/mcp@latest

EOF
fi

echo "Done. Restart Claude Code (or run /agents) to load the wd-* agents."
echo "Start a build with:  /wd:new-project \"<your idea>\""
