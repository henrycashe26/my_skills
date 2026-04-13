---
name: frontend-ai-audit
description: >
  Detect and fix AI-generated-looking frontend code, UI, and copy. Use this skill whenever
  you need to audit a frontend for the "AI slope" — the cluster of visual patterns, code
  patterns, and text patterns that make something unmistakably look like it was generated
  by an AI. Trigger when the user asks "does this look AI-generated", "how do I make this
  look less AI", "why does this look generic", "audit this for AI tells", "this feels like
  a template", or uploads a screenshot of a landing page, component, or UI. Also trigger
  proactively when you see obvious AI visual tells in code you are reviewing: purple/blue
  gradients, emoji feature lists, the "hero + solid color rectangle" layout, gradient text
  headings, Inter font everywhere, or wavy section dividers. This skill uses the humanizer
  skill for copy and extends it to visual and code domains. Being honest about what is
  AI-looking is more useful than being polite.
---

# Frontend AI Audit

The "AI slope" is a real phenomenon with a specific root cause. There is a cluster of visual patterns, code patterns, and copywriting patterns that co-occur so reliably in AI-generated frontends that they are immediately recognizable — and immediately undermine the credibility of what is being built.

This skill audits for those patterns and proposes concrete fixes. It integrates the humanizer skill for text content and extends the concept to visual design and code.

**Core reasoning approach (Karpathy):** Be specific. "This looks AI-generated" is not a diagnosis. "The hero section uses a `from-violet-500 to-indigo-600` diagonal gradient background, a headline with `bg-clip-text text-transparent`, Inter font at font-bold, and an icon grid with `rounded-lg bg-purple-100 p-3` pill containers — that is the full Tailwind UI default stack and it reads as template-generated" is a diagnosis. Name the exact pattern, explain the mechanism, propose a concrete alternative.

---

## Why AI Frontends Look The Way They Do

Understanding the root cause matters — it explains why the patterns are so consistent across different AI tools and different projects.

**The Tailwind Monoculture.** In 2019-2020, Tailwind UI (the official component library) used `indigo-500` as its default accent color and Inter as its default font in all demos. Every code example in the docs, every template, every showcase used these. Models trained on 2019–2024 web code absorbed this as "modern SaaS = indigo + Inter." One design decision five years ago is responsible for the majority of the AI color palette problem.

**The Template Convergence.** AI models learn from what exists. The most common landing page structure in their training data has: hero with text left and graphic right, 3-column feature grid, social proof row, alternating feature sections, pricing tier, CTA section. So they reproduce it. The template is not wrong — it converts — but it is immediately legible as generated because it is the statistical average of everything.

**The Specificity Failure.** AI copy is trained to be general — applicable to the widest range of cases. Real copy is specific — written for one product, one user, one problem. This is why AI landing page text is vague by nature. The fix is always to make it more specific, not more polished.

**The Soullessness.** The result of all this is what people in the design community call "professional but hollow" — sites that look technically correct (proper spacing, readable type, functional layout) but feel like they were "designed by someone who learned about human emotion from a Wikipedia article." Nothing is wrong. Nothing is right. Everything is the average.

---

## How to Run an Audit

When given a frontend to audit (code, screenshot, or URL):

1. **Scan for visual AI tells** — color, layout, typography, decoration, animation
2. **Scan for copy AI tells** — invoke the humanizer skill on all text content, then apply the landing page-specific patterns below
3. **Scan for code AI tells** — structure, naming, spacing, state management, shadcn usage
4. **Score the AI slope** — rate overall AI-ness from 0 (human) to 10 (unmistakably AI)
5. **Report findings** — each tell named specifically, with the mechanism and a concrete fix
6. **Prioritize** — the 3 highest-leverage changes first

---

## Visual AI Tells

### 1. The Tailwind Indigo Problem

The single most reliable tell. AI tools default to `indigo-500` / `violet-500` / `purple-600` as their primary action color because that is what Tailwind UI demos used for years.

**Red flag Tailwind classes (any of these is a signal, multiple co-occurring is a near-certainty):**
```
bg-indigo-500  bg-indigo-600  text-indigo-600
bg-violet-500  bg-violet-600  text-violet-600
bg-purple-600  text-purple-600
from-violet-500 to-indigo-600   (diagonal gradient — extremely common)
from-purple-600 to-blue-500     (the other one)
from-pink-500 to-rose-600       (secondary accent variant)
from-blue-500 to-purple-600     (the reversed version)
```

**What human-designed products actually use:**
- One brand color that is NOT purple/indigo/violet — often a specific blue, green, orange, or red chosen for brand reasons
- Linear: `#5E6AD2` (a specific custom indigo — not the Tailwind default)
- Vercel: black (`#000`) and white. Nothing else.
- Raycast: `#FF6363` (a warm red, completely outside the AI palette)
- Clerk: `#6C47FF` (a specific purple, but paired with aggressive neutrals)

**Fix:** Pick a brand color by choosing a hue intentionally — not by accepting a default. Then commit to using it at 500/600 for actions only, and gray for everything else. No gradient.

---

### 2. The Inter Font Monoculture

Inter became the Tailwind UI demo font and is now the AI font. It is a good font. It is not a brand choice.

**The tell in code:**
```css
font-family: 'Inter', sans-serif;  /* or via next/font/google */
```
```tsx
import { Inter } from 'next/font/google';
const inter = Inter({ subsets: ['latin'] });
```

**The accompanying tells:**
- `font-weight: 300` or `400` for body — very light, reads as "design template"
- `font-weight: 700` for all headings, nothing in between
- No custom fallback stack — just Inter, then `sans-serif`
- No tracking adjustments on large text

**What to do instead:**
- If Inter is genuinely the right choice, commit to it as a system (multiple weights, specific sizes, tracking)
- More distinct alternatives: Geist (Vercel's custom, now public), DM Sans, Plus Jakarta Sans, Instrument Sans, or a serif for contrast
- The key is that the font choice should feel intentional, not default

---

### 3. Animated and Shifting Gradients

A step beyond static gradients — AI generates animated gradient backgrounds that loop continuously.

**Identifying code:**
```css
@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
.hero {
  background: linear-gradient(270deg, #7c3aed, #2563eb, #7c3aed);
  background-size: 400% 400%;
  animation: gradient-shift 6s ease infinite;
}
```

Or the mesh gradient variant:
```tsx
<div className="absolute inset-0 bg-gradient-to-tr from-violet-500/20 via-transparent 
  to-indigo-500/20 animate-pulse" />
```

**Why this is bad beyond just looking AI:** The animation adds no information and creates visual noise that competes with the content. It is pure decoration that signals the designer was looking for something interesting to add.

**Fix:** Remove the animation entirely. A static background color or a single subtle tint is stronger.

---

### 4. The Hero Layout Template

The most common AI landing page structure. If a layout matches more than 3 of these elements, it is almost certainly AI-generated:

```
[Navbar: logo left | links center | CTA button right]
  ↓
[Hero: centered or left-aligned text block]
  - Small pill badge: "New ✨ Feature name →" 
  - Giant headline in gradient text
  - Subtitle in text-gray-500 at text-xl
  - Two buttons: primary (filled) + secondary (outline)
  - Social proof micro-line: "Join 10,000+ teams"
  - Right side: product screenshot in browser mockup with glow/shadow OR the solid color rectangle
  ↓
[Logo row: "Trusted by [companies]" with grayscale logos]
  ↓
[3-column feature grid with icon pills]
  ↓
[Alternating left/right feature sections]
  ↓
[Testimonials: 3 cards with avatar + name + quote]
  ↓
[Pricing: 3 tiers, middle highlighted with ring-2 border]
  ↓
[CTA section with gradient background]
  ↓
[Footer: 4-column links + "Made with ❤️"]
```

**Individual tells within the hero:**

**The pill badge:** `<span className="rounded-full bg-indigo-50 px-3 py-1 text-sm text-indigo-600 ring-1 ring-indigo-200">✨ New feature</span>` — this exact pattern is a very strong AI signal.

**The solid color rectangle:** A `div` with `bg-purple-600` or similar filling the right side of the hero as decoration. AI generates the frame (a brand-colored image container) without putting an actual image in it.

**The browser mockup with glow:** A screenshot inside an `<img>` tag styled with `rounded-xl shadow-2xl ring-1 ring-gray-900/10` and sometimes a `drop-shadow-[0_0_40px_rgba(124,58,237,0.3)]` glow effect underneath.

---

### 5. The Three-Column Feature Grid

The canonical AI feature section. Recognizable at a glance.

```tsx
<div className="grid md:grid-cols-3 gap-8">
  {features.map(f => (
    <div className="rounded-xl border border-gray-200 p-6 shadow-sm">
      <div className="rounded-lg bg-indigo-50 p-3 w-fit mb-4">
        <f.Icon className="h-6 w-6 text-indigo-600" />
      </div>
      <h3 className="font-semibold text-gray-900 mb-2">🚀 {f.title}</h3>
      <p className="text-gray-500 text-sm">{f.description}</p>
    </div>
  ))}
</div>
```

All three tells at once: icon in a colored pill, emoji in the heading, gray description text. The shadow-sm on every card. The `rounded-xl`. The `border-gray-200`.

**Fix:** If you need a feature section, break the template. Use a 2-column layout with larger cards, or a simple two-column list without cards at all. Drop the icon pills. Drop the emojis. Write descriptions that say one specific thing, not a vague benefit.

---

### 6. Wavy SVG Section Dividers

A 2023–2024 pattern that signals AI or no-code tools.

```tsx
<div className="relative">
  <svg viewBox="0 0 1440 120" className="absolute bottom-0 text-white fill-current">
    <path d="M0,64L48,69.3C96,75,192,85..." />
  </svg>
</div>
```

Also appears as CSS `clip-path: polygon(...)` to create diagonal section transitions.

**Why it reads as AI:** This is a Webflow/Squarespace/AI-page-builder pattern. Professional developers use padding and background color changes, not SVG waves, to separate sections.

**Fix:** Just use `border-t border-gray-100` or a background color change between sections. No SVG. No clip-path.

---

### 7. Typography AI Tells

```tsx
// The full AI typography stack
<h1 className="text-5xl md:text-7xl font-bold bg-gradient-to-r from-purple-600 
  to-blue-500 bg-clip-text text-transparent leading-tight">
  Revolutionize Your Workflow
</h1>
<p className="mt-6 text-xl text-gray-500 max-w-2xl mx-auto">
  The all-in-one platform for modern teams.
</p>

// What professional products actually use
<h1 className="text-4xl font-semibold tracking-tight text-gray-900">
  Issue tracking built for speed
</h1>
<p className="mt-4 text-lg text-gray-600 max-w-xl">
  Linear cuts the time from idea to shipped. Keyboard shortcuts, instant search,
  and a model that matches how engineers actually think.
</p>
```

**Specific tells:**
- Gradient text on the main headline — very strong signal
- `font-bold` (700) on every heading instead of `font-semibold` (600)
- `text-5xl`, `text-6xl`, `text-7xl` headings that are too large for the content's importance
- Missing `tracking-tight` on large headings (tightening tracking on display text is a typography fundamental)
- Title Case On Every Heading And Nav Link And Button Label
- `text-gray-500` subtitle directly under a `text-gray-900` h1 — fine on its own, but combined with the other tells it completes the pattern

---

### 8. Decorative Elements That Explain Nothing

A reliable test: if removing the element would lose nothing, remove it.

**The floating blur blob:**
```tsx
<div className="absolute -top-40 -right-40 w-96 h-96 rounded-full 
  bg-violet-400 blur-3xl opacity-20 pointer-events-none" />
```
Every AI landing page has at least two of these. Remove both.

**The top-of-page brand line:**
```tsx
<div className="fixed top-0 inset-x-0 h-[2px] bg-gradient-to-r 
  from-violet-500 to-indigo-500 z-50" />
```

**The dot grid background:**
```tsx
<div className="absolute inset-0 bg-[url('/grid.svg')] bg-center opacity-5" />
```

**The noise texture overlay:**
```css
.hero::after { background-image: url("data:image/svg+xml,...noise..."); opacity: 0.04; }
```

**The card accent stripe:**
```tsx
<div className="rounded-xl border border-gray-200 overflow-hidden">
  <div className="h-1.5 bg-gradient-to-r from-violet-500 to-indigo-500" />
  <div className="p-6">{content}</div>
</div>
```

**The sparkle/star icons in headings:**
```tsx
<h2>✨ Why teams love us</h2>
```

**The "New" badge with no expiry:**
```tsx
<span className="rounded-full bg-green-50 text-green-700 px-2 py-0.5 text-xs">New</span>
```
On a feature that has been live for 8 months.

---

### 9. Animation Tells

**The scroll-fade-in on everything:**
```tsx
<motion.div
  initial={{ opacity: 0, y: 20 }}
  whileInView={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.6 }}   // 600ms is the AI default
  viewport={{ once: true }}
>
```
When every single section and card fades in on scroll, it is an AI tell. Motion should be used for elements where the appearance needs explaining, not applied to everything.

**The 600ms default duration:** Legitimate motion is 100–300ms for UI, 200–400ms for entrances. 600ms reads as slow and template-generated.

**The CTA bounce:**
```tsx
animate={{ y: [0, -8, 0] }}
transition={{ repeat: Infinity, duration: 2 }}
```
The hero button that bobs up and down forever. Remove.

---

## Code AI Tells

### 1. The Spacing System Collapse

When spacing is not tokenized, AI generates 50+ unique spacing values across a codebase. This is both a visual tell (nothing quite aligns) and a code tell.

```tsx
// AI: every value is slightly different, no system
<div style={{ padding: '12px 18px', marginBottom: '7px' }}>
<div className="p-[13px] mt-5 mb-3">
<div className="px-6 py-3.5">  {/* py-3.5 = 14px — off-grid */}
<div className="p-5">           {/* p-5 = 20px — off-grid */}

// Human: 8pt grid, consistent tokens
<div className="px-4 py-3">    {/* 16px / 12px — on-grid */}
<div className="px-4 py-2">    {/* 16px / 8px — on-grid */}
<div className="p-6">          {/* 24px — on-grid */}
```

**The diagnostic:** Run `grep -r "p-\[" src/` and `grep -r "m-\[" src/`. If there are more than a handful of arbitrary spacing values, the spacing system is broken.

---

### 2. Shadcn Prop Hallucination

AI confidently generates shadcn/ui usage with props that do not exist, component APIs that changed, or combinations that are not valid. It never says "I don't know."

```tsx
// AI-generated shadcn usage with invented props
<Button
  variant="primary"      // doesn't exist — it's "default"
  loading={isSubmitting} // doesn't exist — use disabled + a spinner
  icon={<Rocket />}      // doesn't exist
  fullWidth              // doesn't exist — use className="w-full"
>
  Submit
</Button>

// Correct shadcn usage
<Button
  variant="default"
  disabled={isSubmitting}
  className="w-full"
>
  {isSubmitting ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
  Submit
</Button>
```

**The pattern:** When reviewing AI-generated code that uses shadcn, grep the component props against the actual shadcn source. The hallucinated props are plausible-sounding and will cause type errors or silent failures.

---

### 3. Over-commenting

```tsx
// AI: comments explain what the code obviously does
const [isOpen, setIsOpen] = useState(false); // State to track if dropdown is open

// Handle button click to toggle dropdown
const handleClick = () => {
  setIsOpen(!isOpen); // Toggle the isOpen state
};

// Return the dropdown component
return (
  <div className="relative"> {/* Container div */}

// Human: comments explain why, not what
// Delayed close lets the click-outside handler fire first  
const handleClose = () => {
  setTimeout(() => setIsOpen(false), 0);
};
```

---

### 4. Unnecessary Abstraction for Single-Use Code

```tsx
// AI: abstracts everything, even single-use wrappers
const PageWrapper = ({ children }: { children: React.ReactNode }) => (
  <div className="min-h-screen bg-gray-50">{children}</div>
);
const SectionContainer = ({ children }: { children: React.ReactNode }) => (
  <section className="max-w-6xl mx-auto px-4">{children}</section>
);
const CardWrapper = ({ children }: { children: React.ReactNode }) => (
  <div className="rounded-xl border border-gray-200 p-6">{children}</div>
);

// Human: just uses the element
<div className="min-h-screen bg-gray-50">
  <section className="max-w-6xl mx-auto px-4">
    ...
  </section>
</div>
```

---

### 5. State Management Pattern

```tsx
// AI: the manual fetch pattern — always three useState + useEffect
const [products, setProducts] = useState([]);
const [isLoading, setIsLoading] = useState(false);
const [error, setError] = useState(null);

useEffect(() => {
  setIsLoading(true);
  fetch('/api/products')
    .then(res => res.json())
    .then(data => { setProducts(data); setIsLoading(false); })
    .catch(err => { setError(err); setIsLoading(false); });
}, []);

// Human: TanStack Query — one line, handles loading/error/cache/refetch
const { data: products, isLoading, error } = useQuery({
  queryKey: ['products'],
  queryFn: () => fetch('/api/products').then(r => r.json()),
});
```

---

### 6. Component Name Inflation

```tsx
// AI: verbose suffix-heavy naming
<HeroSection />
<FeatureCardSection />
<TestimonialsSection />
<CTASectionWithGradientBackground />
<FooterNavigationLinksColumn />

// Human: direct, no suffixes
<Hero />
<Features />
<Testimonials />
<CTA />
```

---

## Copy AI Tells

For copy, invoke the humanizer skill first. Then apply these landing-page-specific checks.

### The Guaranteed AI Phrases

These appear in approximately 80% of AI-generated landing page copy. If you see any of them, the copy needs to be replaced, not polished:

**Hero headlines:**
- "Revolutionize the way you [verb]"
- "The [adjective] way to [common task]"
- "Supercharge your [workflow/productivity/business]"
- "The all-in-one platform for [audience]"
- "Unlock the full potential of [thing]"
- "Transform your [X] with AI"

**Feature descriptions:**
- "Powerful, intuitive, and built for [audience]"
- "Fast, secure, and reliable" (the AI rule of three)
- "Seamlessly integrate with your existing tools"
- "Built for teams of all sizes"
- "Take your [X] to the next level"

**Social proof:**
- "Join thousands of teams who trust [product]"
- "Trusted by 10,000+ businesses worldwide"
- "Loved by developers everywhere"

**Generic CTA sections:**
- "Ready to get started?" + "Start your free trial today"
- "The future of [X] is here"
- "Don't wait — [product] is waiting for you"

**Filler transition words (AI overuses these):**
- Starting sentences with "Additionally," "Furthermore," "Moreover," "Indeed"
- "In today's competitive business environment..."
- "As businesses navigate the evolving landscape..."
- "Driven by innovation and powered by expertise"

### What Human Copy Looks Like in Contrast

Real copy is specific in ways AI copy is not:

```
AI:   "Powerful real-time collaboration for modern teams"
Human: "Everyone sees the same board. No refresh needed. Works on a 3G connection."

AI:   "Seamlessly integrate with your existing tools"
Human: "Connects to Slack, GitHub, and Jira in about four clicks. No webhooks to configure."

AI:   "Join thousands of teams who trust us"
Human: "Used by the engineering team at Vercel, the ops team at Shopify, and 
       apparently the entire country of Finland"

AI:   "Revolutionize the way you manage projects"
Human: "You have 47 open tabs. We can fix that."
```

The pattern: AI copy describes the product in general terms. Human copy describes the user's specific situation, problem, or feeling.

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

---

## Reference Files

- `references/visual-ai-tells.md` — Exhaustive catalog of visual patterns with code examples and fixes
- `references/code-ai-tells.md` — Code pattern catalog with annotated before/after
- `references/landing-page-copy.md` — Extended copy pattern library with rewrites
