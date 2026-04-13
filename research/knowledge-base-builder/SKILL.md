---
name: knowledge-base-builder
description: |
  Build, organize, and maintain structured knowledge bases on any topic using markdown files with YAML frontmatter. Use this skill whenever the user wants to: create a knowledge base or research repository, organize research findings or notes into a navigable structure, build a reference document collection for a project or domain, track experiments and decisions alongside their rationale, or create a "second brain" for any subject area. Trigger when the user mentions: "knowledge base", "organize my research", "build a reference", "track what I've learned", "create a wiki", "document my findings", "research repository", or anything involving structured storage and retrieval of knowledge across multiple documents. Also trigger when someone has accumulated information across a conversation and wants it saved in a reusable, navigable format -- even if they don't use the phrase "knowledge base."
---

# Knowledge Base Builder

Build navigable, structured knowledge bases that work for humans and LLMs alike. The output is a folder of markdown files with YAML frontmatter, organized so you can find anything in three hops: README -> index -> specific file.

## Why This Structure

Formal databases and ontologies are overkill for most knowledge work. They require upfront schema design that breaks when the domain evolves (and every active domain evolves). What actually works is structured markdown in git -- human-readable, programmatically queryable via frontmatter, and scales from 10 documents to 10,000 without changing the format.

The key insight: **index files at every directory level** make the difference between "a folder of notes" and "a knowledge base." Without them, finding anything requires reading every file. With them, navigation is three hops max.

## Step 1: Understand the Domain

Before creating files, figure out what the knowledge base is about. Ask yourself (or the user):

1. **What's the subject?** (ML research, a product, a market, a hobby, a course)
2. **What types of knowledge exist?** Every domain has 3-6 natural categories. For ML research it's techniques, experiments, papers, ablations. For product development it might be features, user research, competitors, architecture decisions. For investing it's companies, theses, sectors, positions.
3. **What questions will someone ask this knowledge base?** "What have we tried?" "What works?" "Why did we decide X?" "What should we try next?" The structure should make these questions easy to answer.

## Step 2: Create the Directory Structure

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

**Naming conventions:**
- Directories: lowercase, hyphens (e.g., `user-research/`)
- Files: lowercase, hyphens (e.g., `ternary-quantization.md`)
- Date-prefixed when chronological order matters (e.g., `2026-03-26-chose-ternary.md`)

## Step 3: Write the README.md

The README is the front door. It should answer: what is this, what's in it, and where do I go first.

```markdown
# [Knowledge Base Title]

## What This Is
[1-2 sentences: what domain this covers and why it exists]

## How to Navigate
- **[Category 1]/** -- [what's in here, when to look here]
- **[Category 2]/** -- [what's in here, when to look here]
- **[Category 3]/** -- [what's in here, when to look here]
- **synthesis/** -- [cross-cutting analysis, big-picture takeaways]
- **decision_logs/** -- [why we chose what we chose]

## Current Status
[What's the most recent work? What's the current focus?]

## Key Findings So Far
[3-5 bullet points of the most important things this knowledge base contains]
```

Keep it under 50 lines. The README is a routing table, not a document.

## Step 4: Write _index.md Files

Every directory gets an _index.md. This is the single most important pattern in the whole system. It's a table that lets you scan everything in the category without opening individual files.

```markdown
# [Category Name] Index

| Entry | Status | Summary | Last Updated |
|-------|--------|---------|-------------|
| [name](./file.md) | active | One-line description | 2026-03-26 |
| [name](./file.md) | archived | One-line description | 2026-03-20 |
```

For time-organized categories, list newest first. For alphabetical categories, sort alphabetically. Include a status column so readers can skip archived/stale entries.

## Step 5: Write Individual Entries with YAML Frontmatter

Every entry file gets YAML frontmatter. The frontmatter is the structured layer -- it enables filtering, cross-referencing, and programmatic queries without parsing prose.

Read `references/frontmatter_schemas.md` for complete YAML schemas for different document types. The general pattern:

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

After the frontmatter, write the body in plain markdown. Structure varies by document type, but general principles:

- Lead with the conclusion or key finding (don't bury it)
- Use headers for scanability
- Include specific numbers, dates, and sources (not "recently" or "some research shows")
- End with "What's Next" or "Open Questions" when applicable

## Step 6: Write Decision Logs

Decision logs are the highest-value pattern. They capture WHY choices were made, which is the thing most likely to be forgotten and most expensive to lose.

```yaml
---
title: "Choosing X over Y"
date: 2026-03-26
context: "What problem were we solving?"
decision: "What we chose"
status: active               # active | superseded | revisiting
superseded_by: ""            # link to newer decision if relevant
---

## Context
[What situation prompted this decision?]

## Decision
[What did we decide?]

## Alternatives Considered
[What else was on the table? Why not those?]

## Rationale
[Why this choice? What evidence or reasoning?]

## Risks
[What could go wrong?]

## Revisit If
[Under what conditions should we reconsider?]
```

## Step 7: Write Synthesis Documents

After accumulating enough entries, create synthesis documents that connect the dots. These go in `synthesis/` and answer big-picture questions.

Good synthesis docs:
- "What We Know About X" -- summarizes current state of knowledge
- "Comparison of Approaches" -- side-by-side analysis
- "What to Try Next" -- prioritized recommendations based on accumulated evidence
- "Lessons Learned from [Project/Phase]" -- retrospective

These are the most valuable documents in the knowledge base because they do the thinking, not just the storing.

## Updating the Knowledge Base

When adding new information:

1. Create or update the individual entry file
2. Update the relevant _index.md
3. Update the README.md "Current Status" if significant
4. Create a decision log if a choice was made
5. Update synthesis documents if the new info changes the big picture

When the user provides new research, findings, or decisions in conversation, proactively suggest adding them to the knowledge base and do it.

## Making It Work with LLMs

This structure is designed so an LLM can navigate it efficiently:

1. **Read README.md first** -- understand what exists and where
2. **Read the relevant _index.md** -- find the right file
3. **Read the specific entry** -- get the details
4. **Use frontmatter for filtering** -- "find all entries with status: active and tag: quantization"

Three hops max from "I need to know about X" to reading the answer.

## Anti-Patterns to Avoid

**Don't create empty scaffolding.** Only create directories and files that have content. An empty `papers/` directory with a placeholder _index.md is worse than no directory -- it implies there's nothing to find.

**Don't over-categorize.** If you have 5 entries, you don't need 5 subdirectories. Start flat, add structure when a category grows past 10-15 entries.

**Don't duplicate content across entries.** If two entries share background, put the background in a synthesis doc and link to it.

**Don't use the knowledge base for transient notes.** Scratch work, brainstorms, and raw meeting notes belong elsewhere. The knowledge base is for processed, structured knowledge you want to find later.
