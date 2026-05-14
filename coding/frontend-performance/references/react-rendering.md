# React Rendering

React's default behavior is: when a component re-renders, all its children re-render too. Most of the time this is fine. When it is not fine, here is how to think about it.

## When to Memoize

The rule: memoize when you have measured a render problem, not before. Unnecessary memoization adds complexity and has its own performance cost.

```typescript
// useMemo: expensive calculation, not needed on every render
const sortedItems = useMemo(
  () => items.slice().sort((a, b) => a.price - b.price),
  [items]  // only re-sort when items changes
);

// useCallback: stable function reference for a child that is memoized
const handleSubmit = useCallback(
  (values: FormValues) => {
    dispatch(submitForm(values));
  },
  [dispatch]
);

// React.memo: skip re-render if props didn't change
const ProductRow = React.memo(function ProductRow({ product, onSelect }: Props) {
  return (
    <div onClick={() => onSelect(product.id)}>
      {product.name} — ${product.price}
    </div>
  );
});
```

**When memoization is wrong:** If the values you are passing as deps change every render anyway (e.g., a new object literal created in the render), memoization does nothing. `useMemo(() => compute(), [{ id: 1 }])` — the object `{ id: 1 }` is a new reference every time.

## State Placement

Where you put state determines what re-renders when it changes. This is the most common source of unnecessary renders.

```typescript
// Bad: state at the top causes the whole tree to re-render on every keystroke
function Page() {
  const [searchQuery, setSearchQuery] = useState("");
  return (
    <>
      <SearchInput value={searchQuery} onChange={setSearchQuery} />
      <ExpensiveProductGrid />  {/* re-renders on every keystroke */}
    </>
  );
}

// Good: state lives only where it is used
function Page() {
  return (
    <>
      <SearchSection />         {/* manages its own state */}
      <ExpensiveProductGrid />  {/* never re-renders from search */}
    </>
  );
}
```

## Context Performance

React context re-renders ALL consumers when the context value changes, even if only one field of the value changed.

```typescript
// Bad: changing any field re-renders all consumers
const AppContext = createContext({ user, theme, sidebarOpen });

// Good: split contexts by update frequency
const UserContext = createContext(user);      // changes rarely
const ThemeContext = createContext(theme);    // changes rarely
const UIContext = createContext(sidebarOpen); // changes often, isolated
```

For complex shared state with selective subscriptions, use Zustand — its `useStore(selector)` pattern means only the components that care about a specific slice re-render.
