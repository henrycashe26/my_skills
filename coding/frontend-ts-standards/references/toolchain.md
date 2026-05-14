# Toolchain

The tools used by teams that actually ship. Not the ones with the most GitHub stars.

## Runtime and Build: Bun

Bun replaces Node + npm + often esbuild in one install. For new projects, start here.

```bash
bun install                                    # ~10x faster than npm
bun run dev                                    # runs package.json scripts
bun build ./src/index.ts --outdir ./dist       # bundles frontend
bun test                                       # built-in test runner
bunx vitest                                    # vitest via bunx (better for React)
```

**Bun test vs Vitest:** Bun's built-in runner is great for pure TS/JS. Use Vitest when you need jsdom, React Testing Library, or snapshot testing — its ecosystem integration is more mature.

**Commit `bun.lockb`.** It is binary but it is the source of truth for exact versions.

For deep patterns: [`bun-patterns.md`](bun-patterns.md)

## TypeScript Config

Always strict. These settings catch real bugs, not theoretical ones.

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "target": "ES2022",
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "noEmit": true
  }
}
```

`noUncheckedIndexedAccess` is the one people skip and regret. It forces handling of `undefined` when indexing arrays — which is where a surprising number of runtime crashes actually come from.

## Linting and Formatting: Biome

Biome replaces ESLint + Prettier with one fast tool. No config conflicts between formatter and linter.

```json
{
  "formatter": {
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100
  },
  "linter": {
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedVariables": "error",
        "useExhaustiveDependencies": "warn"
      }
    }
  }
}
```

```bash
bunx biome check --apply .
```

**When ESLint is still correct:** Existing monorepos already configured, custom org-wide rules without Biome equivalents, or specific plugins (certain accessibility rules, import ordering with complex alias resolution). Do not rewrite a working ESLint setup just to switch.

## UI Framework

- **React + Vite** — SPAs, internal tools, dashboards
- **Next.js** — anything needing SEO, server rendering, or API routes
- Do not add Next.js complexity to a simple internal tool. The two are not interchangeable.

**Component library: shadcn/ui.** The key thing about shadcn: it copies components into your project. You own the code. This is not a bug — it means you can modify anything without forking a package.

```bash
bunx shadcn-ui@latest init
bunx shadcn-ui@latest add button card dialog table
```

**Accessible primitives: Radix UI.** When building custom dropdowns, dialogs, or comboboxes, use Radix primitives directly rather than rolling your own from scratch. Accessibility is hard to get right; Radix already did it.

## State Management Decision Tree

| Need | Tool |
|------|------|
| Data from an API (with caching, refetching) | TanStack Query |
| Simple local state | `useState` + `useContext` |
| Complex shared client state across many components | Zustand |
| Form state with validation | React Hook Form + Zod |
| State that belongs in the URL | nuqs |

Do not reach for Zustand until you have actually felt the pain of prop drilling through 4+ component layers. Do not use Redux in 2025 unless you are inheriting an existing Redux codebase.

## Runtime Validation: Zod

Validate at API boundaries and form inputs. Define the schema once, infer the type from it.

```typescript
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  role: z.enum(["admin", "user"]),
  createdAt: z.coerce.date(),
});

type User = z.infer<typeof UserSchema>;

// At the API boundary — this throws if the data is wrong
const user = UserSchema.parse(apiResponse);

// Or with a result you can handle
const result = UserSchema.safeParse(apiResponse);
if (!result.success) {
  console.error(result.error.flatten());
}
```

`as UserType` on data from an external source is a lie. The runtime data might not match the type. Zod makes this a hard error instead of a silent mismatch that surfaces as a bug later.

## CSS: Tailwind

Use Tailwind. Not CSS modules. Not styled-components for most use cases. The verbose class-based approach is searchable, collocated with markup, and eliminates naming decisions.

Configure a design token system in the Tailwind config:

```typescript
// tailwind.config.ts
theme: {
  extend: {
    colors: {
      brand: {
        50: "#f0f9ff",
        500: "#0ea5e9",
        900: "#0c4a6e",
      }
    }
  }
}
```

Use the 8pt spacing grid: `p-2` = 8px, `p-4` = 16px, `p-6` = 24px, `p-8` = 32px. Do not use arbitrary values like `p-[13px]` — if you need that, something is wrong with the design.
