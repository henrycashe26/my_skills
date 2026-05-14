# NaN Loss

Loss going to NaN is almost always one of:

- Learning rate too high (most common)
- Gradient explosion (check gradient norms)
- Numerical instability in some operation (log of zero, division by zero, softmax overflow)
- Bad data (NaN or Inf in inputs)

## Debug steps

1. Lower LR 10x.
2. Add gradient clipping.
3. Check for numerical operations that could produce NaN (`log(0)`, `0/0`, softmax overflow).
4. Print intermediate activations to find where the NaN first appears.

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Loss NaN | LR too high, numerical instability | Lower LR 10x, add grad clip, check for log(0) |

If a restart with lower LR still produces NaN, see [divergence.md](divergence.md) for kill criteria.
