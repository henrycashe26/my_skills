# Ablation Strategy

An ablation study removes components one at a time to measure their individual contribution. This tells you which parts of your system are actually helping.

## How to Ablate

Start with your best configuration, then remove/change one thing at a time:

| Experiment | Change | Result | Delta |
|-----------|--------|--------|-------|
| Full model | (baseline) | 1.15 bpb | -- |
| No XSA | Remove XSA layers | 1.16 bpb | +0.01 |
| No RoPE | Remove partial RoPE | 1.155 bpb | +0.005 |
| relu instead of relu² | Swap activation | 1.17 bpb | +0.02 |

## What Makes a Good Ablation

- Only change one variable at a time
- Use the same training budget for each run (same steps, same batch size)
- Run with the same seed (or average over multiple seeds if you can afford it)
- Include your baseline (no technique at all) and your full model (everything included)

## Minimum Viable Ablation

If you can't afford full ablations, at least verify:

1. Your technique beats the baseline
2. Each component you added individually improves over the baseline
3. The full stack is better than any individual component
