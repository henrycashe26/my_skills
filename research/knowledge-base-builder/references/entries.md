# Individual Entries

Every entry file gets YAML frontmatter. The frontmatter is the structured layer -- it enables filtering, cross-referencing, and programmatic queries without parsing prose.

## General frontmatter pattern

```yaml
---
title: "Human-readable title"
category: the-category       # matches directory name
status: active               # active | archived | investigating | draft
created: 2026-03-26
last_updated: 2026-03-26
tags: [tag1, tag2, tag3]     # for cross-cutting search
related:                     # links to other entries
  - path/to/related-entry.md
summary: "One sentence that captures the key point"
---
```

For complete YAML schemas for different document types, maintain `references/frontmatter_schemas.md` inside the knowledge base itself when schemas diverge by category.

## Writing the body

After the frontmatter, write the body in plain markdown. Structure varies by document type, but general principles:

- Lead with the conclusion or key finding (don't bury it)
- Use headers for scanability
- Include specific numbers, dates, and sources (not "recently" or "some research shows")
- End with "What's Next" or "Open Questions" when applicable
