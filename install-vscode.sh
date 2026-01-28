#!/bin/bash
# Install AI Code Review prompts as VS Code snippets (full-length versions)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

# Determine VS Code snippets directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_SNIPPETS="$HOME/Library/Application Support/Code/User/snippets"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    VSCODE_SNIPPETS="$HOME/.config/Code/User/snippets"
else
    VSCODE_SNIPPETS="$HOME/.vscode/snippets"
fi

echo "Installing AI Code Review snippets to: $VSCODE_SNIPPETS"
mkdir -p "$VSCODE_SNIPPETS"

# Function to escape JSON string content
escape_json() {
    # Escape backslashes, double quotes, and dollar signs (VS Code snippet variable)
    sed 's/\\/\\\\/g; s/"/\\"/g; s/\$/\\$/g'
}

# Function to convert markdown file to snippet body array
md_to_snippet_body() {
    local file="$1"
    local first=true

    # Skip frontmatter (between --- markers)
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

        # Escape the line for JSON
        escaped=$(echo "$line" | escape_json)

        if [[ "$first" == true ]]; then
            printf '      "%s"' "$escaped"
            first=false
        else
            printf ',\n      "%s"' "$escaped"
        fi
    done < "$file"
}

# Start building the snippets file
cat > "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'HEADER'
{
  "Generation Guidelines (Full)": {
    "prefix": "review-gen",
    "description": "Layer 0: Prevention guidelines - paste at session start",
    "body": [
HEADER

# Add Layer 0
md_to_snippet_body "$PROMPTS_DIR/layer0-generation-guidelines.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE1'

    ]
  },
  "Quick Review (Full)": {
    "prefix": "review-quick",
    "description": "Layer 1: Comprehensive review catching 80%+ of issues",
    "body": [
MIDDLE1

# Add Layer 1
md_to_snippet_body "$PROMPTS_DIR/layer1-quick-review.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE2'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Security Specialist (Full)": {
    "prefix": "review-security",
    "description": "Layer 2: Deep security analysis - injection, auth, crypto, etc.",
    "body": [
MIDDLE2

md_to_snippet_body "$PROMPTS_DIR/layer2-security-specialist.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE3'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Correctness Specialist (Full)": {
    "prefix": "review-correctness",
    "description": "Layer 2: Logic errors, edge cases, race conditions",
    "body": [
MIDDLE3

md_to_snippet_body "$PROMPTS_DIR/layer2-correctness-specialist.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE4'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Maintainability Specialist (Full)": {
    "prefix": "review-maint",
    "description": "Layer 2: Readability, complexity, debuggability",
    "body": [
MIDDLE4

md_to_snippet_body "$PROMPTS_DIR/layer2-maintainability-specialist.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE5'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Performance Specialist (Full)": {
    "prefix": "review-perf",
    "description": "Layer 2: N+1 queries, O(n²), memory leaks, scalability",
    "body": [
MIDDLE5

md_to_snippet_body "$PROMPTS_DIR/layer2-performance-specialist.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE6'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Data Integrity Specialist (Full)": {
    "prefix": "review-data",
    "description": "Layer 2: Validation, transactions, encoding, consistency",
    "body": [
MIDDLE6

md_to_snippet_body "$PROMPTS_DIR/layer2-data-integrity-specialist.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'MIDDLE7'
,
      "",
      "---",
      "",
      "Code to review:",
      "$TM_SELECTED_TEXT"
    ]
  },
  "Verification Review (Full)": {
    "prefix": "review-verify",
    "description": "Layer 3: Verify Critical/P1 fixes actually work",
    "body": [
MIDDLE7

md_to_snippet_body "$PROMPTS_DIR/layer3-verification.md" >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets"

cat >> "$VSCODE_SNIPPETS/ai-code-review.code-snippets" << 'FOOTER'
,
      "",
      "---",
      "",
      "Original findings and fixed code to verify:",
      "$TM_SELECTED_TEXT"
    ]
  }
}
FOOTER

echo ""
echo "Done! Installed full-length snippets."
echo ""
echo "VS Code extensions these work with:"
echo "  - GitHub Copilot Chat"
echo "  - Continue (open source)"
echo "  - Cody (Sourcegraph)"
echo "  - Codeium"
echo "  - Amazon Q"
echo "  - Any AI chat that accepts text input"
echo ""
echo "Usage:"
echo "  1. Select code in VS Code"
echo "  2. Open AI chat panel"
echo "  3. Type 'review-quick' (or other prefix) and press Tab"
echo "  4. Full prompt + selected code is inserted"
