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

**Core reasoning approach (Karpathy):** Ask what the user is actually trying to do, not what looks impressive. State why a design decision makes sense. Simple patterns executed consistently beat clever patterns executed inconsistently.

---

## The Design System Foundation

Before any visual polish, these four systems need to be defined. Without them, every component is an individual decision and inconsistency accumulates.

### Spacing: The 8pt Grid

Every spacing value should be a multiple of 4 or 8. This creates visual rhythm without effort.

```typescript
// tailwind.config.ts — the default Tailwind spacing already follows this
// p-1 = 4px, p-2 = 8px, p-3 = 12px, p-4 = 16px, p-6 = 24px, p-8 = 32px

// Good: consistent 8pt spacing
<div className="p-6 space-y-4">
  <h2 className="mb-2">Title</h2>
  <p className="text-sm">Content</p>
</div>

// Bad: arbitrary pixel values that break the rhythm
<div style={{ padding: '13px', marginBottom: '7px' }}>
```

**The rule:** If you are reaching for `p-5` (20px) or `p-7` (28px), reconsider. Those values exist but break the major rhythm. Prefer 4, 8, 12, 16, 24, 32, 48, 64.

### Typography Scale

Use a modular scale. The 1.25 ratio (Major Third) works well for UI:

| Scale | Size | Use |
|-------|------|-----|
| xs | 12px | Captions, timestamps, labels |
| sm | 14px | Body text in dense UIs, secondary content |
| base | 16px | Default body text |
| lg | 18px | Large body, card titles |
| xl | 20px | Section headings |
| 2xl | 24px | Page headings |
| 3xl | 30px | Hero headings |
| 4xl+ | 36px+ | Display only |

```typescript
// Good: semantic sizing choices
<h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
<p className="text-sm text-gray-500">Last updated 2 hours ago</p>

// Bad: too many sizes, no system
<h1 className="text-[28px]">Dashboard</h1>
<p className="text-[13px]">Last updated 2 hours ago</p>
```

**Font weight:** Use only two or three weights: regular (400), medium (500), semibold (600). Bold (700) sparingly for strong emphasis only. Never use multiple fonts unless you have a specific reason.

**Line height:** 1.5 for body text, 1.2–1.3 for headings. Tight leading on large text, looser on small text.

### Color System

Define colors as semantic tokens, not raw hex values. The token describes the purpose, not the appearance — which lets you retheme without hunting through files.

```typescript
// In your design system / tailwind config:
colors: {
  // Neutral scale
  gray: { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 },
  
  // Brand colors
  brand: { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900 },
  
  // Semantic tokens
  background: { DEFAULT: 'gray.50', muted: 'gray.100' },
  foreground: { DEFAULT: 'gray.900', muted: 'gray.500', subtle: 'gray.400' },
  border: { DEFAULT: 'gray.200', strong: 'gray.300' },
  destructive: { DEFAULT: 'red.600', foreground: 'white' },
}
```

**Color palette principles:**
- One primary brand color (choose a hue, use the full scale)
- Neutral grays for everything else — backgrounds, borders, text
- Semantic colors: success (green), warning (amber), error (red) — used sparingly
- Do not use more than 3 hues in one UI unless you have a very good reason

**Dark mode:** Use CSS variables mapped to Tailwind tokens. When a class or value needs to change in dark mode, change the token — do not scatter `dark:` prefixes everywhere.

### Borders and Elevation

The default Tailwind shadow scale is too dramatic for most UIs. Real apps use almost no shadow.

```typescript
// Appropriate use of elevation
rounded-lg border border-gray-200          // card in light mode — border, no shadow
rounded-lg border border-gray-200 shadow-sm // slightly elevated card
rounded-lg shadow-md                        // dropdown menus, popovers (floating)
rounded-lg shadow-xl                        // modals (highest elevation)
```

**The rule:** More shadow = more elevation = more separation from the page. Overusing shadows makes everything feel like it is floating randomly.

---

## Component Patterns

How specific components should work. These patterns exist because they have been tested against real user expectations.

### Buttons

```typescript
// Primary: one per page/section, highest visual weight
<button className="rounded-md bg-gray-900 px-4 py-2 text-sm font-medium text-white 
  hover:bg-gray-700 active:bg-gray-800 disabled:opacity-50 disabled:cursor-not-allowed
  focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-900">
  Save changes
</button>

// Secondary: lower weight, multiple allowed
<button className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm 
  font-medium text-gray-700 hover:bg-gray-50 ...">
  Cancel
</button>

// Ghost: for less important actions in dense UIs
<button className="rounded-md px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 ...">
  Edit
</button>
```

**Never:** gradient backgrounds on buttons unless there is a very specific brand reason. Never emojis in button text. Never more than one primary button visible at a time.

### Forms

Label above input. Placeholder text as a hint, not a label replacement (placeholder disappears when typing).

```typescript
<div className="space-y-1.5">
  <label htmlFor="email" className="block text-sm font-medium text-gray-700">
    Email address
  </label>
  <input
    id="email"
    type="email"
    className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm
      placeholder-gray-400 focus:border-gray-900 focus:outline-none focus:ring-1 
      focus:ring-gray-900"
    placeholder="you@example.com"
  />
  {error && (
    <p className="text-sm text-red-600">{error}</p>
  )}
</div>
```

Error states: show below the field, in red, immediately after the user finishes typing (not on submit only for inline validators). For server errors, show them clearly at the top of the form or next to the relevant field.

### Empty States

Every list, table, or data view needs an empty state. This is the thing most developers skip and users notice.

```typescript
// Good empty state: explains what is missing, gives the user something to do
function EmptyProductList() {
  return (
    <div className="flex flex-col items-center justify-center py-16 text-center">
      <div className="rounded-full bg-gray-100 p-4">
        <PackageIcon className="h-8 w-8 text-gray-400" />
      </div>
      <h3 className="mt-4 text-sm font-semibold text-gray-900">No products</h3>
      <p className="mt-1 text-sm text-gray-500">
        Get started by adding your first product.
      </p>
      <button className="mt-6 ...">Add product</button>
    </div>
  );
}
```

### Loading States

Match the shape of the content that is loading (skeleton) rather than showing a generic spinner.

```typescript
// Good: skeleton matches the real content layout
function ProductCardSkeleton() {
  return (
    <div className="animate-pulse rounded-lg border border-gray-200 p-4">
      <div className="h-40 rounded bg-gray-200" />
      <div className="mt-3 h-4 w-3/4 rounded bg-gray-200" />
      <div className="mt-2 h-4 w-1/2 rounded bg-gray-200" />
    </div>
  );
}
```

Do not: show spinners for content that will take under 300ms to load (perceived as flicker). Do not: show nothing while loading (user thinks the page is broken). Use `Suspense` boundaries strategically — not around every component.

### Navigation

- Main nav: clear labels, active state that is visually distinct but not garish
- Sub-nav / tabs: border-bottom active indicator (not background fill for tabs)
- Breadcrumbs: for deep hierarchies, not needed for flat structure
- Back button: only when the navigation is not obvious from context

---

## Interaction Design

### Motion

Animation should communicate meaning, not decorate. The bar for adding motion is: "does this help the user understand what happened?"

```typescript
// Good use of motion: helps user track where the panel came from
<AnimatePresence>
  {isOpen && (
    <motion.div
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '100%' }}
      transition={{ type: 'spring', damping: 30, stiffness: 300 }}
      className="fixed right-0 top-0 h-full w-80 bg-white shadow-xl"
    >
      {content}
    </motion.div>
  )}
</AnimatePresence>

// Subtle fade for content appearing
<motion.div
  initial={{ opacity: 0, y: 4 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.15 }}
>
  {content}
</motion.div>
```

**Duration guide:**
- Micro-interactions (button press, checkbox toggle): 100–150ms
- Panel / drawer open/close: 200–250ms
- Modal appear: 150–200ms
- Page transitions: 200–300ms
- Anything over 400ms feels slow unless it is a deliberate loading animation

### Focus and Accessibility

Focus states must be visible. This is both good UX and a legal requirement (WCAG AA).

```typescript
// The Tailwind default focus:ring is fine, but customize to match your brand
className="focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-900 
  focus-visible:ring-offset-2"
```

**Minimum accessibility checklist:**
- All interactive elements reachable and operable by keyboard
- All images have meaningful `alt` text (empty string for decorative images)
- Form inputs have associated labels (via `htmlFor`/`id` or `aria-label`)
- Color is never the only way information is conveyed
- Text contrast: at least 4.5:1 for normal text, 3:1 for large text

Use `@axe-core/react` in development to catch common issues automatically:

```typescript
// In development only
if (process.env.NODE_ENV === 'development') {
  const { default: axe } = await import('@axe-core/react');
  const React = await import('react');
  const ReactDOM = await import('react-dom');
  axe(React, ReactDOM, 1000);
}
```

---

## What Good Actually Looks Like

Reference these products when asking "is this good?" — not Dribbble, not Awwwards, not AI-generated design concepts. These are products people use every day that have earned their design over time.

**Linear** — Density done right. Information-rich without feeling cluttered. Excellent keyboard navigation. The "everything is a shortcut" model.

**Vercel** — Dark mode done correctly. Thoughtful use of code blocks. The deployment status visualization. Clean data tables.

**Raycast** — Command palette pattern. Fast, keyboard-first. Demonstrates what "native feel" means in an Electron app.

**Clerk** — Auth UI components that actually look good. Shows that forms do not have to be ugly.

**What they all have in common:**
- A small, consistent color palette
- Typography that is readable without decoration
- Spacing that is generous but not wasteful
- Clear visual hierarchy (one thing draws the eye first)
- Interactions that feel immediate (< 100ms feedback)
- Empty and error states that are actually designed

---

## Common Mistakes

**Overuse of card containers.** Not everything needs to be in a card. Cards imply separation and elevation. Use them when you need to group related content that should be visually distinct from its surroundings — not as a default container for everything.

**Too many shades of gray.** Pick two or three: a background gray, a border gray, a text gray. More than that and the hierarchy becomes noise.

**Interactive elements without hover states.** Every clickable element needs some visual feedback: a hover color change, a cursor change, or both.

**Inconsistent icon sizing.** Stick to one or two icon sizes across the app (16px and 20px is a common pairing). Mixing 14px, 16px, 18px, 20px icons is visible and feels amateur.

**Placeholder text as label.** When the user starts typing, the label disappears and they forget what the field was for. Always have a label above.

**Long lines of text.** Optimal reading line length is 50–80 characters. If your content spans the full width of a 1440px screen, the line length is too long. Use `max-w-prose` (65ch) for reading content.

---

## Reference Files

- `references/design-tokens.md` — Full color system, spacing, typography token setup
- `references/component-patterns.md` — Extended component library: tables, comboboxes, command palettes, toasts
- `references/animation-guidelines.md` — Framer Motion recipes, transition timing guide
