<#
.SYNOPSIS
Installs or updates the Craft System and Impeccable design skills in a website project.

.DESCRIPTION
- Copies AGENTS.md and craft/ (craft/ is replaced wholesale so updates arrive cleanly).
- Creates CLAUDE.md with "@AGENTS.md", or appends that line to an existing CLAUDE.md.
- Seeds design/ from templates ONLY for files that do not exist yet. Never overwrites design/.
- Installs Impeccable design skills & anti-pattern detection into the destination project.
- Seeds a default .gitignore if missing.

.EXAMPLE
.\install.ps1 -Destination C:\path\to\your-site
.\install.ps1 ..\my-new-site
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Destination
)

$ErrorActionPreference = "Stop"

$Src = $PSScriptRoot
if (-not (Test-Path $Destination -PathType Container)) {
    Write-Error "Destination folder does not exist: $Destination"
    exit 2
}

$DestPath = (Resolve-Path $Destination).Path
$SrcPath = (Resolve-Path $Src).Path

if ($DestPath -eq $SrcPath) {
    Write-Error "Run this against a website project, not the craft system folder itself."
    exit 2
}

# 1. Shared system (replace craft/ wholesale; it must never hold project-specific edits)
$DestCraft = Join-Path $DestPath "craft"
if (Test-Path $DestCraft) {
    Remove-Item -Recurse -Force $DestCraft
}
Copy-Item -Recurse -Force (Join-Path $SrcPath "craft") $DestCraft

# 2. Agent rules
$DestAgents = Join-Path $DestPath "AGENTS.md"
$SrcAgents = Join-Path $SrcPath "AGENTS.md"
if ((Test-Path $DestAgents) -and (-not (Select-String -Path $DestAgents -Pattern "Craft System" -Quiet))) {
    $Backup = Join-Path $DestPath "AGENTS.project-backup.md"
    Copy-Item -Force $DestAgents $Backup
    Write-Host "Existing AGENTS.md backed up to AGENTS.project-backup.md; merge any project rules into design/creative-brief.md."
}
Copy-Item -Force $SrcAgents $DestAgents

$DestClaude = Join-Path $DestPath "CLAUDE.md"
$SrcClaude = Join-Path $SrcPath "CLAUDE.md"
if (-not (Test-Path $DestClaude)) {
    Copy-Item -Force $SrcClaude $DestClaude
} else {
    $claudeContent = Get-Content $DestClaude -Raw
    if ($claudeContent -notmatch "(?m)^@AGENTS\.md$") {
        Add-Content -Path $DestClaude -Value "`n@AGENTS.md"
        Write-Host "Added @AGENTS.md import to existing CLAUDE.md."
    }
}

# 3. Project-specific files (seed once, never overwrite)
$DestDesign = Join-Path $DestPath "design"
if (-not (Test-Path $DestDesign)) {
    New-Item -ItemType Directory -Path $DestDesign | Out-Null
}

function Seed-File([string]$templateName, [string]$targetName) {
    $targetPath = Join-Path $DestDesign $targetName
    $srcTemplate = Join-Path $SrcPath "craft\templates\$templateName"
    if (-not (Test-Path $targetPath)) {
        Copy-Item -Force $srcTemplate $targetPath
    }
}

Seed-File "creative-brief.md" "creative-brief.md"
Seed-File "brand.example.md" "brand.md"
Seed-File "tokens.example.json" "tokens.json"
Seed-File "motion-spec.md" "motion-spec.md"
Seed-File "research-kit.md" "research-kit.md"

$DecisionsPath = Join-Path $DestDesign "DECISIONS.md"
if (-not (Test-Path $DecisionsPath)) {
    Set-Content -Path $DecisionsPath -Value "# Decisions log`n`n| Date | Decision | Alternatives rejected | Evidence | Known debt |`n|---|---|---|---|---|`n"
}

# 4. Impeccable design skills & anti-pattern engine
$npxCmd = Get-Command npx -ErrorAction SilentlyContinue
if ($npxCmd) {
    Write-Host "Installing Impeccable design skills into $DestPath..."
    try {
        Push-Location $DestPath
        npx -y impeccable install -y --project
        Pop-Location
    } catch {
        Write-Warning "npx impeccable install failed or timed out: $_"
        if ((Get-Location).Path -eq $DestPath) { Pop-Location }
    }
} else {
    Write-Host "Note: npx not found. Run 'npx impeccable install' once Node.js/npm is available."
}

# 5. Git ignore defaults (seed once if missing)
$DestGitignore = Join-Path $DestPath ".gitignore"
if (-not (Test-Path $DestGitignore)) {
    $gitignoreDefaults = @"
node_modules/
*.exe
**/skills/impeccable/scripts/bin/
design/qa-output/
*.log
"@
    Set-Content -Path $DestGitignore -Value $gitignoreDefaults
}

Write-Host "Craft System installed in $DestPath"
Write-Host "Next: fill design/creative-brief.md (locks go under 'Existing features that must not change'),"
Write-Host "replace the example brand.md and tokens.json, then: python3 craft/qa/validate_tokens.py design/tokens.json"
