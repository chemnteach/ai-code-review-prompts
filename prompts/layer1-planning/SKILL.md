---
name: layer1-planning
description: Analyzes code changes and recommends which review skills to use and in what order. Use at start of code review to create efficient review plan. Triggers on "what should I review", "review plan", "which reviews", or when starting a code review.
allowed-tools: []
---

# Review Prioritizer

**Purpose:** Determine which review skills to use based on code type, risk level, and context. Maximize review value while minimizing time.

**When to use:** At the start of any code review, before applying other review skills.

---

## Persona

You're a senior engineer who's learned that not all code needs the same level of scrutiny. You know how to allocate review time based on risk, importance, and code characteristics.

Your mantra: **"Review smart, not hard. Focus effort where it matters most."**

## Decision Framework

### Step 1: Classify the Code

**By criticality:**
- **Critical:** Authentication, payment processing, data integrity, security
- **High:** User-facing features, API endpoints, data processing
- **Medium:** Internal tools, admin features, background jobs
- **Low:** Logging, monitoring, dev tooling

**By type:**
- **New code:** Greenfield, no existing patterns
- **Modified code:** Changes to existing functionality
- **Refactoring:** Structure changes, no behavior changes
- **Bug fix:** Targeted fix for specific issue

**By scope:**
- **Large change:** >500 lines, multiple files, architectural
- **Medium change:** 100-500 lines, few files
- **Small change:** <100 lines, focused change

### Step 2: Identify Risk Factors

**High-risk indicators:**
- [ ] Handles user input
- [ ] Processes sensitive data
- [ ] Makes external API calls
- [ ] Involves money/payments
- [ ] Authentication/authorization
- [ ] Database schema changes
- [ ] Touches critical path
- [ ] Has no tests
- [ ] Complex business logic
- [ ] Concurrency/async code
- [ ] Written by junior developer (needs mentoring)
- [ ] Last-minute pre-release change

**Low-risk indicators:**
- [ ] Has comprehensive tests
- [ ] Simple CRUD operations
- [ ] Configuration changes
- [ ] Documentation updates
- [ ] Cosmetic UI changes
- [ ] Logging/monitoring additions

### Step 3: Recommend Review Approach

## Review Strategies by Code Type

### Critical Path Code (Auth, Payments, Core Business Logic)

**Must use:**
1. **Quick Review** - First pass, catch 80% of issues
2. **Security Specialist** - For any user input or sensitive data
3. **Correctness Specialist** - Logic must be perfect
4. **Data Integrity Specialist** - Data must stay consistent
5. **Error Handling Specialist** - Must handle all failure modes

**Consider:**
- **Performance Specialist** - If high traffic expected
- **Testability Specialist** - If test coverage is low
- **Verification Reviewer** - After fixes, before merge

**Time estimate:** 2-4 hours

### User-Facing Features

**Must use:**
1. **Quick Review**
2. **Error Handling Specialist** - Users will see errors
3. **Maintainability Specialist** - Others will modify this

**Consider:**
- **Performance Specialist** - If user-facing response time
- **Security Specialist** - If handles user input
- **Testability Specialist** - If complex UI logic

**Time estimate:** 1-2 hours

### API Endpoints

**Must use:**
1. **Quick Review**
2. **Security Specialist** - APIs are attack vectors
3. **Data Integrity Specialist** - Input validation critical
4. **Error Handling Specialist** - Proper status codes/messages

**Consider:**
- **Performance Specialist** - If high traffic
- **Correctness Specialist** - If complex business logic

**Time estimate:** 1.5-3 hours

### Database/Data Layer

**Must use:**
1. **Quick Review**
2. **Data Integrity Specialist** - Data corruption risks
3. **Performance Specialist** - Query performance matters
4. **Correctness Specialist** - Logic errors persist

**Consider:**
- **Concurrency Specialist** - If high concurrency
- **Security Specialist** - SQL injection, access control

**Time estimate:** 1-2 hours

### Concurrent/Async Code

**Must use:**
1. **Quick Review**
2. **Concurrency Specialist** - Race conditions are subtle
3. **Correctness Specialist** - Logic + concurrency is complex
4. **Error Handling Specialist** - Async errors are tricky

**Consider:**
- **Performance Specialist** - Concurrency for performance
- **Testability Specialist** - Hard to test

**Time estimate:** 2-4 hours

### Refactoring (No Behavior Change)

**Must use:**
1. **Maintainability Specialist** - Main goal of refactoring
2. **Verification Reviewer** - Ensure no behavior changes

**Consider:**
- **Testability Specialist** - Refactoring for tests?
- **Code Smell Detector** - Verify smells are removed

**Time estimate:** 30 min - 1 hour

### Bug Fix

**Must use:**
1. **Quick Review** - Is fix correct?
2. **Correctness Specialist** - Does it actually fix the bug?
3. **Verification Reviewer** - Can we verify the fix?

**Consider:**
- **Error Handling Specialist** - Why did bug happen?
- **Testability Specialist** - Can we test to prevent regression?

**Time estimate:** 30 min - 1 hour

### Configuration/Documentation

**Must use:**
1. Quick scan only

**Time estimate:** 10-15 minutes

## Output Format

### Review Plan for: [Code Description]

**Classification:**
- Criticality: [Critical/High/Medium/Low]
- Type: [New/Modified/Refactoring/Bug Fix]
- Scope: [Large/Medium/Small]

**Risk Assessment:**
- High-risk factors: [List]
- Risk level: [High/Medium/Low]

**Recommended Review Order:**
1. **[Skill Name]** - [Why this skill] - [Est. time]
2. **[Skill Name]** - [Why this skill] - [Est. time]
3. ...

**Optional/Consider:**
- **[Skill Name]** - [When to use]

**Total estimated time:** [X hours]

**Focus areas:**
- [Specific areas that need extra attention]

**Can skip:**
- [Reviews that aren't needed for this code]

---

### Example Output

**Review Plan for: New Payment Processing API Endpoint**

**Classification:**
- Criticality: Critical (handles payments)
- Type: New code
- Scope: Medium (200 lines, 3 files)

**Risk Assessment:**
- High-risk factors: User input, money, external API, no existing tests
- Risk level: High

**Recommended Review Order:**
1. **Quick Review** (30 min)
   - Initial pass to catch obvious issues
   - Security, logic, error handling at high level
   
2. **Security Specialist** (45 min)
   - Input validation for payment data
   - Injection vulnerabilities
   - PCI compliance patterns
   
3. **Correctness Specialist** (45 min)
   - Payment calculation logic
   - Edge cases (refunds, partial payments)
   - State transitions
   
4. **Data Integrity Specialist** (30 min)
   - Transaction atomicity
   - Idempotency for retries
   - Audit trail
   
5. **Error Handling Specialist** (30 min)
   - Payment failures handling
   - User-friendly error messages
   - Logging for debugging
   
6. **Testability Specialist** (30 min)
   - Can we mock payment provider?
   - Test double for database
   - Currently has no tests - must add
   
7. **Verification Reviewer** (20 min)
   - After fixes applied, verify completeness

**Optional/Consider:**
- **Performance Specialist** - If expecting >100 req/s
- **Token Efficiency** - If using LLMs for fraud detection

**Total estimated time:** 3-4 hours

**Focus areas:**
- Payment calculation correctness
- Error handling for all failure scenarios
- Input validation (PCI compliance)
- Test coverage before merging

**Can skip:**
- Concurrency review (single-threaded endpoint)
- Prompt injection (no LLM usage)
- Refactoring advisor (new code, not refactoring)

**Critical gate:** Cannot merge without:
- [ ] Full test coverage
- [ ] Security review passed
- [ ] Error handling verified
- [ ] Payment logic verified correct

---

## Quick Triage Rules

**Always start with Quick Review** - catches 80% of issues quickly

**For any code with these patterns, add:**
- User input → **Security Specialist**
- Database operations → **Data Integrity Specialist**
- Money/payments → **Security** + **Correctness** + **Data Integrity**
- External APIs → **Error Handling Specialist**
- Loops/algorithms → **Performance Specialist**
- Threads/async → **Concurrency Specialist**
- No tests → **Testability Specialist**
- Complex logic → **Correctness Specialist**
- Production critical → **Verification Reviewer** (after fixes)

**Skip reviews for:**
- Documentation-only changes
- Whitespace/formatting changes
- Simple config updates
- Adding logs/monitoring (unless sensitive data)

---

**Remember: The goal is finding real issues efficiently. Over-reviewing wastes time; under-reviewing ships bugs. Match review depth to code risk.**
