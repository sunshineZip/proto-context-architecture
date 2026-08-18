[CmdletBinding()]
param()

# Invoked by .githooks/pre-push (requires `git config core.hooksPath
# .githooks` — see Architecture.md §6). Blocks a push that creates or
# updates a branch other than this repo's default branch — operationalizes
# the ROUTING.md Hard Constraint "work directly on the default branch by
# default" mechanically, the same way pre-commit-check.ps1 already does
# for the system-layer-logging and secret-pattern constraints, instead of
# relying solely on the model remembering it.
#
# A branch deletion is never blocked — cleanup is always fine, only
# creating/updating content on a non-default branch is checked. Tag
# pushes are out of scope entirely.
#
# Honest limitation: this only fires when a session drives `git push`
# itself. It cannot catch a branch a session-launch environment assigned
# before any local git command ran, or a push made through a platform API
# rather than local git — see ROUTING.md's Hard Constraint for what to do
# if you find yourself already on a non-default branch you didn't choose.
#
# A fork using a different default branch name than "main" should change
# $defaultBranch below — this is a template default, not derived
# automatically, to keep the check simple and dependency-free.

$defaultBranch = "main"

$repoRoot = (git rev-parse --show-toplevel 2>$null)
if (-not $repoRoot) {
    Write-Host "pre-push: could not determine repo root, skipping check" -ForegroundColor Yellow
    exit 0
}

$stdinText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($stdinText)) {
    exit 0
}

$blockedBranches = @()
foreach ($line in ($stdinText -split "`r?`n")) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $parts = $line -split '\s+'
    if ($parts.Count -lt 4) { continue }
    $localOid = $parts[1]
    $remoteRef = $parts[2]

    # Deletions (local side is all-zeros) are never blocked.
    if ($localOid -match '^0+$') { continue }

    # Tags aren't branches — not in scope for this check.
    if ($remoteRef -notmatch '^refs/heads/') { continue }

    $branchName = $remoteRef -replace '^refs/heads/', ''
    if ($branchName -ne $defaultBranch) {
        $blockedBranches += $branchName
    }
}

if ($blockedBranches.Count -eq 0) {
    exit 0
}

Write-Host ""
Write-Host "PUSH BLOCKED: pushing to a non-default branch" -ForegroundColor Red
Write-Host ""
foreach ($b in $blockedBranches) {
    Write-Host "  - $b (default branch is '$defaultBranch')" -ForegroundColor Red
}
Write-Host ""
Write-Host "ROUTING.md Hard Constraints: work directly on '$defaultBranch' by default." -ForegroundColor Yellow
Write-Host "Branching is fine when the human explicitly asked for one, or there is a" -ForegroundColor Yellow
Write-Host "specific, stated reason for needing isolation — state the reason, then use" -ForegroundColor Yellow
Write-Host "'git push --no-verify' deliberately. That bypass is visible in the push" -ForegroundColor Yellow
Write-Host "process, not silent." -ForegroundColor Yellow
Write-Host ""
exit 1
