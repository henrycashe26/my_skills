# Code Structure

Organize your ML code for fast iteration:

```
project/
├── config.py          # All hyperparameters in one place
├── model.py           # Model architecture
├── data.py            # Data loading and preprocessing
├── train.py           # Training loop
├── eval.py            # Evaluation
├── utils.py           # Logging, checkpointing, misc
├── experiments/       # One script per experiment variant
│   ├── baseline.sh
│   ├── ternary_v1.sh
│   └── ternary_v2.sh
└── logs/              # Training logs, organized by run
    ├── baseline_seed42/
    └── ternary_v1_seed42/
```

**Config should be a single source of truth.** Don't scatter hyperparameters across files. One config object, passed everywhere.

**Make runs reproducible.** Set seeds, log the exact config, save the git hash. You should be able to recreate any previous run exactly.
