# Measurement and Profiling

Before touching anything, anchor to numbers. Without a baseline, you cannot know if you actually improved things.

## Core Web Vitals (the metrics that matter)

| Metric | Target | What it measures |
|--------|--------|-----------------|
| LCP (Largest Contentful Paint) | < 2.5s | When the main content loaded |
| FID / INP (Interaction to Next Paint) | < 200ms | How fast the UI responds to input |
| CLS (Cumulative Layout Shift) | < 0.1 | How much the page jumps around |
| TTFB (Time to First Byte) | < 800ms | Server response time |

Measure with: Lighthouse in Chrome DevTools, PageSpeed Insights, or WebPageTest.

## Profiling Tools

1. **Chrome DevTools Performance tab** — Record a trace, look for long tasks (red bars), layout thrashing, forced reflows
2. **React DevTools Profiler** — Identify which components render unnecessarily and why
3. **`vite-bundle-visualizer` or `rollup-plugin-visualizer`** — See what is actually in your bundle
4. **`@next/bundle-analyzer`** — For Next.js projects

```bash
# Analyze bundle in Vite
bunx vite-bundle-visualizer

# For Next.js
ANALYZE=true bun run build
```

## The Mental Model

Think of performance in layers. Problems compound across layers.

```
Network → Parse → Render → Interaction
  ↓           ↓        ↓          ↓
TTFB      Bundle    React       Event
Transfer   Parse   Renders    Handlers
```

A 4MB bundle is a network problem AND a parse problem. A component that re-renders on every keystroke is a render problem. An event handler that does expensive work synchronously is an interaction problem.

## Core reasoning approach (Karpathy)

Define the specific metric you are trying to move. State your hypothesis about what is slow and why. Verify the hypothesis with a profiling tool before writing a single line of optimization code.
