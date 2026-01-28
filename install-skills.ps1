# Install AI Code Review prompts as Claude Code skills

$SkillsDir = "$env:USERPROFILE\.claude\skills"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PromptsDir = Join-Path $ScriptDir "prompts"

Write-Host "Installing AI Code Review skills to $SkillsDir..."

# Create skills directory if it doesn't exist
if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

# Install each prompt as a skill
Get-ChildItem -Path $PromptsDir -Filter "*.md" | ForEach-Object {
    $filename = $_.BaseName
    $skillDir = Join-Path $SkillsDir $filename

    Write-Host "  Installing $filename..."
    if (-not (Test-Path $skillDir)) {
        New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
    }
    Copy-Item $_.FullName -Destination (Join-Path $skillDir "SKILL.md") -Force
}

Write-Host ""
Write-Host "Done! Installed skills:"
Get-ChildItem -Path $SkillsDir -Directory | Where-Object { $_.Name -match "^layer[0-3]" } | ForEach-Object { Write-Host "  $($_.Name)" }
Write-Host ""
Write-Host "Usage: /layer1-quick-review, /layer2-security-specialist, etc."
