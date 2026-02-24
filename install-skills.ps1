# Code Review Skills v2.0 Installer for Windows
# Supports custom Claude skills directories

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Code Review Skills v2.0 - Claude Code Installer" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Function to test if a directory exists and has skills
function Test-SkillsDirectory {
    param([string]$Path)
    if (Test-Path $Path) {
        $skillCount = (Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
        return $skillCount -gt 0
    }
    return $false
}

# Common skill locations to check
$defaultPath = "$env:USERPROFILE\.claude\skills"
$drivePath = "D:\.claude\skills"
$commonPaths = @($defaultPath, $drivePath)

# Detect existing skills installation
$detectedPath = $null
foreach ($path in $commonPaths) {
    if (Test-SkillsDirectory $path) {
        $detectedPath = $path
        Write-Host "Found existing skills in: $path" -ForegroundColor Green
        break
    }
}

# Ask user where to install
Write-Host ""
Write-Host "Where would you like to install Code Review Skills v2.0?" -ForegroundColor Yellow
Write-Host ""

if ($detectedPath) {
    Write-Host "1. Use existing location: $detectedPath (Recommended)" -ForegroundColor White
} else {
    Write-Host "1. Default location: $defaultPath (Recommended)" -ForegroundColor White
}

Write-Host "2. D:\.claude\skills" -ForegroundColor White
Write-Host "3. Custom location (you specify)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" {
        if ($detectedPath) {
            $skillsDir = $detectedPath
        } else {
            $skillsDir = $defaultPath
        }
    }
    "2" {
        $skillsDir = "D:\.claude\skills"
    }
    "3" {
        $customPath = Read-Host "Enter full path to your Claude skills directory"
        $skillsDir = $customPath
    }
    default {
        Write-Host "Invalid choice. Using default: $defaultPath" -ForegroundColor Yellow
        $skillsDir = $defaultPath
    }
}

Write-Host ""
Write-Host "Installing to: $skillsDir" -ForegroundColor Cyan
Write-Host ""

# Create directory if it doesn't exist
New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null

# Check for and remove old v1.0 skills
Write-Host "Checking for old v1.0 skills..." -ForegroundColor Yellow

$v1Skills = @(
    "layer0-generation-guidelines",
    "layer1-quick-review",
    "layer2-correctness-specialist",
    "layer2-data-integrity-specialist",
    "layer2-maintainability-specialist",
    "layer2-performance-specialist",
    "layer2-security-specialist",
    "layer3-verification"
)

$foundV1Skills = @()
foreach ($oldSkill in $v1Skills) {
    $oldPath = Join-Path $skillsDir $oldSkill
    if (Test-Path $oldPath) {
        $foundV1Skills += $oldSkill
    }
}

if ($foundV1Skills.Count -gt 0) {
    Write-Host ""
    Write-Host "Found $($foundV1Skills.Count) old v1.0 skills:" -ForegroundColor Yellow
    foreach ($skill in $foundV1Skills) {
        Write-Host "  - $skill" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "These will be replaced by v2.0 equivalents." -ForegroundColor Yellow
    $confirm = Read-Host "Remove old v1.0 skills? (Y/N)"
    
    if ($confirm -eq "Y" -or $confirm -eq "y") {
        foreach ($oldSkill in $foundV1Skills) {
            $oldPath = Join-Path $skillsDir $oldSkill
            Write-Host "  Removing: $oldSkill" -ForegroundColor Gray
            Remove-Item -Recurse -Force $oldPath
        }
        Write-Host "Removed $($foundV1Skills.Count) old v1.0 skills" -ForegroundColor Green
    } else {
        Write-Host "Skipped removal. Old v1.0 skills will remain alongside v2.0." -ForegroundColor Yellow
    }
} else {
    Write-Host "No old v1.0 skills found" -ForegroundColor Green
}
Write-Host ""

# Check if prompts directory exists
if (-not (Test-Path "prompts")) {
    Write-Host "Error: 'prompts' folder not found!" -ForegroundColor Red
    Write-Host "Make sure you're running this from the ai-code-review-prompts directory" -ForegroundColor Red
    exit 1
}

# Install skills from layer group folders
$installedCount = 0
$skillDirs = Get-ChildItem -Path "prompts\layer*\layer*" -Directory -ErrorAction SilentlyContinue

foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $skillName = $skillDir.Name
        Write-Host "  Installing $skillName..." -ForegroundColor Cyan
        
        $targetDir = Join-Path $skillsDir $skillName
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item $skillFile -Destination $targetDir -Force
        $installedCount++
    }
}

# Install skills from layer root folders
$rootSkills = Get-ChildItem -Path "prompts\layer*-*" -Directory -ErrorAction SilentlyContinue

foreach ($skillDir in $rootSkills) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $skillName = $skillDir.Name
        Write-Host "  Installing $skillName..." -ForegroundColor Cyan
        
        $targetDir = Join-Path $skillsDir $skillName
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item $skillFile -Destination $targetDir -Force
        $installedCount++
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installed: $installedCount skills" -ForegroundColor White
Write-Host "Location: $skillsDir" -ForegroundColor White
Write-Host ""
Write-Host "Usage in Claude Code:" -ForegroundColor Yellow
Write-Host "   /layer0-prevention          - Prevention guidelines" -ForegroundColor White
Write-Host "   /layer1-planning            - Review planning" -ForegroundColor White
Write-Host "   /layer2a-quick-review       - Quick review" -ForegroundColor White
Write-Host "   /layer2c-security-specialist - Security deep dive" -ForegroundColor White
Write-Host ""
Write-Host "Full documentation: prompts\README.md" -ForegroundColor Cyan
Write-Host ""

# Offer to save config
Write-Host "Save this location for future updates? (Y/N)" -ForegroundColor Yellow
$saveConfig = Read-Host

if ($saveConfig -eq "Y" -or $saveConfig -eq "y") {
    $configFile = Join-Path (Get-Location) "claude-skills-config.txt"
    $configContent = "SKILLS_DIR=$skillsDir"
    $configContent | Out-File -FilePath $configFile -Encoding UTF8 -Force
    Write-Host "Saved to claude-skills-config.txt" -ForegroundColor Green
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
