# Forms

Label above input. Placeholder text as a hint, not a label replacement (placeholder disappears when typing).

```typescript
<div className="space-y-1.5">
  <label htmlFor="email" className="block text-sm font-medium text-gray-700">
    Email address
  </label>
  <input
    id="email"
    type="email"
    className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm
      placeholder-gray-400 focus:border-gray-900 focus:outline-none focus:ring-1 
      focus:ring-gray-900"
    placeholder="you@example.com"
  />
  {error && (
    <p className="text-sm text-red-600">{error}</p>
  )}
</div>
```

Error states: show below the field, in red, immediately after the user finishes typing (not on submit only for inline validators). For server errors, show them clearly at the top of the form or next to the relevant field.
