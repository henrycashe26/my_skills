# Common Implementation Bugs

## Silent Correctness Bugs (the worst kind)

- Broadcasting errors: shapes align by accident but semantics are wrong
- Detached tensors: computation graph breaks but no error is raised
- Wrong dimension in softmax/layernorm: runs fine, trains poorly
- Stale optimizer: model parameters changed but optimizer wasn't updated
- Evaluation mode: forgot `model.eval()` or `torch.no_grad()` during validation

## Performance Bugs

- Unnecessary CPU-GPU synchronization (`.item()` in the training loop)
- Data loading bottleneck (not enough workers, no prefetching)
- Recomputing things that could be cached
- Not using mixed precision when you could be

## Debugging Strategy

When something doesn't work:

1. Check shapes at every layer boundary
2. Check for NaN/Inf in activations and gradients
3. Verify the loss on a single batch matches hand computation
4. Compare your implementation's output to a reference implementation on the same input
5. Simplify until it works, then add complexity back
