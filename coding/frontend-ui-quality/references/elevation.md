# Borders and Elevation

The default Tailwind shadow scale is too dramatic for most UIs. Real apps use almost no shadow.

```typescript
// Appropriate use of elevation
rounded-lg border border-gray-200          // card in light mode — border, no shadow
rounded-lg border border-gray-200 shadow-sm // slightly elevated card
rounded-lg shadow-md                        // dropdown menus, popovers (floating)
rounded-lg shadow-xl                        // modals (highest elevation)
```

**The rule:** More shadow = more elevation = more separation from the page. Overusing shadows makes everything feel like it is floating randomly.

See [design-tokens.md](design-tokens.md) for the full shadow and border-radius scales.
