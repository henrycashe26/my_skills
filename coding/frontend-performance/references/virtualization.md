# Long Lists and Tables

Rendering 1000+ rows is a layout problem, not a React problem. The browser has to compute layout for every element in the DOM.

## Virtualization

Render only what is visible. Use TanStack Virtual (formerly react-virtual):

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function ProductList({ products }: { products: Product[] }) {
  const parentRef = useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: products.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 72,  // estimated row height in px
  });

  return (
    <div ref={parentRef} className="h-[600px] overflow-auto">
      <div style={{ height: virtualizer.getTotalSize() }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.index}
            style={{
              position: 'absolute',
              top: virtualRow.start,
              height: virtualRow.size,
            }}
          >
            <ProductRow product={products[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  );
}
```

Use virtualization when: more than ~200 items in a list, a table with many rows and complex cells, or infinite scroll feeds.
