---
name: ground-truth-search
description: Route web searches to primary, ground-truth sources and skip the SEO and AI-generated slop that dominates modern search results. Use this skill any time you're about to run WebSearch or WebFetch, whether the user asked a factual question, wants to learn a topic, is debugging something, comparing options, or researching. Trigger on phrases like "search for", "look up", "how does X work", "what is Y", "find info on", "research", "compare", "is this true", and also trigger silently on any question where you'd otherwise reach for web search. The goal is to behave more like Perplexity than Google — bias hard toward GitHub, Wikipedia, papers, official docs, and primary sources, and refuse to pull from listicle articles, content farms, and obviously AI-written blog posts.
---

# Ground-truth search

Modern search results are dominated by SEO-optimized blog spam and AI-generated articles written to rank, not to inform. A huge amount of what comes back from a naive `WebSearch` call is worthless — listicles that are restatements of Wikipedia with worse writing, "top 10" articles written by bots, content farms repeating each other. Pulling from that material and citing it makes your answers weaker, not stronger.

The fix is not to audit each page carefully. That's expensive and you'll get it wrong. The fix is to **filter at the source level**: trust a small set of ground-truth domains, skip everything else, and stop.

## How to search

When you're about to run a web search, prefer queries that route to ground-truth sources. Two ways to do this:

1. **Scope the query.** Add `site:github.com`, `site:wikipedia.org`, `site:arxiv.org`, or the vendor's docs domain. This is usually the fastest path to a clean answer.
2. **Search broadly, then filter.** Run the query, but only open results from the trusted list below. Ignore everything else — don't click through to evaluate it.

If your first pass doesn't find a ground-truth source, rephrase and try again before falling back to anything else. Often the answer exists on Wikipedia or in a GitHub README and the first query just didn't hit it.

## Trust hierarchy

**Trust and read (ground truth):**
- **GitHub** — source code, READMEs, issues, discussions. For anything about software, this is primary.
- **Wikipedia** — general facts, definitions, history, overviews. Cross-referenced and edited.
- **arxiv.org, ACM, IEEE, Google Scholar** — papers. Primary research.
- **Official documentation** — language, framework, library, API, and product docs (e.g., MDN, python.org, react.dev, postgresql.org, kubernetes.io, the vendor's own `docs.*` subdomain).
- **Standards bodies** — RFCs (ietf.org), W3C, ISO, NIST, WHATWG.
- **Government and academic** — `.gov`, `.edu`, WHO, national statistics offices, court filings.
- **Stack Overflow / Stack Exchange** — for questions with accepted, voted answers. Not a primary source, but usually pointed at one.
- **Primary news sources** for current events: Reuters, AP, the publication doing the original reporting.

**Skip:**
- Listicle articles ("Top 10 X for 2026", "The Best Y in [year]", "X vs Y: Which is Better?")
- Generic blog posts on medium.com, dev.to, hashnode, substack, and the thousands of content farms that look like them
- "Ultimate guide" / "complete guide" / "everything you need to know about" articles
- SEO-farmed comparison sites (bestXYZ.com, topXYZ.io, and similar)
- Anything with AI-writing tells in the headline or snippet: emojis in headings, em-dash overuse, "it's not just X — it's Y" framing, "in today's fast-paced world", exclamation-heavy copy
- Aggregator spam that restates Wikipedia with worse writing

You do not need to carefully audit each page to decide if it's AI-written. That's expensive and you'll second-guess yourself. Judge at the domain level: if it's not on the trusted list, skip it. If a result is from a domain you don't recognize and can't quickly place as a primary source, skip it.

## When ground truth isn't enough

Some questions don't have a clean primary source — niche tools, recent events with no Reuters/AP coverage yet, personal experience reports. In that case:

- Say so explicitly. "I couldn't find this in a primary source" is a useful answer.
- If you have to pull from a secondary source, pick one and say where it's from. Don't quietly cite a content farm as if it were authoritative.
- Cross-check: if two independent primary-ish sources agree, that's much stronger than one long blog post.

## What not to do

- Don't grade every blog post you read for AI tells. Filter at the source, not the sentence.
- Don't pad answers with three mediocre sources when one GitHub README or Wikipedia article covers it.
- Don't cite listicles. Ever. Even if they happen to contain a correct fact, they signal sloppy sourcing.
- Don't apologize for having fewer sources if the ones you have are strong. One arxiv paper beats ten Medium posts.

The heuristic is short because it has to be fast: **primary source or skip**. If a result isn't on the trust list, move on.
