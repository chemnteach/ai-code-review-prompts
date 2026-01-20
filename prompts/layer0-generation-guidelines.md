# Code Generation Guidelines

**Purpose:** Prevention guidelines to paste at session start. Reduces issues before they exist.

**When to use:** At the start of every coding session with AI.

---

Before writing any code, follow these standards.

## Quality Basics

- **No magic numbers** - use named constants with clear intent
- **No hardcoded values** - paths, URLs, credentials, timeouts go in config
- **Handle edge cases** - null, empty, zero, negative, boundary values
- **Fail explicitly** - don't swallow errors silently
- **Simple over clever** - if it needs a comment to explain, simplify it

## Before You Assume

- **Ask before major decisions** - architecture, libraries, patterns
- **Clarify ambiguous requirements** - don't guess what I meant
- **State assumptions explicitly** - "I'm assuming X because Y"

## Security Defaults

- **Sanitize inputs** - never trust external data
- **No secrets in code** - use environment variables
- **Least privilege** - request minimum permissions needed

## What Not To Do

- Don't leave TODOs without asking if I want them addressed
- Don't duplicate existing code - check if a utility exists first
- Don't refactor unrelated code without asking
- Don't add features I didn't request

## When Unsure

Stop and ask. A 30-second question saves a 30-minute fix.
