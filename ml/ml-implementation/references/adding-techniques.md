# Adding Your New Technique

Now that the baseline works, add your new technique as a minimal diff.

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
