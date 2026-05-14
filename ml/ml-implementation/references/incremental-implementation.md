# Implement Incrementally

Don't implement everything at once. The order matters.

## Step 1: Data Pipeline

Get the data flowing first. Verify shapes, dtypes, and values at every stage. Print a few samples and eyeball them. Common bugs:

- Off-by-one in sequence lengths
- Wrong tokenizer vocabulary size
- Padding/masking errors (these are silent killers)
- Data not shuffled, or shuffled wrong
- Normalization applied twice or not at all

## Step 2: Model Architecture (Forward Pass Only)

Build the model and verify the forward pass works:

```python
# Always do this before training
x = torch.randn(batch_size, seq_len, dim)
y = model(x)
print(f"Input: {x.shape}, Output: {y.shape}")
assert y.shape == expected_shape
```

For each new component, test it in isolation before plugging it into the full model. If you're implementing a custom attention layer, verify it produces the same output as a known-good implementation on the same input.

## Step 3: Loss and Backward Pass

Verify gradients flow properly:

```python
loss = criterion(model(x), targets)
loss.backward()
for name, param in model.named_parameters():
    if param.grad is None:
        print(f"WARNING: No gradient for {name}")
    elif param.grad.abs().max() == 0:
        print(f"WARNING: Zero gradient for {name}")
```

## Step 4: Overfit a Single Batch

Before training on the full dataset, overfit on one batch. The model should drive training loss to near-zero on a single repeated batch. If it can't, something is wrong with the model or training loop -- don't proceed until this works.

```python
batch = next(iter(dataloader))
for step in range(200):
    loss = train_step(model, batch)
    if step % 20 == 0:
        print(f"step {step}: loss {loss:.4f}")
# Loss should be near 0 by step 200
```

## Step 5: Short Training Run

Train on the full dataset for a small number of steps. Verify:

- Loss decreases smoothly (no spikes, no NaN)
- Validation loss also decreases (not just memorizing)
- Step time is reasonable (no unexpected slowdowns)
- Memory usage is stable (no leaks)
- Gradient norms are healthy (not exploding or vanishing)

## Step 6: Full Training Run

Only now do you run the full training. And even here, start with a shorter run (25% of total steps) before committing to the full thing.
