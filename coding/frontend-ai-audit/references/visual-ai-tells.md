# Visual AI Tells: Exhaustive Catalog

Each entry: pattern name → identifying code → mechanism (why it reads as AI) → concrete fix.

---

## Root Cause Reference

The majority of AI color/font choices trace to one source: **Tailwind UI's demo defaults from 2019–2020**. Adam Wathan (Tailwind's creator) used `indigo-500` as the accent color and Inter as the font in every component demo. Models trained on 2019–2024 web code absorbed "indigo + Inter = modern SaaS." This is why the patterns co-occur so consistently across different AI tools.

---

## COLOR PATTERNS

### C1: The Tailwind Indigo Default
**Code:** Any of these Tailwind classes used as primary action color:
```
bg-indigo-500  bg-indigo-600  bg-indigo-700
bg-violet-500  bg-violet-600
bg-purple-600  bg-purple-700
text-indigo-600  text-violet-600  text-purple-600
```
**Mechanism:** Direct reproduction of Tailwind UI demo defaults. The most reliable single tell.
**Fix:** Pick a brand color intentionally. `bg-blue-600` (not indigo), `bg-emerald-600`, `bg-orange-600`, `bg-red-600` — anything that was chosen for brand reasons, not accepted as default.

---

### C2: The Purple-to-Blue Gradient
**Code:**
```tsx
className="bg-gradient-to-br from-violet-500 to-indigo-600"
className="bg-gradient-to-r from-purple-600 to-blue-500"
className="bg-gradient-to-tr from-pink-500 to-rose-600"
className="bg-gradient-to-r from-blue-500 to-purple-600"
```
**Mechanism:** AI generates gradients between adjacent Tailwind color families. The specific diagonal `from-violet-500 to-indigo-600` is the most common — appears in thousands of AI-generated landing pages.
**Fix:** No gradient. Solid color only. A single well-chosen color at full saturation reads as more confident than a gradient.

---

### C3: Gradient Text Headline
**Code:**
```tsx
<h1 className="bg-gradient-to-r from-purple-600 to-blue-500 bg-clip-text text-transparent">
  Headline text
</h1>
```
**Mechanism:** Gradient text is technically complex enough to be "interesting" — so AI includes it on everything. Designers use it once, on one word, deliberately.
**Fix:** `text-gray-900 font-semibold tracking-tight`. Black text on white is stronger than any gradient.

---

### C4: The Animated Shifting Gradient
**Code:**
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
Or in Tailwind:
```tsx
<div className="animate-pulse bg-gradient-to-tr from-violet-500/20 via-transparent to-indigo-500/20" />
```
**Mechanism:** AI adds animation to gradients as decoration. The continuous loop adds no information, creates visual noise, and signals no-code/AI tooling.
**Fix:** Remove entirely. Static background.

---

### C5: Purple-Black Dark Mode
**Code:**
```css
background: #0f0f23;  /* common exact value */
background: #1a1a2e;  /* also common */
background: #0d1117;  /* GitHub-adjacent variant */
background: #0a0a15;  /* deeper purple variant */
```
**Mechanism:** AI generates "dark mode" by darkening the purple accent color rather than using a neutral dark gray.
**Fix:** True dark mode backgrounds: `#0f172a` (slate-950), `#111827` (gray-900), `#09090b` (zinc-950). No purple tint.

---

### C6: Teal + Dark
**Code:**
```tsx
className="bg-teal-500"  {/* on dark background */}
className="text-teal-400" {/* on dark background */}
```
The second most common AI palette after purple/indigo. Less prevalent but still a tell when combined with dark backgrounds and the template layout.
**Fix:** Same principle — pick a hue intentionally, not as the second-most-common default.

---

## LAYOUT PATTERNS

### L1: The Full Hero Template
The complete pattern:
```tsx
{/* Pill badge */}
<span className="rounded-full bg-indigo-50 px-3 py-1 text-sm text-indigo-600 
  ring-1 ring-indigo-200 ring-inset">
  ✨ New · Feature name →
</span>

{/* Gradient headline */}
<h1 className="text-6xl font-bold bg-gradient-to-r from-purple-600 to-blue-500 
  bg-clip-text text-transparent">
  Revolutionize Your Workflow
</h1>

{/* Gray subtitle */}
<p className="mt-6 text-xl text-gray-500 max-w-2xl">
  The all-in-one platform for modern teams.
</p>

{/* Two-button CTA */}
<div className="flex gap-4">
  <button className="bg-indigo-600 text-white px-6 py-3 rounded-lg">Get started</button>
  <button className="border border-gray-300 px-6 py-3 rounded-lg">Learn more</button>
</div>

{/* Social proof micro-line */}
<p className="text-sm text-gray-400">Join 10,000+ teams worldwide</p>
```
**Mechanism:** This is the statistical average hero section from the training data. Every element is plausible in isolation; together they are unmistakable.
**Fix:** Break at least 3 of these. Remove the pill badge or make it factual (e.g., "v2.4 released March 2025"). Replace gradient text with black. Replace vague subtitle with a specific claim. Replace "Join 10,000+ teams" with a named customer.

---

### L2: The Solid Color Rectangle
**Code:**
```tsx
<section className="flex items-center min-h-screen">
  <div className="flex-1 space-y-6">
    <h1>Headline</h1>
    <p>Subtitle</p>
    <button>CTA</button>
  </div>
  {/* THE RECTANGLE — a colored block with nothing in it */}
  <div className="flex-1 bg-violet-600 rounded-2xl min-h-[500px]" />
</section>
```
**Mechanism:** AI learned hero sections that have a brand-colored frame behind a product screenshot. Without an actual screenshot, it generates the frame empty.
**Fix:** Real product screenshot, or remove the right column entirely. A single-column hero with a strong headline needs no decoration.

---

### L3: The Three-Column Feature Grid
**Code:**
```tsx
<div className="grid md:grid-cols-3 gap-8 py-24">
  {features.map(f => (
    <div key={f.title} className="rounded-xl border border-gray-200 p-6 shadow-sm">
      <div className="rounded-lg bg-indigo-50 p-3 w-fit mb-4">
        <f.Icon className="h-6 w-6 text-indigo-600" />
      </div>
      <h3 className="font-semibold text-gray-900 mb-2">🚀 {f.title}</h3>
      <p className="text-gray-500 text-sm leading-relaxed">{f.description}</p>
    </div>
  ))}
</div>
```
**Mechanism:** The exact combination — 3 columns, icon pill with `bg-indigo-50 p-3`, emoji in heading, `text-gray-500 text-sm` description — is the canonical AI feature section.
**Fix:** 2 columns with more content per card, or a simple list without cards. Remove icon pills and emojis. If icons, they go inline with the text, not in a pill.

---

### L4: The Product Screenshot with Glow
**Code:**
```tsx
<div className="relative">
  <div className="absolute inset-0 bg-violet-600 blur-3xl opacity-20 rounded-full" />
  <img
    src="/screenshot.png"
    className="relative rounded-xl shadow-2xl ring-1 ring-gray-900/10"
    style={{ filter: 'drop-shadow(0 0 40px rgba(124, 58, 237, 0.3))' }}
  />
</div>
```
**Mechanism:** AI learned to add depth to screenshots with a glowing blur behind them. The purple glow + `shadow-2xl` + `ring-1` combo is extremely common.
**Fix:** Plain screenshot with `rounded-lg border border-gray-200`. No glow. The product should speak for itself.

---

### L5: Wavy / Diagonal SVG Section Dividers
**Code:**
```tsx
<div className="relative bg-white">
  <div className="absolute bottom-0 left-0 right-0">
    <svg viewBox="0 0 1440 80" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M0,40 C360,80 1080,0 1440,40 L1440,80 L0,80 Z" fill="#f9fafb"/>
    </svg>
  </div>
</div>
```
Or as clip-path:
```css
.section { clip-path: polygon(0 0, 100% 5%, 100% 100%, 0 100%); }
```
**Mechanism:** A Webflow/Squarespace/AI-page-builder pattern. Real developers use background colors and padding to separate sections.
**Fix:** `border-t border-gray-100` between sections, or simply change the background color. No SVG curves, no clip-path diagonals.

---

## TYPOGRAPHY PATTERNS

### T1: Inter Font with No System
**Code:**
```tsx
import { Inter } from 'next/font/google';
const inter = Inter({ subsets: ['latin'] });
// Used for everything, no weight variation, no tracking, no deliberate sizing
```
**Mechanism:** Inter is the Tailwind UI demo font. Good font, not a brand choice.
**Fix:** If using Inter, commit to it as a deliberate system: specific weights for specific uses, `tracking-tight` on headings, explicit fallback stack. Alternatives that read less template-like: Geist, DM Sans, Plus Jakarta Sans, Instrument Sans.

---

### T2: Font Weight Collapse
**Code:**
```tsx
// Everything is either 400 or 700 — nothing in between
<h1 className="font-bold">Main heading</h1>      {/* 700 */}
<h2 className="font-bold">Section heading</h2>   {/* 700 */}
<h3 className="font-semibold">Card title</h3>    {/* 600 — sometimes */}
<p className="font-normal">Body text</p>          {/* 400 */}
```
**Mechanism:** AI defaults to the most obvious weights. The full scale (400, 500, 600, 700) used contextually reads as designed; 400/700 binary reads as generated.
**Fix:** `font-medium` (500) for UI labels, nav, buttons. `font-semibold` (600) for headings. Reserve `font-bold` (700) for the absolute most important heading or specific emphasis.

---

### T3: Title Case Everything
**What it looks like:**
```
"Why Choose Our Platform"
"Key Features And Benefits"
"Start Your Free Trial Today"
"Footer Column One | Footer Column Two"
```
**Mechanism:** AI capitalizes consistently, which reads as mechanical. Human capitalization is inconsistent in a natural way — sentence case for headings, all-caps for abbreviations, Title Case for proper nouns.
**Fix:** Sentence case for all headings, section labels, and nav items. "Why choose our platform" reads as more confident and modern.

---

### T4: Missing Tracking on Large Text
**Code:**
```tsx
<h1 className="text-6xl font-bold">Headline</h1>
{/* No tracking-tight — the letters are slightly too loose at display size */}
```
**Mechanism:** AI doesn't apply typographic refinements. At large sizes, the default letter-spacing is slightly too loose — a tell that nobody went back and tuned it.
**Fix:** `tracking-tight` on anything `text-3xl` and above. `tracking-tighter` on `text-5xl` and above.

---

## DECORATION PATTERNS

### D1: The Floating Blur Blob
**Code:**
```tsx
<div className="pointer-events-none absolute -top-40 -right-40 h-96 w-96 
  rounded-full bg-violet-400 opacity-20 blur-3xl" />
```
Two or more of these per page. Nearly universal in AI-generated marketing pages.
**Fix:** Remove both.

---

### D2: The Top-of-Page Brand Line
**Code:**
```tsx
<div className="fixed inset-x-0 top-0 z-50 h-[2px] bg-gradient-to-r 
  from-violet-500 to-indigo-500" />
```
**Fix:** Remove. Nothing is lost.

---

### D3: The Dot Grid Background
**Code:**
```tsx
<div className="absolute inset-0 bg-[url('/grid.svg')] bg-center opacity-5" />
{/* or via Tailwind plugin */}
<div className="bg-grid-slate-100" />
```
**Fix:** Remove. If section differentiation is needed, use a background color change.

---

### D4: The Noise Texture Overlay
**Code:**
```css
.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,...noise...");
  opacity: 0.04;
  mix-blend-mode: multiply;
}
```
**Fix:** Remove.

---

### D5: The Card Accent Stripe
**Code:**
```tsx
<div className="overflow-hidden rounded-xl border border-gray-200">
  <div className="h-1 bg-gradient-to-r from-violet-500 to-indigo-500" />
  <div className="p-6">{content}</div>
</div>
```
**Fix:** Remove the stripe. `rounded-xl border border-gray-200 p-6` without the stripe.

---

### D6: The Sparkle Heading
**Code:**
```tsx
<h2>✨ Why teams love us</h2>
<h3>🚀 Ship faster</h3>
<p>⚡ Powered by AI</p>
```
**Fix:** No emoji in headings. Ever.

---

### D7: The "New" Badge with No Expiry
**Code:**
```tsx
<span className="rounded-full bg-emerald-50 px-2 py-0.5 text-xs text-emerald-700 
  font-medium">
  New
</span>
```
On a feature that has been live for 8 months.
**Fix:** Either make it time-bounded ("New in v2.4") or remove it.

---

## ANIMATION PATTERNS

### A1: Scroll-Fade-In on Everything
**Code:**
```tsx
// Applied to every section, every card, every heading
<motion.div
  initial={{ opacity: 0, y: 20 }}
  whileInView={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.6 }}
  viewport={{ once: true }}
>
```
**Mechanism:** When every element on the page fades in on scroll, the animation becomes noise rather than signal. The 600ms duration is the AI default — real UI animations are 100–300ms.
**Fix:** Use scroll-triggered animation only for elements where the appearance needs explaining (a chart drawing itself, a before/after reveal, a count-up). Remove from everything else.

---

### A2: The Forever-Bouncing CTA
**Code:**
```tsx
<motion.button
  animate={{ y: [0, -8, 0] }}
  transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }}
>
  Get started →
</motion.button>
```
**Fix:** Remove. A button should look like a button, not a fishing lure.

---

### A3: The Animated Gradient Shift
See color pattern C4. The animation is the tell, not just the gradient.

---

## ICON PATTERNS

### I1: Emoji Icons in Feature Lists
```tsx
<li>🚀 Ship faster</li>
<li>🔒 Stay secure</li>
<li>⚡ Scale effortlessly</li>
```
**Fix:** No emoji. A simple text list, or `lucide-react` icons at consistent size/weight.

---

### I2: Icon in Colored Pill
```tsx
<div className="rounded-lg bg-indigo-50 p-3 w-fit">
  <RocketIcon className="h-6 w-6 text-indigo-600" />
</div>
```
**Mechanism:** The pill + matching color + `h-6 w-6` is the Tailwind UI icon component pattern, reproduced by AI in every feature card.
**Fix:** No pill. Icon inline with text, or no icon at all.

---

### I3: Mixed Icon Libraries
Using Heroicons, Lucide, and Font Awesome in the same codebase at different sizes and stroke weights.
**Fix:** One library, one size, one stroke weight. Lucide is the current consensus: tree-shakeable, consistent 2px stroke, 24px default.
