#!/bin/bash
set -euo pipefail

# Point core.hooksPath at the repo's tracked .githooks/ dir so
# scripts/pre-commit-check.ps1 actually runs (Architecture.md §6). This is
# local git config, not something a fresh clone inherits, so every fresh
# session needs it re-set. Idempotent; runs regardless of remote vs. local.
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -n "$REPO_ROOT" ] && [ -d "$REPO_ROOT/.githooks" ]; then
  git -C "$REPO_ROOT" config core.hooksPath .githooks
fi

# PowerShell is only missing in Claude Code on the web / remote sessions.
# Local VS Code + Copilot sessions run on Windows, where PowerShell is
# already native — nothing to do there.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Idempotent — skip if pwsh is already on PATH (e.g. a cached container).
if command -v pwsh >/dev/null 2>&1; then
  exit 0
fi

UBUNTU_VERSION="$(. /etc/os-release 2>/dev/null && echo "$VERSION_ID" || true)"
UBUNTU_VERSION="${UBUNTU_VERSION:-24.04}"

CA_ARGS=()
if [ -f /root/.ccr/ca-bundle.crt ]; then
  CA_ARGS=(--cacert /root/.ccr/ca-bundle.crt)
fi

export DEBIAN_FRONTEND=noninteractive

curl -sS -L "${CA_ARGS[@]}" -o /tmp/packages-microsoft-prod.deb \
  "https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb"
dpkg -i /tmp/packages-microsoft-prod.deb
apt-get update -qq
apt-get install -y -qq powershell
rm -f /tmp/packages-microsoft-prod.deb
