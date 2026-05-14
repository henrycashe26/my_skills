# Anti-Patterns to Avoid

**Don't create empty scaffolding.** Only create directories and files that have content. An empty `papers/` directory with a placeholder _index.md is worse than no directory -- it implies there's nothing to find.

**Don't over-categorize.** If you have 5 entries, you don't need 5 subdirectories. Start flat, add structure when a category grows past 10-15 entries.

**Don't duplicate content across entries.** If two entries share background, put the background in a synthesis doc and link to it.

**Don't use the knowledge base for transient notes.** Scratch work, brainstorms, and raw meeting notes belong elsewhere. The knowledge base is for processed, structured knowledge you want to find later.

## LLM Navigation

This structure is designed so an LLM can navigate it efficiently:

1. **Read README.md first** -- understand what exists and where
2. **Read the relevant _index.md** -- find the right file
3. **Read the specific entry** -- get the details
4. **Use frontmatter for filtering** -- "find all entries with status: active and tag: quantization"

Three hops max from "I need to know about X" to reading the answer.
