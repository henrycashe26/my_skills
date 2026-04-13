# Design Tokens Reference

## The Complete Token System

This is the full token structure for a production design system using Tailwind.

### Colors

```typescript
// tailwind.config.ts
const colors = {
  // Brand — pick ONE hue, use the full scale
  brand: {
    50: '#f0f9ff',
    100: '#e0f2fe',
    200: '#bae6fd',
    300: '#7dd3fc',
    400: '#38bdf8',
    500: '#0ea5e9',  // Primary action color
    600: '#0284c7',  // Hover state
    700: '#0369a1',
    800: '#075985',
    900: '#0c4a6e',
  },

  // Neutrals — used for 90%+ of the UI
  gray: {
    50: '#f8fafc',   // Page background (light mode)
    100: '#f1f5f9',  // Card background, input background
    200: '#e2e8f0',  // Borders, dividers
    300: '#cbd5e1',  // Disabled borders
    400: '#94a3b8',  // Placeholder text, disabled text
    500: '#64748b',  // Secondary text (muted)
    600: '#475569',  // Body text (secondary)
    700: '#334155',  // Body text (primary)
    800: '#1e293b',  // Headings (secondary)
    900: '#0f172a',  // Headings (primary), high-contrast text
    950: '#020617',  // Dark mode backgrounds
  },

  // Semantic — use sparingly for status
  success: { 50: '#f0fdf4', 500: '#22c55e', 700: '#15803d' },
  warning: { 50: '#fffbeb', 500: '#f59e0b', 700: '#b45309' },
  error: { 50: '#fef2f2', 500: '#ef4444', 700: '#b91c1c' },
};
```

### Semantic Tokens

Map semantic names to scale values. This is what you use in components — not raw colors.

```typescript
// In CSS variables (for dark mode support)
:root {
  --background: theme('colors.white');
  --background-muted: theme('colors.gray.50');
  --foreground: theme('colors.gray.900');
  --foreground-muted: theme('colors.gray.500');
  --border: theme('colors.gray.200');
  --border-strong: theme('colors.gray.300');
  --ring: theme('colors.gray.900');
  --primary: theme('colors.brand.500');
  --primary-hover: theme('colors.brand.600');
  --primary-foreground: theme('colors.white');
}

.dark {
  --background: theme('colors.gray.950');
  --background-muted: theme('colors.gray.900');
  --foreground: theme('colors.gray.50');
  --foreground-muted: theme('colors.gray.400');
  --border: theme('colors.gray.800');
  --border-strong: theme('colors.gray.700');
}
```

### Spacing Scale (8pt Grid)

```
0.5  = 2px
1    = 4px
1.5  = 6px
2    = 8px   ← base unit
3    = 12px
4    = 16px  ← common padding
5    = 20px
6    = 24px  ← section padding (small)
8    = 32px  ← section padding (medium)
10   = 40px
12   = 48px  ← section padding (large)
16   = 64px  ← section gap
20   = 80px
24   = 96px
32   = 128px
```

Prefer even-numbered values. Use 5, 7, 9 sparingly and only when a half-step is genuinely needed.

### Typography

```typescript
// Font size scale
text-xs   = 12px  // Timestamps, captions, badges
text-sm   = 14px  // Secondary content, dense UIs, table cells
text-base = 16px  // Default body
text-lg   = 18px  // Card titles, emphasized body
text-xl   = 20px  // Section labels
text-2xl  = 24px  // Page headings
text-3xl  = 30px  // Hero subheadings  
text-4xl  = 36px  // Hero headings
text-5xl+ = 48px+ // Display only, rarely

// Font weights — use only these three
font-normal   = 400  // Body text
font-medium   = 500  // UI labels, nav, buttons
font-semibold = 600  // Headings, emphasis

// Line heights
leading-none    = 1    // Display headings
leading-tight   = 1.25 // Headings
leading-snug    = 1.375 // Subheadings
leading-normal  = 1.5  // Body text
leading-relaxed = 1.625 // Long-form reading

// Letter spacing
tracking-tighter = -0.05em // Large display text
tracking-tight   = -0.025em // Headings (h1, h2)
tracking-normal  = 0       // Body
tracking-wide    = 0.025em // Small caps, UI labels at small sizes
```

### Shadows (Use Sparingly)

```
shadow-none  = nothing      — default, no elevation
shadow-sm    = 0 1px 2px    — very subtle, almost just a border
shadow       = 0 1px 3px    — card slight elevation
shadow-md    = 0 4px 6px    — floating element (dropdown, tooltip)
shadow-lg    = 0 10px 15px  — modal backdrop feel
shadow-xl    = 0 20px 25px  — modal itself

Ring (focus) = outline + offset, not shadow
```

Do not use `shadow-2xl` or custom shadows unless there is a specific need. The scale above covers everything.

### Border Radius

```
rounded-sm  = 2px   — small badges, tight inputs
rounded     = 4px   — default inputs, small buttons
rounded-md  = 6px   — cards (standard)
rounded-lg  = 8px   — larger cards, modals
rounded-xl  = 12px  — hero sections (sparingly)
rounded-2xl = 16px  — very rare, usually looks over-rounded
rounded-full        — avatars, pills, circular buttons
```

The common AI mistake: `rounded-xl` or `rounded-2xl` on every element. It reads as soft and template-generated. `rounded-md` is more refined.
