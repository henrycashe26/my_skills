# Repo Structure

Scaffold the new repo with the minimum structure the first milestone needs. Empty
directories "for later" just add noise — add them when a task actually needs them.

## Baseline layout

```
<project-root>/
├── README.md            — what it is, how to run it, how to develop on it
├── CLAUDE.md            — conventions and pointers for coding agents (see below)
├── .gitignore           — language-appropriate ignores
├── docs/
│   └── PLAN.md          — the planning document
├── .claude/
│   └── agents/          — the six subagent files (copied from this skill)
└── src/                 — source root (use the language-appropriate convention)
```

Add `tests/`, config files, CI workflows, etc. when the stack and the first tasks call for
them. The planning doc's Milestone 1 tells you what's actually needed.

## README.md

Keep it short and practical: a one-line description, prerequisites, how to install and
run, how to run the tests, and a pointer to `docs/PLAN.md` for the roadmap. It's for a
human arriving at the repo for the first time.

## CLAUDE.md

This is the file every coding agent reads first. It's not documentation for humans — it's
operating instructions for agents working in the repo. Include:

- **Project**: one line on what this is, plus a pointer to `docs/PLAN.md`
- **Stack & layout**: the language and framework, where source and tests live
- **Conventions**: naming, formatting, the lint/format commands, patterns to follow
- **Workflow**: the agent pipeline (schema → test → code → due-diligence) and the git
  conventions (from `git-workflow.md`)
- **Commands**: how to install dependencies, run, test, lint, and build
- **Guardrails**: what agents should NOT do — touch generated files, commit secrets,
  reformat unrelated code, expand scope beyond the current task

Keep it current. When a convention changes, this file changes in the same commit.

## .gitignore

Use a standard template for the chosen language and framework. At minimum, ignore
dependency directories, build output, environment and secret files, and editor/OS cruft.
Get this right before the first commit so nothing unwanted enters history.
