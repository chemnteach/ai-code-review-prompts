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
│  Paste at session start                │
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

### For VS Code (Work or Home)

1. **Copy snippets file:**
   ```bash
   cp vscode/review.code-snippets ~/.vscode/snippets/
   # Or for a workspace:
   cp vscode/review.code-snippets .vscode/review.code-snippets
   ```

2. **At session start, type:**
   ```
   review-gen
   ```
   Paste the generation guidelines into your AI chat.

3. **After writing code:**
   - Select the code
   - Type `review-quick`
   - Paste into AI chat
   - Get comprehensive review

4. **For deep dives:**
   - `review-security` - Security analysis
   - `review-correctness` - Logic errors
   - `review-maint` - Maintainability
   - `review-perf` - Performance
   - `review-data` - Data integrity

5. **After fixing Critical/P1:**
   - `review-verify` - Verify fixes actually work

### For Claude Code (Home)

The prompts work the same way - just paste them directly into your Claude Code session.

**Optional:** Create skills for one-command reviews:
```bash
# Copy prompt files to Claude Code skills
cp prompts/*.md ~/.claude/skills/
```

Then use: `/layer1-quick-review` instead of copy-paste.

---

## 📋 Priority Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **Critical** | Will cause problems | Fix now |
| **P1** | Time bomb - works now, fails later | Fix soon or accept risk |
| **P2** | Technical debt | Track, fix eventually |
| **P3** | Style/nitpicks | Optional |

---

## 💡 Usage Patterns

### Solo Developer Workflow

```
1. Start session with Generation Guidelines (review-gen)
2. Write code with AI
3. Run Quick Review (review-quick)
4. Fix Critical/P1 issues
5. Run Verification (review-verify)
6. Ship when Verification passes
```

### On-Demand Deep Dive

```
"Run Security Specialist on auth.py"
"Run Correctness Specialist on the payment logic"
"Run Performance Specialist on the database queries"
```

### Full Audit

```
"Run Quick Review on entire codebase"
"Run all Specialists and give consolidated report"
```

---

## 📁 What's Included

```
ai-code-review-prompts/
├── README.md                               # This file
├── prompts/
│   ├── layer0-generation-guidelines.md     # Prevention (paste at start)
│   ├── layer1-quick-review.md              # 80% use case
│   ├── layer2-security-specialist.md       # Security deep dive
│   ├── layer2-correctness-specialist.md    # Logic errors
│   ├── layer2-maintainability-specialist.md
│   ├── layer2-performance-specialist.md
│   ├── layer2-data-integrity-specialist.md
│   └── layer3-verification.md              # Verify fixes
├── vscode/
│   └── review.code-snippets                # VS Code snippets (8 snippets)
├── claude-code/
│   └── skills/                             # (Optional) Claude Code skills
└── examples/
    └── example-review-output.md            # Sample review
```

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
