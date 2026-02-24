# Skills Reorganization - Migration Guide

## What Changed

The skills have been reorganized into a chronological layer system that matches the actual code review workflow. Layer numbers now indicate **when** you use each skill.

## Old Name → New Name Mapping

### Your Existing Skills (Renamed)

| Old Name | New Name | New Layer | Reasoning |
|----------|----------|-----------|-----------|
| `layer0-generation-guidelines` | `layer0-prevention` | Layer 0 | Name clarified, still prevention |
| `layer1-quick-review` | `layer2a-quick-review` | Layer 2 | Moved to core review phase |
| `layer2-correctness-specialist` | `layer2b-correctness-specialist` | Layer 2 | Stays in core, added letter |
| `layer2-security-specialist` | `layer2c-security-specialist` | Layer 2 | Stays in core, added letter |
| `layer2-data-integrity-specialist` | `layer2d-data-integrity-specialist` | Layer 2 | Stays in core, added letter |
| `layer2-performance-specialist` | `layer3a-performance-specialist` | Layer 3 | Moved to specialized (not always needed) |
| `layer2-maintainability-specialist` | `layer3b-maintainability-specialist` | Layer 3 | Moved to specialized (not always needed) |
| `layer3-verification` | `layer6-verification` | Layer 6 | Moved to end of workflow |

### New Skills (Added)

| Name | Layer | Purpose |
|------|-------|---------|
| `layer1-planning` | Layer 1 | NEW: Plans which reviews to use |
| `layer3c-testability-specialist` | Layer 3 | NEW: Reviews testability |
| `layer3d-error-handling-specialist` | Layer 3 | NEW: Reviews error handling |
| `layer3e-concurrency-specialist` | Layer 3 | NEW: Reviews concurrency |
| `layer3f-prompt-injection-specialist` | Layer 3 | NEW: LLM security |
| `layer3g-token-efficiency-specialist` | Layer 3 | NEW: LLM optimization |
| `layer4a-code-smell-detector` | Layer 4 | NEW: Identifies anti-patterns |
| `layer4b-refactoring-advisor` | Layer 4 | NEW: Refactoring guidance |
| `layer5-fix-planning` | Layer 5 | NEW: Organizes fixes |

## New Layer System Explained

### Why the Reorganization?

**Old system issue:** 
- Layer 1 = First review
- Layer 2 = All specialists (but some always needed, some optional)
- Layer 3 = Verification
- **Problem:** Didn't indicate workflow sequence or priority

**New system:**
- Layer numbers = chronological order in workflow
- Letters within layers = suggested sequence (2a before 2b)
- Clear split: Core (always) vs Specialized (when relevant)

### The New Layers

**Layer 0: Prevention** (Before Coding)
- `layer0-prevention` - Prevent issues before they exist

**Layer 1: Planning** (Start of Review)  
- `layer1-planning` - Determines which skills to use

**Layer 2: Core Review** (Always Use These)
- `layer2a-quick-review` - First pass, 80%+ coverage
- `layer2b-correctness-specialist` - Logic errors
- `layer2c-security-specialist` - Security vulnerabilities
- `layer2d-data-integrity-specialist` - Data consistency

**Layer 3: Specialized Review** (Use When Relevant)
- `layer3a-performance-specialist` - Performance/scalability
- `layer3b-maintainability-specialist` - Code quality/readability
- `layer3c-testability-specialist` - Test coverage/mockability
- `layer3d-error-handling-specialist` - Error handling robustness
- `layer3e-concurrency-specialist` - Thread safety/race conditions
- `layer3f-prompt-injection-specialist` - LLM security
- `layer3g-token-efficiency-specialist` - LLM cost optimization

**Layer 4: Quality Assessment** (Improvement Strategy)
- `layer4a-code-smell-detector` - Identify anti-patterns
- `layer4b-refactoring-advisor` - Refactoring guidance

**Layer 5: Fix Planning** (After Review, Before Fixing)
- `layer5-fix-planning` - Organize findings into plan

**Layer 6: Verification** (After Fixes)
- `layer6-verification` - Verify fixes work

## Key Changes to Understand

### 1. Quick Review Moved to Layer 2

**Why:** It's not a planning step, it's the first actual review. Layer 2a indicates it's the first of the core reviews you always do.

### 2. Performance & Maintainability Moved to Layer 3

**Why:** These are important but not always necessary. Layer 3 = "use when relevant" vs Layer 2 = "always use."

**Example:**
- Config change: Don't need performance review
- Documentation: Don't need maintainability review
- Payment processing: DO need both

### 3. New Layer 1 for Planning

**Why:** You need to decide what to review BEFORE reviewing. Layer 1 (`planning`) analyzes code and recommends which Layer 2/3/4 skills to use.

**Workflow change:**
- **Old:** Start reviewing, hope you picked right skills
- **New:** Ask Layer 1 what to review, then do those reviews

### 4. Verification Moved to Layer 6 (End)

**Why:** It's the last step after fixes are made. Layer 6 makes this clear.

### 5. Letters Within Layers

**Example:** Layer 2 has 2a, 2b, 2c, 2d

**Why:** Suggests sequence within that layer:
- 2a (quick-review) = broad first pass
- 2b-2d (specialists) = deep dives after broad pass

## Migration Path

### If You're Using the Old Skills

1. **Immediate:** Continue using old skills, they still work
2. **When ready:** Download `code-review-skills-complete-v2.0.zip`
3. **Upload new skills:** They won't conflict with old ones (different names)
4. **Try new workflow:** Start with layer1-planning, follow its guidance
5. **Remove old skills:** Once comfortable with new system

### Recommended Adoption

**Week 1:** Add just `layer1-planning`
- Use it to determine which old skills to use
- Learn the new layer logic

**Week 2:** Replace Layer 2 skills
- Upload new `layer2a-d` skills
- These replace your old `layer1-quick-review` and `layer2-*-specialist` (core ones)

**Week 3:** Add Layer 3 specialized skills
- Upload the ones relevant to your work
- LLM apps: Add 3f, 3g
- Concurrent code: Add 3e
- Production APIs: Add 3d

**Week 4:** Add workflow skills
- `layer5-fix-planning` - organize fixes
- `layer6-verification` - verify fixes
- Complete the workflow

## Quick Start with New System

```
1. Code session starts → Use layer0-prevention

2. Code written, ready to review → Use layer1-planning
   "I need to review my payment processing code"
   → Layer 1 recommends: 2a, 2b, 2c, 2d, 3d
   
3. Follow recommendations → Run those reviews
   → Collect findings (Critical, P1, P2, P3)
   
4. Organize fixes → Use layer5-fix-planning
   → Get actionable plan with phases
   
5. Make fixes → Implement Critical and P1
   
6. Verify fixes → Use layer6-verification
   → Ensure fixes actually work
   
7. Merge → Code is ready
```

## Benefits of New System

1. **Clearer workflow** - Layer numbers show sequence
2. **Better prioritization** - Core (2) vs Specialized (3) vs Quality (4)
3. **Time savings** - Layer 1 prevents over-reviewing
4. **Better outcomes** - Layer 5 organizes fixes, Layer 6 verifies them
5. **Easier onboarding** - "Follow layer numbers 0→1→2..." is simple

## File Structure

Old structure:
```
layer0-generation-guidelines.md
layer1-quick-review.md
layer2-correctness-specialist.md
...
```

New structure:
```
layer0-prevention/
  SKILL.md
layer1-planning/
  SKILL.md
layer2-core-review/
  layer2a-quick-review/
    SKILL.md
  layer2b-correctness-specialist/
    SKILL.md
...
```

Each skill is now in its own folder with a standard `SKILL.md` filename, making the structure consistent with Claude's skill format.

## Questions?

**Q: Do I need to delete my old skills?**
A: No, they won't conflict. New skills have different names. Delete when ready.

**Q: Can I mix old and new?**
A: Yes, but confusing. Better to migrate completely once comfortable.

**Q: Which skills are most important?**
A: Layer 0 (prevention), Layer 1 (planning), Layer 2 (core review). These are the foundation.

**Q: Do I need all Layer 3 skills?**
A: No! That's the point. Layer 1 tells you which Layer 3 skills to use based on your code.

**Q: What if I just want the basics?**
A: Use Layer 0, 1, and 2. That covers 90% of needs.

## Summary

**What to remember:**
- Layer numbers = workflow sequence
- Layer 2 = always use (core)
- Layer 3 = use when relevant (specialized)  
- Layer 1 (planning) tells you what to use
- Layer 5 (fix planning) organizes the work
- Layer 6 (verification) ensures quality

**Bottom line:** The new system makes the workflow obvious and prevents both over-reviewing (wasted time) and under-reviewing (missed bugs).
