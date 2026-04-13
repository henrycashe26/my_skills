---
name: frontend-ts-standards
description: >
  TypeScript frontend standards, toolchain, and testing practices for modern web apps.
  Use this skill whenever you are writing, reviewing, or auditing TypeScript frontend code —
  especially when setting up a new project, choosing between libraries, configuring Bun,
  writing tests with Vitest or Playwright, or reviewing code quality. Also trigger when the
  user mentions Bun, Vitest, Playwright, Biome, shadcn, Zod, Tanstack Query, Zustand, or asks
  "what's the right way to do X in a TypeScript frontend". If the user says "set up a frontend
  project", "write a test", "what stack should I use", "review this component", or "is this
  good TypeScript", this skill applies immediately.
---

# Frontend TypeScript Standards

What production-quality TypeScript frontend code actually looks like in 2025. The goal is not trends — it is shipping fast, catching bugs early, and not making future maintainers miserable.

**Core reasoning approach (Karpathy):** Think before coding. State assumptions. Simple over clever. Surgical edits over rewrites. Every decision needs a reason you can say out loud.

---

## The Toolchain

These are the tools used by teams that actually ship. Not the ones with the most GitHub stars.

### Runtime and Build: Bun

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

For deep patterns: `references/bun-patterns.md`

### TypeScript Config

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

### Linting and Formatting: Biome

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

### UI Framework

- **React + Vite** — SPAs, internal tools, dashboards
- **Next.js** — anything needing SEO, server rendering, or API routes
- Do not add Next.js complexity to a simple internal tool. The two are not interchangeable.

**Component library: shadcn/ui.** The key thing about shadcn: it copies components into your project. You own the code. This is not a bug — it means you can modify anything without forking a package.

```bash
bunx shadcn-ui@latest init
bunx shadcn-ui@latest add button card dialog table
```

**Accessible primitives: Radix UI.** When building custom dropdowns, dialogs, or comboboxes, use Radix primitives directly rather than rolling your own from scratch. Accessibility is hard to get right; Radix already did it.

### State Management Decision Tree

| Need | Tool |
|------|------|
| Data from an API (with caching, refetching) | TanStack Query |
| Simple local state | `useState` + `useContext` |
| Complex shared client state across many components | Zustand |
| Form state with validation | React Hook Form + Zod |
| State that belongs in the URL | nuqs |

Do not reach for Zustand until you have actually felt the pain of prop drilling through 4+ component layers. Do not use Redux in 2025 unless you are inheriting an existing Redux codebase.

### Runtime Validation: Zod

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

### CSS: Tailwind

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

---

## Testing

### What Tests Are Actually For

Tests are the specification of what the code does. If you cannot write a test for something, you probably do not understand what it should do.

Priority order:
1. **Unit tests** for pure functions and business logic — fast, catch regressions in seconds
2. **Component tests** with realistic data — catch "works in isolation but breaks when wired up"
3. **E2E tests** for critical user flows — slow, but the only way to catch "works in tests but not in a real browser"

Do not test implementation details. Test what renders and what happens when users interact. If your tests break when you rename an internal function, they are testing the wrong thing.

### Unit Tests: Vitest

```typescript
// currency.test.ts
import { describe, it, expect } from "vitest";
import { formatCurrency } from "./currency";

describe("formatCurrency", () => {
  it("formats positive numbers", () => {
    expect(formatCurrency(1234.56)).toBe("$1,234.56");
  });

  it("formats zero", () => {
    expect(formatCurrency(0)).toBe("$0.00");
  });

  it("handles negatives", () => {
    expect(formatCurrency(-50)).toBe("-$50.00");
  });
});
```

### Component Tests: React Testing Library

```typescript
// UserCard.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { UserCard } from "./UserCard";

it("shows edit button when user is the owner", async () => {
  render(<UserCard userId="123" currentUserId="123" />);
  expect(screen.getByRole("button", { name: /edit/i })).toBeInTheDocument();
});

it("hides edit button for other users", () => {
  render(<UserCard userId="123" currentUserId="456" />);
  expect(screen.queryByRole("button", { name: /edit/i })).not.toBeInTheDocument();
});
```

Query rules:
- `getByRole` first — it is what screen readers see, closest to real user experience
- `getBy` when the element must be there, `queryBy` when it might not, `findBy` for async
- Avoid `getByTestId` — it tests nothing meaningful about the component

### API Mocking: MSW

For component tests hitting APIs, intercept at the network level. Do not mock `fetch`. Do not mock Axios. MSW is more realistic and catches integration bugs that module-level mocks miss.

```typescript
// src/mocks/handlers.ts
import { http, HttpResponse } from "msw";

export const handlers = [
  http.get("/api/users/:id", ({ params }) => {
    return HttpResponse.json({
      id: params.id,
      name: "Ada Lovelace",
      email: "ada@babbage.com",
    });
  }),
  http.post("/api/users", async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({ id: "new-123", ...body }, { status: 201 });
  }),
];
```

### E2E: Playwright

Playwright over Cypress. It is faster, supports all browsers natively, and handles async flows better.

```typescript
// tests/auth.spec.ts
import { test, expect } from "@playwright/test";

test("user can log in and reach dashboard", async ({ page }) => {
  await page.goto("/login");
  await page.getByLabel("Email").fill("test@example.com");
  await page.getByLabel("Password").fill("password123");
  await page.getByRole("button", { name: "Sign in" }).click();
  await expect(page).toHaveURL("/dashboard");
  await expect(page.getByRole("heading", { name: "Dashboard" })).toBeVisible();
});
```

Run E2E only on CI. Do not try to cover everything with E2E — that is what unit and integration tests are for.

---

## Project Structure

```
src/
├── app/                    # Next.js app router OR Vite routes
├── components/
│   ├── ui/                 # shadcn components (you own these, edit freely)
│   └── [feature]/          # UserCard.tsx, InvoiceTable.tsx, etc.
├── lib/
│   ├── api/                # TanStack Query hooks, API client
│   ├── schemas/            # Zod schemas (source of truth for types)
│   └── utils/              # Pure utility functions
├── hooks/                  # Custom React hooks
└── types/                  # Shared types not derived from Zod schemas
```

### Component Pattern

```typescript
// Clear interface, single responsibility, data fetching in hook
interface ProductCardProps {
  productId: string;
  onAddToCart?: (productId: string) => void;
}

export function ProductCard({ productId, onAddToCart }: ProductCardProps) {
  const { data: product, isLoading, error } = useProduct(productId);

  if (isLoading) return <ProductCardSkeleton />;
  if (error) return <ErrorMessage message="Could not load product" />;
  if (!product) return null;

  return (
    <div className="rounded-lg border border-gray-200 p-4">
      <img src={product.imageUrl} alt={product.name} className="mb-3 rounded" />
      <h3 className="font-medium text-gray-900">{product.name}</h3>
      <p className="mt-1 text-sm text-gray-500">${product.price}</p>
      {onAddToCart && (
        <button
          onClick={() => onAddToCart(productId)}
          className="mt-3 w-full rounded-md bg-gray-900 px-4 py-2 text-sm text-white hover:bg-gray-700"
        >
          Add to cart
        </button>
      )}
    </div>
  );
}
```

---

## Code Review Checklist

**Red flags — ask about these:**
- `any` types (except deliberate escape hatches with a comment explaining why)
- `as SomeType` on data from APIs, `localStorage`, or form inputs
- `useEffect` used to sync state with props (usually a derived state bug)
- Components longer than ~200 lines without a clear reason
- Business logic inside JSX instead of custom hooks or utility functions
- Components that fetch data AND contain significant business logic (separate concerns)
- Missing error and loading states in components that call APIs
- `useEffect(() => { fetchData() }, [])` — use TanStack Query instead

**Green flags — these are good:**
- Zod schemas that define both runtime shape and TypeScript type
- Custom hooks that return `{ data, isLoading, error }` cleanly
- Components that accept data as props and fire callbacks (easy to test)
- Tests that use `getByRole` and simulate real user interactions

---

## Reference Files

- `references/bun-patterns.md` — Bun config, scripting, workspace setup, gotchas
- `references/testing-patterns.md` — Full MSW setup, RTL recipes, Playwright config
- `references/typescript-patterns.md` — Generic patterns, utility types, discriminated unions
