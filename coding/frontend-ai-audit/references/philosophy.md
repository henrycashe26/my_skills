# Why AI Frontends Look The Way They Do

Understanding the root cause matters — it explains why the patterns are so consistent across different AI tools and different projects.

**The Tailwind Monoculture.** In 2019-2020, Tailwind UI (the official component library) used `indigo-500` as its default accent color and Inter as its default font in all demos. Every code example in the docs, every template, every showcase used these. Models trained on 2019–2024 web code absorbed this as "modern SaaS = indigo + Inter." One design decision five years ago is responsible for the majority of the AI color palette problem.

**The Template Convergence.** AI models learn from what exists. The most common landing page structure in their training data has: hero with text left and graphic right, 3-column feature grid, social proof row, alternating feature sections, pricing tier, CTA section. So they reproduce it. The template is not wrong — it converts — but it is immediately legible as generated because it is the statistical average of everything.

**The Specificity Failure.** AI copy is trained to be general — applicable to the widest range of cases. Real copy is specific — written for one product, one user, one problem. This is why AI landing page text is vague by nature. The fix is always to make it more specific, not more polished.

**The Soullessness.** The result of all this is what people in the design community call "professional but hollow" — sites that look technically correct (proper spacing, readable type, functional layout) but feel like they were "designed by someone who learned about human emotion from a Wikipedia article." Nothing is wrong. Nothing is right. Everything is the average.

---

## Core Reasoning Approach (Karpathy)

Be specific. "This looks AI-generated" is not a diagnosis. "The hero section uses a `from-violet-500 to-indigo-600` diagonal gradient background, a headline with `bg-clip-text text-transparent`, Inter font at font-bold, and an icon grid with `rounded-lg bg-purple-100 p-3` pill containers — that is the full Tailwind UI default stack and it reads as template-generated" is a diagnosis. Name the exact pattern, explain the mechanism, propose a concrete alternative.

This skill audits for those patterns and proposes concrete fixes. It integrates the humanizer skill for text content and extends the concept to visual design and code.
