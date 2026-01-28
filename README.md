# AI Code Review Prompts

**Insurance policies for AI-generated code.** Prevention first, detection as backup.

Research shows AI-generated code has **2.74x more XSS vulnerabilities** and **1.75x more logic errors** than human code. These prompts give AI permission to be critical instead of agreeable.

---

## 🎯 The Problem

When you ask AI "Is this code good?", it's agreeable by default:
- ✅ "This looks great! Here are some minor suggestions..."

When you use **personas**, AI becomes critical:
- ⚠️ "Critical: SQL injection on line 42. Attack scenario: ..."

**Personas unlock critical thinking that default behavior suppresses.**

---

## 🏗️ Four-Layer System

```
┌─────────────────────────────────────────┐
│  LAYER 0: Generation Guidelines        │
│  Auto-loads in Claude Code via CLAUDE.md│
│  PREVENTS issues before they exist      │
└─────────────────────────────────────────┘
                 ↓
          Code gets written
                 ↓
┌─────────────────────────────────────────┐
│  LAYER 1: Quick Review                  │
│  After writing, before committing       │
│  One comprehensive persona (80% use)    │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  LAYER 2: Specialist Reviews            │
│  On-demand deep dives                   │
│  5 specialists (security, correctness,  │
│  maintainability, performance, data)    │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  LAYER 3: Verification                  │
│  After fixing Critical/P1 issues        │
│  Confirms fixes actually work           │
└─────────────────────────────────────────┘
```

---

## 🚀 Quick Start

Choose your IDE and run the installer. Full-length prompts are installed automatically.

### VS Code

```bash
# Linux/Mac
./install-vscode.sh

# Windows (PowerShell)
.\install-vscode.ps1
```

**Compatible AI extensions:**
- GitHub Copilot Chat
- Continue (open source)
- Cody (Sourcegraph)
- Codeium
- Amazon Q

**Usage:** Select code → Type `review-quick` → Tab → Copy expanded prompt to AI chat

---

### Visual Studio (Full IDE)

```powershell
# Windows only
.\install-visualstudio.ps1
```

**Compatible AI features:**
- GitHub Copilot (VS 2022 17.8+)
- JetBrains AI Assistant (via ReSharper)
- Visual Studio IntelliCode

**Usage:** Type `review-quick` → Tab twice → Replace placeholder with code → Copy to AI chat

---

### JetBrains IDEs (IntelliJ, PyCharm, WebStorm, Rider, etc.)

```bash
# Linux/Mac
./install-jetbrains.sh

# Windows (PowerShell)
.\install-jetbrains.ps1
```

**Compatible AI features:**
- JetBrains AI Assistant (built-in)
- GitHub Copilot plugin
- Any AI chat panel

**Usage:** Select code → `review-quick` or Ctrl+J → Select template → Copy to AI chat

**Note:** Restart IDE after installation to load templates.

---

### Claude Code

```bash
# Linux/Mac
./install-skills.sh

# Windows (PowerShell)
.\install-skills.ps1
```

**What gets installed:**
- Skills in `~/.claude/skills/` (invoke with `/layer1-quick-review`, etc.)
- **Layer 0 in `~/.claude/CLAUDE.md`** - auto-loads every session, no manual paste!

**Usage:** Layer 0 is automatic. Type `/layer1-quick-review` for reviews.

<details>
<summary><strong>Manual installation & skill-rules.json</strong> (click to expand)</summary>

Skills require a specific folder structure:
```
~/.claude/skills/
├── layer1-quick-review/     # Folder named after the skill
│   └── SKILL.md             # File MUST be named SKILL.md
├── layer2-security-specialist/
│   └── SKILL.md
└── ...
```

**Manual steps:**

1. **Create folders:**
   ```bash
   mkdir -p ~/.claude/skills/layer1-quick-review
   # ... repeat for each prompt
   ```

2. **Copy prompts:**
   ```bash
   cp prompts/layer1-quick-review.md ~/.claude/skills/layer1-quick-review/SKILL.md
   # ... repeat for each prompt
   ```

3. **Ensure frontmatter exists:**
   ```yaml
   ---
   name: layer1-quick-review
   description: Quick code review for common issues
   user_invocable: true
   ---
   ```

**(Optional) Enable auto-suggestions** by adding to `~/.claude/skills/skill-rules.json`:

```json
{
    "version": "1.0",
    "skills": {
        "layer1-quick-review": {
            "type": "domain",
            "enforcement": "suggest",
            "priority": "high",
            "description": "Quick code review for common issues",
            "promptTriggers": {
                "keywords": ["review code", "code review", "check my code"]
            }
        }
    }
}
```

</details>

---

### Any Other IDE / Manual Use

Just copy-paste from the `prompts/` folder directly into your AI chat.

---

### Snippet Prefixes (All IDEs)

| Prefix | Layer | Purpose |
|--------|-------|---------|
| `review-gen` | 0 | Generation guidelines (session start) |
| `review-quick` | 1 | Comprehensive review (80% use case) |
| `review-security` | 2 | Security deep dive |
| `review-correctness` | 2 | Logic errors, edge cases |
| `review-maint` | 2 | Maintainability, debuggability |
| `review-perf` | 2 | Performance, scalability |
| `review-data` | 2 | Data integrity, transactions |
| `review-verify` | 3 | Verify fixes work |

---

## 📋 Priority Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **Critical** | Will cause problems | Fix now |
| **P1** | Time bomb - works now, fails later | Fix soon or accept risk |
| **P2** | Technical debt | Track, fix eventually |
| **P3** | Style/nitpicks | Optional |

---

## 📖 Prompt Reference

### Layer 0: Generation Guidelines
**When:** Start of every session (auto-loads in Claude Code, paste once in other tools)
**Purpose:** Prevents issues before they exist by establishing expectations
**Key areas:**
- Managing uncertainty (stop and ask, don't assume)
- Complexity management (start simple, avoid over-engineering)
- Surgical changes (change only what's requested)
- Security defaults (sanitize inputs, no hardcoded secrets)

### Layer 1: Quick Review
**When:** After writing code, BEFORE committing
**Purpose:** Catches 80%+ of issues in one pass
**Key areas (10 categories):**
- Logic errors & correctness (off-by-one, null handling, boundaries)
- Wrong assumptions (the #1 AI failure mode)
- Security risks (injection, auth, secrets)
- Time bombs (resource leaks, scalability issues)
- AI-generated smells (unnecessary abstraction, duplication)
- Maintainability & debuggability
- Performance red flags
- Integration & dependencies
- Edge cases & error scenarios
- Orthogonal changes (scope creep)

### Layer 2: Specialists (Deep Dives)
**When:** After Quick Review finds concerns in a specific area, OR for high-risk code

| Specialist | Use When | Key Areas |
|------------|----------|-----------|
| **Security** | Auth, user input, APIs, file operations, external integrations | 14 areas: Injection (SQL, command, XSS), auth/authz, secrets, input validation, cryptography, session management, CORS, business logic flaws, AI-specific (prompt injection) |
| **Correctness** | Algorithms, business logic, data processing, state management | 10 areas: Off-by-one, null handling, boundary conditions, race conditions, state management, error handling, type coercion, AI-specific patterns |
| **Maintainability** | Complex logic, shared code, anything maintained >6 months | 10 areas: Duplication, complexity, naming quality, explainability, coupling, documentation, AI-specific issues, error messages, structure, future-proofing |
| **Performance** | Database queries, loops, data processing, user-facing operations | 10 areas: N+1 queries, algorithmic complexity, memory management, unbounded operations, blocking operations, caching, data processing, scalability anti-patterns |
| **Data Integrity** | Database operations, data pipelines, multi-step workflows | 10 areas: Input validation, transactions, null propagation, type mismatches, encoding, timezones, state consistency, data loss scenarios, error recovery |

### Layer 3: Verification
**When:** AFTER fixing Critical/P1 issues, BEFORE marking as resolved
**Purpose:** Confirms fixes actually work and don't introduce regressions
**Key areas:**
- Fix completeness (all instances? all paths?)
- Fix correctness (root cause or band-aid?)
- Lazy shortcuts detection (hardcoded values, suppressed errors)
- Regression detection
- Test coverage verification

---

## 🔄 Recommended Workflow

### Standard Flow (Every Session)

```
┌─────────────────────────────────────────────────────────────┐
│  1. START SESSION                                           │
│     Layer 0: Generation Guidelines                          │
│     (Auto in Claude Code, paste once in other tools)        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. WRITE CODE                                              │
│     AI follows guidelines, asks questions when uncertain    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. QUICK REVIEW                                            │
│     Run Layer 1 on completed code                           │
│     Catches 80%+ of issues                                  │
└─────────────────────────────────────────────────────────────┘
                              ↓
              ┌───────────────┴───────────────┐
              │                               │
              ↓                               ↓
┌─────────────────────────┐     ┌─────────────────────────────┐
│  No Critical/P1 issues  │     │  Critical/P1 issues found   │
│  → Ship or continue     │     │  → Fix issues               │
└─────────────────────────┘     │  → Run Layer 3 Verification │
                                │  → Repeat until ✅ Fixed    │
                                └─────────────────────────────┘
```

### Deep Dive Flow (High-Risk Code)

```
After Quick Review, if code involves:
├── Auth/security     → Run Security Specialist
├── Complex logic     → Run Correctness Specialist
├── Shared/long-lived → Run Maintainability Specialist
├── Database/loops    → Run Performance Specialist
└── Data operations   → Run Data Integrity Specialist
```

### Full Audit Flow (Pre-Release)

```
1. Quick Review on all changed files
2. Security Specialist on auth, APIs, user input
3. Performance Specialist on database queries, data processing
4. Data Integrity Specialist on all data operations
5. Verification on all Critical/P1 fixes
```

---

## 💡 Usage By Platform

### Claude Code (No Copy-Paste)

Claude Code has full codebase access - just invoke skills directly:

```
# Layer 0 loads automatically from ~/.claude/CLAUDE.md - nothing to do!

# Quick review - Claude sees your code
/layer1-quick-review

# Specialist review on specific file
/layer2-security-specialist
"Review src/auth/login.ts"

# Verification after fixes
/layer3-verification
"Verify my fixes to the SQL injection issue"
```

**Key difference:** Claude Code sees your files. No paste, no select, no copy.

---

### IDE Snippets (VS Code, JetBrains, Visual Studio)

Snippets expand the prompt with your selected code - you still paste into AI chat:

```
1. Select code in editor
2. Type prefix (e.g., review-quick) → Tab
3. Prompt expands with your code embedded
4. Copy expanded text → Paste into AI chat (Copilot, Continue, etc.)
```

**Why snippets help:** They format 200-800 line prompts with your code included. Without snippets, you'd manually paste prompt + code.

**Limitation:** AI extensions only see what you paste, not your whole codebase.

---

### Manual / Any AI Chat

Copy-paste from `prompts/` folder:

```
1. Open prompts/layer1-quick-review.md
2. Copy entire prompt
3. Paste into AI chat
4. Add your code below the prompt
```

---

### Workflow Comparison

| Action | Claude Code | IDE Snippets | Manual |
|--------|-------------|--------------|--------|
| Layer 0 | Auto-loads | Paste once per session | Paste once per session |
| Select code | Not needed | Yes, before snippet | Copy manually |
| Expand prompt | `/skill-name` | Type prefix + Tab | Copy from file |
| Paste to AI | Not needed | Yes, to AI chat | Yes, prompt + code |
| AI sees codebase | Yes, full access | Only pasted code | Only pasted code |

---

### Team Code Review

```
PR Review: Run Quick Review on diff
Security-sensitive: Add Security Specialist review
Performance-critical: Add Performance Specialist review
Before merge: Verification on all Critical/P1 fixes
```

---

## 📁 What's Included

```
ai-code-review-prompts/
├── README.md                               # This file
│
├── # Installers
├── install-vscode.sh                       # VS Code (Linux/Mac)
├── install-vscode.ps1                      # VS Code (Windows)
├── install-visualstudio.ps1                # Visual Studio (Windows)
├── install-jetbrains.sh                    # JetBrains IDEs (Linux/Mac)
├── install-jetbrains.ps1                   # JetBrains IDEs (Windows)
├── install-skills.sh                       # Claude Code (Linux/Mac)
├── install-skills.ps1                      # Claude Code (Windows)
│
├── # Full Prompts (copy-paste or used by installers)
├── prompts/
│   ├── layer0-generation-guidelines.md     # Prevention (91 lines)
│   ├── layer1-quick-review.md              # Quick review (194 lines)
│   ├── layer2-security-specialist.md       # Security (782 lines)
│   ├── layer2-correctness-specialist.md    # Correctness (469 lines)
│   ├── layer2-maintainability-specialist.md # Maintainability (604 lines)
│   ├── layer2-performance-specialist.md    # Performance (602 lines)
│   ├── layer2-data-integrity-specialist.md # Data integrity (574 lines)
│   └── layer3-verification.md              # Verification (513 lines)
│
├── # Claude Code auto-load template
├── claude-code/
│   └── CLAUDE.md.template              # Layer 0 for ~/.claude/CLAUDE.md
│
├── # Legacy/Lite snippets (condensed versions)
├── vscode/
│   └── review.code-snippets                # Condensed snippets (~30 lines each)
│
└── examples/
    └── example-review-output.md            # Sample review output
```

**Note:** Installers generate full-length snippets from `prompts/`. The Claude Code installer also installs Layer 0 to `~/.claude/CLAUDE.md` for automatic loading every session.

---

## 🎓 Why This Works

### Psychological Hack: Personas Give Permission

**Default AI behavior:**
```
User: "Review my code"
AI: "This looks good! Here are some minor suggestions..."
```

**With persona:**
```
User: "Review as Security Specialist with 15 years pen testing"
AI: "Critical: SQL injection on line 42. Attack scenario: ..."
```

The persona gives AI permission to be critical, unlocking skeptical analysis that default agreeable behavior suppresses.

---

## 🔧 Customization

### Edit Prompts

All prompts are in `prompts/` as plain markdown. Edit to fit your:
- Language/framework preferences
- Team coding standards
- Domain-specific concerns

### Add New Specialists

Create new files in `prompts/`:
```markdown
# My Custom Specialist

## Persona
[Your custom persona...]

## Your Task
[What to look for...]

## Output Format
[How to format findings...]
```

Then add a snippet in `vscode/review.code-snippets`.

---

## 📊 Example Output

See `examples/example-review-output.md` for a complete review of sample code.

**Quick Review finds:**
- **Critical:** SQL injection vulnerability
- **P1:** No rate limiting (brute force risk)
- **P2:** Duplicated email validation logic

**Verification confirms:**
- SQL injection ✅ Fixed (parameterized query)
- Rate limiting ⚠️ Partially fixed (needs testing)

---

## 🤝 Contributing

This is a living system. Improvements welcome:
1. Fork the repo
2. Add/improve prompts
3. Submit PR with examples

---

## 📚 Resources

**Research:**
- Addy Osmani, "AI writes code faster. Your job is still to prove it works." (January 2026)
- AI code quality studies showing 1.75-2.74x higher vulnerability rates

**Philosophy:**
- Prevention > Detection (Layer 0 prevents most issues)
- Prioritization matters (not everything is Critical)
- Verification is mandatory (for Critical/P1 fixes)

---

## 📝 License

MIT License - use freely at work or home.

---

## 🙏 Credits

Inspired by real-world AI code review challenges and the need for systematic quality gates in AI-assisted development.

**Created:** January 2026
**Status:** Production-ready v1.0
