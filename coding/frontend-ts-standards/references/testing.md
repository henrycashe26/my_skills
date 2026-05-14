# Testing

## What Tests Are Actually For

Tests are the specification of what the code does. If you cannot write a test for something, you probably do not understand what it should do.

Priority order:
1. **Unit tests** for pure functions and business logic — fast, catch regressions in seconds
2. **Component tests** with realistic data — catch "works in isolation but breaks when wired up"
3. **E2E tests** for critical user flows — slow, but the only way to catch "works in tests but not in a real browser"

Do not test implementation details. Test what renders and what happens when users interact. If your tests break when you rename an internal function, they are testing the wrong thing.

## Unit Tests: Vitest

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

## Component Tests: React Testing Library

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

## API Mocking: MSW

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

## E2E: Playwright

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
