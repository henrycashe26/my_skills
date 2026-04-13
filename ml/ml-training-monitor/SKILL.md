---
name: ml-training-monitor
description: |
  Diagnose, monitor, and debug ML model training runs. Use this skill when the user wants to: understand why a model isn't learning, diagnose training instability (NaN loss, spikes, divergence), interpret loss curves and training metrics, decide whether to adjust hyperparameters mid-run, figure out if a run is worth continuing or should be killed, debug quantization-aware training issues, or understand gradient behavior. Trigger when the user mentions: loss curves, training logs, gradient norms, learning rate schedules, NaN loss, training divergence, "model isn't learning", "loss is stuck", "should I kill this run", validation loss, overfitting/underfitting, warmup, cooldown, weight decay tuning, or any question about how training is going. Also use when someone pastes training logs and wants interpretation.
---

# ML Training Monitor: Diagnostics and Debugging

You are helping someone understand and fix their training runs. Training ML models is mostly watching numbers and making judgment calls about whether those numbers look right. This skill is about developing that judgment.

## Reading Loss Curves

The loss curve is the single most informative signal during training. Here's what different shapes tell you.

### Healthy Training
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

### Common Pathologies

**Flat start then sudden drop (S-curve):**
Normal for some architectures (ternary models, very deep networks). The model is learning internal representations before they start helping. Don't kill the run during the flat part -- wait at least 2x longer than the flat period before deciding it's not learning.

**Loss spikes:**
Occasional small spikes (2-3x the running average) are usually fine, especially early in training. The model recovers. Worry when:
- Spikes get progressively larger
- The model doesn't recover to pre-spike levels
- Spikes coincide with specific data batches (data quality issue)

**Loss goes to NaN:**
Almost always one of:
- Learning rate too high (most common)
- Gradient explosion (check gradient norms)
- Numerical instability in some operation (log of zero, division by zero, softmax overflow)
- Bad data (NaN or Inf in inputs)

Debug by: lowering LR 10x, adding gradient clipping, checking for numerical operations that could produce NaN, printing intermediate activations to find where the NaN first appears.

**Loss plateaus then drops:**
This is often grokking -- the model memorizes first, then suddenly generalizes. More common with weight decay and smaller models. Usually a good sign, but verify the drop corresponds to actual generalization by checking validation metrics.

**Validation loss diverges from training loss:**
Overfitting. Training loss keeps improving but validation loss gets worse. Solutions:
- More data
- More regularization (dropout, weight decay)
- Smaller model
- Earlier stopping
- Data augmentation

**Loss oscillates without converging:**
Learning rate too high, or batch size too small. Try: halving the learning rate, doubling the batch size, or both.

## Key Metrics to Watch

### During Training (log every N steps)

**Training loss:** The primary signal. Should decrease. Log it per step and per epoch.

**Validation loss:** Check every 100-500 steps. If it diverges from training loss, you're overfitting.

**Learning rate:** Especially important with schedules. Verify the schedule is doing what you think. Plot it.

**Step time (ms):** Should be stable. If it creeps up, you may have a memory leak or data loading bottleneck. Sudden increases often mean the model fell off GPU onto CPU for some operation.

**Memory usage:** Should be stable after the first few steps. Increasing memory = memory leak (usually from accumulating computation graphs).

**Gradient norm:** The L2 norm of all gradients. Healthy range depends on model size, but:
- Suddenly increasing: approaching instability
- Going to zero: vanishing gradients (dead model)
- Highly variable: might need gradient clipping

### Periodically (every K steps)

**Weight statistics:** Mean, std, min, max of each parameter group. If weights grow unbounded or collapse to zero, something is wrong.

**Activation statistics:** Same thing, but for intermediate activations. Dead ReLU neurons (always zero) indicate the model is losing capacity.

**Gradient statistics per layer:** Are all layers receiving gradients? Is one layer's gradient 1000x larger than another's? This indicates an imbalance that will cause some layers to train much faster than others.

## Quantization-Aware Training Specifics

QAT has its own failure modes:

**Quantization gap widens during training:** The difference between quantized and unquantized loss grows over time. This means the model is learning features that can't survive quantization. Solutions:
- Apply quantization earlier in training (not just at the end)
- Use STE (straight-through estimator) from the start
- Reduce the learning rate when quantization is active
- Use group quantization (smaller groups = less error)

**Ternary weight collapse:** All weights in a layer drift to the same ternary value (usually 0). The layer is effectively dead. Solutions:
- Initialize with larger values
- Reduce weight decay
- Use per-group scaling (forces each group to have meaningful range)
- Check if the scaling factor is being learned or is fixed

**Mixed-precision instability:** When some layers are quantized and others aren't, the gradient scales can be wildly different. Solutions:
- Layer-specific learning rates
- Gradient scaling to normalize across layers
- More gradual quantization (start with low bit-width in later layers, add more layers over time)

## When to Adjust Hyperparameters

### Learning Rate
**Increase if:** Loss is decreasing very slowly and gradient norms are tiny. The model can handle more.
**Decrease if:** Loss is noisy, spiky, or diverging. Also decrease if gradient norms are very large.
**Standard approach:** Use a schedule (warmup + cosine decay) and don't touch it. If the schedule isn't working, redesign it rather than manually adjusting mid-run.

### Batch Size
**Increase if:** Training is too noisy, you have memory headroom, and you want smoother gradients.
**Decrease if:** You're overfitting or need more gradient noise for exploration.
**Note:** Changing batch size mid-run changes the effective learning rate. If you double batch size, consider halving LR.

### Weight Decay
**Increase if:** Overfitting (val loss diverges from train loss) or weights are growing unbounded.
**Decrease if:** Model isn't fitting the training data (underfitting) or weights are collapsing to zero.

### Gradient Clipping
**Add/tighten if:** Gradient norms spike or you see NaN loss.
**Loosen if:** Gradient norms are consistently well below the clip threshold (the clipping isn't doing anything, but also isn't hurting).

## When to Kill a Run

Kill it if:
- Loss hasn't decreased at all after 10% of total training steps (and you've verified the code is correct)
- Loss went to NaN and doesn't recover after a restart with lower LR
- Validation loss has been increasing for 20%+ of training with no sign of stopping
- You realize there's a bug in the data pipeline or model (fix the bug, start over)
- You've already beaten this configuration with a different one (stop wasting compute)

Don't kill it if:
- Loss is decreasing slowly but steadily (patience)
- You see the S-curve flat period (ternary models do this)
- There was one spike but it recovered
- It's your first run with a new architecture (let it finish to get a complete picture)

## Interpreting Training Logs

When someone pastes training logs, look for:

1. **Loss trajectory:** Is it going down? How fast? Any spikes?
2. **Step time:** Is it consistent? Getting slower?
3. **Memory:** Stable or growing?
4. **Gradient norms:** If logged, are they healthy?
5. **Learning rate:** Is the schedule correct?
6. **Validation vs training gap:** Growing or stable?

Then give a diagnosis: "Your training looks healthy, loss is decreasing at a reasonable rate, no red flags. At this trajectory, you'll reach approximately X loss by step Y" or "Your loss spiked at step 500 and hasn't recovered. This is likely [cause]. Try [fix]."

## Quick Reference: Training Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Loss NaN | LR too high, numerical instability | Lower LR 10x, add grad clip, check for log(0) |
| Loss flat from start | Model too small, LR too low, data bug | Check data, increase LR, verify forward pass |
| Loss spikes regularly | LR too high, bad batches | Lower LR, check data quality |
| Val loss diverges | Overfitting | More regularization, less model capacity |
| Training very slow | Data loading bottleneck, no compile | Profile, add workers, use torch.compile |
| OOM at step N | Memory leak, activation caching | Check for detached tensors, use gradient checkpointing |
| Gradients all zero | Dead model, detached computation | Check requires_grad, verify backward pass |
| Loss decreases then plateaus early | LR schedule wrong, model capacity hit | Check schedule, try larger model |
| Quantized model much worse | QAT not working, precision too low | Start QAT earlier, use group quantization, check scaling |

## Example Diagnosis

```
step:100/5000 train_loss:4.2 step_avg:850ms
step:200/5000 train_loss:3.8 step_avg:852ms
step:300/5000 train_loss:3.5 step_avg:851ms
step:400/5000 train_loss:3.3 step_avg:855ms
step:500/5000 train_loss:3.2 step_avg:1250ms  # <-- step time jumped
step:600/5000 train_loss:3.1 step_avg:1255ms
```

Diagnosis: Loss trajectory is healthy (decreasing smoothly). But step time jumped from ~852ms to ~1250ms between step 400 and 500. Something changed at step 400-500 that made training 47% slower. Common causes: torch.compile kicking in (this would be a one-time increase then faster after), learning rate schedule change triggering different code paths, or some scheduled operation starting (like periodic full evaluation). Check what happens at step 400-500 in the training config.
