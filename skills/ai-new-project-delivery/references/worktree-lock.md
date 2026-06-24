# Worktree Lock

Use this protocol before investigation, route-specific work, repo search, file reads, edits, tests, builds, and subagent delegation.

## Orchestrator Gate

Before reading project files, running repo search, or starting subagents:

1. Show the current working folder and detected worktree/repo information to the user.
2. Ask the user to reply OK before continuing.
3. Do not inspect project files or delegate until OK is received.
4. After OK, create the Worktree Lock below and carry it through Route Decision, Work Package, Handoff Packet, Explorer Ticket, Implementation Handoff, Verification, and Final Report.

Use absolute paths. Do not pass relative-only paths to subagents.

```text
Worktree Lock
Confirmed working folder:
Expected git top-level:
Expected branch/worktree name:
Allowed read root:
Allowed edit root:
Forbidden sibling worktrees:
Lock verification commands:
Mismatch stop format:
BLOCKER: worktree mismatch
Expected:
Actual:
Action needed:
```

For read-only explorer or reviewer agents, set `Allowed edit root: none`.

## Verification Rules

Before every repo search, file read, edit, test, or build, verify:

- current working folder matches Confirmed working folder, or is inside the allowed root when the handoff explicitly permits it.
- detected git top-level matches Expected git top-level.
- every read target is inside Allowed read root.
- every edit target is inside Allowed edit root.
- no sibling worktree or similar repo name is used by guesswork.

If any value mismatches, stop:

```text
BLOCKER: worktree mismatch
Expected:
Actual:
Action needed:
```

Do not fix a mismatch by guessing a better directory. The orchestrator must create a corrected Worktree Lock and handoff.

## Subagent Rules

Subagents must not work if the handoff lacks Worktree Lock. They must verify the lock before repo search, file read, edit, test, or build.

Subagents must use only absolute paths from the Worktree Lock and handoff. They must not infer the repo from names, sibling folders, default cwd, or recent context.

Subagent output must include:

- Worktree Lock used
- Worktree verified
- Files read / files changed
- Commands/tests run
- Blockers

## Final Report

Final Report must include `Worktree verified` and note any `BLOCKER: worktree mismatch` returned by subagents.
