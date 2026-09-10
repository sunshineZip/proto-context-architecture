#!/bin/bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

# PowerShell is only missing in Claude Code on the web / remote sessions.
# Local VS Code + Copilot sessions run on Windows, where PowerShell is
# already native — nothing to install there. Idempotent — skip if pwsh is
# already on PATH (e.g. a cached container).
#
# This used to be two early `exit 0`s guarding the install block below —
# changed to an `if` instead, because a real session-start sync check
# (below) needs to run on every path through this script, not just the
# one where PowerShell needs installing. An early exit here would have
# silently skipped that sync on every local session and every cached
# remote container — i.e. almost always.
#
# `|| true` on the install: a failed install must not abort this script
# under `set -e`, because the hook-activation step below now depends on
# knowing whether it worked.
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && ! command -v pwsh >/dev/null 2>&1; then
  UBUNTU_VERSION="$(. /etc/os-release 2>/dev/null && echo "$VERSION_ID" || true)"
  UBUNTU_VERSION="${UBUNTU_VERSION:-24.04}"

  CA_ARGS=()
  if [ -f /root/.ccr/ca-bundle.crt ]; then
    CA_ARGS=(--cacert /root/.ccr/ca-bundle.crt)
  fi

  export DEBIAN_FRONTEND=noninteractive

  {
    curl -sS -L "${CA_ARGS[@]}" -o /tmp/packages-microsoft-prod.deb \
      "https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb" &&
    dpkg -i /tmp/packages-microsoft-prod.deb &&
    apt-get update -qq &&
    apt-get install -y -qq powershell
  } || echo "session-start: PowerShell install failed." >&2
  rm -f /tmp/packages-microsoft-prod.deb
fi

# Point core.hooksPath at the repo's tracked .githooks/ dir so
# scripts/pre-commit-check.ps1 and scripts/pre-push-check.ps1 actually run
# (Architecture.md section 6). This is local git config, not something a fresh
# clone inherits, so every fresh session needs it re-set. Idempotent; runs
# regardless of remote vs. local.
#
# Ordered AFTER the PowerShell install above, and conditional on it having
# worked. Activating hooks that cannot run is worse than not activating them:
# .githooks/* invokes PowerShell, so with none present every `git commit` and
# `git push` fails with a "command not found" that looks like a repo bug rather
# than a missing dependency. That happened for a whole session before this
# ordering was fixed, and Architecture.md section 6 step 10 states the rule
# this implements.
if command -v pwsh >/dev/null 2>&1 || command -v powershell.exe >/dev/null 2>&1; then
  if [ -n "$REPO_ROOT" ] && [ -d "$REPO_ROOT/.githooks" ]; then
    git -C "$REPO_ROOT" config core.hooksPath .githooks
  fi
else
  echo "session-start: no PowerShell found, so the git hooks were left inactive." >&2
  echo "session-start: commits will not be checked. See Architecture.md section 6." >&2
fi

# Sync local main with origin before any work begins — see
# scripts/sync-check.ps1 and ROUTING.md Step 1. Safe: only ever
# fast-forwards, and only when there are no local uncommitted changes and
# no local-only commits; anything else is reported, not acted on. This is
# what actually closes the gap that motivated it — jumping between Claude
# Code web and VS Code + Copilot on the same fork, where the newly-started
# side has no automatic way to know the other one already pushed.
if [ -n "$REPO_ROOT" ] && [ -f "$REPO_ROOT/scripts/sync-check.ps1" ] && command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -File "$REPO_ROOT/scripts/sync-check.ps1" || true
fi
