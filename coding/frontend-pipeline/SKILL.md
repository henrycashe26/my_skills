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

This skill runs the complete frontend pipeline. It spawns four specialized subagents in parallel, each running a focused audit with its own skill, then synthesizes the findings into a single prioritized report.

**Core reasoning approach (Karpathy):** Define what "done" looks like before starting. The four agents each have a specific domain and a specific output format. They run in parallel. Do not wait for one to finish before starting the next. Synthesis happens only after all four have reported.

---

## When to Use This

**Full audit mode:** When you have an existing frontend and want a comprehensive review. All four agents run. Output is a prioritized action list across all domains.

**New project setup:** When starting a new project. The TypeScript standards agent runs first to establish the stack, then the others confirm the scaffolding is correct.

**Pre-launch review:** Before shipping. All four agents run with a focus on things that will embarrass you in production: performance regressions, accessibility failures, obvious AI tells, type safety gaps.

**Domain-specific:** If the user asks about one area specifically, invoke just that skill directly rather than the full pipeline. The pipeline is for when you need everything.

---

## Pipeline Architecture

```
User request
     │
     ▼
[Clarify scope] ──────────────────────────────────────────────────┐
     │                                                             │
     ▼                                                             │
[Spawn 4 agents in parallel]                                       │
     │                                                             │
     ├── Agent 1: frontend-ts-standards                           │
     │     ↳ TypeScript quality, testing, toolchain               │
     │                                                             │
     ├── Agent 2: frontend-performance                            │
     │     ↳ Bundle size, renders, network, Core Web Vitals       │
     │                                                             │
     ├── Agent 3: frontend-ui-quality                             │
     │     ↳ Design system, spacing, typography, accessibility    │
     │                                                             │
     └── Agent 4: frontend-ai-audit                              │
           ↳ Visual tells, code tells, copy tells, slope score    │
                                                                   │
     [Wait for all 4 to complete]                                  │
                │                                                  │
                ▼                                                  │
     [Synthesize: merge findings, deduplicate, prioritize]        │
                │                                                  │
                ▼                                                  │
     [Final report: prioritized action list]                       │
```

---

## Step 1: Clarify Scope Before Starting

Before spawning agents, establish:

1. **What is being audited?** — A codebase path, a URL, a screenshot, or a description?
2. **What framework?** — React + Vite, Next.js, other?
3. **What is the goal?** — Ship in production, refactor, new setup, or general learning?
4. **Which domains matter most?** — If the user says "I just care about the AI audit", run only that skill.
5. **What is out of scope?** — Backend, mobile, etc.

If the input is a URL or screenshot, note that the performance and TS agents will have limited information and should note what they cannot assess from visual inspection alone.

---

## Step 2: Spawn All Four Agents

**Spawn all four in the same message.** Do not wait for one to finish before starting the next — they are independent. Each agent receives:

- The skill path for its domain
- The codebase path or URL or screenshot
- A clear output format requirement (see below)
- The task context (what kind of review, what the user cares about)

### Agent 1: TypeScript Standards

```
Execute a TypeScript frontend standards review using the frontend-ts-standards skill.

Skill path: [path-to-skill]/frontend-ts-standards/
Codebase: [path or description]

Your output should cover:
1. Toolchain assessment (is the stack appropriate?)
2. TypeScript strictness (any, as-casts, missing Zod validation)
3. Testing coverage and approach
4. Component quality (separation of concerns, hook extraction)
5. Top 5 specific findings with file paths and line numbers where possible
6. Severity ratings (critical/high/medium/low) for each

Save findings to: [workspace]/agent-ts-standards.md
```

### Agent 2: Performance

```
Execute a frontend performance audit using the frontend-performance skill.

Skill path: [path-to-skill]/frontend-performance/
Codebase: [path or URL]

Your output should cover:
1. Bundle size estimate and known large dependencies
2. Any virtualization gaps (unvirtualized long lists)
3. Obvious render performance issues (unnecessary re-renders, missing memoization)
4. Network patterns (waterfalls, missing caching, no staleTime)
5. Image handling
6. Top 5 performance wins ranked by impact, with implementation sketch

Save findings to: [workspace]/agent-performance.md
```

### Agent 3: UI Quality

```
Execute a UI quality review using the frontend-ui-quality skill.

Skill path: [path-to-skill]/frontend-ui-quality/
Codebase or screenshots: [path]

Your output should cover:
1. Design system consistency (spacing, typography, color)
2. Component pattern quality (buttons, forms, empty states, loading)
3. Accessibility gaps (focus states, labels, contrast, keyboard)
4. Motion and interaction quality
5. Top 5 UI findings with specific component names and suggested fixes

Save findings to: [workspace]/agent-ui-quality.md
```

### Agent 4: AI Audit

```
Execute an AI-slope audit using the frontend-ai-audit skill.
Also invoke the humanizer skill on any significant copy/text content.

Skill path: [path-to-skill]/frontend-ai-audit/
Codebase or screenshots: [path]

Your output should cover:
1. Visual AI tells found (list each specifically)
2. Code AI tells found (list each with file/line)
3. Copy AI tells found (humanizer output for each block of text)
4. Overall AI slope score (0–10) with breakdown by section
5. Top 5 most impactful changes to reduce AI-looking quality

Save findings to: [workspace]/agent-ai-audit.md
```

---

## Step 3: Wait, Then Synthesize

When all four agents have completed, read their output files and synthesize:

### Synthesis Process

1. **Collect all findings** from the four files
2. **Deduplicate** — some findings appear in multiple agents (e.g., bad state management is both a TS standards issue and a performance issue). Merge these.
3. **Cross-reference** — look for findings that compound each other (e.g., no Zod + no tests + API calls in components is a systemic architecture issue, not three separate issues)
4. **Prioritize** using this framework:

| Priority | Criteria |
|----------|----------|
| P0 (Fix before shipping) | Type safety gaps that hide bugs, missing loading/error states, broken accessibility |
| P1 (Fix this sprint) | Performance issues affecting Core Web Vitals, obvious AI tells that undermine credibility |
| P2 (Fix in the next month) | Code quality issues that will slow future development |
| P3 (Nice to have) | Polish, minor consistency issues, advanced optimizations |

5. **Write the final report** in the format below

---

## Final Report Format

```markdown
# Frontend Audit Report
Date: [date]
Codebase: [name/path]
Overall assessment: [1-2 sentences]

## AI Slope Score: [X]/10
[Brief explanation of what drove the score]

## P0: Fix Before Shipping
[Each item: what, where, why it matters, how to fix]

## P1: Fix This Sprint  
[Each item: what, where, why it matters, how to fix]

## P2: Fix Next Month
[Each item: what, where, why it matters]

## P3: Nice to Have
[Grouped by domain, brief]

## What's Working Well
[Things that are good — always include this]

## Full Agent Reports
- TypeScript Standards: [link to agent-ts-standards.md]
- Performance: [link to agent-performance.md]
- UI Quality: [link to agent-ui-quality.md]
- AI Audit: [link to agent-ai-audit.md]
```

---

## Operating Without Subagents

If subagents are not available, run each domain sequentially. Still read all four skill files before starting. Keep the same output structure — just do the synthesis yourself after all four passes.

Order for sequential execution:
1. AI Audit first (fastest, most visual, gives immediate gestalt of quality)
2. TypeScript Standards (systematic, needs code access)
3. Performance (depends on seeing the dependency tree and component structure)
4. UI Quality (can be done from screenshots; do last to avoid influencing the AI audit framing)

---

## Establishing Standards for New Projects

When starting fresh (not auditing an existing codebase), the pipeline runs differently:

1. **TypeScript agent** sets up the stack: bun, biome, vitest, shadcn, the recommended tsconfig
2. **Performance agent** ensures the build is configured correctly from day one: bundle splitting, image handling, no large deps snuck in
3. **UI agent** establishes the design token system and base component patterns
4. **AI audit agent** reviews the initial scaffolding to ensure it does not start with AI-slope defaults

Output for new projects: a set of concrete files to create/modify, not a list of problems to fix.

---

## The Skills This Orchestrates

This pipeline uses four specialized skills. Each can be invoked independently:

- **`frontend-ts-standards`** — TypeScript, Bun, Vitest, Playwright, Biome, component patterns
- **`frontend-performance`** — Bundle analysis, rendering, network, Core Web Vitals
- **`frontend-ui-quality`** — Design systems, component patterns, accessibility, motion
- **`frontend-ai-audit`** — Visual AI tells, code AI tells, copy audit (integrates humanizer)

Read those skill files for the detailed domain knowledge each agent uses.

---

## Quality Bar

The pipeline is done when:

- All four domain reports are complete and saved
- Every finding is specific (file/line/screenshot reference, not "the code could be better")
- Every finding has a concrete fix, not just a description of the problem
- The synthesis report is written and prioritized
- The final report distinguishes between "this will hurt users" and "this is a code smell"

Do not present the synthesis until you have actually read all four agent outputs. Synthesizing from memory or assumptions defeats the purpose.
