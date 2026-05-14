# Visual AI Tells

The cluster of color, typography, layout, decoration, and animation patterns that signal AI-generated frontend work. See also [`visual-ai-tells.md`](visual-ai-tells.md) for an even more exhaustive catalog.

---

## 1. The Tailwind Indigo Problem

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

## 2. The Inter Font Monoculture

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

## 3. Animated and Shifting Gradients

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

## 4. The Hero Layout Template

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

## 5. The Three-Column Feature Grid

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

## 6. Wavy SVG Section Dividers

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

## 7. Typography AI Tells

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

## 8. Decorative Elements That Explain Nothing

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

## 9. Animation Tells

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
