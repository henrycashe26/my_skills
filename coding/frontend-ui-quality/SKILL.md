---
name: frontend-ui-quality
description: >
  UI design quality, visual consistency, component design, and UX best practices for
  frontend applications. Use this skill whenever you are designing or reviewing a UI —
  whether that is layout, typography, color, spacing, component patterns, accessibility,
  or motion. Also trigger when the user asks "does this look good", "how should I design
  this", "what's the best way to do X in UI", "how do I make this more polished", "is my
  spacing consistent", "how do professional apps handle this pattern", or when reviewing
  any component or page design. If the user uploads a screenshot and asks for feedback,
  this skill applies. Reference Linear, Vercel, Raycast, and Clerk as benchmarks for
  quality — not Dribbble shots, not AI-generated mockups.
---

# Frontend UI Quality

Good UI is not aesthetic preference. It is systematic. The cleanest interfaces are built on consistent systems: a spacing scale, a type scale, a color system, and a small set of interaction patterns repeated well. Novelty is usually a smell.

**Benchmarks:** Linear, Vercel, Raycast, Clerk. Not Dribbble, not Awwwards, not AI-generated mockups. See [references/benchmarks.md](references/benchmarks.md).

**Core reasoning approach (Karpathy):** Ask what the user is actually trying to do, not what looks impressive. State why a design decision makes sense. Simple patterns executed consistently beat clever patterns executed inconsistently.

## When to use

- Reviewing or designing any UI: layout, typography, color, spacing, components, motion.
- The user uploads a screenshot and asks for feedback.
- The user asks "does this look good", "how should I design this", "is my spacing consistent", "how do professional apps do X".
- Before shipping a new page or component, run the review workflow as a final pass.

## Review Workflow

When designing or reviewing a UI, work through these passes in order:

1. **Foundations.** Check the design system is in place — spacing on an 8pt grid, a modular type scale, a semantic color system, controlled use of elevation. If any of these are missing or inconsistent, fix them first. See [spacing.md](references/spacing.md), [typography.md](references/typography.md), [color.md](references/color.md), [elevation.md](references/elevation.md), [design-tokens.md](references/design-tokens.md).

2. **Components.** Audit individual components against tested patterns: buttons, forms, empty states, loading states, navigation. Look for the common breaks (gradient buttons, placeholder-as-label, missing empty states, spinner-only loading). See [buttons.md](references/buttons.md), [forms.md](references/forms.md), [empty-states.md](references/empty-states.md), [loading-states.md](references/loading-states.md), [navigation.md](references/navigation.md).

3. **Interaction.** Check motion communicates meaning rather than decorates. Verify focus states are visible and the basic accessibility checklist passes. See [motion.md](references/motion.md), [accessibility.md](references/accessibility.md).

4. **Anti-patterns.** Sweep for the usual suspects: too many grays, missing hover states, inconsistent icon sizing, overlong reading lines, card-everything. See [anti-patterns.md](references/anti-patterns.md).

5. **Compare to benchmarks.** Hold the UI up against Linear, Vercel, Raycast, Clerk. What do they all share that this UI is missing? See [benchmarks.md](references/benchmarks.md).

## Topics

Foundations:

- [spacing.md](references/spacing.md) — 8pt grid, when to break it, why `p-5` and `p-7` are smells.
- [typography.md](references/typography.md) — Modular type scale, weights, line height.
- [color.md](references/color.md) — Semantic tokens, palette principles, dark mode strategy.
- [elevation.md](references/elevation.md) — Borders and shadows, restrained elevation.
- [design-tokens.md](references/design-tokens.md) — Full token reference: colors, spacing, typography, shadows, radii.

Components:

- [buttons.md](references/buttons.md) — Primary, secondary, ghost variants. What never to do.
- [forms.md](references/forms.md) — Labels above inputs, error placement, validation timing.
- [empty-states.md](references/empty-states.md) — The state most devs skip; what a good one looks like.
- [loading-states.md](references/loading-states.md) — Skeletons over spinners; the 300ms rule.
- [navigation.md](references/navigation.md) — Main nav, tabs, breadcrumbs, back buttons.

Interaction:

- [motion.md](references/motion.md) — Animation communicates meaning; duration guide for micro-interactions through page transitions.
- [accessibility.md](references/accessibility.md) — Focus states, WCAG AA checklist, `@axe-core/react`.

Review:

- [anti-patterns.md](references/anti-patterns.md) — Common mistakes: card overuse, gray-soup, missing hovers, icon-size drift, placeholder-as-label, overlong lines.
- [benchmarks.md](references/benchmarks.md) — Linear, Vercel, Raycast, Clerk: what they share.

## Checklist

- [ ] Spacing values are 8pt-grid multiples
- [ ] Type scale uses a modular ratio; no arbitrary `text-[13px]`
- [ ] Colors come from semantic tokens, not raw hex
- [ ] No more than 3 hues in the UI
- [ ] Elevation is restrained; cards prefer border over shadow
- [ ] One primary button per section, no gradients, no emoji
- [ ] Every form input has a label above (not placeholder-as-label)
- [ ] Every list / table / data view has a designed empty state
- [ ] Loading uses content-shaped skeletons, not generic spinners
- [ ] Focus states are visible (`focus-visible:ring-*`)
- [ ] Motion durations sit in the 100–300ms range
- [ ] Reading content is capped at ~65ch (`max-w-prose`)
- [ ] UI holds up next to Linear / Vercel / Raycast / Clerk
