# Skill Standards

The format and conventions every skill in this repo follows. Canonical reference: [`productivity/write-a-skill/SKILL.md`](productivity/write-a-skill/SKILL.md).

Format adopted from [mattpocock/skills](https://github.com/mattpocock/skills) and Anthropic's agent skill spec.

## Required

### 1. YAML frontmatter

```yaml
---
name: skill-name                 # lowercase, kebab-case, matches directory
description: <one-line capability>. Use when <specific triggers>.
---
```

Optional frontmatter keys:

- `disable-model-invocation: true` — skill only runs when user invokes it as a slash-command. Use for skills that don't make sense to auto-trigger (e.g., `zoom-out`, `setup-matt-pocock-skills`).
- `argument-hint: "..."` — shown to user when they slash-invoke the skill (e.g., `handoff`).
- `version: x.y.z` — only if you maintain semver for this skill.

Multi-line descriptions use YAML block scalars (`|` or `>`) when long, but keep the first sentence single-line for readability:

```yaml
description: >
  One-line capability statement.
  Use when <trigger 1>, <trigger 2>, or user says "<phrase>".
```

### 2. Description must include triggers

The description is the **only** thing the agent sees when deciding whether to load the skill. Format:

- **First sentence**: what the skill does (third person).
- **Second sentence / clause**: "Use when ..." with concrete triggers — keywords, phrases, file types, situations.
- Max 1024 chars.

**Good** (`tdd`):

> Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.

**Bad**:

> Helps with testing.

### 3. Directory structure

```
skill-name/
├── SKILL.md              # required, the entry point
├── REFERENCE.md          # optional, deep reference docs
├── EXAMPLES.md           # optional, worked examples
├── <topic>.md            # optional, split by topic (see tdd/, improve-codebase-architecture/)
├── scripts/              # optional, executable helpers
│   └── helper.sh
└── assets/               # optional, bundled prompts/templates loaded at runtime
    └── agents/...
```

- `SKILL.md` is **always** the entry point. Other files are loaded only when SKILL.md references them.
- Prefer multiple topic files (`tests.md`, `mocking.md`) over one giant REFERENCE.md when content has distinct domains.
- `scripts/` for deterministic operations that would otherwise be regenerated each session.
- `assets/` for runtime artifacts (subagent prompts, templates, config). Allowed.

### 4. SKILL.md is short and imperative

Target: under ~120 lines. Hard ceiling: 200. Beyond that, split into topic files.

Imperative voice. "Reproduce the bug. Minimise the repro." Not "You should consider reproducing the bug."

Progressive disclosure: SKILL.md gives the workflow + links. Detail lives in topic files.

## Recommended Style

### 5. Section structure

Most skills follow some subset of:

```md
# Skill Name

## Philosophy / Core principle    # one paragraph, optional
## Quick start / Workflow         # the main loop
## When to use / triggers         # if not obvious from description
## Anti-patterns                  # what to NOT do
## Checklist                      # explicit checks before "done"
## References                     # links to topic files
```

Adapt as needed. The point is: lead with the workflow, not the philosophy.

### 6. Explicit triggers in description

List the actual phrases the user might say. Not vague categories. Compare:

- Vague: "Use when working with UI."
- Concrete: "Use when user asks 'does this look good', 'how should I design this', 'why does this look generic', or uploads a screenshot of a landing page."

### 7. Use checklists for verification

When a skill has a notion of "done", surface it as a checklist the agent can tick through. See `productivity/write-a-skill/SKILL.md` Review Checklist.

## Skill placement

Top-level categories:

- `writing/` — prose, editing, style
- `coding/` — engineering, code review, frontend, refactoring
- `ml/` — model training, research, implementation
- `research/` — search, knowledge bases
- `productivity/` — workflow, meta-skills (grill, handoff, write-a-skill)
- `misc/` — repo setup, migrations, hooks

If a skill genuinely spans categories, pick the dominant one. Don't make new categories without good reason.

## Authoring a new skill

Use the `/write-a-skill` skill — it walks through the process and produces a conforming SKILL.md.

## Auditing existing skills

See `AUDIT.md` (if present) for current conformance status of skills in this repo.
