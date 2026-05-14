# Experiment Design for Limited Compute

When GPU time is expensive, be strategic.

**Proxy metrics.** Train for 10% of the total steps and use that loss as a proxy for the final loss. This isn't perfect (some techniques help more late in training), but it's usually directionally correct and 10x cheaper.

**Binary search hyperparameters.** Don't grid search. Pick two extreme values, test both, then test the midpoint. Repeat. Gets you within 90% of optimal in log(n) runs instead of n.

**Kill early.** If a run is clearly worse than the baseline after 20% of training, kill it and try something else. Don't hope it'll catch up.

**Prioritize by expected impact.** If you have 5 ideas and compute for 3 experiments, rank them by (expected improvement) × (probability of working) and run the top 3.
