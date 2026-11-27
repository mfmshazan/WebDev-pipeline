#!/usr/bin/env bash
# install.sh — install the webdev-pipeline into the global Claude Code config (~/.claude).
# Copies agents/, commands/, and templates/, and installs the Playwright MCP at user scope.
# It only writes into ~/.claude and the user-scope MCP config; it never touches your projects.
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

# 1. Agents (named wd-*.md) -> ~/.claude/agents/
echo "Installing agents          -> $AGENTS_DST"
cp -f "$SRC_DIR"/agents/wd-*.md "$AGENTS_DST"/

# 2. Commands -> ~/.claude/commands/wd/  (invoked as /wd:new-project, /wd:build-next, /wd:finish)
echo "Installing commands        -> $COMMANDS_DST"
cp -f "$SRC_DIR"/commands/wd/*.md "$COMMANDS_DST"/

# 3. Shared conventions + templates -> ~/.claude/webdev-pipeline/
echo "Installing conventions     -> $PIPELINE_DST/CONVENTIONS.md"
cp -f "$SRC_DIR/CONVENTIONS.md" "$PIPELINE_DST/CONVENTIONS.md"
echo "Installing templates       -> $PIPELINE_DST/templates"
rm -rf "$PIPELINE_DST/templates"
cp -rf "$SRC_DIR/templates" "$PIPELINE_DST/templates"

AGENT_COUNT="$(ls "$AGENTS_DST"/wd-*.md | wc -l | tr -d ' ')"
echo
echo "Installed $AGENT_COUNT agents (wd-*) and 3 commands (/wd:new-project, /wd:build-next, /wd:finish)."
echo

# 4. Playwright MCP at user scope (for screenshots / visual QA / a11y audits)
if command -v claude >/dev/null 2>&1; then
  if claude mcp list 2>/dev/null | grep -qi '^playwright\b\|playwright'; then
    echo "Playwright MCP already configured — skipping."
  else
    echo "Installing Playwright MCP at user scope..."
    if claude mcp add --scope user playwright npx @playwright/mcp@latest; then
      echo "Playwright MCP installed (user scope)."
    else
      echo "WARNING: could not add Playwright MCP automatically. Add it manually with:"
      echo "    claude mcp add --scope user playwright npx @playwright/mcp@latest"
    fi
  fi
else
  echo "NOTE: 'claude' CLI not found on PATH — skipping Playwright MCP install."
  echo "      Once Claude Code is installed, run:"
  echo "    claude mcp add --scope user playwright npx @playwright/mcp@latest"
  echo "      (Visual agents degrade gracefully without it.)"
fi

echo
echo "Done. Restart Claude Code (or run /agents) to load the wd-* agents."
echo "Start a build with:  /wd:new-project \"<your idea>\""
