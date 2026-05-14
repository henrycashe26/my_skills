# The AI Slope Score and Tell Catalog

How to rate a frontend for AI-ness, and a flat quick-reference of every tell with its fix.

---

## The AI Slope Score

Rate the frontend from 0–10 overall. Also rate each domain:

| Score | Meaning |
|-------|---------|
| 0–2 | Looks genuinely designed — specific, opinionated, nothing generic |
| 3–4 | A few AI tells but mostly intentional; easy fixes |
| 5–6 | Clearly template-based; multiple co-occurring tells |
| 7–8 | Strong AI signal; the template is recognizable |
| 9–10 | Unmistakably AI; the full stack is present |

**The audit report must:**
1. Name each AI tell found (the specific pattern, not "gradient background")
2. Explain the mechanism (why this particular pattern signals AI)
3. Propose a concrete alternative (not "use a better color" but "replace `from-violet-500 to-indigo-600` with `bg-gray-900`")
4. Score each domain: visual, copy, code
5. Name the 3 highest-leverage changes

---

## Quick Reference: Full Tell Catalog

**Color:**
- `from-violet-500 to-indigo-600` or any purple/indigo gradient → solid brand color
- Animated/shifting gradient background → static background
- Purple-black dark mode (`#0f0f23`, `#1a1a2e`) → true dark gray (`#0f172a`, `#09090b`)

**Typography:**
- Inter font with no intentional weight system → commit to a specific typographic system
- Gradient text headline → `text-gray-900 font-semibold tracking-tight`
- `font-bold` on all headings → `font-semibold`, reserve bold for actual emphasis
- Title Case On Everything → sentence case

**Layout:**
- Full AI template (hero + features + social proof + pricing + CTA) → break at least 2 elements
- Solid color rectangle in hero → real screenshot or remove
- 3-column feature grid with icon pills + emojis → 2-column or list layout, no pills, no emojis
- Wavy SVG section dividers → `border-t border-gray-100` or background color change
- Pill badge with sparkle emoji → remove or use plain text label

**Decoration:**
- Floating blur blobs → remove
- Top-of-page gradient line → remove
- Noise texture overlay → remove
- Card accent stripe → remove
- Dot grid background pattern → remove
- Infinitely bouncing CTA button → remove
- Everything fades in on scroll at 600ms → only animate elements where motion adds meaning

**Diagrams / canvas / in-product UI:**
- Every node is the same rounded rectangle regardless of role → shape vocabulary (actor vs service vs datastore vs external)
- Category encoded in outline AND stripe AND subtitle → pick one
- Vertical left-edge accent stripe on every node → remove if outline already encodes category
- Floating filled "+" button parked next to the selection → edge-hover affordance + keyboard shortcut
- Every surface is `rx=8` (monoradius) → vary radius by role (tighter on inputs, larger on sheets)
- Cyan + coral + amber status palette → one brand color + neutrals + shape/icon-based status

**Forms / dialogs:**
- `UPPERCASE tracking-wide` field labels → sentence case, or inline editing with no label
- Delete + Done in the dialog footer → move destructive actions to a menu or require a typed confirm
- "Are you sure? This cannot be undone. Continue" → specific title, specific consequences, specific button label
- Evenly stacked form fields with uniform spacing → group related fields, use inline layout where it fits

**Code:**
- 50+ unique spacing values, arbitrary `p-[13px]` → 8pt grid, tokens only
- Shadcn props that don't exist → check against actual shadcn API
- Comments explaining what code does → comments explaining why
- Single-use wrapper components → use the element directly
- `useState` + `useEffect` data fetching → TanStack Query

**Copy (invoke humanizer, then check these):**
- "Revolutionize", "seamlessly", "powerful", "unlock", "transform" → specific claim
- The rule of three in every description → one specific benefit
- "Join thousands of..." → specific customer name or number
- "Trusted by teams of all sizes" → named customers or real use case
- Vague audience ("for modern teams") → specific person doing specific thing
