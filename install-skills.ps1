# Install AI Code Review prompts as Claude Code skills

$SkillsDir = "$env:USERPROFILE\.claude\skills"
$ClaudeDir = "$env:USERPROFILE\.claude"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PromptsDir = Join-Path $ScriptDir "prompts"
$TemplateFile = Join-Path $ScriptDir "claude-code\CLAUDE.md.template"

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

# Install Layer 0 as global CLAUDE.md (auto-loads every session)
$GlobalClaudeMd = Join-Path $ClaudeDir "CLAUDE.md"
if (Test-Path $TemplateFile) {
    if (Test-Path $GlobalClaudeMd) {
        # Check if guidelines already present
        $existingContent = Get-Content $GlobalClaudeMd -Raw -ErrorAction SilentlyContinue
        if ($existingContent -match "Code Generation Guidelines") {
            Write-Host "  CLAUDE.md already contains generation guidelines (skipped)"
        } else {
            Write-Host ""
            Write-Host "Found existing $GlobalClaudeMd"
            $response = Read-Host "Append Layer 0 generation guidelines to existing file? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                $templateContent = Get-Content $TemplateFile -Raw
                Add-Content -Path $GlobalClaudeMd -Value "`n---`n"
                Add-Content -Path $GlobalClaudeMd -Value $templateContent
                Write-Host "  Appended generation guidelines to CLAUDE.md"
            } else {
                Write-Host "  Skipped CLAUDE.md (keeping existing)"
            }
        }
    } else {
        Copy-Item $TemplateFile -Destination $GlobalClaudeMd -Force
        Write-Host "  Installed CLAUDE.md (Layer 0 auto-loads every session)"
    }
}

Write-Host ""
Write-Host "Done! Installed skills:"
Get-ChildItem -Path $SkillsDir -Directory | Where-Object { $_.Name -match "^layer[0-3]" } | ForEach-Object { Write-Host "  $($_.Name)" }
Write-Host ""
Write-Host "Usage: /layer1-quick-review, /layer2-security-specialist, etc."
Write-Host ""
Write-Host "Layer 0 (generation guidelines) now loads automatically every session via ~/.claude/CLAUDE.md"
