# Quantization-Aware Training (QAT) Specifics

QAT has its own failure modes.

## Quantization gap widens during training

The difference between quantized and unquantized loss grows over time. This means the model is learning features that can't survive quantization.

Solutions:
- Apply quantization earlier in training (not just at the end)
- Use STE (straight-through estimator) from the start
- Reduce the learning rate when quantization is active
- Use group quantization (smaller groups = less error)

## Ternary weight collapse

All weights in a layer drift to the same ternary value (usually 0). The layer is effectively dead.

Solutions:
- Initialize with larger values
- Reduce weight decay
- Use per-group scaling (forces each group to have meaningful range)
- Check if the scaling factor is being learned or is fixed

## Mixed-precision instability

When some layers are quantized and others aren't, the gradient scales can be wildly different.

Solutions:
- Layer-specific learning rates
- Gradient scaling to normalize across layers
- More gradual quantization (start with low bit-width in later layers, add more layers over time)

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Quantized model much worse | QAT not working, precision too low | Start QAT earlier, use group quantization, check scaling |
