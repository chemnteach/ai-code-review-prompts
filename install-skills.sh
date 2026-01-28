#!/bin/bash
# Install AI Code Review prompts as Claude Code skills

SKILLS_DIR="$HOME/.claude/skills"
CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"
TEMPLATE_FILE="$SCRIPT_DIR/claude-code/CLAUDE.md.template"

echo "Installing AI Code Review skills to $SKILLS_DIR..."

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Install each prompt as a skill
for prompt in "$PROMPTS_DIR"/*.md; do
    filename=$(basename "$prompt" .md)
    skill_dir="$SKILLS_DIR/$filename"

    echo "  Installing $filename..."
    mkdir -p "$skill_dir"
    cp "$prompt" "$skill_dir/SKILL.md"
done

# Install Layer 0 as global CLAUDE.md (auto-loads every session)
GLOBAL_CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
if [[ -f "$TEMPLATE_FILE" ]]; then
    if [[ -f "$GLOBAL_CLAUDE_MD" ]]; then
        # Check if guidelines already present
        if grep -q "Code Generation Guidelines" "$GLOBAL_CLAUDE_MD" 2>/dev/null; then
            echo "  CLAUDE.md already contains generation guidelines (skipped)"
        else
            echo ""
            echo "Found existing $GLOBAL_CLAUDE_MD"
            read -p "Append Layer 0 generation guidelines to existing file? (y/N) " response
            if [[ "$response" == "y" || "$response" == "Y" ]]; then
                echo "" >> "$GLOBAL_CLAUDE_MD"
                echo "---" >> "$GLOBAL_CLAUDE_MD"
                echo "" >> "$GLOBAL_CLAUDE_MD"
                cat "$TEMPLATE_FILE" >> "$GLOBAL_CLAUDE_MD"
                echo "  Appended generation guidelines to CLAUDE.md"
            else
                echo "  Skipped CLAUDE.md (keeping existing)"
            fi
        fi
    else
        cp "$TEMPLATE_FILE" "$GLOBAL_CLAUDE_MD"
        echo "  Installed CLAUDE.md (Layer 0 auto-loads every session)"
    fi
fi

echo ""
echo "Done! Installed skills:"
ls -1 "$SKILLS_DIR" | grep -E "^layer[0-3]"
echo ""
echo "Usage: /layer1-quick-review, /layer2-security-specialist, etc."
echo ""
echo "Layer 0 (generation guidelines) now loads automatically every session via ~/.claude/CLAUDE.md"
