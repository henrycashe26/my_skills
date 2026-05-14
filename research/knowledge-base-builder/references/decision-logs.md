# Decision Logs

Decision logs are the highest-value pattern. They capture WHY choices were made, which is the thing most likely to be forgotten and most expensive to lose.

## Template

```yaml
---
title: "Choosing X over Y"
date: 2026-03-26
context: "What problem were we solving?"
decision: "What we chose"
status: active               # active | superseded | revisiting
superseded_by: ""            # link to newer decision if relevant
---

## Context
[What situation prompted this decision?]

## Decision
[What did we decide?]

## Alternatives Considered
[What else was on the table? Why not those?]

## Rationale
[Why this choice? What evidence or reasoning?]

## Risks
[What could go wrong?]

## Revisit If
[Under what conditions should we reconsider?]
```

Store these in `decision_logs/` with the filename pattern `[YYYY-MM-DD]-[slug].md`. Create one whenever a choice was made that future-you (or a teammate) might second-guess.
