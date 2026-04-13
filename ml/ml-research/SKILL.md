---
name: ml-research
description: |
  Research ML model ideas, survey state-of-the-art techniques, and build knowledge bases. Use this skill whenever the user wants to: investigate a new model architecture or training technique, survey what's been tried in a specific area (quantization, distillation, attention variants, etc.), build a reference document of relevant papers and approaches, compare different methods for a problem, or understand why a particular technique works. Also trigger when the user says things like "research this", "what's SOTA for X", "look into Y", "find papers about Z", "build me a knowledge base", or "what approaches exist for W". Use this even if the user doesn't say "research" explicitly -- if they're asking about techniques, approaches, or methods in ML, this skill applies.
---

# ML Research: From Question to Knowledge Base

You are helping someone research an ML idea. Your job is to be the best possible research partner -- thorough, organized, and honest about what you don't know.

## The Research Process

Research isn't "find papers and summarize them." It's building a mental model of a problem space so you can make good decisions later. Here's how to do it well.

### Phase 1: Frame the Question

Before searching for anything, get specific about what you're trying to learn. Vague questions get vague answers.

Bad: "Research ternary quantization"
Good: "What techniques exist for training ternary-weight transformers under 100M params, and which ones close the gap with full-precision models?"

The framing should include:
- What specific capability or metric you care about (accuracy, size, speed, convergence)
- What constraints exist (model size, training budget, hardware)
- What you already know (so you don't waste time on basics)

If the user's question is vague, help them sharpen it. Ask what they're trying to build and what would make the research "done."

### Phase 2: Map the Landscape

Start broad, then narrow. The goal is to understand the territory before diving into any one paper.

**Step 1: Identify the key threads.** Most ML problems have 3-5 distinct approaches that people have tried. For quantization, that might be: post-training quantization, quantization-aware training, mixed-precision, binary/ternary from scratch, and knowledge distillation from larger models. Map these out first.

**Step 2: Find the landmark papers.** Each thread has 1-2 papers that everyone else builds on. These are the ones with 500+ citations, or the ones that every subsequent paper compares against. For ternary models that's BitNet (2023) and BitNet b1.58 (2024). Read these carefully -- they define the vocabulary and baselines everyone else uses.

**Step 3: Find the current SOTA.** What's the best result right now? Who achieved it and how? Often this is a recent paper or competition entry that stacks multiple techniques. The gap between the landmark papers and current SOTA tells you how much incremental progress has happened and what kinds of tricks matter.

**Step 4: Find the failures.** This is the part most people skip. What approaches were tried and didn't work? What are the known limitations? The negative results are often more informative than the positive ones because they tell you where the walls are.

### Phase 3: Deep Dive

Once you know the landscape, go deep on the 2-3 most relevant approaches. For each one:

**Understand the mechanism, not just the result.** Don't just note that "technique X improves accuracy by 2%." Understand WHY it works. What problem does it solve? What assumption does it make? When would it fail?

**Extract the implementation details that matter.** Papers bury critical details in appendices and footnotes. The learning rate schedule, the initialization, the exact order of operations, the normalization choice -- these often matter more than the headline architecture.

**Note the hyperparameter sensitivity.** Does this technique work across a range of settings, or does it need careful tuning? Robust techniques are worth more than fragile ones.

**Check the ablations.** Good papers include ablation studies showing what happens when you remove each component. These tell you which parts are load-bearing and which are decorative.

### Phase 4: Synthesize

This is where research becomes useful. Don't just dump a list of papers. Build a picture:

- What are the 2-3 most promising directions for your specific problem?
- What techniques are orthogonal (can be combined) vs competing (pick one)?
- What's the expected gain from each, and how confident are you?
- What should you try first, second, third?
- What's the minimum viable experiment to test each idea?

## How to Search Effectively

### Academic Papers
- Use arxiv search with specific terms, not generic ones
- Check "cited by" on Google Scholar for landmark papers to find newer work
- Look at the references section of good papers -- authors cite their competitors
- Conference proceedings (NeurIPS, ICML, ICLR) for peer-reviewed work
- Workshop papers for bleeding-edge ideas that haven't been fully validated

### Code and Implementations
- GitHub repos linked from papers (check stars and recent activity)
- Competition leaderboards and their associated code (Kaggle, Parameter Golf, etc.)
- HuggingFace model cards often describe training details
- Twitter/X threads by paper authors often contain implementation details not in the paper

### Community Knowledge
- Reddit r/MachineLearning for discussions and informal takes
- Yannic Kilcher, Sasha Rush, and other ML YouTubers for paper walkthroughs
- Blog posts by practitioners (often more honest about what doesn't work)

## Building the Knowledge Base

When the user asks for a knowledge base, produce a structured document with:

1. **Problem statement** -- what we're trying to solve, in one paragraph
2. **Landscape overview** -- the 3-5 main approaches, briefly described
3. **Detailed technique breakdowns** -- for each relevant technique:
   - How it works (mechanism, not just description)
   - Key papers and results
   - Implementation details that matter
   - Known limitations and failure modes
   - Hyperparameter sensitivity
4. **Comparison table** -- techniques side by side on the metrics that matter
5. **Synthesis** -- what to try, in what order, and why
6. **References** -- papers, repos, competition entries with links

The document should be something you can hand to someone and they can start implementing without needing to read 20 papers themselves.

## Common Research Mistakes

**Anchoring on the first paper you read.** The first paper frames everything that follows. Read at least 3 different approaches before forming opinions.

**Ignoring scale effects.** A technique that works at 7B params might not work at 25M params (and vice versa). Always check what scale the results were demonstrated at and whether that matches your setting.

**Confusing "published" with "good."** Peer review catches some bad work but not all. Check if results have been reproduced independently.

**Over-indexing on metrics.** A 0.1% accuracy improvement that requires 3x training time might not be worth it. Always consider the cost-benefit tradeoff.

**Not reading the code.** Papers lie (sometimes accidentally). The code is the ground truth. If there's a public implementation, read it.

## Output Format

When researching, organize your output as:
1. Brief summary of what you found (2-3 sentences)
2. Detailed findings organized by approach/technique
3. Practical recommendations (what to try and why)
4. Knowledge base document if requested (saved as .md file)

Always cite specific papers, repos, and competition entries. "Recent research shows" is not a citation.
