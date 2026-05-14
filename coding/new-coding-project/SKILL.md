---
name: new-coding-project
description: >-
  Turn a project idea into a ready-to-build repository: interview the user, write a
  proper planning document, lay out the repo structure and git workflow, and install a
  team of coding subagents (research, critique, schema, test-writer, coder,
  due-diligence). Use this whenever the user wants to start, create, scaffold, kick off,
  bootstrap, or set up a NEW coding project, app, tool, service, library, or repo — even
  if they only describe the idea and never say "scaffold". If someone says "I want to
  build X", "let's start a project", "set up a new repo", or "prepare this repo for
  coding agents", trigger this skill.
---

# New Coding Project

Stand up a new repo so coding agents can work in it productively from day one. The output
is two things: a **planning document** that decomposes the idea into small, ordered tasks,
and a **repo scaffold** with subagent definitions, structure, and git conventions baked in.

The discipline behind this skill: agents do their best work on small, well-specified
units. A vague "build me an app" prompt produces sprawl. A planning doc that breaks the
work into bite-sized tasks — each with a clear acceptance check — lets a coding agent
finish one thing, verify it, commit, and move on. Everything here exists to reach that
state.

## Workflow

Follow these phases in order. Don't skip the interview — the quality of everything
downstream depends on it.

### 1. Interview the user

You can't write a good plan from a one-line idea. Ask about the things that change the
shape of the project, grouped so the user isn't overwhelmed (2-4 questions at a time).
Cover at least:

- **What and why**: what it does, what problem it solves, who uses it
- **Scope**: what's explicitly in scope for v1, what's deliberately out
- **Stack**: language, framework, key libraries, runtime — or ask for a recommendation
- **Constraints**: deadlines, performance needs, deployment target, systems to integrate with
- **Success**: how we know v1 works — what can a user do when it's done

If the user already gave you some of this, confirm it and fill the gaps rather than
re-asking.

### 2. Write the planning document

Read `references/planning-doc-template.md` and follow it. The planning doc lives at
`docs/PLAN.md` in the new repo. The most important section is the task breakdown: the
large problem split into milestones, and each milestone split into tasks small enough for
one focused agent pass, each with an explicit acceptance check.

### 3. Scaffold the repo structure

Read `references/repo-structure.md`. Create the directory layout, a README, a `CLAUDE.md`
that points agents at the plan and conventions, and a `.gitignore`. Keep it minimal —
don't create empty folders "for later".

### 4. Install the subagents

Copy every file from this skill's `assets/agents/` into `.claude/agents/` in the new repo.
These six agents form the standard pipeline:

Research phase — **research-agent** (surveys prior art, libraries, ground truth) and
**critique-agent** (adversarially stress-tests the plan and research for gaps and bad
assumptions).

Coding phase — **schema-agent** (designs data models, types, and interfaces before
implementation), **test-writer-agent** (writes tests against the schema and acceptance
checks), **coding-agent** (implements until the tests pass, one task at a time), and
**due-diligence-agent** (final review against the spec — tests, security, acceptance
criteria).

### 5. Set up git

Read `references/git-workflow.md`. Initialize the repo, make the first commit (the
scaffold + plan), and make sure `CLAUDE.md` documents the branch and commit conventions so
every agent follows them.

### 6. Hand off

Tell the user what was created and what the first task is. Point them at `docs/PLAN.md`
and explain the loop: pick the next task → schema-agent → test-writer-agent →
coding-agent → due-diligence-agent → commit → repeat.

## How the agents fit together

The pipeline mirrors how a careful engineer works, just split into focused roles so each
one keeps a clean, uncluttered context:

```
IDEA
 │
 ├─ research-agent ──► critique-agent ──► docs/PLAN.md      (research phase, runs once up front)
 │
 └─ for each task in PLAN.md:                               (coding phase, runs per task)
        schema-agent ──► test-writer-agent ──► coding-agent ──► due-diligence-agent ──► commit
```

Research and critique run once up front, and again whenever scope changes materially. The
coding loop runs once per task. Keep tasks small enough that the whole loop is cheap to
run — if a task feels heavy, it should have been split during planning.

## Principles

- **Small tasks beat big ones.** An agent with a tightly-scoped task and a clear
  acceptance check outperforms one told to "build the feature". The plan's job is to
  manufacture small tasks.
- **Schema before code.** Deciding the shape of data and interfaces first stops the
  coding agent from painting itself into a corner halfway through.
- **Tests encode the spec.** Tests written from acceptance checks give the coding agent an
  objective target and the due-diligence agent something concrete to verify.
- **One responsibility per agent.** Each subagent has a narrow job and only the tools it
  needs — this keeps its context clean and its output predictable.
- **Don't overengineer the scaffold.** Create what the first milestone needs, not a
  cathedral of empty directories.
