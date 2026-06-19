# Route Decision

Use this format at the start of each Skill run:

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

Use for clear, low-risk, easy-to-verify work with no DB schema, public API, auth, permission, security, business rule, data migration, or external integration contract impact. Existing changes should have a known or obvious cause. New project work should be a small feature or one main flow using a known stack/template.

## Standard

Use for normal multi-step work. Use a compact work package, add an explorer only when needed, use one implementation worker, and run related tests.

## Heavy

Use for DB/API/auth/security/external integration/business rule impact, broad or unclear impact, production or data-loss risk, or unknown high-risk cause. Heavy requires human confirmation before implementation, allows up to two independent investigation agents, and uses critical review.

## Escalation Triggers

- DB/API/auth/security/permission change appears unexpectedly.
- Existing specification change becomes necessary.
- Cause hypothesis is disproved.
- Scope expands significantly.
- Second implementation/test failure.
- Acceptance criteria conflict.
- Security or data-loss risk appears.
- Human choice is required among multiple valid approaches.

## Examples

- Button label copy change: Fast Track.
- Unknown save failure in existing project: Standard or Heavy depending on risk.
- New authenticated business app: Heavy.
- Null check in an existing screen with obvious cause: Fast Track.
- Public API plus DB schema change: Heavy.
