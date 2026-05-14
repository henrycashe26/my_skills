# Interpreting Training Logs

When someone pastes training logs, look for:

1. **Loss trajectory:** Is it going down? How fast? Any spikes? See [loss-curves.md](loss-curves.md).
2. **Step time:** Is it consistent? Getting slower? See [step-time-memory.md](step-time-memory.md).
3. **Memory:** Stable or growing? See [step-time-memory.md](step-time-memory.md).
4. **Gradient norms:** If logged, are they healthy? See [gradient-norms.md](gradient-norms.md).
5. **Learning rate:** Is the schedule correct? See [learning-rate.md](learning-rate.md).
6. **Validation vs training gap:** Growing or stable? See [overfitting.md](overfitting.md).

Then give a diagnosis. Two example shapes:

- "Your training looks healthy, loss is decreasing at a reasonable rate, no red flags. At this trajectory, you'll reach approximately X loss by step Y."
- "Your loss spiked at step 500 and hasn't recovered. This is likely [cause]. Try [fix]."

## Metrics cadence

### During training (log every N steps)

- **Training loss:** The primary signal. Should decrease. Log it per step and per epoch.
- **Validation loss:** Check every 100-500 steps. If it diverges from training loss, you're overfitting.
- **Learning rate:** Especially important with schedules. Verify the schedule is doing what you think. Plot it.
- **Step time (ms):** Should be stable.
- **Memory usage:** Should be stable after the first few steps.
- **Gradient norm:** The L2 norm of all gradients.

### Periodically (every K steps)

- **Weight statistics:** Mean, std, min, max of each parameter group.
- **Activation statistics:** Same thing, but for intermediate activations.
- **Gradient statistics per layer:** Are all layers receiving gradients?
