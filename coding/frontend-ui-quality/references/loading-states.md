# Loading States

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
