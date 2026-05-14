---
name: write-a-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill. Canonical reference for the skill format used in this repo.
---

# Writing Skills

This is the canonical reference for the skill format in this repo. The high-level rules live in [`STANDARDS.md`](../../STANDARDS.md) at the repo root; this file is what the agent loads when actually writing a skill.

## Process

1. **Gather requirements** — ask the user:
   - What task or domain does the skill cover?
   - What specific use cases / triggers should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials, prompts, or templates to bundle?

2. **Pick a category and name**:
   - Categories: `writing/`, `coding/`, `ml/`, `research/`, `productivity/`, `misc/`.
   - Name is lowercase, kebab-case, matches the directory.

3. **Draft the skill**:
   - `SKILL.md` is the entry point. Keep it under ~120 lines.
   - Split deep content into topic files (`tests.md`, `mocking.md`) or `REFERENCE.md`.
   - Add `scripts/` for deterministic helpers.
   - Add `assets/` for bundled prompts/templates loaded at runtime.

4. **Review with user** — ask:
   - Does the description trigger correctly? (read it aloud against the use cases)
   - Anything missing or unclear?
   - Should any section be more or less detailed?

5. **Update `README.md`** at repo root to list the new skill.

## Skill Structure

```
skill-name/
├── SKILL.md              # required, entry point
├── REFERENCE.md          # optional, deep reference
├── EXAMPLES.md           # optional, worked examples
├── <topic>.md            # optional, split by topic
├── scripts/              # optional, executable helpers
│   └── helper.sh
└── assets/               # optional, runtime artifacts (prompts, templates)
```

## SKILL.md Template

```md
---
name: skill-name
description: One-line capability statement. Use when <concrete triggers>.
---

# Skill Name

## Philosophy
[Optional. One paragraph. Skip if obvious.]

## Quick start / Workflow
[The main loop. Imperative voice. Numbered or bulleted steps.]

## Anti-patterns
[What NOT to do. Optional but valuable.]

## Checklist
- [ ] Verification item 1
- [ ] Verification item 2

## References
See [tests.md](tests.md), [mocking.md](mocking.md).
```

## Frontmatter

Required:

```yaml
---
name: skill-name
description: <capability>. Use when <triggers>.
---
```

Optional:

- `disable-model-invocation: true` — only invocable as slash-command, never auto-triggered.
- `argument-hint: "..."` — shown when user slash-invokes the skill.
- `version: x.y.z` — only if you maintain semver.

Multi-line description for long ones, but first sentence stays terse:

```yaml
description: >
  One-line capability.
  Use when <trigger 1>, <trigger 2>, or user says "<phrase>".
```

## Description Rules

The description is the **only** thing the agent sees when picking skills. Max 1024 chars.

- **First sentence**: what it does (third person).
- **"Use when ..."**: concrete triggers — keywords, phrases, file types, situations.
- List actual user phrases, not vague categories.

**Good**: `Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.`

**Bad**: `Helps with testing.`

## Style

- Imperative voice. "Reproduce the bug." not "You should reproduce the bug."
- Lead with the workflow, not philosophy.
- Concrete examples over abstract description.
- Checklists for things with a definition of done.

## When to Add Scripts

When the operation is deterministic (validation, formatting, regex transforms) and the agent would otherwise regenerate the same code each session. Scripts save tokens and reduce errors.

## When to Split Files

Split when:

- SKILL.md exceeds ~120 lines.
- Content has distinct domains (e.g., `tdd/` has `tests.md`, `mocking.md`, `refactoring.md`, `deep-modules.md`, `interface-design.md`).
- A section is rarely needed; loading it eagerly wastes context.

References go one level deep. Don't chain `SKILL.md` → `REFERENCE.md` → `DETAILS.md`.

## Review Checklist

- [ ] `name` matches directory name
- [ ] Description starts with capability, includes "Use when ..." with concrete triggers
- [ ] Description under 1024 chars
- [ ] SKILL.md under ~120 lines (or split into topic files)
- [ ] Imperative voice in workflow sections
- [ ] Concrete examples included
- [ ] No time-sensitive info ("as of 2024", "currently")
- [ ] Consistent terminology throughout
- [ ] References go one level deep
- [ ] Category folder is correct (`writing/`, `coding/`, `ml/`, `research/`, `productivity/`, `misc/`)
- [ ] Added to `README.md` at repo root
