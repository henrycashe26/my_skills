# Network and Data Fetching

## Avoid Request Waterfalls

A waterfall is when request B cannot start until request A finishes. Each one adds 100-300ms of latency.

```typescript
// Bad: waterfall — user waits for user, then for posts
const user = await fetchUser(userId);
const posts = await fetchPosts(user.id);

// Good: parallel — both start immediately
const [user, posts] = await Promise.all([
  fetchUser(userId),
  fetchPosts(userId),  // if you already know the ID
]);
```

With TanStack Query, fetch at the route level and use `prefetchQuery` or parallel queries:

```typescript
// Prefetch on hover — data is ready before the user clicks
function ProductLink({ productId }: { productId: string }) {
  const queryClient = useQueryClient();

  return (
    <a
      href={`/products/${productId}`}
      onMouseEnter={() => {
        queryClient.prefetchQuery({
          queryKey: ['product', productId],
          queryFn: () => fetchProduct(productId),
        });
      }}
    >
      View product
    </a>
  );
}
```

## Caching Strategy

TanStack Query's defaults are good. Understand what they do:
- `staleTime`: how long data is fresh (default 0 — always considered stale)
- `gcTime` (formerly cacheTime): how long unused data stays in memory (default 5 min)
- `refetchOnWindowFocus`: re-fetches when user switches back to the tab (default true)

For data that rarely changes (user profile, settings, product catalog):
```typescript
const { data } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchUser(userId),
  staleTime: 5 * 60 * 1000,  // treat as fresh for 5 minutes
});
```
