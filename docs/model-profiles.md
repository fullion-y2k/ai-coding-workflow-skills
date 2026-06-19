# Model Profiles

## Generic Roles

- Orchestrator: strong decision maker for objective, route, scope, acceptance, and final verification.
- Explorer: read-only targeted investigation.
- Worker: bounded implementation from a clear plan.
- Reviewer: diff-focused correctness and regression review.
- Critical reviewer: Heavy route go/no-go review.

## OpenAI Codex Profile

Allowed model identifiers:

- `gpt-5.5`
- `gpt-5.4`
- `gpt-5.4-mini`
- `gpt-5.3-codex`, only where available

All provided agents use `model_reasoning_effort = "medium"`.

Do not use `gpt-5.4-mini` as orchestrator for multi-step work. Use it for targeted read-only exploration and small bounded implementation.

## Optional gpt-5.3-codex

`worker-codex.toml.example` is provided as an optional medium implementation worker. Install it only if the model is available in your Codex environment.

## Adapting to Other Models or Tools

Map models by role capability, not name. Keep the generic workflow unchanged: strong orchestrator, read-only explorer, bounded worker, independent reviewer, and critical reviewer for Heavy work.
