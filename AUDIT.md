# Skill Audit

Per-skill conformance check against [`STANDARDS.md`](STANDARDS.md). Generated 2026-05-14.

Delete this file once Phase 2 migrations are done.

## Legend

- **Lines**: SKILL.md line count. Soft target ~120, hard ceiling 200.
- **FM**: YAML frontmatter — `name` + `description` present and correct.
- **Trig**: Description includes a concrete "Use when ..." with real trigger phrases.
- **Style**: Imperative voice, workflow-first, not overly verbose.
- **Struct**: Topic files / `references/` / `scripts/` / `assets/` used appropriately when SKILL.md is long.
- **Action**: `keep` / `trim` / `split` / `restructure`.

## Summary table

| Skill | Lines | FM | Trig | Style | Struct | Action | Notes |
|---|---|---|---|---|---|---|---|
| `writing/humanizer` | 474 | ok | ok | ok | **bad** | **split** | Massive reference content inline. Move detection patterns to `patterns.md` or `references/`. |
| `coding/karpathy-guidelines` | 112 | ok | ok | ok | ok | keep | Borderline length, content is cohesive. |
| `coding/frontend-ts-standards` | 351 | ok | ok | ok | ok | trim | Already has `references/`. Move more content out of SKILL.md. |
| `coding/frontend-performance` | 406 | ok | ok | ok | ok | trim | Same. |
| `coding/frontend-ui-quality` | 336 | ok | ok | ok | ok | trim | Same. |
| `coding/frontend-ai-audit` | 813 | ok | ok | ok | ok | **split** | Biggest violator. Already has `references/`; aggressively move detection rules out of SKILL.md. |
| `coding/frontend-pipeline` | 274 | ok | ok | ok | **bad** | split | No `references/` dir. Orchestrator logic could stay short, subagent prompts to `assets/`. |
| `coding/new-coding-project` | 116 | ok | ok | ok | ok | keep | Already well-structured with `assets/` + `references/`. |
| `coding/diagnose` | 117 | ok | ok | ok | ok | keep | mattpocock, conforming. |
| `coding/grill-with-docs` | 88 | ok | ok | ok | ok | keep | mattpocock. |
| `coding/improve-codebase-architecture` | 71 | ok | ok | ok | ok | keep | mattpocock, multiple topic files. |
| `coding/prototype` | 30 | ok | ok | ok | ok | keep | mattpocock. |
| `coding/setup-matt-pocock-skills` | 121 | ok | ok | ok | ok | keep | mattpocock. Has `disable-model-invocation: true`. |
| `coding/tdd` | 109 | ok | ok | ok | ok | keep | mattpocock, has `tests.md`, `mocking.md`, etc. |
| `coding/to-issues` | 83 | ok | ok | ok | ok | keep | mattpocock. |
| `coding/to-prd` | 76 | ok | ok | ok | ok | keep | mattpocock. |
| `coding/triage` | 103 | ok | ok | ok | ok | keep | mattpocock. |
| `coding/zoom-out` | 7 | ok | ok | ok | ok | keep | mattpocock. `disable-model-invocation: true`. |
| `ml/ml-research` | 121 | ok | ok | ok | ok | keep | Borderline. |
| `ml/ml-implementation` | 200 | ok | ok | ok | **bad** | split | At hard ceiling. Move sub-workflows to topic files. |
| `ml/ml-training-monitor` | 183 | ok | ok | ok | **bad** | split | Over soft target. Symptom→diagnosis tables could move to `diagnoses.md`. |
| `research/knowledge-base-builder` | 202 | ok | ok | ok | **bad** | split | At hard ceiling. Frontmatter/structure conventions could move to `kb-format.md`. |
| `research/ground-truth-search` | 58 | ok | ok | ok | ok | keep | |
| `productivity/caveman` | 49 | ok | ok | ok | ok | keep | mattpocock. |
| `productivity/grill-me` | 10 | ok | ok | ok | ok | keep | mattpocock. |
| `productivity/handoff` | 13 | ok | ok | ok | ok | keep | mattpocock. Has `argument-hint`. |
| `productivity/write-a-skill` | 145 | ok | ok | ok | ok | keep | Just rewrote to be canonical reference. |
| `misc/git-guardrails-claude-code` | 95 | ok | ok | ok | ok | keep | mattpocock. Has `scripts/`. |
| `misc/migrate-to-shoehorn` | 118 | ok | ok | ok | ok | keep | mattpocock. |
| `misc/scaffold-exercises` | 106 | ok | ok | ok | ok | keep | mattpocock. |
| `misc/setup-pre-commit` | 91 | ok | ok | ok | ok | keep | mattpocock. |

## Required migrations (sorted by effort)

### Low effort

1. **`coding/frontend-pipeline`** (274 lines, no `references/`)
   - Create `references/subagent-prompts.md` or `assets/agents/` and move prompt blocks out.
   - Estimated: 20 min.

### Medium effort

2. **`coding/frontend-ts-standards`** (351 lines)
3. **`coding/frontend-ui-quality`** (336 lines)
4. **`coding/frontend-performance`** (406 lines)
   - Each already has `references/`. Move detailed rules/patterns from SKILL.md into the existing references dir. Keep SKILL.md as workflow + index.
   - Estimated: 30 min each.

5. **`ml/ml-implementation`** (200 lines)
6. **`ml/ml-training-monitor`** (183 lines)
7. **`research/knowledge-base-builder`** (202 lines)
   - Create topic files (`diagnoses.md`, `kb-format.md`, etc.). Keep SKILL.md as workflow only.
   - Estimated: 30 min each.

### High effort

8. **`writing/humanizer`** (474 lines)
   - Move pattern catalog to `patterns.md` or `references/patterns/*.md`. SKILL.md keeps workflow + pattern index.
   - Estimated: 60 min. Care needed — the content is dense and interconnected.

9. **`coding/frontend-ai-audit`** (813 lines)
   - Biggest. Already has `references/`. Aggressively move detection rules per category (visual, code, copy, diagrams, forms) into `references/<category>.md`. SKILL.md becomes a workflow + category index.
   - Estimated: 90 min.

## Not migrating

All mattpocock-imported skills (engineering/productivity/misc) — they were the model for the standard. Conforming by construction.

Short personal skills (`grill-me`, `handoff`, `zoom-out`, `ground-truth-search`, `prototype`, `caveman`) — already under target.

Already well-structured (`new-coding-project`, `karpathy-guidelines`) — within ceiling, content is cohesive.

## Phase 2 plan

Recommended order: 1 → 2/3/4 → 5/6/7 → 8 → 9. Low-effort first to build momentum and validate the migration pattern on something simple before tackling humanizer/frontend-ai-audit.

Total estimated effort: ~6 hours of focused work.
