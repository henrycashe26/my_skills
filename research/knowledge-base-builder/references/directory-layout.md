# Directory Layout

Use this general template, adapting category names to the domain:

```
knowledge_base/
├── README.md                 # Master index and overview
├── [category-1]/             # e.g., techniques/, companies/, features/
│   ├── _index.md             # Table of all items with 1-line summaries
│   └── [item].md             # Individual entries
├── [category-2]/             # e.g., experiments/, analyses/, sprints/
│   ├── _index.md
│   └── [YYYY-MM]/            # Time-based subcategories when useful
│       └── [item].md
├── [category-3]/             # e.g., papers/, sources/, references/
│   ├── _index.md
│   └── [subcategory]/
│       └── [item].md
├── synthesis/                # Cross-cutting analysis and summaries
│   ├── _index.md
│   └── [topic].md
└── decision_logs/            # Why choices were made
    ├── _index.md
    └── [YYYY-MM-DD]-[slug].md
```

Adapt freely. A knowledge base about cooking doesn't need "decision_logs/" but might need "recipes/" and "ingredient-notes/". The categories should match how the user naturally thinks about the domain.

## Naming conventions

- Directories: lowercase, hyphens (e.g., `user-research/`)
- Files: lowercase, hyphens (e.g., `ternary-quantization.md`)
- Date-prefixed when chronological order matters (e.g., `2026-03-26-chose-ternary.md`)

## Picking categories

Every domain has 3-6 natural categories.

- ML research: techniques, experiments, papers, ablations
- Product development: features, user research, competitors, architecture decisions
- Investing: companies, theses, sectors, positions
- Cooking: recipes, ingredient-notes, techniques

Pick what matches how the user naturally thinks about the domain.
