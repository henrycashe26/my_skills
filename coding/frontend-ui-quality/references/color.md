# Color System

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

See [design-tokens.md](design-tokens.md) for the full color scale and semantic token CSS variable setup.
