# Code Review Skills - Quick Reference

## The Golden Path (Most Common Use)

1. **Before coding:** Use `layer0-prevention`
   - Claude Code: Enable as project skill (applies automatically)
   - Claude.ai: Upload skill and enable, OR paste guidelines in first message
   - API: Include in system prompt
   
2. **Starting review:** Use `layer1-planning` → follow its recommendations

3. **After review:** Use `layer5-fix-planning` → organize fixes

4. **After fixes:** Use `layer6-verification` → verify Critical/P1 fixes

## How Skills Work in Different Environments

**Claude Code:**
- Skills in project directory auto-load
- Layer 0: Enables prevention for all coding
- Layers 1-6: Invoke by trigger phrase or explicit request

**Claude.ai:**
- Upload skills via Settings → Capabilities → Skills
- Enable for conversations/projects
- Activate by trigger phrases or explicit invocation

**API:**
- Attach via skills parameter (if supported)
- Or include skill content in system/user prompts

**Key difference for Layer 0:**
- Other layers: Invoke when needed ("review this code")
- Layer 0: Load once at session start, applies to all subsequent coding

## Skill Selection Cheat Sheet

### Always Use (Layer 2 - Core Review)
- `layer2a-quick-review` - First pass, 80% coverage
- `layer2b-correctness-specialist` - Logic errors
- `layer2c-security-specialist` - Security vulnerabilities  
- `layer2d-data-integrity-specialist` - Data consistency

### Use When Relevant (Layer 3 - Specialized)
- `layer3a-performance-specialist` → High traffic, queries, loops
- `layer3b-maintainability-specialist` → Complex or long-lived code
- `layer3c-testability-specialist` → Low test coverage
- `layer3d-error-handling-specialist` → Production/API code
- `layer3e-concurrency-specialist` → Threads, async, locks
- `layer3f-prompt-injection-specialist` → LLM applications
- `layer3g-token-efficiency-specialist` → High LLM API costs

### Use for Code Quality (Layer 4)
- `layer4a-code-smell-detector` → Before refactoring
- `layer4b-refactoring-advisor` → Deciding to refactor

## Time Estimates

| Change Type | Layers to Use | Time |
|-------------|---------------|------|
| Config/Docs | 2a only | 15 min |
| Small change | 1, 2a | 30 min |
| Standard feature | 1, 2a-d | 1-2 hours |
| Critical path | 1, 2a-d, 3 (selected), 5, 6 | 3-4 hours |
| Major refactor | 1, 2, 4, 5, 6 | 4-6 hours |

## Priority Levels

- **Critical:** Fix now (security, data corruption, logic errors)
- **P1:** Fix before release (time bombs, incomplete features)
- **P2:** Fix soon (tech debt, maintainability)
- **P3:** Optional (nitpicks, style)

## Code Type → Skills Mapping

| Code Type | Must Use | Consider |
|-----------|----------|----------|
| Authentication | 2a, 2c, 2d | 3d |
| Payments | 2a, 2b, 2c, 2d | 3d |
| API Endpoint | 2a, 2c, 2d | 3a, 3d |
| Database | 2a, 2b, 2d | 3a |
| Concurrent | 2a, 2b | 3e |
| LLM App | 2a, 2c | 3f, 3g |
| Complex Logic | 2a, 2b | 3b |
| Production | 2a, 2b, 2c | 3d |

## Red Flags = Use These Skills

| Red Flag | Use Skill |
|----------|-----------|
| User input | 2c (Security) |
| Database ops | 2d (Data Integrity) |
| Money/payments | 2c, 2b, 2d |
| External APIs | 3d (Error Handling) |
| Loops/algorithms | 3a (Performance) |
| Threads/async | 3e (Concurrency) |
| No tests | 3c (Testability) |
| Complex logic | 2b (Correctness) |
| LLM calls | 3f, 3g |

## When to Skip Reviews

- Documentation only → Quick scan, no formal review
- Whitespace/formatting → No review needed
- Simple config → 2a only
- Reverting changes → No review (assuming original was reviewed)

## Workflow Shortcuts

**Fast track (30 min):**
```
layer1-planning → layer2a-quick-review → done
```

**Standard (1-2 hours):**
```
layer1-planning → layer2 (all) → layer5-fix-planning
```

**Critical (3-4 hours):**
```
layer1 → layer2 (all) → layer3 (selected) → layer5 → [fix] → layer6
```

## Common Mistakes to Avoid

❌ Skipping Layer 1 Planning (wastes time on unnecessary reviews)
❌ Using Layer 3 for everything (over-reviewing simple changes)
❌ Skipping Layer 6 Verification (incomplete fixes slip through)
❌ Not using Layer 5 Fix Planning (chaotic fix process)
❌ Forgetting Layer 0 Prevention (issues could have been prevented)

## Key Principle

**Match review depth to code risk.**
- Over-reviewing wastes time
- Under-reviewing ships bugs
- Let Layer 1 Planning guide you
