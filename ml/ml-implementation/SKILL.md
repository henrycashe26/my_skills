---
name: ml-implementation
description: |
  Guide implementation of ML models from paper to working code. Use this skill when the user wants to: implement a model architecture from a paper or description, design experiments and ablation studies, set up a training pipeline, structure ML code for iteration speed, plan which components to build first, or create a baseline before adding complexity. Trigger when the user says things like "implement this", "build this model", "code this up", "how should I structure this", "set up the training loop", "design an experiment", or "what should I ablate". Also trigger when someone has a model idea and needs help turning it into code, even if they don't use the word "implement."
---

# ML Implementation: From Idea to Working Code

You are helping someone turn an ML idea into running code. The goal is not just "code that runs" but code that produces trustworthy results you can iterate on quickly.

## The Implementation Philosophy

The single most important principle: **get something running end-to-end before optimizing anything.** A broken training loop that trains for 100 steps and shows decreasing loss in 10 minutes is worth infinitely more than a perfect architecture that you haven't tested yet.

## Phase 1: Baseline First, Always

Before implementing your fancy new idea, get a dumb baseline working. This serves three purposes:
- Validates your data pipeline, training loop, and evaluation code
- Gives you a number to beat (if your idea can't beat a baseline, it doesn't work)
- Creates a codebase you can modify incrementally

For language models, the baseline is usually a small standard transformer. For vision, a ResNet or ViT. For your specific domain, whatever the simplest reasonable model is.

**The baseline should be embarrassingly simple.** If you're implementing ternary quantization, your baseline is the same architecture with normal float weights. If you're implementing a new attention mechanism, your baseline is standard attention. Same everything else.

### What the Baseline Must Include
- Data loading and preprocessing (the exact same pipeline your real model will use)
- Training loop with logging (loss, learning rate, step time, memory usage)
- Periodic validation evaluation
- Checkpoint saving
- A way to reproduce the run (seed, config, exact command)

## Phase 2: Implement Incrementally

Don't implement everything at once. The order matters:

### Step 1: Data Pipeline
Get the data flowing first. Verify shapes, dtypes, and values at every stage. Print a few samples and eyeball them. Common bugs:
- Off-by-one in sequence lengths
- Wrong tokenizer vocabulary size
- Padding/masking errors (these are silent killers)
- Data not shuffled, or shuffled wrong
- Normalization applied twice or not at all

### Step 2: Model Architecture (Forward Pass Only)
Build the model and verify the forward pass works:
```python
# Always do this before training
x = torch.randn(batch_size, seq_len, dim)
y = model(x)
print(f"Input: {x.shape}, Output: {y.shape}")
assert y.shape == expected_shape
```

For each new component, test it in isolation before plugging it into the full model. If you're implementing a custom attention layer, verify it produces the same output as a known-good implementation on the same input.

### Step 3: Loss and Backward Pass
Verify gradients flow properly:
```python
loss = criterion(model(x), targets)
loss.backward()
for name, param in model.named_parameters():
    if param.grad is None:
        print(f"WARNING: No gradient for {name}")
    elif param.grad.abs().max() == 0:
        print(f"WARNING: Zero gradient for {name}")
```

### Step 4: Overfit a Single Batch
Before training on the full dataset, overfit on one batch. The model should drive training loss to near-zero on a single repeated batch. If it can't, something is wrong with the model or training loop -- don't proceed until this works.

```python
batch = next(iter(dataloader))
for step in range(200):
    loss = train_step(model, batch)
    if step % 20 == 0:
        print(f"step {step}: loss {loss:.4f}")
# Loss should be near 0 by step 200
```

### Step 5: Short Training Run
Train on the full dataset for a small number of steps. Verify:
- Loss decreases smoothly (no spikes, no NaN)
- Validation loss also decreases (not just memorizing)
- Step time is reasonable (no unexpected slowdowns)
- Memory usage is stable (no leaks)
- Gradient norms are healthy (not exploding or vanishing)

### Step 6: Full Training Run
Only now do you run the full training. And even here, start with a shorter run (25% of total steps) before committing to the full thing.

## Phase 3: Adding Your New Technique

Now that the baseline works, add your new technique as a minimal diff:

**Change ONE thing at a time.** If you change the architecture AND the optimizer AND the learning rate, you won't know which change helped (or hurt). Make one change, run a short experiment, verify it helps, then move on.

**Keep the baseline code accessible.** Use config flags, not code deletion. You want to be able to switch back to the baseline at any time.

```python
# Good: config flag
if config.use_ternary_quantization:
    weight = quantize_ternary(weight)

# Bad: delete the old code and replace it
```

**Log everything.** For each experiment, save:
- The exact config/command used
- Training curves (loss, val_loss, learning rate, gradient norms)
- Wall clock time per step
- Final metric
- Any notes about what you observed

## Phase 4: Ablation Strategy

An ablation study removes components one at a time to measure their individual contribution. This tells you which parts of your system are actually helping.

### How to Ablate

Start with your best configuration, then remove/change one thing at a time:

| Experiment | Change | Result | Delta |
|-----------|--------|--------|-------|
| Full model | (baseline) | 1.15 bpb | -- |
| No XSA | Remove XSA layers | 1.16 bpb | +0.01 |
| No RoPE | Remove partial RoPE | 1.155 bpb | +0.005 |
| relu instead of relu² | Swap activation | 1.17 bpb | +0.02 |

### What Makes a Good Ablation
- Only change one variable at a time
- Use the same training budget for each run (same steps, same batch size)
- Run with the same seed (or average over multiple seeds if you can afford it)
- Include your baseline (no technique at all) and your full model (everything included)

### Minimum Viable Ablation
If you can't afford full ablations, at least verify:
1. Your technique beats the baseline
2. Each component you added individually improves over the baseline
3. The full stack is better than any individual component

## Experiment Design for Limited Compute

When GPU time is expensive, be strategic:

**Proxy metrics.** Train for 10% of the total steps and use that loss as a proxy for the final loss. This isn't perfect (some techniques help more late in training), but it's usually directionally correct and 10x cheaper.

**Binary search hyperparameters.** Don't grid search. Pick two extreme values, test both, then test the midpoint. Repeat. Gets you within 90% of optimal in log(n) runs instead of n.

**Kill early.** If a run is clearly worse than the baseline after 20% of training, kill it and try something else. Don't hope it'll catch up.

**Prioritize by expected impact.** If you have 5 ideas and compute for 3 experiments, rank them by (expected improvement) × (probability of working) and run the top 3.

## Code Structure

Organize your ML code for fast iteration:

```
project/
├── config.py          # All hyperparameters in one place
├── model.py           # Model architecture
├── data.py            # Data loading and preprocessing
├── train.py           # Training loop
├── eval.py            # Evaluation
├── utils.py           # Logging, checkpointing, misc
├── experiments/       # One script per experiment variant
│   ├── baseline.sh
│   ├── ternary_v1.sh
│   └── ternary_v2.sh
└── logs/              # Training logs, organized by run
    ├── baseline_seed42/
    └── ternary_v1_seed42/
```

**Config should be a single source of truth.** Don't scatter hyperparameters across files. One config object, passed everywhere.

**Make runs reproducible.** Set seeds, log the exact config, save the git hash. You should be able to recreate any previous run exactly.

## Common Implementation Bugs

### Silent Correctness Bugs (the worst kind)
- Broadcasting errors: shapes align by accident but semantics are wrong
- Detached tensors: computation graph breaks but no error is raised
- Wrong dimension in softmax/layernorm: runs fine, trains poorly
- Stale optimizer: model parameters changed but optimizer wasn't updated
- Evaluation mode: forgot `model.eval()` or `torch.no_grad()` during validation

### Performance Bugs
- Unnecessary CPU-GPU synchronization (`.item()` in the training loop)
- Data loading bottleneck (not enough workers, no prefetching)
- Recomputing things that could be cached
- Not using mixed precision when you could be

### Debugging Strategy
When something doesn't work:
1. Check shapes at every layer boundary
2. Check for NaN/Inf in activations and gradients
3. Verify the loss on a single batch matches hand computation
4. Compare your implementation's output to a reference implementation on the same input
5. Simplify until it works, then add complexity back
