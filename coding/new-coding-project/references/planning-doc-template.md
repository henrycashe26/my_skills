# Planning Document Template

The planning document (`docs/PLAN.md` in the new repo) is what turns a fuzzy idea into
something agents can build. Write it FOR the agents that will execute it: concrete,
decomposed, and honest about what's uncertain.

Use the structure below. Keep prose tight — this is a working document, not a pitch.

---

## Template

```markdown
# <Project Name>

## Summary
One paragraph: what this is, who it's for, and what it lets them do. If someone reads
only this, they should understand the project.

## Problem & motivation
What pain exists today, who feels it, and why it's worth solving now. Be specific about
the status quo.

## Goals
The handful of things v1 must achieve. Each should be checkable.

## Non-goals
What this project deliberately does NOT do — for v1, or ever. This section prevents scope
creep more than any other.

## Users & use cases
Who uses this, and the two or three core scenarios they walk through.

## Proposed approach
The high-level architecture and key technical decisions: stack, major components, how
they fit together. Note the alternatives you considered and why you didn't pick them.
Stay at the "boxes and arrows" level — implementation detail belongs in tasks.

## Data model & interfaces
The main entities, their relationships, and the key interfaces between components (APIs,
module boundaries, events). This is the starting point for the schema-agent — it doesn't
have to be exhaustive, but it should name the important shapes.

## Milestones & task breakdown
The heart of the document. Break the project into 2-5 milestones, ordered so each builds
on the last. Under each milestone, list tasks.

### Milestone 1: <name>
- **Task 1.1 — <short title>**
  - What: one or two sentences on what to build
  - Acceptance: the concrete check that proves it's done (a test passes, a command
    works, an endpoint returns X)
  - Depends on: nothing / Task X.Y

## Risks & open questions
What might go wrong, and what you don't know yet. Anything here that blocks a task should
be resolved — often by the research-agent — before that task starts.

## Success criteria
How you'll know v1 is done and working — ideally a short list of things a user can do, or
a demo script you could run end to end.
```

---

## What makes a good task

The task breakdown is where to spend your effort. Vague tasks are the single biggest
cause of agents going off the rails. A good task is:

- **Small enough for one focused agent pass** — roughly one schema + tests + implementation
  cycle. If a task's "What" needs more than two sentences, it's probably two tasks.
- **Independently checkable** — it has an explicit acceptance check that's objectively
  pass/fail.
- **Ordered** — its dependencies come before it in the plan.

## Notes on writing it

- The interview feeds this document. If a section comes out thin, you probably didn't ask
  enough — go back and ask.
- It's fine for later milestones to be coarser than the first; you'll refine them as
  earlier work lands. But Milestone 1 should be fully decomposed before coding starts.
- The plan is a living document. When the critique-agent finds a gap or scope changes,
  update `docs/PLAN.md` rather than letting it drift out of date.
