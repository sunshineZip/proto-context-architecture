[CmdletBinding()]
param()

# Invoked by .githooks/pre-commit (requires `git config core.hooksPath
# .githooks` — see Architecture.md §6). Blocks a commit that stages a
# system-layer file without also staging projects/system/session-log.md
# in the same commit — operationalizes the ROUTING.md Hard Constraint
# "do not make structural system changes without logging them" instead
# of relying on the model to remember it.
#
# If you're testing this hook's block/pass behaviour (e.g. while porting
# it to a fork): a blocked `git commit` creates no new commit. A fork's
# sync session once ran an unconditional `git reset --soft HEAD~1` right
# after a blocked, no-op commit attempt, assuming the attempt had
# succeeded — it hadn't, so HEAD~1 was one commit further back than
# expected, and a real, already-pushed commit got undone. Caught before
# anything bad was pushed by diffing against origin/<branch> rather than
# trusting local state, and recovered with `git reset --soft origin/main`.
# Before running any reset, verify whether the commit actually happened
# (check the exit code, or compare `git rev-parse HEAD` before and after)
# — never assume.

$repoRoot = (git rev-parse --show-toplevel 2>$null)
if (-not $repoRoot) {
    Write-Host "pre-commit: could not determine repo root, skipping check" -ForegroundColor Yellow
    exit 0
}

$stagedFiles = @(git -C $repoRoot diff --cached --name-only)
if ($stagedFiles.Count -eq 0) {
    exit 0
}

# --- System-layer tracked paths. Mirrors knowledge/flow/upstream-sync.md
#     §3's Tracked Paths list — if that list changes, update this too. ---
$systemLayerPatterns = @(
    '^ROUTING\.md$',
    '^Architecture\.md$',
    '^MarkdownConventions\.md$',
    '^README\.md$',
    '^\.github/copilot-instructions\.md$',
    '^knowledge/domains/authoring-guidelines\.md$',
    '^knowledge/flow/',
    '^scripts/',
    '^\.claude/',
    '^\.githooks/'
)

$sessionLogPath = "projects/system/session-log.md"
$touchedSystemFiles = @($stagedFiles | Where-Object {
    $file = $_
    $systemLayerPatterns | Where-Object { $file -match $_ } | Select-Object -First 1
})

if ($touchedSystemFiles.Count -eq 0) {
    exit 0
}

if ($stagedFiles -contains $sessionLogPath) {
    exit 0
}

Write-Host ""
Write-Host "COMMIT BLOCKED: system-layer file(s) staged without a matching entry in $sessionLogPath" -ForegroundColor Red
Write-Host ""
Write-Host "Files:" -ForegroundColor Red
foreach ($f in $touchedSystemFiles) { Write-Host "  - $f" -ForegroundColor Red }
Write-Host ""
Write-Host "ROUTING.md Hard Constraints: structural changes route through projects/system/" -ForegroundColor Yellow
Write-Host "and get recorded in session-log.md before committing. Stage a turn describing" -ForegroundColor Yellow
Write-Host "this change in $sessionLogPath and include it in this commit." -ForegroundColor Yellow
Write-Host ""
Write-Host "If this genuinely shouldn't require a log entry, use 'git commit --no-verify'" -ForegroundColor Yellow
Write-Host "deliberately — that bypass is visible in the commit process, not silent." -ForegroundColor Yellow
Write-Host ""
exit 1
