# Reading Loss Curves

The loss curve is the single most informative signal during training. Here's what different shapes tell you.

## Healthy Training

```
Loss
 |
 |\.
 |  \.
 |    \..
 |       '...
 |           '''''....___
 |_________________________ Steps
```

Smooth, monotonically decreasing, with diminishing returns. Validation loss tracks training loss with a small gap. This is what you want.

## Common Pathologies

**Flat start then sudden drop (S-curve):**
Normal for some architectures (ternary models, very deep networks). The model is learning internal representations before they start helping. Don't kill the run during the flat part -- wait at least 2x longer than the flat period before deciding it's not learning.

**Loss spikes:**
Occasional small spikes (2-3x the running average) are usually fine, especially early in training. The model recovers. Worry when:
- Spikes get progressively larger
- The model doesn't recover to pre-spike levels
- Spikes coincide with specific data batches (data quality issue)

**Loss goes to NaN:**
See [nan-loss.md](nan-loss.md).

**Loss plateaus then drops:**
This is often grokking -- the model memorizes first, then suddenly generalizes. More common with weight decay and smaller models. Usually a good sign, but verify the drop corresponds to actual generalization by checking validation metrics.

**Validation loss diverges from training loss:**
Overfitting. See [overfitting.md](overfitting.md).

**Loss oscillates without converging:**
Learning rate too high, or batch size too small. Try: halving the learning rate, doubling the batch size, or both.
