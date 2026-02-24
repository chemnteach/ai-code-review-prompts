# Installing Skills to Claude Code

## Quick Install (Interactive)

The installer will:
1. ✅ **Detect** your existing Claude skills directory
2. 🔍 **Find old v1.0 skills** and ask to remove them
3. 🤔 **Ask** where you want to install (default, detected, or custom)
4. 📦 **Install** all 17 v2.0 skills
5. 💾 **Save** your choice for future updates

**Windows (PowerShell):**
```powershell
cd ai-code-review-prompts
powershell -ExecutionPolicy Bypass -File .\install-skills.ps1
```

**Linux/Mac:**
```bash
cd ai-code-review-prompts
chmod +x install-skills.sh
./install-skills.sh
```

---

## Upgrading from v1.0

If you have old v1.0 skills installed, the installer will automatically detect them:

```
Checking for old v1.0 skills...

Found 8 old v1.0 skills:
  - layer0-generation-guidelines
  - layer1-quick-review
  - layer2-correctness-specialist
  - layer2-data-integrity-specialist
  - layer2-maintainability-specialist
  - layer2-performance-specialist
  - layer2-security-specialist
  - layer3-verification

These will be replaced by v2.0 equivalents.
Remove old v1.0 skills? (Y/N):
```

**Recommendations:**
- **Press Y** - Clean upgrade (recommended)
  - Removes all v1.0 skills
  - Installs fresh v2.0 skills
  - No conflicts or confusion
  
- **Press N** - Keep both versions (not recommended)
  - v1.0 and v2.0 coexist
  - May cause confusion (two "quick-review" skills with different names)
  - Takes up extra space

**Old Skills → New Skills Mapping:**

| Old v1.0 Skill | New v2.0 Skill | Notes |
|----------------|----------------|-------|
| layer0-generation-guidelines | layer0-prevention | Renamed and updated |
| layer1-quick-review | layer2a-quick-review | Moved to layer 2 |
| layer2-correctness-specialist | layer2b-correctness-specialist | Renumbered |
| layer2-security-specialist | layer2c-security-specialist | Renumbered |
| layer2-data-integrity-specialist | layer2d-data-integrity-specialist | Renumbered |
| layer2-performance-specialist | layer3a-performance-specialist | Moved to layer 3 |
| layer2-maintainability-specialist | layer3b-maintainability-specialist | Moved to layer 3 |
| layer3-verification | layer6-verification | Moved to layer 6 |

**Plus 9 new skills you don't have yet:**
- layer1-planning (NEW)
- layer3c-testability-specialist (NEW)
- layer3d-error-handling-specialist (NEW)
- layer3e-concurrency-specialist (NEW)
- layer3f-prompt-injection-specialist (NEW)
- layer3g-token-efficiency-specialist (NEW)
- layer4a-code-smell-detector (NEW)
- layer4b-refactoring-advisor (NEW)
- layer5-fix-planning (NEW)

---

## Installation Locations

The installer checks these common locations:

**Windows:**
- `C:\Users\YourName\.claude\skills` (Default)
- `D:\.claude\skills` (Common custom location)
- Custom path you specify

**Linux/Mac:**
- `~/.claude/skills` (Default: `/home/username/.claude/skills`)
- Custom path you specify

---

## Custom Installation Directory

If your skills are in a different location (e.g., `D:\.claude\skills`), the installer will:

1. Detect it automatically if skills already exist there
2. Or let you choose option 3 (Custom) and specify the path

**Example session:**
```
Where would you like to install Code Review Skills v2.0?

1. Use existing location: D:\.claude\skills (Recommended)
2. C:\Users\YourName\.claude\skills
3. Custom location (you specify)

Enter your choice (1-3): 1

Installing to: D:\.claude\skills
```

---

## Saved Configuration

The installer can save your chosen location to `.claude-skills-config`:

```
# Code Review Skills Installation Config
SKILLS_DIR=D:\.claude\skills
```

This allows:
- ✅ Future updates use the same location automatically
- ✅ Team members can commit this to Git (optional)
- ✅ No need to remember custom paths

**To use saved config:**
Just run the installer again - it reads `.claude-skills-config` automatically.

---

## Manual Installation (No Installer)

If you prefer manual installation or the installer doesn't work:

**Windows:**
```powershell
# Your skills directory (adjust path as needed)
$skillsDir = "D:\.claude\skills"

# Create directory
New-Item -ItemType Directory -Path $skillsDir -Force

# Copy all skills
Get-ChildItem -Path "prompts\layer*\layer*" -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $targetDir = Join-Path $skillsDir $_.Name
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item $skillFile -Destination $targetDir -Force
    }
}

# Also copy root layer skills
Get-ChildItem -Path "prompts\layer*-*" -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $targetDir = Join-Path $skillsDir $_.Name
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item $skillFile -Destination $targetDir -Force
    }
}
```

**Linux/Mac:**
```bash
# Your skills directory (adjust path as needed)
skills_dir="$HOME/.claude/skills"

# Create directory
mkdir -p "$skills_dir"

# Copy all skills
for skill_dir in prompts/layer*/layer*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$skills_dir/$skill_name"
        cp "$skill_dir/SKILL.md" "$skills_dir/$skill_name/"
    fi
done

# Also copy root layer skills
for skill_dir in prompts/layer*-*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$skills_dir/$skill_name"
        cp "$skill_dir/SKILL.md" "$skills_dir/$skill_name/"
    fi
done
```

---

## Verify Installation

After installation, verify skills are in place:

**Windows:**
```powershell
Get-ChildItem D:\.claude\skills
```

**Linux/Mac:**
```bash
ls ~/.claude/skills
```

You should see 17 folders:
- layer0-prevention
- layer1-planning
- layer2a-quick-review
- layer2b-correctness-specialist
- layer2c-security-specialist
- layer2d-data-integrity-specialist
- layer3a-performance-specialist
- layer3b-maintainability-specialist
- layer3c-testability-specialist
- layer3d-error-handling-specialist
- layer3e-concurrency-specialist
- layer3f-prompt-injection-specialist
- layer3g-token-efficiency-specialist
- layer4a-code-smell-detector
- layer4b-refactoring-advisor
- layer5-fix-planning
- layer6-verification

Each folder should contain a `SKILL.md` file.

---

## Updating Existing Skills

If you already have v1.0 skills installed, the installer will:

**Option 1: Replace in same location**
- Choose your existing directory
- v2.0 skills overwrite v1.0 skills
- Old v1.0-only skills remain (won't conflict)

**Option 2: Install to new location**
- Keep v1.0 in old location
- Install v2.0 to new location
- Switch between versions by changing Claude Code's skills path

**Recommended:** Replace in same location (Option 1)
- v2.0 is backward compatible naming (layer0, layer1 exist in both)
- New skills added (layer1-planning, layer3c-g, layer4, layer5)
- Layer 2 specialists renamed but still work

---

## Troubleshooting

**"prompts folder not found" error:**
- Make sure you're in the `ai-code-review-prompts` directory
- Run `pwd` (Linux/Mac) or `Get-Location` (Windows) to check

**"Permission denied" (Linux/Mac):**
```bash
chmod +x install-skills.sh
```

**"Execution of scripts is disabled" (Windows):**
```powershell
powershell -ExecutionPolicy Bypass -File .\install-skills.ps1
```

**Skills not showing in Claude Code:**
- Restart Claude Code
- Check skills path matches Claude Code's configuration
- Verify SKILL.md files exist in each folder

---

## For Repository Maintainers

**Include `.claude-skills-config` in `.gitignore`?**

**Don't ignore it if:**
- Team uses same skills directory structure
- Want consistent install locations across team

**Do ignore it if:**
- Developers use different paths
- Personal preference varies

Add to `.gitignore`:
```
.claude-skills-config
```

Or commit it for team consistency:
```
# Committed - team uses same structure
.claude-skills-config
```
