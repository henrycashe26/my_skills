# Bun Patterns and Configuration

## Project Setup

```bash
# New project
bun init
bun add react react-dom
bun add -d typescript @types/react @types/react-dom vite @vitejs/plugin-react biome

# Install all deps (reads package.json)
bun install

# Run a script
bun run dev
bun run build
bun run test
```

## package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "test": "vitest",
    "test:e2e": "playwright test",
    "lint": "biome check .",
    "lint:fix": "biome check --apply .",
    "typecheck": "tsc --noEmit"
  }
}
```

## Workspaces (Monorepo)

```json
{
  "workspaces": ["packages/*", "apps/*"]
}
```

```bash
bun install          # installs all workspace deps
bun --filter web dev # runs 'dev' in the 'web' workspace only
```

## Bun Test (Built-in Runner)

Use for non-React utility code. Bun test is Jest-compatible.

```typescript
import { test, expect, describe, beforeEach } from "bun:test";

describe("parseAmount", () => {
  test("parses dollar string", () => {
    expect(parseAmount("$1,234.56")).toBe(1234.56);
  });

  test("handles empty string", () => {
    expect(parseAmount("")).toBe(0);
  });
});
```

Run: `bun test` or `bun test --watch`

## Gotchas

**bun.lockb is binary** — do not edit it, do commit it. If you get conflicts, delete it and run `bun install` fresh.

**`bunx` vs `bun x`** — identical. `bunx vitest` runs vitest without installing it globally.

**Bun does not support all Node.js APIs** — most work, but some native addons may not. Check if a package uses `node-gyp` before assuming it works.

**`bun build` for bundling** — Good for simple cases. For complex Vite plugins or Next.js, use those bundlers instead.

**Environment variables** — Bun reads `.env` files automatically. Access via `process.env.VAR` or `Bun.env.VAR`.

## Vite Config with Bun

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router-dom'],
        },
      },
    },
  },
  resolve: {
    alias: {
      '@': '/src',
    },
  },
});
```
