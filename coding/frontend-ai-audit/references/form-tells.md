# Form and Dialog Tells

Form and dialog UI has its own fingerprint, largely inherited from shadcn/ui defaults.

---

## 1. UPPERCASE TRACKED Field Labels

The single strongest form-UI AI tell. It comes from the common shadcn `Label` usage pattern and Radix Form defaults.

```tsx
// AI: uppercase tracked muted label above every input
<label className="text-xs uppercase tracking-wide text-muted-foreground">
  LABEL
</label>
<input ... />

// Human: sentence case, normal tracking
<label className="text-sm text-gray-600">Label</label>
<input ... />

// Often better: no form chrome at all
<input
  className="bg-transparent border-none"
  value={node.label}
  onChange={...}
  aria-label="Node label"
/>
```

**Why it happens:** the shadcn docs use uppercase tracked labels in nearly every form example. Training data absorbed this as "form labels look like this."

**Fix:** sentence case, no tracking, no uppercase. For simple fields, consider inline editing (click the value, type) so there is no form chrome at all.

---

## 2. The Delete + Done Footer Pair

The AI-default dialog footer: destructive action outlined on the left, neutral primary filled on the right, both always visible.

```tsx
// AI: destructive action parked in the primary footer
<div className="flex justify-end gap-2">
  <Button variant="destructive-outline">Delete</Button>
  <Button>Done</Button>
</div>
```

What real apps do — Linear puts destructive actions in an overflow (three-dots) menu, not the footer. Notion hides delete behind a menu or a separate confirmation modal. Figma uses a keyboard shortcut or right-click, not a primary footer button. Stripe Dashboard requires typed confirmation for anything destructive ("type DELETE to confirm").

**Why it's a tell:** models are trained on "every dialog has Cancel + Save." They extrapolate destructive actions into the same footer slot. Real products protect destructive actions from accidental clicks.

**Fix:** move Delete into a menu, an icon in the dialog header, or require an explicit confirm step. Keep the primary footer for non-destructive actions.

---

## 3. "Are you sure?" Generic Confirm Modals

The generic confirmation dialog, straight from the shadcn `alert-dialog` example:

```tsx
<AlertDialog>
  <AlertDialogTitle>Are you sure?</AlertDialogTitle>
  <AlertDialogDescription>
    This action cannot be undone.
  </AlertDialogDescription>
  <AlertDialogCancel>Cancel</AlertDialogCancel>
  <AlertDialogAction>Continue</AlertDialogAction>
</AlertDialog>
```

Title, description, Cancel + Continue. Exactly the shadcn demo.

**Fix:** specific title ("Delete DoD Customer?"), specific description that names what is being deleted and what it affects ("This removes the node and 3 connections"), specific button labels ("Delete node" instead of "Continue").

---

## 4. Evenly Stacked Form Fields

Every field gets the same vertical treatment: label, input, next field. Spacing is uniform. No grouping, no visual hierarchy, no inline fields.

```tsx
// AI: uniform stack
<div className="space-y-4">
  <Field label="NAME" />
  <Field label="EMAIL" />
  <Field label="ROLE" />
  <Field label="DEPARTMENT" />
  <Field label="START DATE" />
</div>
```

**Fix:** group related fields (Name fields side-by-side; Address fields as a sub-group). Use inline layouts where they make sense. A form should look composed, not listed.
