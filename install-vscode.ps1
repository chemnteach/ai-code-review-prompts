# Install AI Code Review prompts as VS Code snippets (full-length versions)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PromptsDir = Join-Path $ScriptDir "prompts"

# Determine VS Code snippets directory
$VsCodeSnippets = "$env:APPDATA\Code\User\snippets"

Write-Host "Installing AI Code Review snippets to: $VsCodeSnippets"

if (-not (Test-Path $VsCodeSnippets)) {
    New-Item -ItemType Directory -Path $VsCodeSnippets -Force | Out-Null
}

# Function to escape JSON string content
function Escape-JsonString {
    param([string]$text)
    $text = $text -replace '\\', '\\'
    $text = $text -replace '"', '\"'
    $text = $text -replace '\$', '\$'
    return $text
}

# Function to convert markdown file to snippet body array
function ConvertTo-SnippetBody {
    param([string]$FilePath)

    $lines = Get-Content $FilePath -Encoding UTF8
    $result = @()
    $inFrontmatter = $false
    $pastFrontmatter = $false

    foreach ($line in $lines) {
        if ($line -eq "---" -and -not $pastFrontmatter) {
            if (-not $inFrontmatter) {
                $inFrontmatter = $true
                continue
            } else {
                $inFrontmatter = $false
                $pastFrontmatter = $true
                continue
            }
        }

        if ($inFrontmatter) { continue }

        $escaped = Escape-JsonString $line
        $result += "      `"$escaped`""
    }

    return $result -join ",`n"
}

# Build the snippets file
$snippetsContent = @"
{
  "Generation Guidelines (Full)": {
    "prefix": "review-gen",
    "description": "Layer 0: Prevention guidelines - paste at session start",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer0-generation-guidelines.md"))
    ]
  },
  "Quick Review (Full)": {
    "prefix": "review-quick",
    "description": "Layer 1: Comprehensive review catching 80%+ of issues",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer1-quick-review.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Security Specialist (Full)": {
    "prefix": "review-security",
    "description": "Layer 2: Deep security analysis - injection, auth, crypto, etc.",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer2-security-specialist.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Correctness Specialist (Full)": {
    "prefix": "review-correctness",
    "description": "Layer 2: Logic errors, edge cases, race conditions",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer2-correctness-specialist.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Maintainability Specialist (Full)": {
    "prefix": "review-maint",
    "description": "Layer 2: Readability, complexity, debuggability",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer2-maintainability-specialist.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Performance Specialist (Full)": {
    "prefix": "review-perf",
    "description": "Layer 2: N+1 queries, O(n²), memory leaks, scalability",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer2-performance-specialist.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Data Integrity Specialist (Full)": {
    "prefix": "review-data",
    "description": "Layer 2: Validation, transactions, encoding, consistency",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer2-data-integrity-specialist.md")),
      "",
      "---",
      "",
      "Code to review:",
      "`$TM_SELECTED_TEXT"
    ]
  },
  "Verification Review (Full)": {
    "prefix": "review-verify",
    "description": "Layer 3: Verify Critical/P1 fixes actually work",
    "body": [
$(ConvertTo-SnippetBody (Join-Path $PromptsDir "layer3-verification.md")),
      "",
      "---",
      "",
      "Original findings and fixed code to verify:",
      "`$TM_SELECTED_TEXT"
    ]
  }
}
"@

$snippetsContent | Out-File -FilePath (Join-Path $VsCodeSnippets "ai-code-review.code-snippets") -Encoding UTF8

Write-Host ""
Write-Host "Done! Installed full-length snippets."
Write-Host ""
Write-Host "VS Code extensions these work with:"
Write-Host "  - GitHub Copilot Chat"
Write-Host "  - Continue (open source)"
Write-Host "  - Cody (Sourcegraph)"
Write-Host "  - Codeium"
Write-Host "  - Amazon Q"
Write-Host "  - Any AI chat that accepts text input"
Write-Host ""
Write-Host "Usage:"
Write-Host "  1. Select code in VS Code"
Write-Host "  2. Open AI chat panel"
Write-Host "  3. Type 'review-quick' (or other prefix) and press Tab"
Write-Host "  4. Full prompt + selected code is inserted"
