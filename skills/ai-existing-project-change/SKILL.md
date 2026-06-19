---
name: ai-existing-project-change
description: Existing project change workflow for Codex. Uses issue confirmation, targeted investigation, cause analysis, minimal implementation, and regression verification to reduce unnecessary token usage and rework. Use ai-new-project-delivery for new projects.
---

# AI Existing Project Change

Use this Skill for bug fixes, behavior changes, regressions, and existing code changes. Use `references/investigation-and-verification.md` for investigation rules. Use `references/artifact-templates.md` when artifacts are needed.

## Core Rules

- Orchestrator owns objective, scope, route, and acceptance criteria.
- Do not use a mini model as orchestrator for multi-step work.
- Separate decisions from execution.
- Ask humans only for blockers.
- Do not ask humans for facts that can be read from the repository.
- Subagents must not ask the user directly.
- Subagents return blockers to the orchestrator.
- Keep human questions to one round whenever possible.
- Ask at most 3 blocking questions at once.
- Include recommended options in human questions.
- Do not pass the full conversation to subagents.
- Pass a compact handoff packet only.
- Avoid duplicate investigation.
- Do not run multiple implementation agents in parallel.
- Allow parallelism only for independent investigation.
- Maximum implementation retry count is 1.
- If the second attempt fails, stop and replan.
- Do not expand scope silently.
- Do not mix unrelated refactoring into existing fixes.
- Do not implement before cause analysis unless Fast Track conditions are met.
- For web apps, verify with browser tooling if available; otherwise write manual verification steps and mark browser verification as blocked/manual.

## Route Decision

Start with:

```text
Route Decision

* Route:
* Reasons:
* Blocking questions:
* Assumptions:
* Allowed scope:
* Disallowed changes:
* Agent plan:
* Verification plan:
* Escalation triggers:
```

## Fast Track

Use when objective and acceptance criteria are clear, risk is low, verification is easy, cause is known or obvious, the change is usually 1-3 files, and no DB/API/auth/security/business-rule/data-migration/external-contract impact exists.

Execution:

- Prefer no subagent for very small changes.
- Use at most one subagent.
- Do not generate long documents.
- No independent reviewer by default.
- Orchestrator checks diff, tests, and acceptance criteria.

## Standard

Use for normal bug fixes and behavior changes.

- Create `docs/ai-work/<task-id>/STATE.md`, `WORK-PACKAGE.md`, and `VERIFICATION.md`.
- Use explorer only when cause is not obvious.
- Complete cause analysis before implementation.
- Use one implementation worker.
- Worker runs related tests.
- Independent review only when risk appears.

## Heavy

Use when DB/API/auth/security/external integration/business-rule impact, broad unclear impact, unknown high-risk cause, production/data-loss risk, or acceptance conflict exists.

- Require human confirmation before implementation.
- Allow up to two independent investigation agents.
- Use critical review.
- Require go/no-go and risk notes.

## Escalation Triggers

- DB/API/auth/security/permission change appears unexpectedly.
- Existing specification change becomes necessary.
- Cause hypothesis is disproved.
- Scope expands significantly.
- Second implementation/test failure.
- Acceptance criteria conflict.
- Security or data loss risk appears.
- Human choice is required among multiple valid approaches.

## Handoff Packet

Subagent input must be compact:

- Objective
- Acceptance criteria
- In scope
- Out of scope
- Disallowed changes
- Relevant files and symbols
- Evidence or known cause
- Assigned action
- Required verification
- Blocker return format

Subagent output must be compact:

- Findings or changes
- Evidence
- Files touched
- Commands/tests run
- Result
- Blockers
- Remaining risk

Forbidden: full conversation dump, long code paste, duplicated requirements, verbose diary-style reports.

## Artifact Guidance

Use `docs/ai-work/<task-id>/`.

- Fast Track: usually no documents; add `STATE.md` only if work spans multiple turns.
- Standard: `STATE.md`, `WORK-PACKAGE.md`, `VERIFICATION.md`.
- Heavy: `STATE.md`, `REQUIREMENTS.md`, `DESIGN.md`, `IMPLEMENTATION-PLAN.md`, `VERIFICATION.md`, `FINAL-REVIEW.md`.

Do not write monetary calculations in artifacts.
