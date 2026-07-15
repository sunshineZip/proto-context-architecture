# commit-push.ps1
# Stages all workspace changes (temp/ is .gitignored), commits with the provided
# message, and pushes to origin. Run from anywhere in the workspace.
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

Write-Host "Pushing to origin..."
& $git -C $repo push 2>&1 | ForEach-Object { Write-Host "  $_" }
$pushExit = $LASTEXITCODE

$ErrorActionPreference = "Stop"

if ($pushExit -ne 0) {
    Write-Error ("Push failed (exit " + $pushExit + ").")
    exit 1
}

Write-Host ""
Write-Host "Done."
