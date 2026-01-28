#!/bin/bash
# Install AI Code Review prompts as Claude Code skills

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

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

echo ""
echo "Done! Installed skills:"
ls -1 "$SKILLS_DIR" | grep -E "^layer[0-3]"
echo ""
echo "Usage: /layer1-quick-review, /layer2-security-specialist, etc."
