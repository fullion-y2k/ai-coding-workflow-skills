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

## Default Completion Contract

When the user asks to implement, fix, change, proceed, follow a specification, or complete a repair, continue through implementation, related tests, verification, and final report unless a Stop Condition applies.

Do not stop after route decision, planning, investigation, or cause analysis when implementation was requested. Route Decision is an execution checkpoint, not the final answer.

## Delegated Implementation Contract

- Fast Track may be implemented directly by the orchestrator.
- The Skill itself is the delegation instruction; the user does not need to explicitly request subagents.
- For Standard and Heavy, check subagent availability, then delegate main implementation to `worker-mini` when available; use optional `worker-codex` only when installed and explicitly selected.
- Orchestrator owns route, scope, cause analysis, handoff, review, verification, and final report. Worker owns bounded code edits and related checks.
- Route Decision `Agent plan` must match execution. If the plan changes, update it before implementation and explain the change in the final report.
- No-worker execution is allowed only when subagent tools are unavailable, the task is reclassified as Fast Track, the worker returns a blocker, or orchestrator-only context cannot be safely summarized.
- Preference, convenience, missing explicit delegation wording, small-looking scope, or "safer to do directly" are not valid no-worker reasons.
- For Heavy, if explorer, worker, or critical reviewer is skipped because subagent tools are unavailable, state `Subagent unavailable: <specific reason>` before implementation and mark final review incomplete with the missing agents.

## Delegation Barrier

For Standard and Heavy, the orchestrator must stay token-light: before delegation, read only enough to route and create the handoff packet, usually no more than 3 targeted files or commands.
Do not edit files, run broad investigation, or perform main implementation before the worker returns. After worker output, review the diff, run verification, and produce the final report.

## Stop Conditions

Stop only when one of these is true:

- A required human product or business decision is missing.
- Acceptance criteria conflict.
- Credentials, login, paid external access, or private systems are required.
- Safety, security, permission, data-loss, or production risk requires approval.
- Required tooling is unavailable and no manual fallback is possible.
- The second implementation or verification attempt fails.
- The requested change requires out-of-scope work.

Do not stop for facts that can be read from the repository. If safe assumptions allow progress, record them and continue.

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

After Route Decision:

- Fast Track: implement directly.
- Standard: complete cause analysis, prepare a compact work package, then implement.
- Heavy: complete only required human gates, then proceed through investigation, implementation, verification, and critical review.

## Route Risk Floors

Classify as Heavy when the work affects DB schema, migrations, initializer data correction, allowed DB values, public API contracts, auth, permissions, security, external integrations, production data, or data-loss risk.

Classify as Standard only when none of those boundaries are affected. If a Standard task later touches one, escalate before implementation.

## Specification-Driven Work

When the user provides or references a specification:

- Treat it as the primary source of acceptance criteria.
- Extract only requirements needed for the current task.
- Do not ask the user to restate facts that can be read.
- If incomplete but safe assumptions allow progress, record assumptions and continue.
- Ask humans only when multiple valid product decisions remain.

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
- Delegate the main implementation to `worker-mini` when subagent tools are available.
- Use explorer only when cause is not obvious.
- Complete cause analysis before implementation.
- Worker runs related tests.
- Independent review only when risk appears.
- If no subagent is used, state why in the final report.

## Heavy

Use when DB/API/auth/security/external integration/business-rule impact, broad unclear impact, unknown high-risk cause, production/data-loss risk, or acceptance conflict exists.

- Require human confirmation before implementation.
- Use at least one independent explorer when subagent tools are available.
- Delegate the main implementation to `worker-mini`, or optional `worker-codex` only when installed and explicitly selected.
- Use critical review before final completion.
- If subagents are unavailable, state that clearly before implementation and continue in single-agent mode only when safe.
- Require go/no-go and risk notes.

## Cause Analysis Completion Rule

Cause analysis is complete when enough evidence exists to choose a minimal implementation path. After that, proceed to implementation unless a Stop Condition applies. Do not return only cause analysis when the user requested a fix.

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

## Final Report

Include route used, agents used or why no subagent was used, files changed, tests/checks run, verification result, acceptance criteria status, remaining risk, and blockers if any.
