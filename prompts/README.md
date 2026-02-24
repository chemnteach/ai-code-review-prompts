# Code Review Skills - Complete Framework v2.0

**Insurance policies for AI-generated code.** Prevention first, systematic review as backup.

Research shows AI-generated code has **2.74x more XSS vulnerabilities** and **1.75x more logic errors** than human code. These skills give AI permission to be critical instead of agreeable.

---

## 🎯 The Problem

When you ask AI "Is this code good?", it's agreeable by default:
- ✅ "This looks great! Here are some minor suggestions..."

When you use **skills/personas**, AI becomes critical:
- ⚠️ "Critical: SQL injection on line 42. Attack scenario: ..."

**Skills unlock critical thinking that default behavior suppresses.**

---

## 🏗️ Seven-Layer System

```
Layer 0: Prevention       → Before writing code (session setup)
Layer 1: Planning         → Start of review (determine what to review)
Layer 2: Core Review      → Always use (80%+ coverage)
Layer 3: Specialized      → Use when relevant (deep dives)
Layer 4: Quality          → Improvement advisors
Layer 5: Fix Planning     → After review, before fixing
Layer 6: Verification     → After fixes, before merge
```

**Total:** 17 skills across 7 layers

---

## 📥 Installation by Platform

### Quick Start - Choose Your Environment

| Platform | Installation Time | Best For |
|----------|------------------|----------|
| **[Claude.ai](#claudeai-webmobile)** | 5 min | Individual users, web-based |
| **[Claude Code](#claude-code)** | 5 min | Developers, full codebase integration |
| **[VS Code](#vs-code)** | 10 min | Any AI extension (Copilot, Continue, etc.) |
| **[JetBrains](#jetbrains-ides)** | 10 min | IntelliJ, PyCharm, WebStorm, Rider |
| **[Visual Studio](#visual-studio)** | 10 min | VS 2022 + Copilot |
| **[API](#via-api)** | N/A | Programmatic use, automation |
| **[Manual](#manual--any-other-ide)** | 0 min | Copy-paste to any AI chat |

---

## 🚀 Platform-Specific Installation

### Claude.ai (Web/Mobile)

**What you'll use:** Claude Skills (upload .zip files)

**Installation:**
1. Download: `code-review-skills-complete-v2.0.zip`
2. Extract to see skill folders
3. Zip individual skills (e.g., compress `layer1-planning/` → `layer1-planning.zip`)
4. Upload: Settings → Capabilities → Skills → Upload skill
5. Enable for your projects/conversations

**Layer 0 (Prevention) - Two Options:**

**Option 1 (Recommended):** Upload as skill
```
1. Zip layer0-prevention/ folder
2. Upload to Skills
3. Enable for coding projects
4. Automatically applies to all coding sessions
```

**Option 2:** Paste at session start
```
"Before we start coding, follow these generation guidelines:
[paste layer0-prevention/SKILL.md content]

Now, help me build a user authentication system"
```

**Layer 1-6 (Review Skills):**
- Auto-activate based on trigger phrases
- Or invoke explicitly: "Use layer2a-quick-review"
- Example: "Review my payment code" → planning skill activates

**When to use which:**
- Start coding session → Enable layer0-prevention
- Start review → "Use layer1-planning" or let it trigger
- Follow recommendations → Use suggested specialists

---

### Claude Code

**What you'll use:** Claude Skills (native integration)

**Installation:**

Choose your operating system:

<details>
<summary><strong>Linux/Mac Installation</strong></summary>

```bash
# Download and extract (choose one method)
# Method 1: wget
wget https://github.com/your-repo/releases/download/v2.0/code-review-skills-complete-v2.0.zip
unzip code-review-skills-complete-v2.0.zip

# Method 2: curl
curl -L -O https://github.com/your-repo/releases/download/v2.0/code-review-skills-complete-v2.0.zip
unzip code-review-skills-complete-v2.0.zip

# Create Claude Code skills directory
mkdir -p ~/.claude/skills

# Copy all skills
cp -r reorganized-skills/layer*-*/layer*/ ~/.claude/skills/

# Verify installation
ls ~/.claude/skills/
# Should see: layer0-prevention/, layer1-planning/, layer2a-quick-review/, etc.
```
</details>

<details>
<summary><strong>Windows Installation (PowerShell)</strong></summary>

```powershell
# Download (choose one method)
# Method 1: Using PowerShell (Windows 10+)
Invoke-WebRequest -Uri "https://github.com/your-repo/releases/download/v2.0/code-review-skills-complete-v2.0.zip" -OutFile "code-review-skills-complete-v2.0.zip"

# Method 2: Manual download
# Download from GitHub releases page and save to current directory

# Extract the zip file
Expand-Archive -Path "code-review-skills-complete-v2.0.zip" -DestinationPath "." -Force

# Create Claude Code skills directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills" -Force

# Copy all skills
Get-ChildItem -Path "reorganized-skills\layer*-*\layer*" -Directory | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$env:USERPROFILE\.claude\skills\" -Recurse -Force
}

# Verify installation
Get-ChildItem "$env:USERPROFILE\.claude\skills\"
# Should see: layer0-prevention, layer1-planning, layer2a-quick-review, etc.
```
</details>

**Alternative: Manual Installation (All OS)**

If scripts don't work, manually copy folders:

1. Extract `code-review-skills-complete-v2.0.zip`
2. Navigate into `reorganized-skills/` folder
3. Copy all `layer*` folders from inside each layer group folder
4. Paste into:
   - **Linux/Mac:** `~/.claude/skills/`
   - **Windows:** `C:\Users\YourName\.claude\skills\`

Each skill should be a folder with a `SKILL.md` file inside.

**Layer 0 (Prevention):**
```
# Enable for project → Applies to all coding automatically
# OR invoke explicitly when starting
/layer0-prevention
```

**Layer 1-6 (Review Skills):**
```bash
# Planning - determines what to review
/layer1-planning
"Review my payment processing module"

# Quick review - first pass
/layer2a-quick-review

# Specialists - as recommended
/layer2c-security-specialist
/layer3a-performance-specialist

# Fix planning
/layer5-fix-planning

# Verification
/layer6-verification
```

**Key Advantage:** Claude Code sees entire codebase, no copy-paste needed

---

### VS Code

**What you'll use:** Code Snippets (text expansion for AI extensions)

**What are snippets?**
- Type prefix (e.g., `review-quick`) → Tab → Full prompt expands
- Your selected code is automatically embedded
- Copy expanded text → Paste to AI chat (Copilot, Continue, etc.)

**Compatible AI extensions:**
- GitHub Copilot Chat
- Continue (open source)
- Cody (Sourcegraph)
- Codeium
- Amazon Q

**Installation:**

**Snippets File Location:**

<details>
<summary><strong>Linux</strong></summary>

```bash
# Create snippets directory
mkdir -p ~/.config/Code/User/snippets

# Navigate to directory
cd ~/.config/Code/User/snippets
```

Create or edit: `review.code-snippets`
</details>

<details>
<summary><strong>Mac</strong></summary>

```bash
# Create snippets directory
mkdir -p ~/Library/Application\ Support/Code/User/snippets

# Navigate to directory
cd ~/Library/Application\ Support/Code/User/snippets
```

Create or edit: `review.code-snippets`
</details>

<details>
<summary><strong>Windows</strong></summary>

```powershell
# Snippets directory (usually exists already)
# Navigate using File Explorer or PowerShell:
cd $env:APPDATA\Code\User\snippets

# If directory doesn't exist:
New-Item -ItemType Directory -Path "$env:APPDATA\Code\User\snippets" -Force
```

Create or edit: `review.code-snippets`

**Full path:** `C:\Users\YourName\AppData\Roaming\Code\User\snippets\review.code-snippets`
</details>

**Alternative: Via VS Code UI (All OS)**

1. Open VS Code
2. File → Preferences → Configure User Snippets (or Ctrl+Shift+P → "snippets")
3. Select "New Global Snippets file..."
4. Name it: `review`
5. This creates `review.code-snippets` in the correct location automatically

Create file: `review.code-snippets`

```json
{
  "Layer 0 - Prevention Guidelines": {
    "prefix": "review-gen",
    "body": [
      "Before we start coding, follow these generation guidelines:",
      "",
      "# Critical: Manage Your Uncertainty",
      "- Stop when uncertain - ask before proceeding",
      "- Surface confusion immediately",
      "- Flag inconsistencies in requirements",
      "...[full layer0-prevention/SKILL.md content]...",
      "",
      "Now, help me: $1"
    ],
    "description": "Layer 0 - Prevention (use at session start)"
  },
  
  "Layer 1 - Planning": {
    "prefix": "review-plan",
    "body": [
      "...[full layer1-planning/SKILL.md content]...",
      "",
      "Code to analyze:",
      "${TM_SELECTED_TEXT}",
      "$1"
    ],
    "description": "Layer 1 - Determine which reviews to run"
  },
  
  "Layer 2a - Quick Review": {
    "prefix": "review-quick",
    "body": [
      "...[full layer2a-quick-review/SKILL.md content]...",
      "",
      "Code to review:",
      "${TM_SELECTED_TEXT}",
      "$1"
    ],
    "description": "Layer 2a - Quick Review (80%+ coverage)"
  },
  
  "Layer 2c - Security Specialist": {
    "prefix": "review-security",
    "body": [
      "...[full layer2c-security-specialist/SKILL.md content]...",
      "",
      "Code to review:",
      "${TM_SELECTED_TEXT}",
      "$1"
    ],
    "description": "Layer 2c - Security deep dive"
  }
  
  // Add more snippets for other layers as needed...
}
```

**Note:** Replace `...[full SKILL.md content]...` with actual content from each skill's SKILL.md file.

**Usage:**
1. **Layer 0 (once per session):** Type `review-gen` → Tab → Copy to AI chat
2. **Layer 1-6:** Select code → Type `review-quick` → Tab → Copy to AI chat

**Key Limitation:** AI extensions only see pasted code, not full codebase

---

### JetBrains IDEs

**What you'll use:** Live Templates (JetBrains' version of snippets)

**Supported IDEs:**
- IntelliJ IDEA
- PyCharm
- WebStorm
- Rider
- PhpStorm
- GoLand
- RubyMine

**Compatible AI features:**
- JetBrains AI Assistant (built-in)
- GitHub Copilot plugin
- Any AI chat panel

**Installation:**

1. Settings → Editor → Live Templates
2. Click `+` → Template Group → Name: "Code Review Skills"
3. Click `+` → Live Template
4. Configure each template:

**Example: Layer 2a Quick Review**
- Abbreviation: `review-quick`
- Description: "Layer 2a - Quick Review (80%+ coverage)"
- Template text:
```
[full layer2a-quick-review/SKILL.md content]

Code to review:
$SELECTION$
$END$
```
- Applicable in: Everywhere (or specific languages)
- Click "Define" → Select contexts

**Create templates for each layer:**
- `review-gen` → Layer 0 Prevention
- `review-plan` → Layer 1 Planning
- `review-quick` → Layer 2a Quick Review
- `review-security` → Layer 2c Security
- `review-correctness` → Layer 2b Correctness
- `review-data` → Layer 2d Data Integrity
- `review-perf` → Layer 3a Performance
- `review-maint` → Layer 3b Maintainability
- `review-test` → Layer 3c Testability
- `review-errors` → Layer 3d Error Handling
- `review-concurrency` → Layer 3e Concurrency
- `review-llm-security` → Layer 3f Prompt Injection
- `review-llm-tokens` → Layer 3g Token Efficiency
- `review-smells` → Layer 4a Code Smells
- `review-refactor` → Layer 4b Refactoring
- `review-fixplan` → Layer 5 Fix Planning
- `review-verify` → Layer 6 Verification

**Usage:**
1. Select code in editor
2. Type `review-quick` or press Ctrl+J (Cmd+J on Mac)
3. Select template from list
4. Template expands with your code
5. Copy to AI chat (AI Assistant, Copilot, etc.)

**Note:** Restart IDE after adding templates to load them

---

### Visual Studio

**What you'll use:** Code Snippets (.snippet files)

**Supported versions:** Visual Studio 2022 17.8+

**Compatible AI features:**
- GitHub Copilot
- JetBrains AI Assistant (via ReSharper)
- Visual Studio IntelliCode

**Installation:**

**Snippets Location (Windows):**

Full path: `C:\Users\YourName\Documents\Visual Studio 2022\Code Snippets\Visual C#\My Code Snippets\`

**Creating Snippets (Choose One Method):**

<details>
<summary><strong>Method 1: PowerShell Script</strong></summary>

```powershell
# Set snippets directory path
$snippetsPath = "$env:USERPROFILE\Documents\Visual Studio 2022\Code Snippets\Visual C#\My Code Snippets"

# Create directory if needed
New-Item -ItemType Directory -Path $snippetsPath -Force

# Navigate to directory
Set-Location $snippetsPath

# Now create .snippet XML files here
# (See example format below)
```
</details>

<details>
<summary><strong>Method 2: Via Visual Studio UI (Easiest)</strong></summary>

1. Open Visual Studio 2022
2. Tools → Code Snippets Manager (Ctrl+K, Ctrl+B)
3. Language: Select "Visual C#" (or your language)
4. Note the location shown in the manager
5. Create .snippet files in that location
6. Or use "Import..." button to import existing .snippet files
</details>

<details>
<summary><strong>Method 3: Snippet Designer Extension</strong></summary>

Install "Snippet Designer" from Visual Studio Marketplace for GUI-based snippet creation
</details>

**Example: review-quick.snippet**
```xml
<?xml version="1.0" encoding="utf-8"?>
<CodeSnippets>
  <CodeSnippet Format="1.0.0">
    <Header>
      <Title>Quick Review - Layer 2a</Title>
      <Shortcut>review-quick</Shortcut>
      <Description>Comprehensive code review (80%+ coverage)</Description>
    </Header>
    <Snippet>
      <Code Language="csharp">
        <![CDATA[[Full layer2a-quick-review/SKILL.md content here]

Code to review:
$selected$
$end$]]>
      </Code>
    </Snippet>
  </CodeSnippet>
</CodeSnippets>
```

**Create snippets for each layer** using the same pattern, changing:
- Title
- Shortcut (review-gen, review-plan, review-security, etc.)
- Description
- SKILL.md content

**Usage:**
1. Select code in editor
2. Type `review-quick` → Tab twice
3. Template expands with selected code
4. Copy to Copilot/AI chat

---

### Via API

**What you'll use:** Anthropic API with Skills parameter or system prompts

**Option 1: Skills API (Recommended)**
```python
from anthropic import Anthropic

client = Anthropic(api_key="your-key")

# Attach skills to conversation
response = client.messages.create(
    model="claude-sonnet-4-20250514",
    skills=["layer1-planning", "layer2a-quick-review"],
    messages=[
        {"role": "user", "content": "Review this payment code: ..."}
    ]
)
```

**Option 2: System Prompt Injection**
```python
# Read skill content
with open('reorganized-skills/layer0-prevention/SKILL.md', 'r') as f:
    prevention = f.read()

# Include in system prompt
messages = [
    {
        "role": "system",
        "content": f"You are a coding assistant.\n\n{prevention}"
    },
    {
        "role": "user",
        "content": "Help me build authentication"
    }
]

response = client.messages.create(
    model="claude-sonnet-4-20250514",
    messages=messages
)
```

**Layer 0 (Prevention):**
- Include in system prompt for session-wide guidelines
- Applies to all code generation

**Layers 1-6 (Review):**
- Attach via skills parameter, OR
- Include skill content in user message with code to review

---

### Manual / Any Other IDE

**What you'll use:** Direct copy-paste from SKILL.md files

**Installation:** None needed

**Usage:**
1. Navigate to `reorganized-skills/` folder
2. Choose skill (e.g., `layer2a-quick-review/SKILL.md`)
3. Open file and copy entire content
4. Paste into AI chat

**Example workflow:**
```
Step 1: Open layer2a-quick-review/SKILL.md
Step 2: Copy all content (Ctrl+A, Ctrl+C)
Step 3: Paste into ChatGPT/Claude/Gemini
Step 4: Add your code below:

"Code to review:
[paste your code here]"
```

**Works with:** Any AI chat interface (ChatGPT, Claude.ai, Gemini, Copilot web, etc.)

---

## 📊 Platform Comparison Table

| Feature | Claude Code | Claude.ai | VS Code Snippets | JetBrains Templates | Visual Studio | API |
|---------|-------------|-----------|------------------|---------------------|---------------|-----|
| **Layer 0 auto-load** | ✅ Enable for project | ✅ Upload skill | ⚠️ Paste per session | ⚠️ Paste per session | ⚠️ Paste per session | ✅ System prompt |
| **Mechanism** | Native skills | Native skills | Code snippets | Live templates | Code snippets | Skills/prompts |
| **Select code** | ❌ Sees codebase | ❌ Has context | ✅ Required | ✅ Required | ✅ Required | ❌ Send in message |
| **Copy/paste to AI** | ❌ Direct invoke | ❌ Auto-triggers | ✅ Yes | ✅ Yes | ✅ Yes | ❌ API call |
| **AI sees codebase** | ✅ Full access | ⚠️ Project context | ❌ Only pasted | ❌ Only pasted | ❌ Only pasted | ⚠️ Depends |
| **Skill storage** | ~/.claude/skills/ | Cloud (uploaded) | snippets file | Live templates | .snippet files | Code/config |
| **Invocation** | `/skill-name` | Auto or manual | prefix + Tab | abbr or Ctrl+J | prefix + Tab Tab | Parameter/prompt |
| **Best for** | Developers | All users | AI extensions | JetBrains users | VS 2022 users | Automation |
| **Setup time** | 5 min | 5 min | 10-15 min | 10-15 min | 10-15 min | Varies |

---

## 🔄 Usage Workflows

### Complete Review Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. SESSION START (Layer 0: Prevention)                     │
│     Claude Code: Enable skill                               │
│     Claude.ai: Enable skill or paste                        │
│     IDE Snippets: review-gen → Tab → Paste to AI           │
│     Guidelines active for session                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. WRITE CODE                                              │
│     AI follows prevention guidelines                        │
│     Asks questions when uncertain                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. START REVIEW (Layer 1: Planning)                        │
│     Claude Code: /layer1-planning                           │
│     Claude.ai: "Use layer1-planning"                        │
│     IDE: review-plan → Tab → Paste                          │
│     → Recommends which reviews to run                       │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. CORE REVIEW (Layer 2: Always Use)                       │
│     2a: Quick Review (80%+ coverage)                        │
│     2b-d: Specialists as recommended                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
              ┌───────────────┴───────────────┐
              │                               │
              ↓                               ↓
┌─────────────────────────┐     ┌─────────────────────────────┐
│  No Critical/P1 issues  │     │  5. SPECIALIZED REVIEW      │
│  → Skip to step 7       │     │     (Layer 3: When Relevant)│
└─────────────────────────┘     │     Run deep dives          │
                                └─────────────┬───────────────┘
                                              ↓
                                ┌─────────────────────────────┐
                                │  6. FIX PLANNING            │
                                │     (Layer 5)               │
                                │     Organize findings       │
                                │     → Blocking/Required/... │
                                └─────────────┬───────────────┘
                                              ↓
                                ┌─────────────────────────────┐
                                │  7. MAKE FIXES              │
                                │     Implement Critical/P1   │
                                └─────────────┬───────────────┘
                                              ↓
                                ┌─────────────────────────────┐
                                │  8. VERIFICATION            │
                                │     (Layer 6)               │
                                │     Verify fixes work       │
                                └─────────────┬───────────────┘
                                              ↓
                                ┌─────────────────────────────┐
                                │  9. MERGE                   │
                                │     Code ready ✅           │
                                └─────────────────────────────┘
```

### Layer 0: Prevention Examples by Platform

**Claude Code:**
```bash
# One-time: Enable layer0-prevention for project
# Then just start coding:
"Build a user authentication system"
# Prevention guidelines already active
```

**Claude.ai:**
```
# Option 1: Enable skill (recommended)
Settings → Skills → Enable layer0-prevention

# Option 2: Paste at start
"Follow these guidelines: [paste layer0 content]
Now, build user authentication"
```

**VS Code:**
```
1. Type: review-gen → Tab
2. Copy expanded guidelines
3. Paste to AI chat (Copilot/Continue/etc.)
4. Add: "Now build user authentication"
```

**JetBrains:**
```
1. Ctrl+J (Cmd+J on Mac)
2. Select "review-gen" template
3. Copy expanded text
4. Paste to AI Assistant
5. Add: "Now build user auth"
```

---

## 📋 Skill Reference

### Snippet Prefixes (All IDEs)

| Prefix | Layer | Skill Name | When to Use |
|--------|-------|------------|-------------|
| `review-gen` | 0 | Prevention | Session start |
| `review-plan` | 1 | Planning | Start of review |
| `review-quick` | 2a | Quick Review | Every review (first pass) |
| `review-correctness` | 2b | Correctness | Complex logic |
| `review-security` | 2c | Security | User-facing, sensitive data |
| `review-data` | 2d | Data Integrity | Database, data operations |
| `review-perf` | 3a | Performance | High traffic, queries |
| `review-maint` | 3b | Maintainability | Long-lived code |
| `review-test` | 3c | Testability | Low test coverage |
| `review-errors` | 3d | Error Handling | Production code |
| `review-concurrency` | 3e | Concurrency | Threads, async |
| `review-llm-security` | 3f | Prompt Injection | LLM applications |
| `review-llm-tokens` | 3g | Token Efficiency | LLM API costs |
| `review-smells` | 4a | Code Smells | Before refactoring |
| `review-refactor` | 4b | Refactoring Advisor | Considering refactor |
| `review-fixplan` | 5 | Fix Planning | After reviews |
| `review-verify` | 6 | Verification | After Critical/P1 fixes |

### Layer Details

**Layer 0: Prevention**
- `layer0-prevention`: Load at session start, prevents issues before coding

**Layer 1: Planning**
- `layer1-planning`: Analyzes code and recommends which reviews to run

**Layer 2: Core Review** (Always use)
- `layer2a-quick-review`: 80%+ coverage, first pass
- `layer2b-correctness-specialist`: Logic errors, edge cases
- `layer2c-security-specialist`: Injection, auth, secrets
- `layer2d-data-integrity-specialist`: Validation, transactions, consistency

**Layer 3: Specialized** (Use when relevant)
- `layer3a-performance-specialist`: N+1 queries, O(n²), scalability
- `layer3b-maintainability-specialist`: Readability, coupling, naming
- `layer3c-testability-specialist`: Dependencies, mocking, test coverage
- `layer3d-error-handling-specialist`: Exception handling, recovery, messages
- `layer3e-concurrency-specialist`: Race conditions, deadlocks, thread safety
- `layer3f-prompt-injection-specialist`: LLM security, adversarial prompts
- `layer3g-token-efficiency-specialist`: Token optimization, API costs

**Layer 4: Quality Assessment**
- `layer4a-code-smell-detector`: Anti-patterns, design problems
- `layer4b-refactoring-advisor`: When/how to refactor safely

**Layer 5: Fix Planning**
- `layer5-fix-planning`: Organize findings into actionable plan

**Layer 6: Verification**
- `layer6-verification`: Verify Critical/P1 fixes actually work

---

## 📖 Priority Levels

| Level | Meaning | Action | Verification |
|-------|---------|--------|--------------|
| **Critical** | Will cause problems now | Fix before commit | ✅ Required (Layer 6) |
| **P1** | Time bomb - fails later | Fix before release | ✅ Required (Layer 6) |
| **P2** | Technical debt | Track, fix eventually | ⚠️ Optional |
| **P3** | Style/nitpicks | Optional | ❌ Not needed |

---

## 💡 Common Workflows by Code Type

### Authentication/Security Code
```
Layer 1: Planning
Layer 2a: Quick Review
Layer 2c: Security (deep dive)
Layer 2b: Correctness
Layer 2d: Data Integrity
Layer 5: Fix Planning
[Fix]
Layer 6: Verification
```

### Payment Processing
```
Layer 1: Planning
Layer 2: All core reviews (a-d)
Layer 3c: Security (deep)
Layer 3d: Error Handling
Layer 5: Fix Planning
[Fix]
Layer 6: Verification (mandatory)
```

### Database/Data Layer
```
Layer 1: Planning
Layer 2a: Quick Review
Layer 2d: Data Integrity (deep)
Layer 3a: Performance
Layer 5: Fix Planning
```

### LLM Applications
```
Layer 1: Planning
Layer 2a: Quick Review
Layer 2c: Security
Layer 3f: Prompt Injection (deep)
Layer 3g: Token Efficiency
Layer 5: Fix Planning
```

---

## 🎓 Why This Works

### Psychological Hack: Skills/Personas Give Permission

**Default AI behavior:**
```
User: "Review my code"
AI: "This looks good! Minor suggestions..."
```

**With skills/personas:**
```
User: "Use layer2c-security-specialist"
AI: "Critical: SQL injection line 42. Attack scenario: ..."
```

Skills give AI permission to be critical, unlocking skeptical analysis that default agreeable behavior suppresses.

---

## 📁 Package Contents

```
code-review-skills-complete-v2.0.zip
└── reorganized-skills/
    ├── README.md                           # This file
    ├── QUICK_REFERENCE.md                  # One-page cheat sheet
    ├── MIGRATION_GUIDE.md                  # Old→New mapping
    │
    ├── layer0-prevention/SKILL.md          # Session guidelines
    ├── layer1-planning/SKILL.md            # Review planning
    │
    ├── layer2-core-review/
    │   ├── layer2a-quick-review/SKILL.md
    │   ├── layer2b-correctness-specialist/SKILL.md
    │   ├── layer2c-security-specialist/SKILL.md
    │   └── layer2d-data-integrity-specialist/SKILL.md
    │
    ├── layer3-specialized-review/
    │   ├── layer3a-performance-specialist/SKILL.md
    │   ├── layer3b-maintainability-specialist/SKILL.md
    │   ├── layer3c-testability-specialist/SKILL.md
    │   ├── layer3d-error-handling-specialist/SKILL.md
    │   ├── layer3e-concurrency-specialist/SKILL.md
    │   ├── layer3f-prompt-injection-specialist/SKILL.md
    │   └── layer3g-token-efficiency-specialist/SKILL.md
    │
    ├── layer4-quality-assessment/
    │   ├── layer4a-code-smell-detector/SKILL.md
    │   └── layer4b-refactoring-advisor/SKILL.md
    │
    ├── layer5-fix-planning/SKILL.md
    └── layer6-verification/SKILL.md
```

**Total:** 17 skills, 7 layers

---

## 🔧 Customization

All skills are plain markdown. Edit `SKILL.md` files to customize:
- Language/framework preferences
- Team coding standards
- Domain-specific concerns

Create new skills following the pattern:
```markdown
---
name: my-custom-skill
description: What it does. Use when... Triggers on...
allowed-tools: []
---

# My Custom Skill

**Purpose:** ...
**When to use:** ...

## Persona
[Expert mindset]

## Your Task
[What to analyze]

## Output Format
[How to structure findings]
```

---

## 🤝 Contributing

Improvements welcome:
1. Fork repo
2. Add/improve skills
3. Test across platforms
4. Submit PR with examples

---

## 📚 Resources

**Research:**
- Addy Osmani, "AI writes code faster. Your job is still to prove it works." (January 2026)
- AI code quality studies: 1.75-2.74x higher vulnerability rates

**Philosophy:**
- Prevention > Detection (Layer 0)
- Planning > Guessing (Layer 1)
- Verification is mandatory (Layer 6)

---

## 📝 License

MIT License - use freely

---

## 🙏 Credits

Created: January 2026  
Version: 2.0  
Status: Production-ready

Inspired by real-world AI code review challenges and the need for systematic quality gates.

---

**Get Started:** Download `code-review-skills-complete-v2.0.zip` and follow the installation guide for your platform above.
