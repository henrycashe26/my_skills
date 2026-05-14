# Code AI Tells

Patterns in the source code itself — structure, naming, spacing, state management, library usage — that signal AI generation.

---

## 1. The Spacing System Collapse

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

## 2. Shadcn Prop Hallucination

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

## 3. Over-commenting

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

## 4. Unnecessary Abstraction for Single-Use Code

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

## 5. State Management Pattern

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

## 6. Component Name Inflation

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
