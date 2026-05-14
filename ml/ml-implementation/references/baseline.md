# Baseline First, Always

Before implementing your fancy new idea, get a dumb baseline working. This serves three purposes:

- Validates your data pipeline, training loop, and evaluation code
- Gives you a number to beat (if your idea can't beat a baseline, it doesn't work)
- Creates a codebase you can modify incrementally

For language models, the baseline is usually a small standard transformer. For vision, a ResNet or ViT. For your specific domain, whatever the simplest reasonable model is.

**The baseline should be embarrassingly simple.** If you're implementing ternary quantization, your baseline is the same architecture with normal float weights. If you're implementing a new attention mechanism, your baseline is standard attention. Same everything else.

## What the Baseline Must Include

- Data loading and preprocessing (the exact same pipeline your real model will use)
- Training loop with logging (loss, learning rate, step time, memory usage)
- Periodic validation evaluation
- Checkpoint saving
- A way to reproduce the run (seed, config, exact command)
