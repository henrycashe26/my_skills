---
name: humanizer
version: 2.3.0
description: |
  Remove signs of AI-generated writing from text. Use when editing or reviewing
  text to make it sound more natural and human-written. Based on Wikipedia's
  comprehensive "Signs of AI writing" guide. Detects and fixes patterns including:
  inflated symbolism, promotional language, superficial -ing analyses, vague
  attributions, em dash overuse, rule of three, AI vocabulary words, negative
  parallelisms, and excessive conjunctive phrases.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

# Humanizer: Remove AI Writing Patterns

Editor skill for stripping signs of AI-generated text from prose. Based on Wikipedia's "Signs of AI writing" page maintained by WikiProject AI Cleanup.

## Philosophy

LLMs use statistical algorithms to guess what should come next. The result tends toward the most statistically likely output that applies to the widest variety of cases. Humanizing means swapping that statistically average prose for specific, opinionated, uneven writing that sounds like a person thought it. Removing AI patterns is only half the job; the other half is adding voice. See [references/personality-and-soul.md](references/personality-and-soul.md).

## Workflow

1. **Read** the input text carefully.
2. **Detect** instances of the patterns in the catalog below. Load the relevant reference file for each pattern you suspect.
3. **Draft** a rewrite. Replace AI-isms with natural alternatives. Preserve meaning, match the intended tone, vary sentence rhythm, prefer specific details over vague claims, and use simple constructions (is/are/has) where appropriate.
4. **Add soul.** Inject opinions, uneven rhythm, first person when fitting, acknowledgment of complexity. See [references/personality-and-soul.md](references/personality-and-soul.md).
5. **Audit.** Prompt yourself: "What makes the below so obviously AI generated?" Answer briefly with remaining tells.
6. **Revise.** Prompt: "Now make it not obviously AI generated." Produce the final version.
7. **Present** draft, audit notes, final rewrite, and (optionally) a short changelog of what changed.

See [references/full-example.md](references/full-example.md) for a complete worked example showing draft → audit → final → changelog.

## Output Format

Provide, in order:

1. Draft rewrite
2. "What makes the below so obviously AI generated?" (brief bullets)
3. Final rewrite
4. Brief summary of changes (optional, if helpful)

## Pattern Catalog

Each pattern has detection rules, before/after examples, and fixes in its reference file.

### Content patterns — [references/content-patterns.md](references/content-patterns.md)

1. **Undue emphasis on significance, legacy, broader trends** — "pivotal moment", "testament", "evolving landscape".
2. **Undue emphasis on notability and media coverage** — name-dropping outlets without context.
3. **Superficial -ing analyses** — tacked-on "highlighting...", "reflecting...", "underscoring...".
4. **Promotional / advertisement-like language** — "nestled", "vibrant", "breathtaking", "stands as".
5. **Vague attributions and weasel words** — "Industry reports", "Experts argue", "Observers have cited".
6. **Outline-like "Challenges and Future Prospects" sections** — formulaic "Despite... continues to thrive".

### Language and grammar — [references/language-grammar.md](references/language-grammar.md)

7. **Overused AI vocabulary** — delve, crucial, tapestry, intricate, testament, underscore, landscape.
8. **Copula avoidance** — "serves as", "stands as", "boasts" instead of plain "is/are/has".
9. **Negative parallelisms** — "It's not just X, it's Y", "Not only... but...".
10. **Rule of three overuse** — forced triplets to sound comprehensive.
11. **Elegant variation (synonym cycling)** — protagonist/main character/central figure/hero.
12. **False ranges** — "from X to Y" where X and Y aren't on a meaningful scale.

### Style patterns — [references/style-patterns.md](references/style-patterns.md)

13. **Em dash overuse** — punchy sales-style em dashes everywhere.
14. **Overuse of boldface** — mechanically bolding key phrases.
15. **Inline-header vertical lists** — `- **Topic:** description.` pattern.
16. **Title case in headings** — Capitalizing All Main Words.
17. **Emojis** — 🚀 💡 ✅ decorating headings and bullets.
18. **Curly quotation marks** — “...” instead of "...".

### Communication patterns — [references/communication.md](references/communication.md)

19. **Collaborative communication artifacts** — "I hope this helps", "Let me know", "Here is a...".
20. **Knowledge-cutoff disclaimers** — "as of my last update", "While specific details are limited...".
21. **Sycophantic / servile tone** — "Great question!", "You're absolutely right!".

### Filler and hedging — [references/filler-hedging.md](references/filler-hedging.md)

22. **Filler phrases** — "in order to", "due to the fact that", "at this point in time".
23. **Excessive hedging** — "could potentially possibly be argued that... might".
24. **Generic positive conclusions** — "the future looks bright", "exciting times lie ahead".
25. **Hyphenated word pair overuse** — uniformly hyphenated cross-functional/data-driven/high-quality.

## Reference

Based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup. The patterns documented there come from observations of thousands of instances of AI-generated text on Wikipedia.
