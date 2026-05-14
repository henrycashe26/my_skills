# Code Review Checklist

**Red flags — ask about these:**
- `any` types (except deliberate escape hatches with a comment explaining why)
- `as SomeType` on data from APIs, `localStorage`, or form inputs
- `useEffect` used to sync state with props (usually a derived state bug)
- Components longer than ~200 lines without a clear reason
- Business logic inside JSX instead of custom hooks or utility functions
- Components that fetch data AND contain significant business logic (separate concerns)
- Missing error and loading states in components that call APIs
- `useEffect(() => { fetchData() }, [])` — use TanStack Query instead

**Green flags — these are good:**
- Zod schemas that define both runtime shape and TypeScript type
- Custom hooks that return `{ data, isLoading, error }` cleanly
- Components that accept data as props and fire callbacks (easy to test)
- Tests that use `getByRole` and simulate real user interactions
