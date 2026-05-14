---
name: frontend-performance
description: >
  Frontend performance analysis, optimization, and auditing for React/TypeScript apps.
  Use this skill whenever you are investigating slow load times, high bundle sizes, janky
  animations, or poor Core Web Vitals scores. Also trigger when the user wants to optimize
  a specific component, reduce JavaScript bundle size, improve Time to First Byte, implement
  lazy loading, or asks "why is this slow", "how do I make this faster", "what's causing
  the jank", or "how do I reduce bundle size". If there are any hints of performance problems
  — slow renders, large deps, unvirtualized lists, waterfall requests — this skill applies.
  Always profile before optimizing. Never guess where the bottleneck is.
---

# Frontend Performance

Performance is measurable. The first job is always to measure, not to guess. Premature optimization is real — so is shipping a 4MB bundle that takes 8 seconds to load on a phone.

## Core principle

Define the specific metric you are trying to move. State your hypothesis about what is slow and why. Verify the hypothesis with a profiling tool before writing a single line of optimization code.

## The four layers

Think of performance in layers. Problems compound across layers.

```
Network → Parse → Render → Interaction
  ↓           ↓        ↓          ↓
TTFB      Bundle    React       Event
Transfer   Parse   Renders    Handlers
```

A 4MB bundle is a network problem AND a parse problem. A component that re-renders on every keystroke is a render problem. An event handler that does expensive work synchronously is an interaction problem.

## Audit workflow

1. **Anchor to numbers.** Pick the metric (LCP, INP, CLS, TTFB, bundle KB, render ms). Record a baseline with Lighthouse, the Performance tab, or the React Profiler. Targets and tools live in [measurement.md](references/measurement.md).
2. **Form a hypothesis.** Which layer is the problem in — network, parse, render, or interaction? Bundle size is usually the highest-leverage suspect; check it first.
3. **Profile, do not guess.** Open the right tool for the layer:
   - Bundle size → `bunx vite-bundle-visualizer` or `ANALYZE=true bun run build`
   - Waterfalls → Network tab, look for sequential requests
   - Re-renders → React DevTools Profiler, sort by self render time
   - Jank → Performance tab, look for long tasks (red bars) and forced reflows
4. **Fix the top offender.** Pull from the topic file for that layer (see Topics below).
5. **Re-measure.** Confirm the metric moved. If it did not, your hypothesis was wrong — go back to step 2.

## Quick wins checklist

When doing a performance audit, check these in order:

1. **Bundle size** — Run the visualizer. Anything over 100KB gzipped in a single chunk is suspicious
2. **Unused dependencies** — Run `bunx depcheck` and remove things you don't import
3. **Images** — Are they properly sized? Lazy loaded? Next/image or equivalent?
4. **Long lists** — Any list with more than 100 items that is not virtualized
5. **Waterfall requests** — Open the Network tab, look for sequential requests that could be parallel
6. **Heavy render paths** — React Profiler → sort by "self render time" → top offenders
7. **Large third-party scripts** — Analytics, chat widgets, A/B testing libraries loaded synchronously
8. **No staleTime on queries** — TanStack Query defaults cause a refetch on every mount without it

## Topics

Each topic file is self-contained — load only the one matching the layer you are debugging.

- [measurement.md](references/measurement.md) — Core Web Vitals targets (LCP, INP, CLS, TTFB), profiling tools, the network→parse→render→interaction mental model, Karpathy reasoning approach.
- [bundle-optimization.md](references/bundle-optimization.md) — Common culprits and substitutions (moment, lodash, MUI, react-icons), tree-shaking rules and mistakes, code splitting with `React.lazy` + Suspense, manual chunk strategy for Vite, dynamic import patterns.
- [react-rendering.md](references/react-rendering.md) — When to memoize (`useMemo`, `useCallback`, `React.memo`), why deps that change every render defeat memoization, state placement, context re-render pitfalls, Zustand selectors.
- [virtualization.md](references/virtualization.md) — TanStack Virtual for lists and tables over ~200 items.
- [network.md](references/network.md) — Avoiding request waterfalls with `Promise.all`, TanStack Query prefetch-on-hover, `staleTime` / `gcTime` / `refetchOnWindowFocus` defaults.
- [images.md](references/images.md) — `next/image` for everything, `priority` and `fetchpriority="high"` for the LCP image, `loading="lazy"` below the fold, WebP/AVIF, explicit `width`/`height` to prevent CLS.
- [css-animation.md](references/css-animation.md) — Layout thrashing (batch reads then writes), animating only `transform` and `opacity`, Framer Motion for JS-driven animation.

## Anti-patterns

- Optimizing without a baseline measurement.
- Wrapping everything in `useMemo` / `useCallback` without a measured render problem.
- Memoizing with deps that are recreated every render (new object literals, inline arrays).
- Splitting tiny components — the network round trip costs more than loading inline.
- Animating `width`/`height`/`top`/`left` instead of `transform`.
- Sequential `await` calls for data that could be fetched in parallel.
- Putting form input state at the top of the tree so the whole page re-renders on every keystroke.
- A single mega-context whose value changes often, re-rendering every consumer.

## Checklist before declaring done

- [ ] Baseline metric recorded before changes
- [ ] Hypothesis stated and tied to a specific layer
- [ ] Profile confirmed the hypothesis
- [ ] Fix applied from the relevant topic file
- [ ] Metric re-measured and moved in the right direction
- [ ] No regressions introduced in other Core Web Vitals
