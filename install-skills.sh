#!/bin/bash
# Code Review Skills v2.0 Installer for Linux/Mac
# Supports custom Claude skills directories

echo "=================================================="
echo "  Code Review Skills v2.0 - Claude Code Installer"
echo "=================================================="
echo ""

# Function to test if a directory exists and has skills
test_skills_directory() {
    if [ -d "$1" ]; then
        skill_count=$(find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        [ $skill_count -gt 0 ] && return 0
    fi
    return 1
}

# Common skill locations to check
default_path="$HOME/.claude/skills"
detected_path=""

# Detect existing skills installation
if test_skills_directory "$default_path"; then
    detected_path="$default_path"
    echo "✓ Found existing skills in: $default_path"
fi

# Ask user where to install
echo ""
echo "Where would you like to install Code Review Skills v2.0?"
echo ""

if [ -n "$detected_path" ]; then
    echo "1. Use existing location: $detected_path (Recommended)"
else
    echo "1. Default location: $default_path (Recommended)"
fi

echo "2. Custom location (you specify)"
echo ""
read -p "Enter your choice (1-2): " choice

case $choice in
    1)
        if [ -n "$detected_path" ]; then
            skills_dir="$detected_path"
        else
            skills_dir="$default_path"
        fi
        ;;
    2)
        read -p "Enter full path to your Claude skills directory: " custom_path
        # Expand tilde if present
        skills_dir="${custom_path/#\~/$HOME}"
        ;;
    *)
        echo "Invalid choice. Using default: $default_path"
        skills_dir="$default_path"
        ;;
esac

echo ""
echo "Installing to: $skills_dir"
echo ""

# Create directory if it doesn't exist
mkdir -p "$skills_dir"

# Check for and remove old v1.0 skills
echo "Checking for old v1.0 skills..."

v1_skills=(
    "layer0-generation-guidelines"
    "layer1-quick-review"
    "layer2-correctness-specialist"
    "layer2-data-integrity-specialist"
    "layer2-maintainability-specialist"
    "layer2-performance-specialist"
    "layer2-security-specialist"
    "layer3-verification"
)

found_v1_skills=()
for old_skill in "${v1_skills[@]}"; do
    old_path="$skills_dir/$old_skill"
    if [ -d "$old_path" ]; then
        found_v1_skills+=("$old_skill")
    fi
done

if [ ${#found_v1_skills[@]} -gt 0 ]; then
    echo ""
    echo "Found ${#found_v1_skills[@]} old v1.0 skills:"
    for skill in "${found_v1_skills[@]}"; do
        echo "  - $skill"
    done
    echo ""
    echo "These will be replaced by v2.0 equivalents."
    read -p "Remove old v1.0 skills? (y/n): " confirm
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        for old_skill in "${found_v1_skills[@]}"; do
            old_path="$skills_dir/$old_skill"
            echo "  Removing: $old_skill"
            rm -rf "$old_path"
        done
        echo "Removed ${#found_v1_skills[@]} old v1.0 skills"
    else
        echo "Skipped removal. Old v1.0 skills will remain alongside v2.0."
    fi
else
    echo "No old v1.0 skills found"
fi
echo ""

# Check if prompts directory exists
if [ ! -d "prompts" ]; then
    echo "❌ Error: 'prompts' folder not found!"
    echo "   Make sure you're running this from the ai-code-review-prompts directory"
    exit 1
fi

# Install skills
installed_count=0

# Install skills from layer group folders (layer2-core-review, layer3-specialized-review, etc.)
for skill_dir in prompts/layer*/layer*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        echo "  Installing $skill_name..."
        mkdir -p "$skills_dir/$skill_name"
        cp "$skill_dir/SKILL.md" "$skills_dir/$skill_name/"
        ((installed_count++))
    fi
done

# Install skills from layer root folders (layer0-prevention, layer1-planning, layer5-fix-planning, layer6-verification)
for skill_dir in prompts/layer*-*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        echo "  Installing $skill_name..."
        mkdir -p "$skills_dir/$skill_name"
        cp "$skill_dir/SKILL.md" "$skills_dir/$skill_name/"
        ((installed_count++))
    fi
done

# Install meta-skills (review, review-diff, verify, review-file)
for skill_dir in prompts/meta/*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        echo "  Installing meta/$skill_name..."
        mkdir -p "$skills_dir/$skill_name"
        cp "$skill_dir/SKILL.md" "$skills_dir/$skill_name/"
        ((installed_count++))
    fi
done

echo ""
echo "=================================================="
echo "  ✅ Installation Complete!"
echo "=================================================="
echo ""
echo "📊 Installed: $installed_count skills"
echo "📁 Location: $skills_dir"
echo ""
echo "🚀 Usage in Claude Code:"
echo "   /layer0-prevention          - Prevention guidelines"
echo "   /layer1-planning            - Review planning"
echo "   /layer2a-quick-review       - Quick review (80%+ coverage)"
echo "   /layer2c-security-specialist - Security deep dive"
echo "   /review                     - Full review pipeline"
echo "   /review-diff                - Diff-scoped pre-commit review"
echo "   /verify                     - Post-fix verification"
echo "   /review-file                - Single file quick review"
echo ""
echo "📖 Full documentation: prompts/README.md"
echo ""

# Offer to save config for future use
read -p "💾 Save this location for future updates? (y/n): " save_config

if [ "$save_config" = "y" ] || [ "$save_config" = "Y" ]; then
    cat > .claude-skills-config << EOF
# Code Review Skills Installation Config
# This file stores your preferred skills directory
SKILLS_DIR=$skills_dir
EOF
    echo "✓ Saved to .claude-skills-config"
    echo "  Future installs will use this location automatically"
fi

echo ""
