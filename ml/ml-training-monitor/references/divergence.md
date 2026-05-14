# Divergence and When to Kill a Run

## Kill it if

- Loss hasn't decreased at all after 10% of total training steps (and you've verified the code is correct)
- Loss went to NaN and doesn't recover after a restart with lower LR
- Validation loss has been increasing for 20%+ of training with no sign of stopping
- You realize there's a bug in the data pipeline or model (fix the bug, start over)
- You've already beaten this configuration with a different one (stop wasting compute)

## Don't kill it if

- Loss is decreasing slowly but steadily (patience)
- You see the S-curve flat period (ternary models do this)
- There was one spike but it recovered
- It's your first run with a new architecture (let it finish to get a complete picture)

## Related

- NaN-specific debugging: [nan-loss.md](nan-loss.md)
- Loss curve shapes that look bad but aren't: [loss-curves.md](loss-curves.md)
