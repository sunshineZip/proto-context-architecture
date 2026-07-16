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
$libraryPath = Join-Path $repoRoot "library"
$copilotInstructionsPath = Join-Path $repoRoot ".github\copilot-instructions.md"

Write-Host "Context Architecture - Repo Validation"
Write-Host "Root: $repoRoot"
Write-Host ""

# --- Required root files ---
foreach ($file in @("README.md", "ROUTING.md", "Architecture.md", "MarkdownConventions.md")) {
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

# --- Shared helper: strip fenced code blocks before scanning prose for
#     headings/fields/links, so a documentation *example* embedded in a
#     ``` fence (e.g. the template block in library/reference-index.md
#     itself) is never mistaken for a real entry or a real citation. ---
function Remove-CodeFences {
    param([string]$Text)
    return [regex]::Replace($Text, '(?s)```.*?```', '')
}

# --- knowledge/domains/*/sources/ — evidentiary source manifests ---
# See knowledge/domains/authoring-guidelines.md §9.1.
function Get-ManifestTableFirstColumn {
    param([string]$Text)
    $values = @()
    foreach ($line in ($Text -split "`r?`n")) {
        $trimmed = $line.Trim()
        if (-not $trimmed.StartsWith("|")) { continue }
        $cells = $trimmed.Trim('|') -split '\|' | ForEach-Object { $_.Trim() }
        if ($cells.Count -eq 0) { continue }
        $first = $cells[0]
        if ($first -eq "" -or $first -eq "File" -or $first -match '^-+$') { continue }
        $values += $first
    }
    return $values
}

foreach ($domainDir in $domainDirs) {
    $sourcesPath = Join-Path $domainDir.FullName "sources"
    if (-not (Test-Path $sourcesPath)) { continue }

    $manifestPath = Join-Path $sourcesPath "manifest.md"
    if (-not (Test-Path $manifestPath)) {
        Add-ValidationError "Domain '$($domainDir.Name)' has a sources/ folder but no sources/manifest.md"
        continue
    }

    $manifestText = Remove-CodeFences -Text (Get-Content -Path $manifestPath -Raw)
    $manifestFiles = Get-ManifestTableFirstColumn -Text $manifestText

    $actualFiles = Get-ChildItem -Path $sourcesPath -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne "manifest.md" } |
        Select-Object -ExpandProperty Name

    foreach ($mf in $manifestFiles) {
        if ($actualFiles -notcontains $mf) {
            Add-ValidationError "'$($domainDir.Name)/sources/manifest.md' lists '$mf' but that file does not exist in sources/"
        }
    }
    foreach ($af in $actualFiles) {
        if ($manifestFiles -notcontains $af) {
            Add-ValidationWarning "'$($domainDir.Name)/sources/$af' exists but is not listed in manifest.md (orphan source file)"
        }
    }
}

# --- library/ — deep-well registry vs. stored files ---
# See knowledge/domains/authoring-guidelines.md §9.2-9.3.
$refIndexPath = Join-Path $libraryPath "reference-index.md"
$deepWellsPath = Join-Path $libraryPath "deep-wells"
$storedLocations = @()

if (Test-Path $refIndexPath) {
    $refText = Remove-CodeFences -Text (Get-Content -Path $refIndexPath -Raw)
    $entryBlocks = [regex]::Split($refText, '(?m)^## ')

    foreach ($block in $entryBlocks) {
        if ($block.Trim() -eq "") { continue }
        $slugLine = ($block -split "`r?`n")[0].Trim()
        if ($slugLine -eq "") { continue }

        $storedMatch = [regex]::Match($block, '(?mi)^\s*-\s*\*\*Stored:\*\*\s*(yes|no)')
        if (-not $storedMatch.Success) { continue }

        if ($storedMatch.Groups[1].Value.ToLower() -eq "yes") {
            $locationMatch = [regex]::Match($block, '(?m)^\s*-\s*\*\*Location:\*\*\s*(\S+)')
            if (-not $locationMatch.Success) {
                Add-ValidationError "library/reference-index.md entry '$slugLine' is Stored: yes but has no Location field"
                continue
            }
            $location = $locationMatch.Groups[1].Value
            $storedLocations += $location
            $fullPath = Join-Path $repoRoot $location
            if (-not (Test-Path $fullPath)) {
                Add-ValidationError "library/reference-index.md entry '$slugLine' points Location at '$location', which does not exist"
            }
        }
    }

    if (Test-Path $deepWellsPath) {
        $actualDeepWellFiles = Get-ChildItem -Path $deepWellsPath -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notlike "*-manifest.md" } |
            ForEach-Object { "library/deep-wells/$($_.Name)" }

        foreach ($f in $actualDeepWellFiles) {
            if ($storedLocations -notcontains $f) {
                Add-ValidationWarning "'$f' exists in library/deep-wells/ but no reference-index.md entry claims it via Location (orphan deep-well file)"
            }
        }
    }
} elseif (Test-Path $deepWellsPath) {
    Add-ValidationError "library/deep-wells/ exists but library/reference-index.md is missing"
}

# --- Referential integrity: links from domain files into sources/ or library/reference-index.md ---
$refIndexHeadings = @()
if (Test-Path $refIndexPath) {
    $refText = Remove-CodeFences -Text (Get-Content -Path $refIndexPath -Raw)
    $refIndexHeadings = [regex]::Matches($refText, '(?m)^## (.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() }
}

foreach ($domainDir in $domainDirs) {
    foreach ($fileName in @("knowledge.md", "description.md")) {
        $filePath = Join-Path $domainDir.FullName $fileName
        if (-not (Test-Path $filePath)) { continue }
        $text = Remove-CodeFences -Text (Get-Content -Path $filePath -Raw)

        $linkMatches = [regex]::Matches($text, '\]\(([^)]+)\)')
        foreach ($m in $linkMatches) {
            $target = $m.Groups[1].Value
            $anchor = $null
            if ($target -match '^(.*?)(#[^#]*)$') {
                $target = $Matches[1]
                $anchor = $Matches[2]
            }
            if ($target -notmatch '^(sources/|(\.\./){3}library/)') { continue }

            $resolvedPath = [System.IO.Path]::GetFullPath((Join-Path $domainDir.FullName $target))
            if (-not (Test-Path $resolvedPath)) {
                Add-ValidationError "'$($domainDir.Name)/$fileName' links to '$target', which does not resolve to a real file"
                continue
            }
            if ($anchor -and $target -like "*reference-index.md") {
                $slug = $anchor.TrimStart('#')
                if ($refIndexHeadings -notcontains $slug) {
                    Add-ValidationWarning "'$($domainDir.Name)/$fileName' links to reference-index.md#$slug, which has no matching '## $slug' heading"
                }
            }
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
