# Contributing

Contributions are welcome when they keep the workflow practical, concise, and reusable.

## Route Rules

When proposing route rule changes, include:

- The scenario that failed or wasted work.
- The proposed Fast Track / Standard / Heavy rule.
- Expected impact on investigation, implementation, and review.
- Any examples that should be added or updated.

## Model Profiles

Keep generic docs role-based. Add vendor-specific model names only in profile files or agent examples. Do not add unvalidated model identifiers to OpenAI Codex agents.

## Skills

Keep `SKILL.md` files short. Put templates, checklists, and long examples in `references/`. Avoid duplicating requirements across files.

## Validation

Update `validate.py` when adding required files, agent schemas, or model constraints. Run:

```bash
python validate.py
```
