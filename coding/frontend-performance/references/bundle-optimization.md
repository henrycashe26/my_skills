# Bundle Optimization Reference

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
