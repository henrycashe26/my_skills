# Spacing: The 8pt Grid

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

See [design-tokens.md](design-tokens.md) for the full spacing scale.
