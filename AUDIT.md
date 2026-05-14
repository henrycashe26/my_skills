# Skill Audit

Per-skill conformance check against [`STANDARDS.md`](STANDARDS.md). Generated 2026-05-14, Phase 2 completed 2026-05-14.

All migrations are complete. This file can be deleted, but is kept for historical reference.

## Final state

| Skill | Lines | Status |
|---|---|---|
| `coding/diagnose` | 117 | conforming |
| `coding/frontend-ai-audit` | 89 | migrated (was 813, content moved to `references/`) |
| `coding/frontend-performance` | 90 | migrated (was 406) |
| `coding/frontend-pipeline` | 101 | migrated (was 274, agents moved to `assets/agents/`) |
| `coding/frontend-ts-standards` | 83 | migrated (was 351) |
| `coding/frontend-ui-quality` | 86 | migrated (was 336) |
| `coding/grill-with-docs` | 88 | conforming |
| `coding/improve-codebase-architecture` | 71 | conforming |
| `coding/karpathy-guidelines` | 112 | conforming |
| `coding/new-coding-project` | 116 | conforming |
| `coding/prototype` | 30 | conforming |
| `coding/setup-matt-pocock-skills` | 121 | conforming |
| `coding/tdd` | 109 | conforming |
| `coding/to-issues` | 83 | conforming |
| `coding/to-prd` | 76 | conforming |
| `coding/triage` | 103 | conforming |
| `coding/zoom-out` | 7 | conforming |
| `misc/git-guardrails-claude-code` | 95 | conforming |
| `misc/migrate-to-shoehorn` | 118 | conforming |
| `misc/scaffold-exercises` | 106 | conforming |
| `misc/setup-pre-commit` | 91 | conforming |
| `ml/ml-implementation` | 82 | migrated (was 200) |
| `ml/ml-research` | 121 | conforming |
| `ml/ml-training-monitor` | 84 | migrated (was 183) |
| `productivity/caveman` | 49 | conforming |
| `productivity/grill-me` | 10 | conforming |
| `productivity/handoff` | 13 | conforming |
| `productivity/write-a-skill` | 145 | conforming (canonical reference, slightly over target by design) |
| `research/ground-truth-search` | 58 | conforming |
| `research/knowledge-base-builder` | 89 | migrated (was 202) |
| `writing/humanizer` | 95 | migrated (was 474, content moved to `references/`) |

All SKILL.md files are now ≤ 145 lines. All migrated skills preserved their original content via `references/` topic files or `assets/` runtime artifacts (`frontend-pipeline`).

## Migration notes

- **humanizer** (474 → 95): pattern catalog split into 7 thematic files in `references/` (content patterns, language/grammar, style patterns, communication, filler/hedging, personality/soul, full example).
- **frontend-ai-audit** (813 → 89): detection categories split into 8 files (visual tells, diagram tells, form tells, code tells, copy tells, scoring, philosophy, plus the preserved exhaustive `visual-ai-tells.md`).
- **frontend-pipeline** (274 → 101): the 4 subagent prompts moved to `assets/agents/`, report format to `references/`.
- **frontend-ts-standards / performance / ui-quality**: split into topic-based `references/` files (toolchain, testing, project-structure, code-review for TS; measurement, react-rendering, virtualization, network, images, css-animation, bundle-optimization for perf; 13 topic files for UI quality).
- **ml-implementation / ml-training-monitor / knowledge-base-builder**: split into workflow-stage and topic-based `references/` files.
