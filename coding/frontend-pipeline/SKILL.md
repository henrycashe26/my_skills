---
name: frontend-pipeline
description: >
  Full frontend pipeline orchestrator: spawns specialized agents for TypeScript standards,
  performance, UI quality, and AI audit in parallel, then synthesizes results into a
  prioritized action plan. Use this skill whenever someone wants a comprehensive frontend
  review, wants to know "what's wrong with my frontend", asks for a full audit of a project,
  or says "review everything", "give me a full frontend report", "audit this codebase",
  "what should I fix first". Also trigger when starting a new frontend project and wanting
  to establish standards, or when a frontend is about to ship and needs a final pass.
  This skill coordinates the full suite: frontend-ts-standards, frontend-performance,
  frontend-ui-quality, and frontend-ai-audit as parallel subagents, then synthesizes.
---

# Frontend Pipeline: Full Review Orchestrator

Spawns four specialized subagents in parallel, then synthesizes findings into a single prioritized report.

**Core principle (Karpathy):** Define what "done" looks like before starting. Each agent has a specific domain and output format. They run in parallel — never sequentially when both can run.

## When to Use

- **Full audit**: existing frontend, comprehensive review.
- **New project setup**: TS-standards first, others confirm scaffolding.
- **Pre-launch**: focus on what embarrasses you in production.
- **Domain-specific**: invoke the individual skill instead, not this orchestrator.

## Workflow

### 1. Clarify scope

Before spawning agents, establish:

- What is being audited? (path, URL, screenshot, description)
- Framework? (React+Vite, Next.js, other)
- Goal? (ship, refactor, new setup, learning)
- Which domains matter most? (skip ones the user doesn't care about)
- What is out of scope? (backend, mobile)

If input is URL or screenshot only, performance and TS agents have limited info — they should note what they can't assess.

### 2. Spawn all four agents in parallel

Spawn in the **same message**. They are independent.

Prompts live in `assets/agents/`:

- [`assets/agents/ts-standards.md`](assets/agents/ts-standards.md) — TypeScript quality, testing, toolchain
- [`assets/agents/performance.md`](assets/agents/performance.md) — Bundle, renders, network, Core Web Vitals
- [`assets/agents/ui-quality.md`](assets/agents/ui-quality.md) — Design system, spacing, typography, a11y
- [`assets/agents/ai-audit.md`](assets/agents/ai-audit.md) — Visual, code, copy tells, slope score

Each prompt produces a markdown file (`agent-<name>.md`) the synthesis step reads.

### 3. Synthesize

After all four complete, read the output files and:

1. **Collect** findings from all four.
2. **Deduplicate** — bad state management is both a TS and perf issue. Merge.
3. **Cross-reference** — compounding findings (no Zod + no tests + API calls in components = systemic, not three issues).
4. **Prioritize**:

| Priority | Criteria |
|---|---|
| P0 | Type-safety gaps hiding bugs, missing loading/error states, broken a11y |
| P1 | Core Web Vitals regressions, obvious AI tells |
| P2 | Code quality issues slowing future work |
| P3 | Polish, minor consistency, advanced optimizations |

5. **Write final report** — see [`references/report-format.md`](references/report-format.md).

## Operating Without Subagents

Run sequentially in this order: AI audit (fastest, gives gestalt) → TS standards → Performance → UI quality (do last so it doesn't bias the AI audit framing). Same output structure.

## New-Project Mode

When scaffolding fresh (not auditing):

1. TS agent sets up stack (bun, biome, vitest, shadcn, tsconfig).
2. Perf agent configures build (bundle splitting, image handling, no large deps).
3. UI agent establishes design tokens and base component patterns.
4. AI audit reviews scaffolding for AI-slope defaults.

Output: files to create/modify, not problems to fix.

## Skills Orchestrated

- [`frontend-ts-standards`](../frontend-ts-standards/) — TS, Bun, Vitest, Playwright, Biome, components
- [`frontend-performance`](../frontend-performance/) — Bundle, rendering, network, Web Vitals
- [`frontend-ui-quality`](../frontend-ui-quality/) — Design systems, components, a11y, motion
- [`frontend-ai-audit`](../frontend-ai-audit/) — Visual/code/copy AI tells (integrates humanizer)

## Quality Bar

- All four domain reports saved.
- Every finding is specific: file, line, or screenshot reference. Not "the code could be better".
- Every finding has a concrete fix.
- Synthesis distinguishes "this hurts users" from "this is a code smell".
- Do not synthesize before reading all four outputs.
