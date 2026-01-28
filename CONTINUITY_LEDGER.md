# Continuity Ledger - AI Code Review Prompts

## Project Overview

A 4-layer AI code review system with prompts optimized for different review scenarios:
- **Layer 0**: Generation Guidelines (prevention, auto-loads at session start)
- **Layer 1**: Quick Review (catches 80% of issues)
- **Layer 2**: Specialists (Security, Correctness, Maintainability, Performance, Data Integrity)
- **Layer 3**: Verification (confirm fixes work)

Repository: https://github.com/chemnteach/ai-code-review-prompts

---

## Session: 2025-01-28 (Latest)

### Objective
Add CLAUDE.md auto-load feature, clarify platform-specific usage differences.

### Status: Complete

### Key Decisions

1. **Layer 0 auto-loading**: Install generation guidelines to `~/.claude/CLAUDE.md` so they load automatically every Claude Code session (not just when skills are invoked).

2. **Smart merge behavior**: When `~/.claude/CLAUDE.md` already exists:
   - If guidelines already present → skip (no duplicate)
   - If no guidelines → prompt user to append
   - If file doesn't exist → create it

3. **Global vs Project CLAUDE.md**: Confirmed these are separate files:
   - `~/.claude/CLAUDE.md` - Global, loads every session
   - `./CLAUDE.md` - Project-specific, created by `/init`
   - `/init` doesn't affect global file

### Changes Made

| File | Change |
|------|--------|
| `claude-code/CLAUDE.md.template` | Created - Layer 0 content for auto-load |
| `install-skills.sh` | Added CLAUDE.md install with append logic |
| `install-skills.ps1` | Added CLAUDE.md install with append logic |
| `README.md` | Documented auto-load + clarified platform usage differences |

### Key Clarification Added

| Platform | Layer 0 | Reviews | Codebase Access |
|----------|---------|---------|-----------------|
| Claude Code | Auto-loads | `/skill-name` | Full access |
| IDE Snippets | Paste once | Prefix + Tab → paste to AI | Only pasted code |
| Manual | Paste once | Copy from file | Only pasted code |

### Commits
- `fad2e2c` - feat: add Layer 0 auto-load via CLAUDE.md
- (this session) - docs: clarify platform-specific usage workflows

### Also Done
- Installed Layer 0 to user's global `~/.claude/CLAUDE.md`
- Confirmed auto-load behavior for future sessions

---

## Session: 2025-01-28 (Earlier)

### Objective
Fix Claude Code skills documentation and add multi-IDE installer support.

### Status: Complete

### Key Decisions

1. **Correct skill structure**: Skills require folder structure with SKILL.md:
   ```
   ~/.claude/skills/
   └── layer1-quick-review/
       └── SKILL.md
   ```

2. **Full-length snippets**: IDE snippets contain complete prompt text (200-800 lines), not condensed versions.

3. **Multi-IDE support**: Created installers for:
   - Claude Code (skills)
   - VS Code (snippets)
   - Visual Studio (XML snippets)
   - JetBrains IDEs (Live Templates)

### Changes Made

| File | Change |
|------|--------|
| `README.md` | Comprehensive rewrite with IDE-specific instructions |
| `install-skills.sh` | Created - Claude Code installer (Linux/Mac) |
| `install-skills.ps1` | Created - Claude Code installer (Windows) |
| `install-vscode.sh` | Created - VS Code snippets (Linux/Mac) |
| `install-vscode.ps1` | Created - VS Code snippets (Windows) |
| `install-visualstudio.ps1` | Created - Visual Studio snippets |
| `install-jetbrains.sh` | Created - JetBrains Live Templates (Linux/Mac) |
| `install-jetbrains.ps1` | Created - JetBrains Live Templates (Windows) |

### Commits
- `570b1ce` - Add multi-IDE installer support and expand prompts
- `7498517` - Add install scripts and fix Claude Code skill setup docs
- `a8bd963` - Updated based on Claude developer input

---

## File Structure

```
ai-code-review-prompts/
├── prompts/                      # Source prompts (8 files)
│   ├── layer0-generation-guidelines.md
│   ├── layer1-quick-review.md
│   ├── layer2-security-specialist.md
│   ├── layer2-correctness-specialist.md
│   ├── layer2-maintainability-specialist.md
│   ├── layer2-performance-specialist.md
│   ├── layer2-data-integrity-specialist.md
│   └── layer3-verification.md
├── claude-code/
│   └── CLAUDE.md.template        # Layer 0 for auto-load
├── install-skills.sh/.ps1        # Claude Code installer
├── install-vscode.sh/.ps1        # VS Code installer
├── install-visualstudio.ps1      # Visual Studio installer
├── install-jetbrains.sh/.ps1     # JetBrains installer
└── README.md                     # Documentation
```

---

## Next Steps (if continuing)

1. **Optional**: Add `skill-rules.json` for auto-suggestions based on keywords
2. **Optional**: Test installers on fresh systems
3. **Optional**: Add uninstall scripts
