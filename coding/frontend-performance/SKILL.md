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

**Core reasoning approach (Karpathy):** Define the specific metric you are trying to move. State your hypothesis about what is slow and why. Verify the hypothesis with a profiling tool before writing a single line of optimization code.

---

## The Measurement Framework

Before touching anything, anchor to numbers. Without a baseline, you cannot know if you actually improved things.

### Core Web Vitals (the metrics that matter)

| Metric | Target | What it measures |
|--------|--------|-----------------|
| LCP (Largest Contentful Paint) | < 2.5s | When the main content loaded |
| FID / INP (Interaction to Next Paint) | < 200ms | How fast the UI responds to input |
| CLS (Cumulative Layout Shift) | < 0.1 | How much the page jumps around |
| TTFB (Time to First Byte) | < 800ms | Server response time |

Measure with: Lighthouse in Chrome DevTools, PageSpeed Insights, or WebPageTest.

### Profiling Tools

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

### The Mental Model

Think of performance in layers. Problems compound across layers.

```
Network → Parse → Render → Interaction
  ↓           ↓        ↓          ↓
TTFB      Bundle    React       Event
Transfer   Parse   Renders    Handlers
```

A 4MB bundle is a network problem AND a parse problem. A component that re-renders on every keystroke is a render problem. An event handler that does expensive work synchronously is an interaction problem.

---

## Bundle Size

The single highest-leverage thing in most apps. A smaller bundle loads faster, parses faster, and executes faster. Everything else is a rounding error compared to shipping 500KB of unused polyfills.

### Find What Is Big

```bash
# Vite
bunx vite-bundle-visualizer

# Next.js
bunx @next/bundle-analyzer
```

**Common culprits:**
- `moment.js` — 67KB gzipped. Replace with `date-fns` (or `dayjs`) which is tree-shakeable
- `lodash` — If you import `import _ from 'lodash'`, you get all 70KB. Import specifically: `import { debounce } from 'lodash-es'`
- `@mui/material` — Enormous. Prefer Radix UI + Tailwind
- `recharts` — Large. Consider `visx` or `chart.js` for simpler cases
- Large icon libraries — `import { IconOne } from 'react-icons'` pulls in the whole library. Use `lucide-react` (tree-shakeable) or import SVGs directly

### Code Splitting

Route-level splitting is free in Next.js. In Vite, use dynamic imports.

```typescript
// Instead of: import { HeavyChart } from './HeavyChart'
const HeavyChart = React.lazy(() => import('./HeavyChart'));

// Use it with Suspense
function Dashboard() {
  return (
    <Suspense fallback={<ChartSkeleton />}>
      <HeavyChart data={data} />
    </Suspense>
  );
}
```

Split on:
- Routes (always)
- Heavy components only shown on user interaction (modals, drawers with rich content)
- Components that depend on large libraries (PDF viewer, rich text editor, code highlighter)

Do not split tiny components — the network round trip costs more than loading them inline.

### Tree-shaking Requirements

For tree-shaking to work: ES module format (not CommonJS), named exports (not `export default { everything }`), and no side effects in the package.json sideEffects field.

```typescript
// Good — tree-shakeable
import { format, parseISO } from 'date-fns';

// Bad — pulls in everything
import dateFns from 'date-fns';
const formatted = dateFns.format(date, 'yyyy-MM-dd');
```

---

## React Rendering

React's default behavior is: when a component re-renders, all its children re-render too. Most of the time this is fine. When it is not fine, here is how to think about it.

### When to Memoize

The rule: memoize when you have measured a render problem, not before. Unnecessary memoization adds complexity and has its own performance cost.

```typescript
// useMemo: expensive calculation, not needed on every render
const sortedItems = useMemo(
  () => items.slice().sort((a, b) => a.price - b.price),
  [items]  // only re-sort when items changes
);

// useCallback: stable function reference for a child that is memoized
const handleSubmit = useCallback(
  (values: FormValues) => {
    dispatch(submitForm(values));
  },
  [dispatch]
);

// React.memo: skip re-render if props didn't change
const ProductRow = React.memo(function ProductRow({ product, onSelect }: Props) {
  return (
    <div onClick={() => onSelect(product.id)}>
      {product.name} — ${product.price}
    </div>
  );
});
```

**When memoization is wrong:** If the values you are passing as deps change every render anyway (e.g., a new object literal created in the render), memoization does nothing. `useMemo(() => compute(), [{ id: 1 }])` — the object `{ id: 1 }` is a new reference every time.

### State Placement

Where you put state determines what re-renders when it changes. This is the most common source of unnecessary renders.

```typescript
// Bad: state at the top causes the whole tree to re-render on every keystroke
function Page() {
  const [searchQuery, setSearchQuery] = useState("");
  return (
    <>
      <SearchInput value={searchQuery} onChange={setSearchQuery} />
      <ExpensiveProductGrid />  {/* re-renders on every keystroke */}
    </>
  );
}

// Good: state lives only where it is used
function Page() {
  return (
    <>
      <SearchSection />         {/* manages its own state */}
      <ExpensiveProductGrid />  {/* never re-renders from search */}
    </>
  );
}
```

### Context Performance

React context re-renders ALL consumers when the context value changes, even if only one field of the value changed.

```typescript
// Bad: changing any field re-renders all consumers
const AppContext = createContext({ user, theme, sidebarOpen });

// Good: split contexts by update frequency
const UserContext = createContext(user);      // changes rarely
const ThemeContext = createContext(theme);    // changes rarely
const UIContext = createContext(sidebarOpen); // changes often, isolated
```

For complex shared state with selective subscriptions, use Zustand — its `useStore(selector)` pattern means only the components that care about a specific slice re-render.

---

## Long Lists and Tables

Rendering 1000+ rows is a layout problem, not a React problem. The browser has to compute layout for every element in the DOM.

### Virtualization

Render only what is visible. Use TanStack Virtual (formerly react-virtual):

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function ProductList({ products }: { products: Product[] }) {
  const parentRef = useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: products.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 72,  // estimated row height in px
  });

  return (
    <div ref={parentRef} className="h-[600px] overflow-auto">
      <div style={{ height: virtualizer.getTotalSize() }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.index}
            style={{
              position: 'absolute',
              top: virtualRow.start,
              height: virtualRow.size,
            }}
          >
            <ProductRow product={products[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  );
}
```

Use virtualization when: more than ~200 items in a list, a table with many rows and complex cells, or infinite scroll feeds.

---

## Network and Data Fetching

### Avoid Request Waterfalls

A waterfall is when request B cannot start until request A finishes. Each one adds 100-300ms of latency.

```typescript
// Bad: waterfall — user waits for user, then for posts
const user = await fetchUser(userId);
const posts = await fetchPosts(user.id);

// Good: parallel — both start immediately
const [user, posts] = await Promise.all([
  fetchUser(userId),
  fetchPosts(userId),  // if you already know the ID
]);
```

With TanStack Query, fetch at the route level and use `prefetchQuery` or parallel queries:

```typescript
// Prefetch on hover — data is ready before the user clicks
function ProductLink({ productId }: { productId: string }) {
  const queryClient = useQueryClient();

  return (
    <a
      href={`/products/${productId}`}
      onMouseEnter={() => {
        queryClient.prefetchQuery({
          queryKey: ['product', productId],
          queryFn: () => fetchProduct(productId),
        });
      }}
    >
      View product
    </a>
  );
}
```

### Caching Strategy

TanStack Query's defaults are good. Understand what they do:
- `staleTime`: how long data is fresh (default 0 — always considered stale)
- `gcTime` (formerly cacheTime): how long unused data stays in memory (default 5 min)
- `refetchOnWindowFocus`: re-fetches when user switches back to the tab (default true)

For data that rarely changes (user profile, settings, product catalog):
```typescript
const { data } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchUser(userId),
  staleTime: 5 * 60 * 1000,  // treat as fresh for 5 minutes
});
```

---

## Images

Images are often the LCP element. Getting them right has an outsized impact.

```typescript
// Next.js: always use next/image — it handles lazy loading, sizing, formats
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Product hero"
  width={1200}
  height={600}
  priority  // add for above-the-fold images (prevents lazy loading the LCP)
  placeholder="blur"  // show blurred version while loading
  blurDataURL={base64BlurHash}
/>
```

**In non-Next.js apps:**
- Add `loading="lazy"` to all images below the fold
- Add `loading="eager"` + `fetchpriority="high"` to the LCP image
- Use `width` and `height` attributes on `<img>` to prevent layout shift (CLS)
- Serve WebP or AVIF — they are 30-50% smaller than JPEG for the same quality

---

## CSS and Animation

### Layout Thrashing

Reading a layout property (like `offsetWidth`) forces the browser to calculate layout immediately. If you then write to a layout property, and read again, that is layout thrashing — can make animations drop to single-digit fps.

```typescript
// Bad: causes layout thrashing in a loop
elements.forEach(el => {
  const width = el.offsetWidth;  // forces layout
  el.style.width = width + 10 + 'px';  // writes layout
});

// Good: batch reads, then batch writes
const widths = elements.map(el => el.offsetWidth);  // all reads
elements.forEach((el, i) => {
  el.style.width = widths[i] + 10 + 'px';  // all writes
});
```

### Smooth Animations

Animate `transform` and `opacity` only — these do not trigger layout or paint, so the GPU can handle them.

```css
/* Bad: triggers layout recalculation */
.card:hover { width: 110%; height: 110%; }

/* Good: GPU-composited, no layout recalc */
.card:hover { transform: scale(1.05); }
```

For JS-driven animations, use Framer Motion — it handles `will-change`, GPU promotion, and frame scheduling automatically.

```typescript
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.2, ease: 'easeOut' }}
>
  {content}
</motion.div>
```

---

## Quick Wins Checklist

When doing a performance audit, check these in order:

1. **Bundle size** — Run the visualizer. Anything over 100KB gzipped in a single chunk is suspicious
2. **Unused dependencies** — Run `bunx depcheck` and remove things you don't import
3. **Images** — Are they properly sized? Lazy loaded? Next/image or equivalent?
4. **Long lists** — Any list with more than 100 items that is not virtualized
5. **Waterfall requests** — Open the Network tab, look for sequential requests that could be parallel
6. **Heavy render paths** — React Profiler → sort by "self render time" → top offenders
7. **Large third-party scripts** — Analytics, chat widgets, A/B testing libraries loaded synchronously
8. **No staleTime on queries** — TanStack Query defaults cause a refetch on every mount without it

---

## Reference Files

- `references/react-performance.md` — Memoization decision tree, context patterns, Zustand selectors
- `references/bundle-optimization.md` — Per-library substitutions, tree-shaking recipes, chunk strategy
- `references/core-web-vitals.md` — LCP, INP, CLS detailed optimization techniques with code
