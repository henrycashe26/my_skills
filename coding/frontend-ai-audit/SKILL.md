---
name: frontend-ai-audit
description: >
  Detect and fix AI-generated-looking frontend code, UI, and copy. Use this skill whenever
  you need to audit a frontend for the "AI slope" — the cluster of visual patterns, code
  patterns, and text patterns that make something unmistakably look like it was generated
  by an AI. Covers landing pages, in-product UI, diagrams and canvas tools, forms and
  dialogs. Trigger when the user asks "does this look AI-generated", "how do I make this
  look less AI", "why does this look generic", "audit this for AI tells", "this feels like
  a template", or uploads a screenshot of a landing page, component, dashboard, diagram,
  or form. Also trigger proactively when you see obvious AI visual tells in code you are
  reviewing: purple/blue gradients, emoji feature lists, gradient text headings, Inter
  font everywhere, wavy section dividers, uppercase tracked form labels, every-node-is-a-
  rounded-rectangle diagrams, or the cyan+coral+amber dashboard palette. This skill uses
  the humanizer skill for copy and extends it to visual and code domains. Being honest
  about what is AI-looking is more useful than being polite.
---

# Frontend AI Audit

The "AI slope" is a real phenomenon with a specific root cause. There is a cluster of visual, code, and copywriting patterns that co-occur so reliably in AI-generated frontends that they are immediately recognizable — and immediately undermine the credibility of what is being built.

Honesty beats politeness. Name the exact pattern, explain the mechanism, propose a concrete alternative. The canonical example: a `from-violet-500 to-indigo-600` diagonal gradient with `bg-clip-text text-transparent` headline text in Inter is not "a nice modern look" — it is the Tailwind UI default stack from 2019 reproduced verbatim, and it reads as template-generated.

For the root-cause explanation (Tailwind monoculture, template convergence, specificity failure, soullessness), see [`references/philosophy.md`](references/philosophy.md).

---

## Audit Workflow

When given a frontend to audit (code, screenshot, or URL):

1. **Scan visual tells** — color, typography, hero layout, decoration, animation. See [`references/visual-tells.md`](references/visual-tells.md) and the deeper [`references/visual-ai-tells.md`](references/visual-ai-tells.md).
2. **Scan diagram / canvas / in-product UI tells** — node shapes, redundant metadata, connect handles, monoradius, status palette. See [`references/diagram-tells.md`](references/diagram-tells.md).
3. **Scan form / dialog tells** — uppercase tracked labels, Delete + Done footers, generic confirms, uniform field stacks. See [`references/form-tells.md`](references/form-tells.md).
4. **Scan copy tells** — invoke the `/humanizer` skill first, then apply landing-page-specific phrases. See [`references/copy-tells.md`](references/copy-tells.md).
5. **Scan code tells** — spacing system, shadcn API hallucination, over-commenting, unnecessary abstractions, state-management pattern, name inflation. See [`references/code-tells.md`](references/code-tells.md).
6. **Score the AI slope** — 0 (human) to 10 (unmistakably AI), broken out per domain. See [`references/scoring.md`](references/scoring.md).
7. **Report findings** — each tell named specifically, with mechanism and concrete fix.
8. **Prioritize** — name the 3 highest-leverage changes first.

---

## Detection Categories

Each category is a self-contained reference file under `references/`. Load the ones relevant to what you're auditing — don't load all of them at once.

- **[philosophy.md](references/philosophy.md)** — root causes (Tailwind monoculture, template convergence, specificity failure) and the Karpathy-style "be specific" reasoning approach
- **[visual-tells.md](references/visual-tells.md)** — the 9 visual patterns: indigo problem, Inter monoculture, animated gradients, hero template, 3-column feature grid, wavy SVG dividers, typography stack, decorative elements, animation tells
- **[visual-ai-tells.md](references/visual-ai-tells.md)** — the deeper exhaustive catalog with extended color, layout, typography, decoration, animation, and icon entries (C1–C6, L1–L5, T1–T4, D1–D7, A1–A3, I1–I3)
- **[diagram-tells.md](references/diagram-tells.md)** — in-product UI: uniform node shapes, redundant metadata subtitles, vertical accent stripes, floating "+" connect handles, monoradius, cyan+coral+amber status palette
- **[form-tells.md](references/form-tells.md)** — uppercase tracked labels, Delete + Done footer pair, generic "Are you sure?" confirms, evenly stacked fields
- **[code-tells.md](references/code-tells.md)** — spacing collapse, shadcn prop hallucination, over-commenting, single-use wrappers, useState+useEffect data fetching, component name inflation
- **[copy-tells.md](references/copy-tells.md)** — guaranteed AI phrases (hero, features, social proof, CTA), filler transitions, contrast with specific human copy. Integrates with `/humanizer`
- **[scoring.md](references/scoring.md)** — 0–10 AI slope rubric, audit report requirements, and the full flat tell catalog as a quick reference

---

## Report Requirements

Every audit report must:

1. **Name each AI tell found** — the specific pattern, not "gradient background." "The hero uses `from-violet-500 to-indigo-600`."
2. **Explain the mechanism** — why this particular pattern signals AI (Tailwind UI default, shadcn demo, template convergence).
3. **Propose a concrete alternative** — not "use a better color" but "replace `from-violet-500 to-indigo-600` with `bg-gray-900`."
4. **Score each domain** — visual, copy, code, separately on the 0–10 scale.
5. **Name the 3 highest-leverage changes** — the smallest set of fixes that moves the score the most.

---

## Anti-patterns

- Saying "this looks AI-generated" without naming the specific pattern.
- Suggesting "use a better color" instead of a specific replacement.
- Polishing AI copy instead of replacing it (AI copy is vague by nature; polish does not fix vagueness).
- Skipping the humanizer skill on copy.
- Being polite when honesty would be more useful.

---

## Checklist

- [ ] Visual tells scanned (color, type, layout, decoration, animation)
- [ ] Diagram / canvas / app-UI tells scanned if applicable
- [ ] Form / dialog tells scanned if applicable
- [ ] Copy run through `/humanizer` first, then landing-page-specific phrases checked
- [ ] Code tells scanned (spacing, shadcn API, comments, abstractions, state, names)
- [ ] AI slope score given, broken out by domain
- [ ] Top 3 highest-leverage fixes named with concrete replacements
