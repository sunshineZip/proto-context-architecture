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
foreach ($file in @("operating-principles.md", "turn-protocol.md", "routing-rules.md", "project-types.md", "upstream-sync.md")) {
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
$retiredProjects = @()

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
        } elseif ($todoText -match '(?mi)^Version\s+.+\|\s+\d{4}-\d{2}-\d{2}\s+\|\s+Retired\s*$') {
            $retiredProjects += $projectDir.Name
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

# --- Shared helper: parse a minimal YAML frontmatter block (key: value
#     pairs only, no nesting) from the very start of a file. Anchored to
#     the true start of the string so a document's own "---" section
#     separators are never mistaken for a frontmatter delimiter. ---
function Get-Frontmatter {
    param([string]$Text)
    $result = @{}
    $m = [regex]::Match($Text, '\A---\r?\n(.*?)\r?\n---\r?\n', 'Singleline')
    if (-not $m.Success) { return $result }
    foreach ($line in ($m.Groups[1].Value -split "`r?`n")) {
        $kv = [regex]::Match($line, '^([a-zA-Z0-9_-]+):\s*(.+?)\s*$')
        if ($kv.Success) {
            $result[$kv.Groups[1].Value] = $kv.Groups[2].Value
        }
    }
    return $result
}

# --- Shared helper: extract the Status field from a file's standard header
#     line ("Version X.Y | YYYY-MM-DD | Status"), used by the retirement
#     consistency checks below. See MarkdownConventions.md §1. ---
function Get-HeaderStatus {
    param([string]$Text)
    $m = [regex]::Match($Text, '(?m)^Version\s+[\d.]+\s*\|\s*\d{4}-\d{2}-\d{2}\s*\|\s*(.+?)\s*$')
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

# --- Frontmatter: domain files ---
# See MarkdownConventions.md §1 (Frontmatter).
foreach ($domainDir in $domainDirs) {
    foreach ($fileName in @("description.md", "knowledge.md")) {
        $filePath = Join-Path $domainDir.FullName $fileName
        if (-not (Test-Path $filePath)) { continue }

        $fm = Get-Frontmatter -Text (Get-Content -Path $filePath -Raw)
        if ($fm.Count -eq 0) {
            Add-ValidationError "'$($domainDir.Name)/$fileName' is missing frontmatter (expected type: domain, domain: $($domainDir.Name))"
            continue
        }
        if ($fm['type'] -ne 'domain') {
            Add-ValidationError "'$($domainDir.Name)/$fileName' frontmatter has type: $($fm['type']), expected 'domain'"
        }
        if ($fm['domain'] -ne $domainDir.Name) {
            Add-ValidationError "'$($domainDir.Name)/$fileName' frontmatter has domain: $($fm['domain']), expected '$($domainDir.Name)' (folder name mismatch)"
        }
    }

    $sourcesManifestPath = Join-Path (Join-Path $domainDir.FullName "sources") "manifest.md"
    if (Test-Path $sourcesManifestPath) {
        $fm = Get-Frontmatter -Text (Get-Content -Path $sourcesManifestPath -Raw)
        if ($fm.Count -eq 0) {
            Add-ValidationError "'$($domainDir.Name)/sources/manifest.md' is missing frontmatter (expected type: source-manifest, domain: $($domainDir.Name))"
        } else {
            if ($fm['type'] -ne 'source-manifest') {
                Add-ValidationError "'$($domainDir.Name)/sources/manifest.md' frontmatter has type: $($fm['type']), expected 'source-manifest'"
            }
            if ($fm['domain'] -ne $domainDir.Name) {
                Add-ValidationError "'$($domainDir.Name)/sources/manifest.md' frontmatter has domain: $($fm['domain']), expected '$($domainDir.Name)' (folder name mismatch)"
            }
        }
    }
}

# --- Frontmatter: project files ---
foreach ($projectDir in $projectDirs) {
    foreach ($fileName in @("TODO.md", "session-log.md")) {
        $filePath = Join-Path $projectDir.FullName $fileName
        if (-not (Test-Path $filePath)) { continue }

        $fm = Get-Frontmatter -Text (Get-Content -Path $filePath -Raw)
        if ($fm.Count -eq 0) {
            Add-ValidationError "'$($projectDir.Name)/$fileName' is missing frontmatter (expected type: project, project: $($projectDir.Name))"
            continue
        }
        if ($fm['type'] -ne 'project') {
            Add-ValidationError "'$($projectDir.Name)/$fileName' frontmatter has type: $($fm['type']), expected 'project'"
        }
        if ($fm['project'] -ne $projectDir.Name) {
            Add-ValidationError "'$($projectDir.Name)/$fileName' frontmatter has project: $($fm['project']), expected '$($projectDir.Name)' (folder name mismatch)"
        }
    }
}

# --- Retirement: domain Status consistency (description.md vs knowledge.md vs
#     index.md's Status column). See MarkdownConventions.md §1 and
#     knowledge/domains/index.md § Retiring a Domain. Only the Retired/
#     not-Retired distinction is compared — the three non-retired values
#     (Draft, Review Pending, Production) are legitimately independent of
#     each other and not what this check is for. ---
$indexDomainStatus = @{}
$indexPath = Join-Path $domainsPath "index.md"
if (Test-Path $indexPath) {
    $indexText = Remove-CodeFences -Text (Get-Content -Path $indexPath -Raw)
    foreach ($line in ($indexText -split "`r?`n")) {
        $trimmed = $line.Trim()
        if (-not $trimmed.StartsWith("|")) { continue }
        $cells = $trimmed.Trim('|') -split '\|' | ForEach-Object { $_.Trim() }
        if ($cells.Count -lt 3) { continue }
        $slugMatch = [regex]::Match($cells[1], 'knowledge/domains/([a-zA-Z0-9_-]+)/?')
        if (-not $slugMatch.Success) { continue }
        $indexDomainStatus[$slugMatch.Groups[1].Value] = $cells[2]
    }
}

foreach ($domainDir in $domainDirs) {
    $descPath = Join-Path $domainDir.FullName "description.md"
    $knowledgeFilePath = Join-Path $domainDir.FullName "knowledge.md"
    $descStatus = $null
    $knowledgeStatus = $null
    if (Test-Path $descPath) { $descStatus = Get-HeaderStatus -Text (Get-Content -Path $descPath -Raw) }
    if (Test-Path $knowledgeFilePath) { $knowledgeStatus = Get-HeaderStatus -Text (Get-Content -Path $knowledgeFilePath -Raw) }

    $descRetired = ($descStatus -eq "Retired")
    $knowledgeRetired = ($knowledgeStatus -eq "Retired")
    if ($descStatus -and $knowledgeStatus -and ($descRetired -ne $knowledgeRetired)) {
        Add-ValidationWarning "Domain '$($domainDir.Name)': description.md status is '$descStatus' but knowledge.md status is '$knowledgeStatus' — retirement status should match across both files"
    }

    if ($indexDomainStatus.ContainsKey($domainDir.Name)) {
        $indexStatus = $indexDomainStatus[$domainDir.Name]
        $indexRetired = ($indexStatus -eq "Retired")
        $filesRetired = $descRetired -or $knowledgeRetired
        if ($indexRetired -and -not $filesRetired) {
            Add-ValidationWarning "Domain '$($domainDir.Name)': index.md lists Status 'Retired' but description.md/knowledge.md do not — update the files or revert the index"
        } elseif ($filesRetired -and -not $indexRetired) {
            Add-ValidationWarning "Domain '$($domainDir.Name)': description.md/knowledge.md status is 'Retired' but index.md still lists Status '$indexStatus' — update the index"
        }
    }
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

# --- Cross-domain reference reciprocity (warning only) ---
# See knowledge/domains/authoring-guidelines.md §5 and §8. Ground truth is
# the actual links inside each domain's own files, not index.md's prose
# References column — that column is a human-authored summary and could
# itself drift from the real links.
$domainNames = $domainDirs | ForEach-Object { $_.Name }
$domainLinkMap = @{}

foreach ($domainDir in $domainDirs) {
    $linkedDomains = New-Object System.Collections.Generic.HashSet[string]
    foreach ($fileName in @("description.md", "knowledge.md")) {
        $filePath = Join-Path $domainDir.FullName $fileName
        if (-not (Test-Path $filePath)) { continue }
        $text = Remove-CodeFences -Text (Get-Content -Path $filePath -Raw)

        $siblingMatches = [regex]::Matches($text, '\]\(\.\./([a-zA-Z0-9_-]+)/')
        foreach ($m in $siblingMatches) {
            $target = $m.Groups[1].Value
            if ($target -ne $domainDir.Name -and ($domainNames -contains $target)) {
                [void]$linkedDomains.Add($target)
            }
        }
    }
    $domainLinkMap[$domainDir.Name] = $linkedDomains
}

foreach ($from in $domainLinkMap.Keys) {
    foreach ($to in $domainLinkMap[$from]) {
        $backLinked = $domainLinkMap.ContainsKey($to) -and $domainLinkMap[$to].Contains($from)
        if (-not $backLinked) {
            Add-ValidationWarning "'$from' links to '$to', but '$to' does not link back to '$from' (one-directional cross-reference — confirm this is intentional, see authoring-guidelines.md §5)"
        }
    }
}

# --- Retirement: a Retired project should not still have a live routing row
#     in ROUTING.md Step 2 — see ROUTING.md's Retirement note under Step 2. ---
$routingPath = Join-Path $repoRoot "ROUTING.md"
$step2ProjectNames = @()
if (Test-Path $routingPath) {
    $routingText = Get-Content -Path $routingPath -Raw
    $step2Match = [regex]::Match($routingText, '(?s)### Step 2.*?(?=### Step 3)')
    if ($step2Match.Success) {
        $step2Text = Remove-CodeFences -Text $step2Match.Value
        foreach ($line in ($step2Text -split "`r?`n")) {
            $trimmed = $line.Trim()
            if (-not $trimmed.StartsWith("|")) { continue }
            $cells = $trimmed.Trim('|') -split '\|' | ForEach-Object { $_.Trim() }
            if ($cells.Count -lt 2) { continue }
            $projectCell = $cells[1]
            if ($projectCell -eq "" -or $projectCell -eq "Project" -or $projectCell -match '^-+$') { continue }
            $step2ProjectNames += ($projectCell.ToLower() -replace '\s+', '-')
        }
    }
}

foreach ($name in $retiredProjects) {
    if ($step2ProjectNames -contains $name.ToLower()) {
        Add-ValidationWarning "Project '$name' is marked Retired but still has a routing row in ROUTING.md Step 2 — remove the row so new work isn't routed there"
    }
}

# --- Summary ---
Write-Host ""
Write-Host "Active projects: $($activeProjects.Count)"
foreach ($p in $activeProjects) {
    Write-Host "  - $p"
}

if ($retiredProjects.Count -gt 0) {
    Write-Host ""
    Write-Host "Retired projects: $($retiredProjects.Count)"
    foreach ($p in $retiredProjects) {
        Write-Host "  - $p"
    }
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
