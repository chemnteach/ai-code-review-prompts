# Install AI Code Review prompts as JetBrains Live Templates
# Works with: IntelliJ IDEA, PyCharm, WebStorm, Rider, GoLand, etc.

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PromptsDir = Join-Path $ScriptDir "prompts"

# Find JetBrains config directory
$JetBrainsBase = "$env:APPDATA\JetBrains"

if (-not (Test-Path $JetBrainsBase)) {
    Write-Host "JetBrains config directory not found at: $JetBrainsBase"
    Write-Host "Make sure you have a JetBrains IDE installed and have run it at least once."
    exit 1
}

# Find all JetBrains IDE config directories
$IdeConfigs = Get-ChildItem -Path $JetBrainsBase -Directory | Where-Object {
    $_.Name -match "^(IntelliJIdea|PyCharm|WebStorm|Rider|GoLand|CLion|PhpStorm|RubyMine|DataGrip)"
}

if ($IdeConfigs.Count -eq 0) {
    Write-Host "No JetBrains IDE configurations found."
    exit 1
}

Write-Host "Found JetBrains IDEs:"
foreach ($ide in $IdeConfigs) {
    Write-Host "  - $($ide.Name)"
}
Write-Host ""

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

    return $result -join "&#10;"
}

# Function to escape XML content
function Escape-XmlContent {
    param([string]$text)
    $text = $text -replace '&', '&amp;'
    $text = $text -replace '<', '&lt;'
    $text = $text -replace '>', '&gt;'
    $text = $text -replace '"', '&quot;'
    return $text
}

# Template definitions
$templates = @(
    @{
        Name = "review-gen"
        Description = "AI Review: Generation Guidelines (Layer 0)"
        File = "layer0-generation-guidelines.md"
    },
    @{
        Name = "review-quick"
        Description = "AI Review: Quick Review (Layer 1)"
        File = "layer1-quick-review.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-security"
        Description = "AI Review: Security Specialist (Layer 2)"
        File = "layer2-security-specialist.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-correctness"
        Description = "AI Review: Correctness Specialist (Layer 2)"
        File = "layer2-correctness-specialist.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-maint"
        Description = "AI Review: Maintainability Specialist (Layer 2)"
        File = "layer2-maintainability-specialist.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-perf"
        Description = "AI Review: Performance Specialist (Layer 2)"
        File = "layer2-performance-specialist.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-data"
        Description = "AI Review: Data Integrity Specialist (Layer 2)"
        File = "layer2-data-integrity-specialist.md"
        AddCodePlaceholder = $true
    },
    @{
        Name = "review-verify"
        Description = "AI Review: Verification (Layer 3)"
        File = "layer3-verification.md"
        AddCodePlaceholder = $true
    }
)

# Build the Live Template XML
$templateXml = @"
<templateSet group="AI Code Review">
"@

foreach ($template in $templates) {
    $content = Get-MarkdownContent (Join-Path $PromptsDir $template.File)
    $escapedContent = Escape-XmlContent $content

    if ($template.AddCodePlaceholder) {
        $escapedContent += "&#10;&#10;---&#10;&#10;Code to review:&#10;`$SELECTION`$`$END`$"
    }

    $templateXml += @"

  <template name="$($template.Name)" value="$escapedContent" description="$($template.Description)" toReformat="false" toShortenFQNames="false">
    <context>
      <option name="OTHER" value="true"/>
    </context>
  </template>
"@
}

$templateXml += @"

</templateSet>
"@

# Install to each found IDE
foreach ($ide in $IdeConfigs) {
    $templatesDir = Join-Path $ide.FullName "templates"

    if (-not (Test-Path $templatesDir)) {
        New-Item -ItemType Directory -Path $templatesDir -Force | Out-Null
    }

    $outputFile = Join-Path $templatesDir "AICodeReview.xml"
    $templateXml | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "Installed to: $($ide.Name)"
}

Write-Host ""
Write-Host "Done! Installed AI Code Review live templates."
Write-Host ""
Write-Host "JetBrains AI features these work with:"
Write-Host "  - JetBrains AI Assistant (built-in)"
Write-Host "  - GitHub Copilot plugin"
Write-Host "  - Any AI chat panel"
Write-Host ""
Write-Host "Usage:"
Write-Host "  1. Select code in editor"
Write-Host "  2. Type abbreviation (e.g., 'review-quick') or use Ctrl+J"
Write-Host "  3. Select from Live Templates list"
Write-Host "  4. Prompt expands with selected code"
Write-Host ""
Write-Host "IMPORTANT: Restart your JetBrains IDE to load the new templates."
