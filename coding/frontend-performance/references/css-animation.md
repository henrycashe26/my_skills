# CSS and Animation

## Layout Thrashing

Reading a layout property (like `offsetWidth`) forces the browser to calculate layout immediately. If you then write to a layout property, and read again, that is layout thrashing — can make animations drop to single-digit fps.

```typescript
// Bad: causes layout thrashing in a loop
elements.forEach(el => {
  const width = el.offsetWidth;  // forces layout
  el.style.width = width + 10 + 'px';  // writes layout
});

// Good: batch reads, then batch writes
const widths = elements.map(el => el.offsetWidth);  // all reads
elements.forEach((el, i) => {
  el.style.width = widths[i] + 10 + 'px';  // all writes
});
```

## Smooth Animations

Animate `transform` and `opacity` only — these do not trigger layout or paint, so the GPU can handle them.

```css
/* Bad: triggers layout recalculation */
.card:hover { width: 110%; height: 110%; }

/* Good: GPU-composited, no layout recalc */
.card:hover { transform: scale(1.05); }
```

For JS-driven animations, use Framer Motion — it handles `will-change`, GPU promotion, and frame scheduling automatically.

```typescript
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.2, ease: 'easeOut' }}
>
  {content}
</motion.div>
```
