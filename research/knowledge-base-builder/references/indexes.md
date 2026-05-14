# Index Files

Every directory gets an `_index.md`. This is the single most important pattern in the whole system. It's a table that lets you scan everything in the category without opening individual files.

```markdown
# [Category Name] Index

| Entry | Status | Summary | Last Updated |
|-------|--------|---------|-------------|
| [name](./file.md) | active | One-line description | 2026-03-26 |
| [name](./file.md) | archived | One-line description | 2026-03-20 |
```

## Ordering

- Time-organized categories: list newest first.
- Alphabetical categories: sort alphabetically.
- Include a status column so readers can skip archived/stale entries.

## Why indexes matter

Index files at every directory level make the difference between "a folder of notes" and "a knowledge base." Without them, finding anything requires reading every file. With them, navigation is three hops max: README -> index -> specific file.
