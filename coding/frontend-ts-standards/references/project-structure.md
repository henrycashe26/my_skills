# Project Structure

```
src/
├── app/                    # Next.js app router OR Vite routes
├── components/
│   ├── ui/                 # shadcn components (you own these, edit freely)
│   └── [feature]/          # UserCard.tsx, InvoiceTable.tsx, etc.
├── lib/
│   ├── api/                # TanStack Query hooks, API client
│   ├── schemas/            # Zod schemas (source of truth for types)
│   └── utils/              # Pure utility functions
├── hooks/                  # Custom React hooks
└── types/                  # Shared types not derived from Zod schemas
```

## Component Pattern

```typescript
// Clear interface, single responsibility, data fetching in hook
interface ProductCardProps {
  productId: string;
  onAddToCart?: (productId: string) => void;
}

export function ProductCard({ productId, onAddToCart }: ProductCardProps) {
  const { data: product, isLoading, error } = useProduct(productId);

  if (isLoading) return <ProductCardSkeleton />;
  if (error) return <ErrorMessage message="Could not load product" />;
  if (!product) return null;

  return (
    <div className="rounded-lg border border-gray-200 p-4">
      <img src={product.imageUrl} alt={product.name} className="mb-3 rounded" />
      <h3 className="font-medium text-gray-900">{product.name}</h3>
      <p className="mt-1 text-sm text-gray-500">${product.price}</p>
      {onAddToCart && (
        <button
          onClick={() => onAddToCart(productId)}
          className="mt-3 w-full rounded-md bg-gray-900 px-4 py-2 text-sm text-white hover:bg-gray-700"
        >
          Add to cart
        </button>
      )}
    </div>
  );
}
```
