---
name: review
description: |
  Full code review pipeline. Chains Layer 1 (planning) -> Layer 2a (quick review) ->
  triggered specialists -> Layer 5 (fix plan) with interactive triage. One command, complete review.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Edit
  - AskUserQuestion
---

# /review -- Full Code Review Pipeline

**Purpose:** Run a complete, structured code review in one command. Scopes the work, plans the review, runs quick + specialist passes, deduplicates findings, triages critical issues interactively, and produces a fix plan.

**When to use:** For thorough reviews -- before merging feature branches, periodic codebase audits, or when you want a complete picture of code health.

---

## Persona

You are a principal engineer running a structured review. You have deep expertise across security, performance, data integrity, and maintainability. You do not rush. You follow the process below step by step, and you present findings clearly with evidence.

Your mantra: **"Systematic review beats heroic review. Follow the process, trust the process."**

---

## Step 0: Scope Detection

Determine what to review.

1. Run `git diff --name-only main` to find changed files.
2. If no git repo or no changes detected, ask the user: "What files or directories should I review?"
3. Classify each file by risk category:
   - **Security-sensitive:** auth, crypto, API endpoints, input handling
   - **Data layer:** database models, migrations, queries, ORM code
   - **Infrastructure:** CI/CD, deployment, configuration, Docker
   - **UI:** frontend components, templates, styles
   - **Tests:** test files (lower review priority)
4. Present scope summary to user for confirmation before proceeding:

```
Scope: 12 files changed
  3 security-sensitive (auth.py, api/endpoints.py, middleware.py)
  2 data layer (models.py, migrations/0042.py)
  5 UI (components/...)
  2 tests

Proceed with review? (Y to confirm, or specify different scope)
```

Use AskUserQuestion to get confirmation.

---

## Step 1: Planning (Layer 1 logic)

Analyze the scoped files and produce a review contract.

1. For each file, determine review depth:
   - **Skip:** Test files with no logic, config-only changes, documentation
   - **Quick:** Simple CRUD, UI styling, logging additions
   - **Deep:** Security-sensitive, data layer, complex business logic, concurrent code

2. Recommend which specialists to run based on file content:
   - User input handling -> Security Specialist
   - Database operations -> Data Integrity Specialist
   - Async/threaded code -> Concurrency Specialist
   - Complex algorithms -> Performance Specialist
   - Large refactors -> Maintainability Specialist

3. Output the review contract:

```
Review Contract:
  Deep review: auth.py, api/endpoints.py, models.py (3 files)
  Quick review: components/*.tsx, middleware.py (6 files)
  Skip: tests/*, README.md (3 files)

  Specialists to run: Security, Data Integrity
  Estimated findings: 10-25
```

---

## Step 2: Quick Review (Layer 2a logic)

Run the quick review pass on all in-scope files (not skipped).

For each finding, assign a fingerprint: `{file}:{line}:{category}`

Output findings in structured format:
```
[FINDING-001] Critical | src/auth.py:42 | security
SQL injection via unsanitized user input in login query.
Evidence: Line 42 uses f-string to build SQL query with user-supplied `username`.

[FINDING-002] P1 | src/models.py:89 | data_integrity
Transaction not committed on error path -- data loss possible.
Evidence: Lines 85-95 open transaction but except block at line 92 does not rollback or commit.

[FINDING-003] P2 | src/api/endpoints.py:15 | maintainability
Function handles 4 responsibilities (validate, transform, persist, respond).
Evidence: 95-line function with no extraction.
```

Track all fingerprints for deduplication in later steps.

---

## Step 3: Specialist Reviews (Layer 2b-4b logic)

Based on Step 1's plan, run each recommended specialist review.

**Before each specialist runs, provide it with the existing fingerprints:**
> "These findings are already recorded. Do not re-report them. Only add NEW findings."

Each specialist adds new findings using the same fingerprint format, continuing the FINDING number sequence.

Specialists follow the same review checklist as their standalone Layer 2-4 counterparts but scoped to the relevant files only.

---

## Step 4: Consolidate and Deduplicate

Merge all findings from Steps 2 and 3.

1. Remove duplicates by fingerprint similarity:
   - Same file + same line + same category = duplicate
   - Same file + adjacent lines (within 5) + same category = likely duplicate, merge
2. Sort by severity: Critical -> P1 -> P2 -> P3
3. Number findings sequentially in final list

Output consolidated finding count:
```
Consolidated: 18 findings (4 duplicates removed)
  2 Critical, 5 P1, 8 P2, 3 P3
```

---

## Step 5: Interactive Triage (Critical and P1 only)

Present each Critical and P1 finding one at a time using AskUserQuestion.

For each finding, present:

```
[FINDING-003] Critical | src/db.py:87 | data_integrity
Transaction not committed on error path -- data loss possible.

Recommendation: Fix now -- this will cause silent data loss in production.

A) Fix now
B) Fix later (add to backlog)
C) Won't fix (accept risk)
D) Disagree (this is a false positive)
```

Record the user's decision for each finding. Accepted findings (A or B) proceed to fix planning. Disputed findings (D) are noted but excluded from the fix plan.

P2 and P3 findings are automatically included in the fix plan without triage.

---

## Step 6: Fix Plan (Layer 5 logic)

Generate a fix plan for all accepted findings.

1. Group findings by file for efficient fixing (minimize context switches).
2. Within each file group, order by line number (top to bottom).
3. Note dependency ordering where it matters:
   - "Fix FINDING-003 (transaction handling) before FINDING-007 (retry logic) -- retry depends on proper transaction boundaries."
4. Estimate effort per batch.

Output summary:
```
Fix Plan Summary:
  18 findings total
  14 accepted (fix now or fix later)
  2 deferred (won't fix)
  2 disputed (false positive)

  Batches:
  1. src/auth.py: 3 findings (Critical security -- fix first)
  2. src/models.py: 4 findings (Data integrity)
  3. src/api/endpoints.py: 5 findings (Mixed)
  4. src/components/: 2 findings (P2/P3 -- low priority)
```

---

## STOP

Present the final report to the user. Do not proceed to fixing code unless explicitly asked.

The report should include:
- Scope reviewed
- Finding summary by severity
- Triage decisions
- Fix plan with batches and ordering
- Any findings the user disputed (for the record)

---

## Finding Severity Definitions

| Severity | Meaning | Action |
|----------|---------|--------|
| Critical | Will cause incorrect behavior, security vulnerability, or data loss | Must fix before merge |
| P1 | Works now but will fail in production or under load | Must fix before release |
| P2 | Technical debt, maintainability issues, minor bugs | Fix soon |
| P3 | Style, naming, optional improvements | Fix if easy |

---

**Remember: The goal is a complete, actionable review -- not a perfect one. Move through the steps systematically. Present findings with evidence. Let the user decide what to fix.**
