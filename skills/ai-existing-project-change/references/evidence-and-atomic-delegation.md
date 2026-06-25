# Evidence and Atomic Delegation

## Evidence Discipline

Do not write inference as fact. Classify every claim:

- `Observed`: directly confirmed from code, config, schema, test, log, or command output.
- `Derived`: mechanically derived from listed Observed evidence.
- `Unknown`: not confirmed yet; include how to confirm.

Write `Cause not confirmed` when evidence is insufficient. Write a likely cause only when at least two Observed evidence items support it. Use words such as probably, seems, maybe, likely, should, or appears only inside explicit Derived or Unknown sections.

Fast Track may use a compact evidence summary. Standard requires an Evidence Table. Heavy requires Evidence Table, Unknowns, and risk boundaries.

Only the orchestrator creates Derived findings, final conclusion, and likely cause. Subagents return Observed facts only and may list Unknowns.

## Atomic Delegation

Standard and Heavy default to delegation. Before deep file reading, create at least one Atomic Explorer Ticket when any trigger applies:

- cause is unknown.
- multiple files or layers are involved.
- DB, query, schema, auth, API, or security behavior is involved.
- UI and service behavior both need mapping.
- user asks about current code behavior.
- investigation may exceed 3 primary files.

Fast Track may skip subagents only when the target file or symbol is already known, scope is one file or one symbol, no cross-layer behavior exists, cause is known, and no DB/auth/API/security boundary is involved.

Mini/lightweight subagents must not receive broad investigation, product decisions, design judgment, broad diagnosis, implementation decisions, final conclusions, or likely cause work. Give exactly one evidence question.

## Explorer Ticket Quality Gate

Split the ticket before delegation unless all items are true:

- ticket asks exactly one evidence question.
- search root is bounded and inside Worktree Lock.
- search terms are listed and limited to 5.
- allowed files are listed and limited to 5, or one bounded directory is used.
- ticket does not ask for product decisions, design judgment, broad diagnosis, or implementation decisions.
- output requires Observed facts only.
- output limit is explicit.
- Worktree Lock is included.

## Atomic Explorer Ticket Template

```text
Atomic Explorer Ticket
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
```

## Explorer Output Template

```text
Explorer Output
Worktree Lock used:
Worktree verified:
Observed facts:
Unknowns:
Files read:
Important candidates not read:
Commands run:
Result:
Blockers:
Remaining risk:
```

## Report Template

```text
Evidence discipline:
Observed evidence:
Derived findings:
Unknowns:
Cause not confirmed: yes/no
```
