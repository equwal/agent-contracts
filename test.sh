#!/bin/sh
# install.sh installs into the AIs whose config folder exists, into explicit
# folders, and nowhere else.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
skill="$here/skills/agent-contracts/SKILL.md"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

grep -q '^name: agent-contracts$' "$skill" || fail "SKILL.md has no name"

mkdir -p "$tmp/.claude" "$tmp/.codex"
HOME="$tmp" sh "$here/install.sh"
for ai in .claude .codex; do
  diff -q "$skill" "$tmp/$ai/skills/agent-contracts/SKILL.md" >/dev/null \
    || fail "$ai not installed"
done
for ai in .copilot .gemini; do
  [ ! -e "$tmp/$ai" ] || fail "$ai created without a config folder"
done

HOME="$tmp" sh "$here/install.sh" "$tmp/custom/skills"
diff -q "$skill" "$tmp/custom/skills/agent-contracts/SKILL.md" >/dev/null \
  || fail "explicit folder not installed"

echo PASS
