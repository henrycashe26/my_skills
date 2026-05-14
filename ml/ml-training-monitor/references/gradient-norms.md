# Gradient Norms and Weight/Activation Statistics

## Gradient norm (logged every N steps)

The L2 norm of all gradients. Healthy range depends on model size, but:

- Suddenly increasing: approaching instability
- Going to zero: vanishing gradients (dead model)
- Highly variable: might need gradient clipping

## Weight statistics (logged periodically)

Mean, std, min, max of each parameter group. If weights grow unbounded or collapse to zero, something is wrong.

## Activation statistics

Same thing, but for intermediate activations. Dead ReLU neurons (always zero) indicate the model is losing capacity.

## Gradient statistics per layer

Are all layers receiving gradients? Is one layer's gradient 1000x larger than another's? This indicates an imbalance that will cause some layers to train much faster than others.

## Gradient clipping

**Add/tighten if:** Gradient norms spike or you see NaN loss.
**Loosen if:** Gradient norms are consistently well below the clip threshold (the clipping isn't doing anything, but also isn't hurting).

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Gradients all zero | Dead model, detached computation | Check `requires_grad`, verify backward pass |
