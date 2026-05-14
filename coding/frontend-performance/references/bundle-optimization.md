# Bundle Optimization Reference

The single highest-leverage thing in most apps. A smaller bundle loads faster, parses faster, and executes faster. Everything else is a rounding error compared to shipping 500KB of unused polyfills.

## Find What Is Big

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

## Dependency Substitutions

Common large dependencies and their lighter alternatives:

| Replace | With | Size savings |
|---------|------|-------------|
| `moment` (67KB gz) | `date-fns` or `dayjs` | ~60KB |
| `lodash` (70KB gz) | `lodash-es` + named imports | ~60KB |
| `@mui/material` | `radix-ui` + Tailwind | ~200KB+ |
| `react-icons` (bulk import) | `lucide-react` (tree-shaken) | ~100KB+ |
| `axios` | native `fetch` + `ky` | ~10KB |
| `uuid` | `crypto.randomUUID()` | ~8KB |
| `classnames` | `clsx` + `tailwind-merge` | ~1KB |

## Checking Bundle Size

```bash
# Vite
bunx vite-bundle-visualizer

# Webpack / CRA
bunx webpack-bundle-analyzer

# Next.js
ANALYZE=true bun run build
# Requires: bun add -d @next/bundle-analyzer
```

## Code Splitting

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

## Manual Chunk Strategy (Vite)

```typescript
// vite.config.ts
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          // Separate vendor chunks
          if (id.includes('node_modules/react')) return 'react';
          if (id.includes('node_modules/@tanstack')) return 'tanstack';
          if (id.includes('node_modules/framer-motion')) return 'framer';
        },
      },
    },
  },
});
```

## Dynamic Import Patterns

```typescript
// Route-level code splitting (React Router)
const ProductPage = lazy(() => import('./pages/ProductPage'));
const CheckoutPage = lazy(() => import('./pages/CheckoutPage'));

// Conditional loading (feature flags, role-based)
async function loadAdminPanel() {
  if (!user.isAdmin) return null;
  const { AdminPanel } = await import('./components/AdminPanel');
  return AdminPanel;
}

// Library-level: load heavy libs only when needed
async function generatePDF(data: ReportData) {
  const { jsPDF } = await import('jspdf');
  const doc = new jsPDF();
  // ...
}
```

## Tree-Shaking Requirements

For tree-shaking to work, the package must:
1. Use ES module format (`"module"` or `"exports"` field in package.json)
2. Use named exports
3. Mark itself as side-effect-free in package.json: `"sideEffects": false`

Check with: `bunx is-esm package-name`

```typescript
// Good — tree-shakeable
import { format, parseISO } from 'date-fns';

// Bad — pulls in everything
import dateFns from 'date-fns';
const formatted = dateFns.format(date, 'yyyy-MM-dd');
```

## Common Tree-Shaking Mistakes

```typescript
// WRONG: imports entire lodash
import _ from 'lodash';
const sorted = _.sortBy(items, 'price');

// RIGHT: named import from lodash-es
import { sortBy } from 'lodash-es';
const sorted = sortBy(items, 'price');

// WRONG: imports all of react-icons
import { FaRocket, FaShield } from 'react-icons/fa';

// RIGHT: use lucide-react (actually tree-shakeable)
import { Rocket, Shield } from 'lucide-react';
```
