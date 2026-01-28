# Install AI Code Review prompts as Visual Studio snippets
# Works with: Visual Studio 2019, 2022 with GitHub Copilot or AI features

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PromptsDir = Join-Path $ScriptDir "prompts"

# Visual Studio snippet directories (check both 2022 and 2019)
$VsSnippetDirs = @(
    "$env:USERPROFILE\Documents\Visual Studio 2022\Code Snippets\Visual C#\My Code Snippets",
    "$env:USERPROFILE\Documents\Visual Studio 2022\Code Snippets\Text\My Code Snippets",
    "$env:USERPROFILE\Documents\Visual Studio 2019\Code Snippets\Visual C#\My Code Snippets"
)

# Find first existing VS installation
$TargetDir = $null
foreach ($dir in $VsSnippetDirs) {
    $parentDir = Split-Path -Parent $dir
    if (Test-Path (Split-Path -Parent $parentDir)) {
        $TargetDir = $dir
        break
    }
}

if (-not $TargetDir) {
    # Default to VS 2022
    $TargetDir = "$env:USERPROFILE\Documents\Visual Studio 2022\Code Snippets\Text\My Code Snippets"
}

Write-Host "Installing AI Code Review snippets to: $TargetDir"

# Create directory structure if needed
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# Function to get markdown content (skip frontmatter)
function Get-MarkdownContent {
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
        $result += $line
    }

    return $result -join "`r`n"
}

# Function to create Visual Studio snippet XML
function Create-VsSnippet {
    param(
        [string]$Title,
        [string]$Shortcut,
        [string]$Description,
        [string]$Content,
        [string]$OutputPath
    )

    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<CodeSnippets xmlns="http://schemas.microsoft.com/VisualStudio/2005/CodeSnippet">
  <CodeSnippet Format="1.0.0">
    <Header>
      <Title>$Title</Title>
      <Shortcut>$Shortcut</Shortcut>
      <Description>$Description</Description>
      <Author>AI Code Review Prompts</Author>
      <SnippetTypes>
        <SnippetType>Expansion</SnippetType>
      </SnippetTypes>
    </Header>
    <Snippet>
      <Declarations>
        <Literal>
          <ID>code</ID>
          <Default>[paste your code here]</Default>
          <ToolTip>Code to review</ToolTip>
        </Literal>
      </Declarations>
      <Code Language="Text">
        <![CDATA[$Content

---

Code to review:
`$code`$]]>
      </Code>
    </Snippet>
  </CodeSnippet>
</CodeSnippets>
"@

    $xml | Out-File -FilePath $OutputPath -Encoding UTF8
}

# Create snippets for each prompt
$snippets = @(
    @{
        Title = "AI Review - Generation Guidelines"
        Shortcut = "review-gen"
        Description = "Layer 0: Prevention guidelines - paste at session start"
        File = "layer0-generation-guidelines.md"
    },
    @{
        Title = "AI Review - Quick Review"
        Shortcut = "review-quick"
        Description = "Layer 1: Comprehensive review catching 80%+ of issues"
        File = "layer1-quick-review.md"
    },
    @{
        Title = "AI Review - Security Specialist"
        Shortcut = "review-security"
        Description = "Layer 2: Deep security analysis"
        File = "layer2-security-specialist.md"
    },
    @{
        Title = "AI Review - Correctness Specialist"
        Shortcut = "review-correctness"
        Description = "Layer 2: Logic errors, edge cases, race conditions"
        File = "layer2-correctness-specialist.md"
    },
    @{
        Title = "AI Review - Maintainability Specialist"
        Shortcut = "review-maint"
        Description = "Layer 2: Readability, complexity, debuggability"
        File = "layer2-maintainability-specialist.md"
    },
    @{
        Title = "AI Review - Performance Specialist"
        Shortcut = "review-perf"
        Description = "Layer 2: N+1 queries, scalability, memory"
        File = "layer2-performance-specialist.md"
    },
    @{
        Title = "AI Review - Data Integrity Specialist"
        Shortcut = "review-data"
        Description = "Layer 2: Validation, transactions, consistency"
        File = "layer2-data-integrity-specialist.md"
    },
    @{
        Title = "AI Review - Verification"
        Shortcut = "review-verify"
        Description = "Layer 3: Verify Critical/P1 fixes actually work"
        File = "layer3-verification.md"
    }
)

foreach ($snippet in $snippets) {
    $content = Get-MarkdownContent (Join-Path $PromptsDir $snippet.File)
    $outputFile = Join-Path $TargetDir "$($snippet.Shortcut).snippet"

    Create-VsSnippet -Title $snippet.Title `
                     -Shortcut $snippet.Shortcut `
                     -Description $snippet.Description `
                     -Content $content `
                     -OutputPath $outputFile

    Write-Host "  Created: $($snippet.Shortcut).snippet"
}

Write-Host ""
Write-Host "Done! Installed $($snippets.Count) Visual Studio snippets."
Write-Host ""
Write-Host "Visual Studio AI extensions these work with:"
Write-Host "  - GitHub Copilot (built-in chat in VS 2022 17.8+)"
Write-Host "  - JetBrains AI Assistant (via ReSharper)"
Write-Host "  - Visual Studio IntelliCode"
Write-Host ""
Write-Host "Usage:"
Write-Host "  1. In any editor, type the shortcut (e.g., 'review-quick')"
Write-Host "  2. Press Tab twice to expand"
Write-Host "  3. Replace [paste your code here] with actual code"
Write-Host "  4. Copy entire prompt to Copilot Chat or AI assistant"
Write-Host ""
Write-Host "Or import via: Tools > Code Snippets Manager > Import"
