#!/bin/sh
# Copy the agent-contracts skill into each AI's skills folder.
#
#   install.sh                 every AI whose config folder exists under $HOME:
#                              ~/.claude ~/.codex ~/.copilot ~/.gemini (+ antigravity)
#   install.sh DIR...          these skills folders only
set -eu

here=$(cd "$(dirname "$0")" && pwd)
src="$here/skills/agent-contracts"

auto=0
if [ $# -eq 0 ]; then
  auto=1
  set -- "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.copilot/skills" \
    "$HOME/.gemini/skills" "$HOME/.gemini/antigravity/skills"
fi

for dir in "$@"; do
  parent=$(dirname "$dir")
  if [ "$auto" -eq 1 ] && [ ! -d "$parent" ]; then
    echo "skip      $dir (no $parent)"
    continue
  fi
  mkdir -p "$dir/agent-contracts"
  cp -R "$src/." "$dir/agent-contracts/"
  echo "installed $dir/agent-contracts"
done
