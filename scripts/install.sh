#!/usr/bin/env bash
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for TARGET in "$HOME/.gemini/config/skills" "$HOME/.agents/skills" "$HOME/.claude/skills"; do
  mkdir -p "$TARGET"
  cp -r "$REPO_ROOT/skills/clasp-netlify-sheets" "$TARGET/"
  cp -r "$REPO_ROOT/skills/clasp-netlify-sheets-en" "$TARGET/"
  echo "✅ Installed skills to: $TARGET"
done

echo ""
echo "🎉 Installation complete! Restart AntiGravity or open a new chat to use /clasp-netlify-sheets or /clasp-netlify-sheets-en."
