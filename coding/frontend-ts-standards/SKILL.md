---
name: frontend-ts-standards
description: >
  TypeScript frontend standards, toolchain, and testing practices for modern web apps.
  Use this skill whenever you are writing, reviewing, or auditing TypeScript frontend code —
  especially when setting up a new project, choosing between libraries, configuring Bun,
  writing tests with Vitest or Playwright, or reviewing code quality. Also trigger when the
  user mentions Bun, Vitest, Playwright, Biome, shadcn, Zod, Tanstack Query, Zustand, or asks
  "what's the right way to do X in a TypeScript frontend". If the user says "set up a frontend
  project", "write a test", "what stack should I use", "review this component", or "is this
  good TypeScript", this skill applies immediately.
---

# Frontend TypeScript Standards

What production-quality TypeScript frontend code actually looks like in 2025. The goal is not trends — it is shipping fast, catching bugs early, and not making future maintainers miserable.

**Core reasoning approach (Karpathy):** Think before coding. State assumptions. Simple over clever. Surgical edits over rewrites. Every decision needs a reason you can say out loud.

## When to apply this skill

- Setting up a new TypeScript frontend project from scratch
- Choosing between libraries (Bun vs Node, Biome vs ESLint, Vitest vs Bun test, Zustand vs Redux, etc.)
- Writing or reviewing React components, hooks, or Zod schemas
- Writing tests (unit, component, or E2E)
- Reviewing a PR and looking for the right things to flag
- A user mentions Bun, Vitest, Playwright, Biome, shadcn, Zod, TanStack Query, Zustand, or asks "what's the right way to do X"

## Workflow

1. **Identify the task.** Setting up a project, writing a feature, writing tests, or reviewing code? Each branches into a different reference file below. Do not load all of them — pull in the one you need.

2. **Pick the toolchain first.** For any new project the defaults are:
   - **Runtime/build:** Bun (commit `bun.lockb`).
   - **Language:** TypeScript with `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`.
   - **Lint/format:** Biome (one tool, no Prettier/ESLint conflicts). Keep existing ESLint if it works.
   - **Framework:** React + Vite for SPAs; Next.js only if you need SSR/SEO/API routes.
   - **UI:** shadcn/ui (you own the copied code) + Radix primitives for custom components.
   - **Data:** TanStack Query for server state; Zustand only after real prop-drilling pain.
   - **Validation:** Zod at every API boundary and form input. Infer types from schemas.
   - **Styling:** Tailwind on the 8pt spacing grid; design tokens in the config.

   Full configs, rationale, and decision tables: [toolchain.md](references/toolchain.md).

3. **Lay out the project.** Use the canonical `src/` layout with `components/ui/`, `components/[feature]/`, `lib/api/`, `lib/schemas/`, `lib/utils/`, `hooks/`, `types/`. Components accept data as props, fetch via hooks, render loading + error + empty states. See [project-structure.md](references/project-structure.md).

4. **Test it.** Pyramid: unit (Vitest) → component (React Testing Library + MSW) → E2E (Playwright, CI only). Test behaviour, not implementation. Prefer `getByRole` over `getByTestId`. Intercept network at the MSW layer, not at `fetch`/Axios. See [testing.md](references/testing.md).

5. **Review.** Walk through the red/green flags in [code-review.md](references/code-review.md) before declaring done.

## Anti-patterns

- `any` types without a comment justifying the escape hatch
- `as SomeType` on API responses, `localStorage`, or form inputs — use Zod instead
- `useEffect(() => { fetchData() }, [])` — use TanStack Query
- Mocking `fetch` or Axios in component tests — use MSW at the network layer
- `getByTestId` over `getByRole` — tests should mirror what users (and screen readers) see
- Arbitrary Tailwind values like `p-[13px]` — stay on the 8pt grid
- Adding Next.js to a simple internal tool that only needs an SPA
- Reaching for Zustand or Redux before feeling prop-drilling pain through 4+ layers
- Components that both fetch data and contain significant business logic — separate concerns
- Components longer than ~200 lines without a clear reason

## Checklist

- [ ] TypeScript `strict` + `noUncheckedIndexedAccess` + `exactOptionalPropertyTypes` on
- [ ] Biome (or justified ESLint) configured and passing
- [ ] External data validated through Zod schemas; types inferred from schemas
- [ ] Data fetching via TanStack Query, not raw `useEffect`
- [ ] Components have loading + error + empty states
- [ ] Tests use `getByRole` and simulate real interactions
- [ ] MSW handles API mocking, not module-level `fetch` mocks
- [ ] No `any`, no unjustified `as` casts
- [ ] Tailwind values stay on the 8pt grid
- [ ] `bun.lockb` committed

## Topics

- [toolchain.md](references/toolchain.md) — Bun runtime, strict TypeScript config, Biome, React/Next decision, shadcn + Radix, state management decision tree, Zod patterns, Tailwind tokens.
- [testing.md](references/testing.md) — What tests are for, Vitest unit tests, React Testing Library queries, MSW network-level mocking, Playwright E2E setup.
- [project-structure.md](references/project-structure.md) — Canonical `src/` directory layout plus the standard component pattern with props, hooks, and states.
- [code-review.md](references/code-review.md) — Red flags to challenge and green flags to encourage when reviewing a PR.
- [bun-patterns.md](references/bun-patterns.md) — Bun project setup, package.json scripts, workspaces, built-in test runner, gotchas, Vite config example.
