---
name: ml-implementation
description: |
  Guide implementation of ML models from paper to working code. Use this skill when the user wants to: implement a model architecture from a paper or description, design experiments and ablation studies, set up a training pipeline, structure ML code for iteration speed, plan which components to build first, or create a baseline before adding complexity. Trigger when the user says things like "implement this", "build this model", "code this up", "how should I structure this", "set up the training loop", "design an experiment", or "what should I ablate". Also trigger when someone has a model idea and needs help turning it into code, even if they don't use the word "implement."
---

# ML Implementation: From Idea to Working Code

You are helping someone turn an ML idea into running code. The goal is not just "code that runs" but code that produces trustworthy results you can iterate on quickly.

## Philosophy

The single most important principle: **get something running end-to-end before optimizing anything.** A broken training loop that trains for 100 steps and shows decreasing loss in 10 minutes is worth infinitely more than a perfect architecture that you haven't tested yet.

## Workflow

Follow these phases in order. Don't skip ahead.

### Phase 1: Baseline

Build the dumbest reasonable model first. Same data pipeline, same training loop, same eval, but with a standard architecture (transformer, ResNet, ViT). This validates the plumbing and gives you a number to beat.

The baseline should be embarrassingly simple. If you're implementing ternary quantization, the baseline is the same architecture with normal float weights. Same everything else. The baseline must include the real data pipeline, the real training loop with logging, periodic eval, checkpointing, and a way to reproduce the run.

See [`references/baseline.md`](references/baseline.md).

### Phase 2: Implement Incrementally

Bring up the system in this order, verifying each step before the next:

1. Data pipeline — shapes, dtypes, samples eyeballed
2. Model forward pass — assert output shapes
3. Loss and backward pass — gradients flow to every parameter
4. Overfit a single batch — loss must go near zero
5. Short training run — smooth loss, stable memory, healthy grad norms
6. Full training run — only after the above pass

See [`references/incremental-implementation.md`](references/incremental-implementation.md) for code snippets and the failure modes at each step.

### Phase 3: Add Your Technique

Now add your new idea as a minimal diff on top of the baseline. Change ONE thing at a time. Use config flags, not code deletion, so you can switch back. Log everything. See [`references/adding-techniques.md`](references/adding-techniques.md).

### Phase 4: Ablate

Run ablations to measure which components actually help. Start from your best config and remove one thing at a time, holding training budget and seed constant. See [`references/ablations.md`](references/ablations.md).

### Phase 5: Scale

Only scale up once the small-scale story is clean. Use proxy metrics, binary search hyperparameters, kill bad runs early, and rank experiments by expected impact when compute is tight. See [`references/limited-compute.md`](references/limited-compute.md).

## Anti-patterns

- Implementing the fancy idea before the baseline runs.
- Changing more than one variable between experiments.
- Deleting baseline code instead of gating it behind a config flag.
- Skipping the single-batch overfit check.
- Hoping a bad run "catches up" instead of killing it.
- Grid-searching hyperparameters when you have limited compute.
- Hyperparameters scattered across files instead of one config.

## Checklist

Before declaring an implementation done:

- [ ] Baseline runs end-to-end and reproduces a known number
- [ ] Single-batch overfit succeeds for both baseline and full model
- [ ] Each new component tested in isolation against a known-good reference
- [ ] Every experiment has a saved config, seed, and git hash
- [ ] Training curves, grad norms, and step time are logged
- [ ] Ablation table shows each component's individual contribution
- [ ] No silent correctness bugs (see [`references/debugging.md`](references/debugging.md))

## Topics

- [`references/baseline.md`](references/baseline.md) — why the baseline comes first and what it must include.
- [`references/incremental-implementation.md`](references/incremental-implementation.md) — the six-step bring-up order with code snippets and common bugs.
- [`references/adding-techniques.md`](references/adding-techniques.md) — how to add your new idea as a minimal, reversible diff.
- [`references/ablations.md`](references/ablations.md) — how to design ablations and what a minimum viable ablation looks like.
- [`references/limited-compute.md`](references/limited-compute.md) — proxy metrics, binary search, early killing, and prioritization under compute limits.
- [`references/code-structure.md`](references/code-structure.md) — directory layout, single-source-of-truth config, reproducibility.
- [`references/debugging.md`](references/debugging.md) — silent correctness bugs, performance bugs, and a debugging checklist.
