# commit-push.ps1
# Stages all workspace changes (temp/ is .gitignored), commits with the provided
# message, safely integrates any remote changes, and pushes to origin. Run from
# anywhere in the workspace.
#
# Usage:
#   .\scripts\commit-push.ps1 "describe what changed"
#
# Note: git is not in the system PATH on this machine — this script locates it
# automatically via the GitHub Desktop installation.
#
# Note on stderr handling: git writes normal progress/status output (e.g. the
# "To <url> ... branch -> branch" push summary) to stderr by design, even on
# full success. Merging that via `2>&1` into a pipeline while
# $ErrorActionPreference = "Stop" is in effect turns it into a terminating
# PowerShell error regardless of git's actual exit code. Every native git call
# below runs under Continue and is judged solely on $LASTEXITCODE — the
# authoritative, preference-independent signal of real success/failure — so a
# genuine failure (rejected push, auth error, network issue, etc.) is never
# masked and a benign stderr line never produces a false alarm.
#
# Note on remote integration: if more than one person may push to this repo,
# a clean local commit isn't enough on its own — see
# knowledge/flow/git-collaboration.md. This script fetches and rebases onto
# origin before every push, and re-validates even after a clean rebase,
# because two edits to different files (or non-adjacent sections of the same
# file) can merge with no git conflict at all and still leave something
# structurally inconsistent — that's validate.ps1's job to catch, not git's.
# (Two sessions colliding on the exact same append point, like a session-log
# turn, is more likely to surface as a real rebase conflict than to merge
# silently — verified directly, not assumed.) On any real conflict, or on a
# validation failure after a clean rebase, this script stops without pushing
# rather than guessing at a resolution. It never force-pushes under any
# circumstance — that always requires a human running the command by hand.

param(
    [Parameter(Mandatory = $true)]
    [string]$Message
)

$ErrorActionPreference = "Stop"

# Locate git via GitHub Desktop (most recent installed version)
$git = Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\GitHubDesktop\app-*\resources\app\git\cmd\git.exe" `
    -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending |
    Select-Object -ExpandProperty FullName -First 1

if (-not $git) {
    # Fallback: standard Git install
    $git = "C:\Program Files\Git\cmd\git.exe"
    if (-not (Test-Path $git)) {
        Write-Error "git.exe not found. Install Git for Windows or GitHub Desktop, then retry."
        exit 1
    }
}

# Repo root is one level above this script's directory
$repo = Split-Path $PSScriptRoot -Parent

Write-Host "Repository: $repo"
Write-Host "Git:        $git"
Write-Host ""

# From here on, native git stderr output must never escalate into a
# terminating PowerShell error — see note above. $LASTEXITCODE is checked
# explicitly after every call instead.
$ErrorActionPreference = "Continue"

Write-Host "Staging all changes..."
& $git -C $repo add -A 2>&1 | ForEach-Object { Write-Host "  $_" }
$addExit = $LASTEXITCODE
if ($addExit -ne 0) {
    $ErrorActionPreference = "Stop"
    Write-Error ("git add failed (exit " + $addExit + ").")
    exit 1
}

Write-Host "Committing: $Message"
$commitOut = & $git -C $repo commit -m $Message 2>&1
$commitExit = $LASTEXITCODE

if ($commitOut -match "nothing to commit") {
    Write-Host "Nothing to commit - workspace is already clean."
    exit 0
}

$commitOut | ForEach-Object { Write-Host "  $_" }

if ($commitExit -ne 0) {
    $ErrorActionPreference = "Stop"
    Write-Error ("Commit failed (exit " + $commitExit + ").")
    exit 1
}

$branch = (& $git -C $repo rev-parse --abbrev-ref HEAD 2>&1).Trim()

Write-Host "Fetching origin..."
& $git -C $repo fetch origin 2>&1 | ForEach-Object { Write-Host "  $_" }
$fetchExit = $LASTEXITCODE
if ($fetchExit -ne 0) {
    $ErrorActionPreference = "Stop"
    Write-Error ("git fetch failed (exit " + $fetchExit + "). Not pushing.")
    exit 1
}

& $git -C $repo rev-parse --verify "origin/$branch" 2>&1 | Out-Null
$remoteBranchExists = ($LASTEXITCODE -eq 0)

if ($remoteBranchExists) {
    $behindCount = (& $git -C $repo rev-list "HEAD..origin/$branch" --count 2>&1).Trim()

    if ($behindCount -and $behindCount -ne "0") {
        Write-Host "origin/$branch has $behindCount commit(s) not yet in this branch — rebasing..."
        & $git -C $repo rebase "origin/$branch" 2>&1 | ForEach-Object { Write-Host "  $_" }
        $rebaseExit = $LASTEXITCODE

        if ($rebaseExit -ne 0) {
            $conflicted = @(& $git -C $repo diff --name-only --diff-filter=U 2>&1)
            & $git -C $repo rebase --abort 2>&1 | Out-Null
            $ErrorActionPreference = "Stop"
            Write-Host ""
            if ($conflicted.Count -gt 0) {
                Write-Host "REBASE CONFLICT — aborted, nothing pushed. Working tree is back to a clean state." -ForegroundColor Red
                Write-Host "Conflicted file(s):" -ForegroundColor Red
                $conflicted | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
                Write-Host ""
                Write-Host "See knowledge/flow/git-collaboration.md §4 for how to resolve this by file type." -ForegroundColor Yellow
            } else {
                Write-Host "REBASE FAILED for a reason other than a content conflict (no unmerged files" -ForegroundColor Red
                Write-Host "found) — aborted, nothing pushed. Working tree is back to a clean state." -ForegroundColor Red
                Write-Host "Inspect manually (e.g. a hook rejected a replayed commit) before retrying." -ForegroundColor Red
            }
            exit 1
        }

        Write-Host "Rebase completed cleanly. Re-validating before push — a clean rebase across" -ForegroundColor Yellow
        Write-Host "different files can still leave something structurally inconsistent that git's" -ForegroundColor Yellow
        Write-Host "own diff won't flag." -ForegroundColor Yellow
        $validateScript = Join-Path $repo "scripts\validate.ps1"
        & powershell -NoProfile -File $validateScript
        $validateExit = $LASTEXITCODE
        if ($validateExit -ne 0) {
            $ErrorActionPreference = "Stop"
            Write-Host ""
            Write-Host "VALIDATION FAILED after rebase — not pushing. The rebase itself is not undone;" -ForegroundColor Red
            Write-Host "fix the reported issue (see knowledge/flow/git-collaboration.md §4 for the" -ForegroundColor Red
            Write-Host "append-only renumbering procedure), then re-run this script." -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host "Pushing to origin..."
& $git -C $repo push origin $branch 2>&1 | ForEach-Object { Write-Host "  $_" }
$pushExit = $LASTEXITCODE

$ErrorActionPreference = "Stop"

if ($pushExit -ne 0) {
    Write-Error ("Push failed (exit " + $pushExit + "). This should be rare right after a successful fetch+rebase above — if it recurs, someone pushed again in the meantime; re-run this script rather than forcing.")
    exit 1
}

Write-Host ""
Write-Host "Done."
