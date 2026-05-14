# Overfitting and Validation Loss

Validation loss diverges from training loss = overfitting. Training loss keeps improving but validation loss gets worse.

## Solutions

- More data
- More regularization (dropout, weight decay)
- Smaller model
- Earlier stopping
- Data augmentation

## Monitoring

Check validation loss every 100-500 steps. Watch the gap between training and validation loss:

- Stable small gap: healthy
- Growing gap: overfitting starting
- Validation loss increasing for 20%+ of training: consider killing the run (see [divergence.md](divergence.md))

## Underfitting

If the model isn't fitting the training data either, that's underfitting, not overfitting. Decrease weight decay, increase model capacity, or train longer. See [learning-rate.md](learning-rate.md).

## Quick reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Val loss diverges | Overfitting | More regularization, less model capacity |
