# Git Workflow

Coding agents commit often and in small pieces. The conventions below keep history
readable and make it easy to see — and undo — what each task did. Document these in the
new repo's `CLAUDE.md` so every agent follows them.

## Setup

Initialize the repo and make the first commit once the scaffold and `docs/PLAN.md` are in
place. That commit is the baseline: scaffold, plan, agents, conventions.

## One task, one branch

Each task from the plan gets its own branch:

```
task/<milestone>.<task>-<short-slug>     e.g. task/1.2-user-auth-schema
```

Small or solo projects can commit straight to the main branch instead — but still keep it
to one logical task at a time.

## Commits

- One logical change per commit. A task usually produces a few commits (schema, tests,
  implementation), not one giant one.
- Write messages in the imperative: "add user schema", "make auth tests pass".
- Use a type prefix if the project wants it: `feat:`, `fix:`, `test:`, `refactor:`,
  `chore:`, `docs:`.
- Commit only after the relevant tests and linter pass. A commit should never knowingly
  break the build.
- First line is a summary under ~70 characters; add a body when the "why" isn't obvious
  from the change.

## When to commit during a task

- After the schema/interfaces are defined — captures the shape before behavior exists
- After tests are written and confirmed failing for the right reason
- After the implementation makes them pass
- After the due-diligence agent signs off — this is the commit that's safe to merge

## Merging

When a task's branch is done and due-diligence has passed, merge it back to main. Keep the
main branch in a state where the test suite passes at every commit — that's what makes it
safe for the next task to branch from.

## What not to commit

Secrets, credentials, `.env` files, build output, dependency directories, large binaries.
If something shouldn't be in history, it belongs in `.gitignore` before the first commit.
