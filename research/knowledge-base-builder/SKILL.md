---
name: knowledge-base-builder
description: |
  Build, organize, and maintain structured knowledge bases on any topic using markdown files with YAML frontmatter. Use this skill whenever the user wants to: create a knowledge base or research repository, organize research findings or notes into a navigable structure, build a reference document collection for a project or domain, track experiments and decisions alongside their rationale, or create a "second brain" for any subject area. Trigger when the user mentions: "knowledge base", "organize my research", "build a reference", "track what I've learned", "create a wiki", "document my findings", "research repository", or anything involving structured storage and retrieval of knowledge across multiple documents. Also trigger when someone has accumulated information across a conversation and wants it saved in a reusable, navigable format -- even if they don't use the phrase "knowledge base."
---

# Knowledge Base Builder

Build navigable, structured knowledge bases that work for humans and LLMs alike. The output is a folder of markdown files with YAML frontmatter, organized so you can find anything in three hops: README -> index -> specific file.

## Philosophy

Formal databases and ontologies are overkill for most knowledge work. They require upfront schema design that breaks when the domain evolves (and every active domain evolves). What actually works is structured markdown in git -- human-readable, programmatically queryable via frontmatter, and scales from 10 documents to 10,000 without changing the format.

The key insight: **index files at every directory level** make the difference between "a folder of notes" and "a knowledge base." Without them, finding anything requires reading every file. With them, navigation is three hops max.

## Workflow

### 1. Understand the domain

Before creating files, decide scope. Ask yourself (or the user):

1. **What's the subject?** (ML research, a product, a market, a hobby, a course)
2. **What types of knowledge exist?** Every domain has 3-6 natural categories. For ML research it's techniques, experiments, papers, ablations. For product development it might be features, user research, competitors, architecture decisions. For investing it's companies, theses, sectors, positions.
3. **What questions will someone ask this knowledge base?** "What have we tried?" "What works?" "Why did we decide X?" "What should we try next?" The structure should make these questions easy to answer.

### 2. Create the directory layout

Pick 3-6 category directories that match how the user thinks about the domain. Add `synthesis/` and `decision_logs/` when applicable. Use lowercase-hyphenated names. Date-prefix files when chronological order matters.

See [references/directory-layout.md](references/directory-layout.md) for the full template and naming conventions.

### 3. Write the README.md

The README is the front door, not a document. It answers: what is this, what's in it, where do I go first. Keep it under 50 lines.

See [references/readme.md](references/readme.md) for the template.

### 4. Write _index.md files

Every directory gets an `_index.md` -- a table that lets you scan everything in the category without opening individual files. This is the single most important pattern in the system.

See [references/indexes.md](references/indexes.md) for the format and ordering rules.

### 5. Write individual entries

Every entry file gets YAML frontmatter (the structured layer) followed by markdown body. Lead with the conclusion. Use headers for scanability. Include specific numbers, dates, and sources.

See [references/entries.md](references/entries.md) for the frontmatter pattern and body style.

### 6. Write decision logs

Whenever a choice was made that future-you might second-guess, drop a decision log in `decision_logs/` capturing context, decision, alternatives, rationale, risks, and revisit conditions.

See [references/decision-logs.md](references/decision-logs.md) for the template.

### 7. Write synthesis documents

After accumulating enough entries, create synthesis docs in `synthesis/` that connect the dots and answer big-picture questions. These do the thinking, not just the storing.

See [references/synthesis.md](references/synthesis.md) for when and what to write.

## Updating the Knowledge Base

When adding new information:

1. Create or update the individual entry file
2. Update the relevant `_index.md`
3. Update the README.md "Current Status" if significant
4. Create a decision log if a choice was made
5. Update synthesis documents if the new info changes the big picture

When the user provides new research, findings, or decisions in conversation, proactively suggest adding them to the knowledge base and do it.

## Anti-Patterns

Don't create empty scaffolding. Don't over-categorize. Don't duplicate content across entries. Don't use the knowledge base for transient notes.

See [references/anti-patterns.md](references/anti-patterns.md) for the full list and LLM navigation rules.

## Topics

- [directory-layout.md](references/directory-layout.md) -- full directory template, naming conventions, picking categories.
- [readme.md](references/readme.md) -- README.md template for the front door of a knowledge base.
- [indexes.md](references/indexes.md) -- `_index.md` table format, ordering, and why indexes matter.
- [entries.md](references/entries.md) -- YAML frontmatter pattern and body-writing principles for individual entries.
- [decision-logs.md](references/decision-logs.md) -- template for capturing WHY a choice was made.
- [synthesis.md](references/synthesis.md) -- when and what to write for cross-cutting synthesis documents.
- [anti-patterns.md](references/anti-patterns.md) -- what NOT to do, plus the LLM navigation pattern.
