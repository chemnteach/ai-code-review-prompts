#!/bin/bash
# Install AI Code Review prompts as JetBrains Live Templates
# Works with: IntelliJ IDEA, PyCharm, WebStorm, Rider, GoLand, etc.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

# Find JetBrains config directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    JETBRAINS_BASE="$HOME/Library/Application Support/JetBrains"
else
    JETBRAINS_BASE="$HOME/.config/JetBrains"
fi

if [[ ! -d "$JETBRAINS_BASE" ]]; then
    echo "JetBrains config directory not found at: $JETBRAINS_BASE"
    echo "Make sure you have a JetBrains IDE installed and have run it at least once."
    exit 1
fi

# Find all JetBrains IDE config directories
IDE_CONFIGS=$(find "$JETBRAINS_BASE" -maxdepth 1 -type d -name "IntelliJIdea*" -o -name "PyCharm*" -o -name "WebStorm*" -o -name "Rider*" -o -name "GoLand*" -o -name "CLion*" -o -name "PhpStorm*" 2>/dev/null)

if [[ -z "$IDE_CONFIGS" ]]; then
    echo "No JetBrains IDE configurations found."
    exit 1
fi

echo "Found JetBrains IDEs:"
echo "$IDE_CONFIGS" | while read -r ide; do
    echo "  - $(basename "$ide")"
done
echo ""

# Function to get markdown content (skip frontmatter), escape for XML
get_markdown_content() {
    local file="$1"
    local in_frontmatter=false
    local past_frontmatter=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "---" ]] && [[ "$past_frontmatter" == false ]]; then
            if [[ "$in_frontmatter" == false ]]; then
                in_frontmatter=true
                continue
            else
                in_frontmatter=false
                past_frontmatter=true
                continue
            fi
        fi

        [[ "$in_frontmatter" == true ]] && continue

        # Escape XML special characters
        line="${line//&/&amp;}"
        line="${line//</&lt;}"
        line="${line//>/&gt;}"
        line="${line//\"/&quot;}"

        echo -n "$line&#10;"
    done < "$file"
}

# Build the Live Template XML
build_template_xml() {
    cat << 'HEADER'
<templateSet group="AI Code Review">
HEADER

    # Template definitions
    local templates=(
        "review-gen|AI Review: Generation Guidelines (Layer 0)|layer0-generation-guidelines.md|false"
        "review-quick|AI Review: Quick Review (Layer 1)|layer1-quick-review.md|true"
        "review-security|AI Review: Security Specialist (Layer 2)|layer2-security-specialist.md|true"
        "review-correctness|AI Review: Correctness Specialist (Layer 2)|layer2-correctness-specialist.md|true"
        "review-maint|AI Review: Maintainability Specialist (Layer 2)|layer2-maintainability-specialist.md|true"
        "review-perf|AI Review: Performance Specialist (Layer 2)|layer2-performance-specialist.md|true"
        "review-data|AI Review: Data Integrity Specialist (Layer 2)|layer2-data-integrity-specialist.md|true"
        "review-verify|AI Review: Verification (Layer 3)|layer3-verification.md|true"
    )

    for template in "${templates[@]}"; do
        IFS='|' read -r name desc file add_code <<< "$template"
        local content=$(get_markdown_content "$PROMPTS_DIR/$file")

        if [[ "$add_code" == "true" ]]; then
            content="${content}&#10;---&#10;&#10;Code to review:&#10;\$SELECTION\$\$END\$"
        fi

        cat << EOF
  <template name="$name" value="$content" description="$desc" toReformat="false" toShortenFQNames="false">
    <context>
      <option name="OTHER" value="true"/>
    </context>
  </template>
EOF
    done

    echo "</templateSet>"
}

# Generate the template XML once
TEMPLATE_XML=$(build_template_xml)

# Install to each found IDE
echo "$IDE_CONFIGS" | while read -r ide; do
    [[ -z "$ide" ]] && continue

    templates_dir="$ide/templates"
    mkdir -p "$templates_dir"

    echo "$TEMPLATE_XML" > "$templates_dir/AICodeReview.xml"
    echo "Installed to: $(basename "$ide")"
done

echo ""
echo "Done! Installed AI Code Review live templates."
echo ""
echo "JetBrains AI features these work with:"
echo "  - JetBrains AI Assistant (built-in)"
echo "  - GitHub Copilot plugin"
echo "  - Any AI chat panel"
echo ""
echo "Usage:"
echo "  1. Select code in editor"
echo "  2. Type abbreviation (e.g., 'review-quick') or use Ctrl+J / Cmd+J"
echo "  3. Select from Live Templates list"
echo "  4. Prompt expands with selected code"
echo ""
echo "IMPORTANT: Restart your JetBrains IDE to load the new templates."
