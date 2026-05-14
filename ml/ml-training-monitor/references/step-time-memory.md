# Step Time and Memory

## Step time (ms)

Should be stable. If it creeps up, you may have a memory leak or data loading bottleneck. Sudden increases often mean the model fell off GPU onto CPU for some operation.

## Memory usage

Should be stable after the first few steps. Increasing memory = memory leak (usually from accumulating computation graphs).

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Training very slow | Data loading bottleneck, no compile | Profile, add workers, use `torch.compile` |
| OOM at step N | Memory leak, activation caching | Check for detached tensors, use gradient checkpointing |

## Example diagnosis

```
step:100/5000 train_loss:4.2 step_avg:850ms
step:200/5000 train_loss:3.8 step_avg:852ms
step:300/5000 train_loss:3.5 step_avg:851ms
step:400/5000 train_loss:3.3 step_avg:855ms
step:500/5000 train_loss:3.2 step_avg:1250ms  # <-- step time jumped
step:600/5000 train_loss:3.1 step_avg:1255ms
```

Diagnosis: Loss trajectory is healthy (decreasing smoothly). But step time jumped from ~852ms to ~1250ms between step 400 and 500. Something changed at step 400-500 that made training 47% slower. Common causes: `torch.compile` kicking in (this would be a one-time increase then faster after), learning rate schedule change triggering different code paths, or some scheduled operation starting (like periodic full evaluation). Check what happens at step 400-500 in the training config.
