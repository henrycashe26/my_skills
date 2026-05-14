# Focus and Accessibility

Focus states must be visible. This is both good UX and a legal requirement (WCAG AA).

```typescript
// The Tailwind default focus:ring is fine, but customize to match your brand
className="focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-900 
  focus-visible:ring-offset-2"
```

**Minimum accessibility checklist:**
- All interactive elements reachable and operable by keyboard
- All images have meaningful `alt` text (empty string for decorative images)
- Form inputs have associated labels (via `htmlFor`/`id` or `aria-label`)
- Color is never the only way information is conveyed
- Text contrast: at least 4.5:1 for normal text, 3:1 for large text

Use `@axe-core/react` in development to catch common issues automatically:

```typescript
// In development only
if (process.env.NODE_ENV === 'development') {
  const { default: axe } = await import('@axe-core/react');
  const React = await import('react');
  const ReactDOM = await import('react-dom');
  axe(React, ReactDOM, 1000);
}
```
