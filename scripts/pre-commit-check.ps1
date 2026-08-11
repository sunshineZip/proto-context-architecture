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

# --- Secret-pattern scan (staged additions only). Deliberately narrow: ---
#     matches recognizable token/key SHAPES (a stable prefix or delimiter),
#     not free-form heuristics like a bare "password=" or entropy scoring —
#     narrow keeps false positives low enough that this can safely block
#     rather than warn. This is a mechanical backstop for the ROUTING.md
#     Hard Constraint requiring a pause-and-ask before writing a secret or
#     confidential detail into any tracked file — it catches what slips
#     past that judgment call, it does not replace it. See
#     projects/system/session-log.md Turn 18.
$secretPatterns = @(
    @{ Name = 'AWS Access Key ID';      Regex = 'AKIA[0-9A-Z]{16}' }
    @{ Name = 'GitHub token';           Regex = 'gh[pousr]_[A-Za-z0-9]{36,}' }
    @{ Name = 'Slack token';            Regex = 'xox[baprs]-[A-Za-z0-9-]{10,}' }
    @{ Name = 'Stripe live secret key'; Regex = 'sk_live_[A-Za-z0-9]{24,}' }
    @{ Name = 'Private key block';      Regex = '-----BEGIN (RSA |EC |OPENSSH |DSA |PGP )?PRIVATE KEY-----' }
    @{ Name = 'Generic bearer token';   Regex = '(?i)bearer\s+[A-Za-z0-9\-_\.=]{20,}' }
)

$secretHits = @()
foreach ($file in $stagedFiles) {
    $diff = @(git -C $repoRoot diff --cached -U0 -- $file 2>$null)
    if ($diff.Count -eq 0) { continue }
    if ($diff -match 'Binary files .* differ') { continue }
    foreach ($line in $diff) {
        if ($line -match '^\+\+\+') { continue }
        if ($line -notmatch '^\+') { continue }
        $content = $line.Substring(1)
        if ($content -match 'pragma:\s*allowlist secret') { continue }
        foreach ($pattern in $secretPatterns) {
            if ($content -match $pattern.Regex) {
                $secretHits += [PSCustomObject]@{ File = $file; Pattern = $pattern.Name }
            }
        }
    }
}

if ($secretHits.Count -gt 0) {
    Write-Host ""
    Write-Host "COMMIT BLOCKED: possible secret detected in staged changes" -ForegroundColor Red
    Write-Host ""
    foreach ($hit in $secretHits) {
        Write-Host "  - $($hit.File)  [$($hit.Pattern)]" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "If real: rotate/revoke the credential first, then remove it from the staged" -ForegroundColor Yellow
    Write-Host "change entirely (and from history too, if it was ever committed before)." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "If this is a false positive (a placeholder, an already-revoked example key)," -ForegroundColor Yellow
    Write-Host "add 'pragma: allowlist secret' on the same line, or use 'git commit --no-verify'" -ForegroundColor Yellow
    Write-Host "deliberately — that bypass is visible in the commit process, not silent." -ForegroundColor Yellow
    Write-Host ""
    exit 1
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
