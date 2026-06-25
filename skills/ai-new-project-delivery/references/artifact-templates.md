# Artifact Templates

## STATE.md

```markdown
# State

## Objective

## Route

## Worktree Lock

Confirmed working folder:
Expected git top-level:
Expected branch/worktree name:
Allowed read root:
Allowed edit root:
Forbidden sibling worktrees:
Lock verification commands:
Worktree verified:

## Confirmed Requirements

## Assumptions

## Scope

## Disallowed Changes

## Current Phase

## Decisions

## Blockers

## Next Action

## Models/Agents Used

## Rework Count
```

## WORK-PACKAGE.md

```markdown
# Work Package

## Objective

## Acceptance Criteria

## In Scope

## Out of Scope

## Relevant Files and Symbols

## Worktree Lock

Confirmed working folder:
Expected git top-level:
Allowed read root:
Allowed edit root:
Worktree verified:

## Evidence Table

| Claim | Type: Observed / Derived / Unknown | Evidence | How to confirm |
| ----- | ---------------------------------- | -------- | -------------- |

## Atomic Explorer Ticket

Worktree Lock:
Evidence question:
Why this is delegated:
Allowed search roots:
Allowed search terms:
Allowed files:
Do not read:
Do not do:
Evidence needed:
Output format:
Stop and return if:
Output limit:

## Explorer Ticket Quality Gate

- ticket asks exactly one evidence question
- search root is bounded and inside Worktree Lock
- search terms are listed and limited to 5
- allowed files are listed and limited to 5, or one bounded directory is used
- ticket does not ask for product decisions, design judgment, broad diagnosis, or implementation decisions
- output requires Observed facts only
- output limit is explicit
- Worktree Lock is included

## Assigned Action

## Required Verification

## Blocker Return Format

Use `BLOCKER: worktree mismatch` when the Worktree Lock does not match.
```

## EXPLORER-OUTPUT.md

```markdown
# Explorer Output

## Worktree Lock used

## Worktree verified

## Observed facts

## Unknowns

## Files read

## Important candidates not read

## Commands run

## Result

## Blockers

## Remaining risk
```

## VERIFICATION.md

```markdown
# Verification

## Build

## Tests

## Lint/Format

## Browser Verification

## Manual Verification Fallback

## Worktree verified

## Acceptance Criteria Check

## Remaining Risk
```

## REQUIREMENTS.md

```markdown
# Requirements

## Goal

## Users and Main Flows

## Functional Requirements

## Nonfunctional Requirements

## Human Decisions

## Out of Scope
```

## DESIGN.md

```markdown
# Design

## Architecture

## Data and Interfaces

## UI/UX

## Risks

## Alternatives Considered
```

## IMPLEMENTATION-PLAN.md

```markdown
# Implementation Plan

## Steps

## Files Expected to Change

## Verification Per Step

## Rollback Notes
```

## FINAL-REVIEW.md

```markdown
# Final Review

## Requirements Match

## Diff Review

## Verification Evidence

## Worktree verified

## Evidence discipline

## Observed evidence

## Derived findings

## Unknowns

## Cause not confirmed: yes/no

## Go/No-Go

## Remaining Risk
```
