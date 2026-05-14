# Empty States

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
