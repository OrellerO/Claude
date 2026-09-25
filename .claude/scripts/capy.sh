#!/usr/bin/env bash

# Wrapper that locates and runs the capy binary.
# Used as a Claude Code hook — must always exit 0 to avoid phantom hook errors.
# See: https://github.com/serpro69/claude-toolbox/issues/57

set -uo pipefail

for p in "$(command -v capy 2>/dev/null || true)" "$HOME/.local/bin/capy" "/opt/homebrew/bin/capy" "/usr/local/bin/capy" "$HOME/go/bin/capy" "capy"; do
  if [ -n "$p" ] && [ -x "$p" ]; then
    "$p" "$@" || true
    exit 0
  fi
done

# capy not found — fail open. Denying here would block every tool the
# PreToolUse matcher covers (Bash, Read, Grep, ...) on machines without capy.
echo "capy.sh: capy binary not found; skipping '$*' (install capy to enable it)" >&2

# As an MCP server entrypoint, fail visibly so the client reports the server as down.
if [ "${1:-}" = "serve" ]; then
  exit 1
fi
exit 0
