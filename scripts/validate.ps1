[CmdletBinding()]
param(
    [switch]$Strict
)

$ErrorCount = 0
$WarningCount = 0

function Add-ValidationError {
    param([string]$Message)
    $script:ErrorCount++
    Write-Host "ERROR: $Message" -ForegroundColor Red
}

function Add-ValidationWarning {
    param([string]$Message)
    $script:WarningCount++
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$projectsPath = Join-Path $repoRoot "projects"
$knowledgePath = Join-Path $repoRoot "knowledge"
$copilotInstructionsPath = Join-Path $repoRoot ".github\copilot-instructions.md"

Write-Host "Context Architecture - Repo Validation"
Write-Host "Root: $repoRoot"
Write-Host ""

# --- Required root files ---
foreach ($file in @("README.md", "Architecture.md", "MarkdownConventions.md")) {
    if (-not (Test-Path (Join-Path $repoRoot $file))) {
        Add-ValidationError "Missing root file: $file"
    }
}

if (-not (Test-Path $copilotInstructionsPath)) {
    Add-ValidationError "Missing entry point: .github\copilot-instructions.md"
}

# --- knowledge/flow/ ---
$flowPath = Join-Path $knowledgePath "flow"
foreach ($file in @("operating-principles.md", "turn-protocol.md", "routing-rules.md", "project-types.md")) {
    if (-not (Test-Path (Join-Path $flowPath $file))) {
        Add-ValidationError "Missing knowledge/flow file: $file"
    }
}

# --- knowledge/domains/ ---
$domainsPath = Join-Path $knowledgePath "domains"
if (-not (Test-Path (Join-Path $domainsPath "index.md"))) {
    Add-ValidationError "Missing knowledge/domains/index.md"
}
if (-not (Test-Path (Join-Path $domainsPath "authoring-guidelines.md"))) {
    Add-ValidationWarning "Missing knowledge/domains/authoring-guidelines.md"
}

$domainDirs = Get-ChildItem -Path $domainsPath -Directory -ErrorAction SilentlyContinue
foreach ($domainDir in $domainDirs) {
    $descPath = Join-Path $domainDir.FullName "description.md"
    $knowledgeFilePath = Join-Path $domainDir.FullName "knowledge.md"
    if (-not (Test-Path $descPath)) {
        Add-ValidationWarning "Domain '$($domainDir.Name)' is missing description.md"
    }
    if (-not (Test-Path $knowledgeFilePath)) {
        Add-ValidationWarning "Domain '$($domainDir.Name)' is missing knowledge.md"
    }
}

# --- projects/ ---
if (-not (Test-Path $projectsPath)) {
    Add-ValidationError "Missing projects folder"
}

$projectDirs = Get-ChildItem -Path $projectsPath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "_template" }
$activeProjects = @()

foreach ($projectDir in $projectDirs) {
    $todoPath = Join-Path $projectDir.FullName "TODO.md"
    $sessionLogPath = Join-Path $projectDir.FullName "session-log.md"

    if (-not (Test-Path $todoPath)) {
        Add-ValidationWarning "Project '$($projectDir.Name)' is missing TODO.md"
    }
    if (-not (Test-Path $sessionLogPath)) {
        Add-ValidationWarning "Project '$($projectDir.Name)' is missing session-log.md"
    }

    if (Test-Path $todoPath) {
        $todoText = Get-Content -Path $todoPath -Raw
        if ($todoText -match '(?mi)^Version\s+.+\|\s+\d{4}-\d{2}-\d{2}\s+\|\s+Active\s*$') {
            $activeProjects += $projectDir.Name
        }
    }
}

# --- Summary ---
Write-Host ""
Write-Host "Active projects: $($activeProjects.Count)"
foreach ($p in $activeProjects) {
    Write-Host "  - $p"
}

Write-Host ""
if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "Validation passed - no issues found." -ForegroundColor Green
} elseif ($ErrorCount -eq 0) {
    Write-Host ("Validation passed with " + $WarningCount + " warning(s).") -ForegroundColor Yellow
} else {
    Write-Host ("Validation failed: " + $ErrorCount + " error(s), " + $WarningCount + " warning(s).") -ForegroundColor Red
    exit 1
}
