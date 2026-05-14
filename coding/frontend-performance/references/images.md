# Images

Images are often the LCP element. Getting them right has an outsized impact.

```typescript
// Next.js: always use next/image — it handles lazy loading, sizing, formats
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Product hero"
  width={1200}
  height={600}
  priority  // add for above-the-fold images (prevents lazy loading the LCP)
  placeholder="blur"  // show blurred version while loading
  blurDataURL={base64BlurHash}
/>
```

**In non-Next.js apps:**
- Add `loading="lazy"` to all images below the fold
- Add `loading="eager"` + `fetchpriority="high"` to the LCP image
- Use `width` and `height` attributes on `<img>` to prevent layout shift (CLS)
- Serve WebP or AVIF — they are 30-50% smaller than JPEG for the same quality
