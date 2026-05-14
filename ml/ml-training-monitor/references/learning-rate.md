# Learning Rate, Batch Size, and Weight Decay

## Learning Rate

**Increase if:** Loss is decreasing very slowly and gradient norms are tiny. The model can handle more.

**Decrease if:** Loss is noisy, spiky, or diverging. Also decrease if gradient norms are very large.

**Standard approach:** Use a schedule (warmup + cosine decay) and don't touch it. If the schedule isn't working, redesign it rather than manually adjusting mid-run.

Verify the schedule is doing what you think. Plot it.

## Batch Size

**Increase if:** Training is too noisy, you have memory headroom, and you want smoother gradients.

**Decrease if:** You're overfitting or need more gradient noise for exploration.

**Note:** Changing batch size mid-run changes the effective learning rate. If you double batch size, consider halving LR.

## Weight Decay

**Increase if:** Overfitting (val loss diverges from train loss) or weights are growing unbounded.

**Decrease if:** Model isn't fitting the training data (underfitting) or weights are collapsing to zero.

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Loss spikes regularly | LR too high, bad batches | Lower LR, check data quality |
| Loss flat from start | Model too small, LR too low, data bug | Check data, increase LR, verify forward pass |
| Loss decreases then plateaus early | LR schedule wrong, model capacity hit | Check schedule, try larger model |
