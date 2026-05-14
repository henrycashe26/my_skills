# Diagram, Canvas, and App UI Tells

The landing-page tells don't cover in-product UI: system diagrams, graph editors, canvas tools, node-based editors, dashboards with many domain objects. These have their own cluster of AI patterns, and they're easy to miss if you only look for indigo gradients and wavy dividers.

---

## 1. Uniform Node Shape Across Roles

When every item in a diagram, graph, or topology is the same rounded rectangle, it is a strong AI tell. Real diagrams use shape to encode role: actor / person / party as a person icon or stadium shape, service or process as a rectangle, datastore as a cylinder or stacked-rectangles glyph, external system as a dashed border or distinct fill, decision or branch as a diamond.

```tsx
// AI: everything is the same card
<rect width={160} height={52} rx={8} />   // DoD Customer (an actor)
<rect width={160} height={52} rx={8} />   // Auth service (a process)
<rect width={160} height={52} rx={8} />   // Postgres (a datastore)
```

**Why it happens:** models trained on web/dashboard code have seen vastly more "cards in a grid" than proper architecture diagrams (which live in Lucid, Miro, and Figma — not in repos). The cheap default is "every node = card."

**Fix:** at minimum, make external nodes visually distinct from internal ones (dashed border, different fill, or different shape). For richer diagrams, commit to a small shape vocabulary and document it in a legend.

---

## 2. Redundant Metadata Subtitles

AI defaults to exhaustive labeling. A node that has its category encoded in its outline color AND in a left-edge accent stripe AND in a muted subtitle text is triple-coded. The subtitle is the tell.

```tsx
// AI: belt, suspenders, and a second belt
<g stroke={categoryColor}>                        // 1. outline color encodes category
  <rect width={6} fill={categoryColor} />         // 2. accent stripe also encodes it
  <text>{node.label}</text>
  <text className="muted">{categoryLabel}</text>  // 3. subtitle says it again
</g>
```

**Fix:** count how many ways you are communicating the same attribute. If it's more than one, drop the redundant ones. Belt-and-suspenders is an AI cadence, not a design virtue.

---

## 3. The Vertical Card-Accent Stripe

The horizontal accent stripe from landing pages (see Visual Tells §8) has a vertical cousin in node-based UIs: a 4–6px vertical bar on the left edge of each node, colored by category or status. Redundant with the outline color if both exist.

```tsx
<g>
  <rect width={160} height={52} stroke={categoryColor} />
  <rect width={6} height={52} fill={categoryColor} />  // ← vertical stripe
</g>
```

**Fix:** pick one.

---

## 4. The Floating "+" Connect Handle

The canonical AI way to express "add a connection from this node": a cyan or indigo filled circle with a white plus, parked next to whatever is selected.

What real tools do instead — Figma and FigJam put the affordance on the edge of the shape and activate it on hover; Excalidraw lets you drag from a side midpoint; Miro surfaces directional arrows on all four sides on hover; Lucidchart lets you drag-to-create from any shape edge. None of them park a filled button next to the selection.

**Why it's an AI tell:** training data weighs "button that does a thing" much more heavily than "hover affordance on an edge." The AI reaches for the most literal UI shape.

**Fix:** edge-hover affordances are the professional pattern. If you keep a visible button, make it ghost-styled, only visible on hover, and add a keyboard shortcut.

---

## 5. The "Every Surface Is rx=8" Monoradius

AI picks one border radius (usually 8px, Tailwind's `rounded-lg`) and applies it to every surface: nodes, popovers, cards, buttons, inputs, dropdowns, dialogs. The monolithic radius reads as generated.

```tsx
// AI: every surface has the same radius
<rect rx={8} />                          // node
<div className="rounded-lg" />           // popover
<button className="rounded-lg" />        // button
<input className="rounded-lg" />         // input
```

**Fix:** pick at least two radii and use them by role. Inputs and data-dense elements usually want tighter radii than containers and sheets. Linear uses roughly 2px on inputs, 6px on buttons, 8px on cards — intentional variation.

---

## 6. The "Serious Dashboard" Status Palette

A generic palette that appears in every AI-generated in-product UI: teal or cyan for "good," coral or red for "bad," amber or yellow for "warn," plus a neutral dark background. It is accessible and boring.

```css
/* AI serious-dashboard tokens */
--good: #22d3ee;    /* or #06b6d4, #14b8a6 */
--bad:  #f87171;    /* or #ef4444, #f43f5e */
--warn: #f59e0b;    /* or #fbbf24, #eab308 */
```

**Why it's a tell:** these are the "accessibility-safe status colors" that everyone lands on when they don't make a brand choice. A real product commits to one brand hue + neutrals and reserves status colors for genuine status, not decoration.

**Fix:** pick one brand color that is not teal, coral, or amber. Use it for selection, focus, and primary actions. Reserve red and yellow for actual errors and warnings, and encode status with shape or iconography too — not just color.
