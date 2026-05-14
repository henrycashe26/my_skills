# Buttons

```typescript
// Primary: one per page/section, highest visual weight
<button className="rounded-md bg-gray-900 px-4 py-2 text-sm font-medium text-white 
  hover:bg-gray-700 active:bg-gray-800 disabled:opacity-50 disabled:cursor-not-allowed
  focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-900">
  Save changes
</button>

// Secondary: lower weight, multiple allowed
<button className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm 
  font-medium text-gray-700 hover:bg-gray-50 ...">
  Cancel
</button>

// Ghost: for less important actions in dense UIs
<button className="rounded-md px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 ...">
  Edit
</button>
```

**Never:** gradient backgrounds on buttons unless there is a very specific brand reason. Never emojis in button text. Never more than one primary button visible at a time.
