# Typography Scale

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

See [design-tokens.md](design-tokens.md) for the complete typography tokens including letter-spacing.
