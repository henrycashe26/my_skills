---
name: ml-training-monitor
description: |
  Diagnose, monitor, and debug ML model training runs. Use this skill when the user wants to: understand why a model isn't learning, diagnose training instability (NaN loss, spikes, divergence), interpret loss curves and training metrics, decide whether to adjust hyperparameters mid-run, figure out if a run is worth continuing or should be killed, debug quantization-aware training issues, or understand gradient behavior. Trigger when the user mentions: loss curves, training logs, gradient norms, learning rate schedules, NaN loss, training divergence, "model isn't learning", "loss is stuck", "should I kill this run", validation loss, overfitting/underfitting, warmup, cooldown, weight decay tuning, or any question about how training is going. Also use when someone pastes training logs and wants interpretation.
---

# ML Training Monitor: Diagnostics and Debugging

Training ML models is mostly watching numbers and making judgment calls about whether those numbers look right. This skill is about developing that judgment.

## Diagnosis workflow

1. **Observe** — read the loss curve and metrics. What's the shape? Decreasing, flat, spiky, NaN, diverging? See [references/loss-curves.md](references/loss-curves.md) and [references/log-interpretation.md](references/log-interpretation.md).
2. **Hypothesize** — pick the most likely cause from the symptom table below. Don't pile on fixes; isolate one variable.
3. **Instrument** — if you don't have enough signal, add it. Log gradient norms, weight statistics, activation statistics, validation loss, step time, memory. See [references/gradient-norms.md](references/gradient-norms.md).
4. **Decide** — adjust a hyperparameter, restart with a fix, or kill the run. See [references/divergence.md](references/divergence.md) for kill criteria.

Then give the user a concrete diagnosis with cause and fix, not a list of possibilities. Two example diagnosis shapes:

- "Your training looks healthy, loss is decreasing at a reasonable rate, no red flags. At this trajectory, you'll reach approximately X loss by step Y."
- "Your loss spiked at step 500 and hasn't recovered. This is likely [cause]. Try [fix]."

## Symptom → Cause → Fix

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Loss NaN | LR too high, numerical instability | Lower LR 10x, add grad clip, check for log(0) |
| Loss flat from start | Model too small, LR too low, data bug | Check data, increase LR, verify forward pass |
| Loss spikes regularly | LR too high, bad batches | Lower LR, check data quality |
| Val loss diverges | Overfitting | More regularization, less model capacity |
| Training very slow | Data loading bottleneck, no compile | Profile, add workers, use `torch.compile` |
| OOM at step N | Memory leak, activation caching | Check for detached tensors, use gradient checkpointing |
| Gradients all zero | Dead model, detached computation | Check `requires_grad`, verify backward pass |
| Loss decreases then plateaus early | LR schedule wrong, model capacity hit | Check schedule, try larger model |
| Quantized model much worse | QAT not working, precision too low | Start QAT earlier, use group quantization, check scaling |

## Key heuristics

- A flat loss for less than 2x the flat period in an S-curve architecture (ternary, very deep): don't kill yet.
- Small loss spikes (2-3x running average) that recover: usually fine.
- Validation loss increasing for 20%+ of training: kill.
- Loss hasn't decreased at all after 10% of training steps (code verified): kill.
- Doubling batch size: halve LR.
- Step time creeping up: memory leak or data loading bottleneck.
- Memory growing: accumulating computation graphs.
- Check validation loss every 100-500 steps.
- LR schedule: warmup + cosine decay; don't manually touch mid-run, redesign instead.

## Metrics to log

During training (every N steps): training loss, validation loss, learning rate, step time, memory usage, gradient norm.

Periodically (every K steps): weight statistics per parameter group, activation statistics, gradient statistics per layer.

## Anti-patterns

- Manually tweaking LR mid-run instead of redesigning the schedule.
- Piling on regularization, dropout, weight decay, and smaller model all at once. Change one thing.
- Killing a run during an S-curve flat period.
- Continuing a NaN run hoping it recovers without changing anything.
- Diagnosing from training loss alone. Always look at validation loss, gradient norms, step time, memory.

## Topics

Detailed references live in `references/`:

- [loss-curves.md](references/loss-curves.md) — healthy shapes, S-curves, spikes, plateaus, oscillation.
- [nan-loss.md](references/nan-loss.md) — causes and debug steps for NaN.
- [divergence.md](references/divergence.md) — when to kill a run, when to keep it alive.
- [gradient-norms.md](references/gradient-norms.md) — gradient norm interpretation, weight and activation statistics, gradient clipping.
- [learning-rate.md](references/learning-rate.md) — LR, batch size, weight decay tuning rules.
- [overfitting.md](references/overfitting.md) — validation loss divergence, regularization, underfitting.
- [qat.md](references/qat.md) — quantization-aware training failure modes (quantization gap, ternary collapse, mixed-precision).
- [step-time-memory.md](references/step-time-memory.md) — step time and memory diagnostics with example.
- [log-interpretation.md](references/log-interpretation.md) — what to look for when reading pasted training logs; metrics cadence.

## Checklist

- [ ] Identified the dominant symptom (NaN, flat, spike, divergence, slow, OOM).
- [ ] Checked validation loss, not just training loss.
- [ ] Verified the LR schedule is actually doing what it claims.
- [ ] Checked gradient norms (or recommended logging them).
- [ ] Gave one concrete diagnosis and one concrete fix, not a menu.
- [ ] Decided: adjust, restart, or kill.
