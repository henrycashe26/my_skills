---
name: karpathy-guidelines
description: >
  Behavioral guidelines to reduce common LLM coding mistakes, based on Andrej Karpathy's
  observations about LLM coding pitfalls. Use this skill whenever you are writing, reviewing,
  editing, or refactoring code — especially when the task involves implementing a new feature,
  fixing a bug, making changes to existing code, or responding to any coding request. Also
  trigger when the user asks for code review, mentions "keep it simple", "minimal changes",
  "don't overengineer", "just fix the bug", or anything involving careful, disciplined coding
  practices. If you're about to write code, this skill applies.
license: MIT
---

# Karpathy Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

The most common LLM mistake is silently picking one interpretation of an ambiguous request and running with it. This wastes everyone's time when the assumption turns out to be wrong.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

**Why this matters:** A 30-second clarification question saves a 30-minute rewrite. Users would rather answer a question than undo bad assumptions baked into 200 lines of code.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

LLMs love to over-abstract. They'll build a Strategy pattern for a single discount calculation, add caching to a function called once, or create configuration systems for hardcoded values. This isn't "good engineering" — it's premature complexity that makes code harder to read, test, and change.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

**The key insight:** The overcomplicated version isn't obviously wrong — it follows design patterns and best practices. The problem is *timing*. Adding complexity before it's needed makes code harder to understand, introduces more bugs, takes longer to implement, and is harder to test. Simple code can always be refactored later when complexity is actually needed.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code, LLMs tend to "improve" things they weren't asked to touch — reformatting quotes, adding type hints, rewriting comments, refactoring adjacent functions. This creates noisy diffs that obscure the actual change and risk introducing bugs in unrelated code.

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

**The test:** Every changed line should trace directly to the user's request. If it can't, don't change it.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Vague plans like "review the code and make improvements" lead to unfocused changes. Instead, transform every task into something verifiable:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan with verification at each step:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Quick Reference

| Principle | Anti-Pattern | Fix |
|-----------|-------------|-----|
| Think Before Coding | Silently assumes file format, fields, scope | List assumptions, ask for clarification |
| Simplicity First | Strategy pattern for a single calculation | One function until complexity is actually needed |
| Surgical Changes | Reformats quotes, adds type hints while fixing a bug | Only change lines that fix the reported issue |
| Goal-Driven | "I'll review and improve the code" | "Write test for bug X → make it pass → verify no regressions" |

---

## Examples

For detailed before/after examples of each principle, including common LLM mistakes and their corrections, see `references/EXAMPLES.md`. Read it when you need concrete illustrations of these guidelines in action.

---

**These guidelines are working when:** diffs contain fewer unnecessary changes, first-draft code is simpler, clarifying questions come before implementation rather than after mistakes, and pull requests don't contain drive-by improvements.
