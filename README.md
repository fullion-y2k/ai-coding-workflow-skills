# AI Coding Workflow Skills

Cost-aware and rework-aware Codex Skills for AI coding workflows.

AI coding can waste tokens through duplicated investigation, unclear objectives, premature implementation, and rework. This project reduces unnecessary token usage and rework by controlling workflow, not by blindly using cheaper models. It does not guarantee a fixed percentage of token or cost reduction.

## What This Provides

- Two reusable Codex Skills: new project delivery and existing project change.
- Generic workflow roles: orchestrator, explorer, worker, reviewer, and critical reviewer.
- An OpenAI Codex profile with bounded custom agent examples.
- Fast Track / Standard / Heavy route selection.
- Install scripts for Skills and Custom Agents.
- A dependency-free validation script and GitHub Actions workflow.

## Who This Is For

Use this when you want AI coding work to be scoped, verified, and reviewed according to risk. It is especially useful for teams that want lighter workflows for small changes and stronger gates for risky work.

This is not for fully autonomous production changes, secret handling, compliance guarantees, or replacing human engineering review.

## How It Works

The orchestrator owns objective, route, scope, acceptance criteria, and final verification. It may use compact handoff packets for independent investigation or bounded implementation. For very small tasks, it avoids subagents. For risky tasks, it escalates to stronger review.

## New Project vs Existing Project

- `$ai-new-project-delivery`: new projects, new features, prototypes, and greenfield delivery.
- `$ai-existing-project-change`: bug fixes, behavior changes, regressions, refactors with known scope, and existing code changes.

Existing project changes emphasize cause analysis before implementation unless Fast Track conditions are met.

You should not need to write a long prompt to make the workflow finish. A request such as:

```text
$ai-existing-project-change Follow this specification and implement it.
```

should proceed through route decision, implementation, related checks, verification, and final reporting unless a real blocker exists.

## Routes

| Route | When to use | Agents | Artifacts | Review |
| ----- | ----------- | ------ | --------- | ------ |
| Fast Track | Clear, low-risk, easy to verify | Usually none, at most one | Usually none | Orchestrator checks diff/tests |
| Standard | Normal multi-step work | Optional explorer, one worker | STATE, WORK-PACKAGE, VERIFICATION | Independent review only when risk appears |
| Heavy | DB/API/auth/security/business/external integration risk or unclear impact | Up to two explorers, one worker | Requirements, design, plan, verification, final review | Critical review and go/no-go |

Fast Track may be implemented directly by the orchestrator. Standard and Heavy delegate the main implementation to `worker-mini` when subagent tools are available. Heavy also uses at least one independent explorer and critical review when available. If subagents are unavailable, the orchestrator must say so and continue in single-agent mode only when safe.

## Roles

| Role | Generic | OpenAI Codex profile |
| ---- | ------- | -------------------- |
| Orchestrator | Strong model owns route and decisions | Use `gpt-5.5` or `gpt-5.4`, medium reasoning |
| Explorer | Read-only targeted investigation | `explorer-mini.toml`, `gpt-5.4-mini` |
| Worker | Bounded implementation | `worker-mini.toml`, `gpt-5.4-mini` for small work |
| Reviewer | Diff-focused review | `reviewer.toml`, `gpt-5.4` |
| Critical reviewer | Heavy route final review | `critical-reviewer.toml`, `gpt-5.5` |

## Why Not Always Use Mini Models

Mini models can be effective for targeted investigation and small bounded edits, but they are not good default orchestrators for multi-step work. The workflow separates decisions from execution so a stronger orchestrator keeps scope, risk, and acceptance criteria stable.

## Installation

Skills are distributed in this repository under `skills/`. The install scripts copy them to `~/.agents/skills/`. Custom Agents are distributed under `agents/openai-codex/` and copied to `~/.codex/agents/`.

```bash
./install.sh
./install.sh --dry-run
./install.sh --with-worker-codex
```

```powershell
.\install.ps1
.\install.ps1 -DryRun
.\install.ps1 -WithWorkerCodex
```

The optional `worker-codex.toml.example` is installed only when explicitly requested and only if `gpt-5.3-codex` is available in your Codex environment. The scripts do not write secrets, tokens, `.env` files, or `config.toml`.

## Usage Examples

```text
$ai-new-project-delivery Build a small notes app with import/export and tests.
$ai-existing-project-change Fix the save failure on the settings page.
```

## Browser Verification

For web apps, the Skills require browser tooling verification when available. If browser tooling is unavailable, the agent must write manual verification steps and mark browser verification as blocked or manual.

## Security Notes

Review install scripts before running them. Explorers are read-only by design, workers use workspace-write, and reviewers do not implement. This repository is not a security audit or supply-chain guarantee.

## Limitations

Model availability differs by environment. Subagents add overhead and are not always cheaper. This is a workflow guide and profile set, not a strict workflow engine. Human review is still required for important changes.

## Repository Structure

```text
skills/      Codex Skill sources distributed by this repo
agents/      Custom Agent profiles
profiles/    Generic and OpenAI Codex model guidance
docs/        Concepts, route rules, security, examples, limitations
examples/    Scenario examples
```

## Contributing

See `CONTRIBUTING.md`. Keep Skills short, update `validate.py` when adding required files, and keep generic docs role-based rather than vendor-locked.

## License

MIT
