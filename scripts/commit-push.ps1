# commit-push.ps1
# Stages all workspace changes (temp/ is .gitignored), commits with the provided
# message, and pushes to origin. Run from anywhere in the workspace.
#
# Usage:
#   .\scripts\commit-push.ps1 "describe what changed"
#
# Note: git is not in the system PATH on this machine — this script locates it
# automatically via the GitHub Desktop installation.

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

Write-Host "Staging all changes..."
& $git -C $repo add -A 2>&1 | ForEach-Object { Write-Host "  $_" }

Write-Host "Committing: $Message"
$commitOut = & $git -C $repo commit -m $Message 2>&1

if ($commitOut -match "nothing to commit") {
    Write-Host "Nothing to commit - workspace is already clean."
    exit 0
}

$commitOut | ForEach-Object { Write-Host "  $_" }

if ($LASTEXITCODE -ne 0) {
    Write-Error ("Commit failed (exit " + $LASTEXITCODE + ").")
    exit 1
}

Write-Host "Pushing to origin..."
& $git -C $repo push 2>&1 | ForEach-Object { Write-Host "  $_" }

if ($LASTEXITCODE -ne 0) {
    Write-Error ("Push failed (exit " + $LASTEXITCODE + ").")
    exit 1
}

Write-Host ""
Write-Host "Done."
