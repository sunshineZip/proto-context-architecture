[CmdletBinding()]
param()

# Run at the very start of a session's work in this repo — before reading
# ROUTING.md, session-log.md, or anything else — so decisions are never
# made against a stale local checkout. Complements, and is distinct from,
# the fetch/rebase-before-push logic already in commit-push.ps1
# (knowledge/flow/git-collaboration.md §2-3): that one catches staleness
# right before a push, after work has already been done against whatever
# was locally current; this one catches it before any work begins at all,
# which is what actually prevents wasted effort and late-discovered
# conflicts when jumping between environments (Claude Code web, VS Code +
# Copilot, another session) that don't automatically share state.
#
# Wired into .claude/hooks/session-start.sh so every Claude Code session
# (web or CLI) runs this automatically. Environments without an automatic
# session-start hook (VS Code + Copilot) rely on ROUTING.md Step 1
# instructing a session to run it manually as the first action — see that
# file for the honest limitation this implies.
#
# Behavior is deliberately conservative: it only ever fast-forwards, and
# only when that is unambiguously safe (no local uncommitted changes, no
# local-only commits). Anything else is reported, never acted on
# automatically, and this script always exits 0 — it is informational
# infrastructure, not a gate, and must never block a session from
# starting.

$repoRoot = (git rev-parse --show-toplevel 2>$null)
if (-not $repoRoot) {
    exit 0
}

$branch = (git -C $repoRoot rev-parse --abbrev-ref HEAD 2>$null)
if (-not $branch -or $branch -eq "HEAD") {
    Write-Host "sync-check: not on a branch (detached HEAD) — skipping." -ForegroundColor Yellow
    exit 0
}

git -C $repoRoot fetch origin $branch 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "sync-check: could not fetch origin/$branch (offline, or no remote configured) — skipping." -ForegroundColor Yellow
    exit 0
}

git -C $repoRoot rev-parse --verify "origin/$branch" 2>&1 *> $null
if ($LASTEXITCODE -ne 0) {
    exit 0
}

$hasLocalChanges = [bool](git -C $repoRoot status --porcelain 2>$null)
$behindCount = [int](git -C $repoRoot rev-list "HEAD..origin/$branch" --count 2>$null)
$aheadCount = [int](git -C $repoRoot rev-list "origin/$branch..HEAD" --count 2>$null)

if ($behindCount -eq 0 -and $aheadCount -eq 0) {
    Write-Host "sync-check: up to date with origin/$branch." -ForegroundColor Green
    exit 0
}

if ($behindCount -eq 0 -and $aheadCount -gt 0) {
    Write-Host "sync-check: $aheadCount local commit(s) not yet pushed to origin/$branch. Nothing to sync." -ForegroundColor Yellow
    exit 0
}

if ($behindCount -gt 0 -and $aheadCount -eq 0 -and -not $hasLocalChanges) {
    $incoming = @(git -C $repoRoot log --oneline "HEAD..origin/$branch" 2>$null)
    git -C $repoRoot merge --ff-only "origin/$branch" 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "sync-check: was $behindCount commit(s) behind origin/$branch — fast-forwarded automatically." -ForegroundColor Green
        foreach ($line in $incoming) { Write-Host "  $line" }
    } else {
        Write-Host "sync-check: was $behindCount commit(s) behind but the fast-forward failed unexpectedly — check manually." -ForegroundColor Red
    }
    exit 0
}

if ($behindCount -gt 0 -and $hasLocalChanges) {
    Write-Host "sync-check: $behindCount commit(s) behind origin/$branch, and there are uncommitted local changes — not auto-syncing." -ForegroundColor Yellow
    Write-Host "Commit or stash first, then re-run, or see knowledge/flow/git-collaboration.md." -ForegroundColor Yellow
    exit 0
}

if ($behindCount -gt 0 -and $aheadCount -gt 0) {
    Write-Host "sync-check: DIVERGED from origin/$branch — $aheadCount local commit(s), $behindCount remote commit(s) not in either." -ForegroundColor Red
    Write-Host "Do not push as-is. See knowledge/flow/git-collaboration.md §3-4 for the rebase" -ForegroundColor Yellow
    Write-Host "and append-only-safe resolution procedure before doing anything else here." -ForegroundColor Yellow
    exit 0
}
