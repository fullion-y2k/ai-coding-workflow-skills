# Investigation and Verification

## Targeted Investigation Rules

- Start with `rg` or the repository's fastest search tool.
- Search for exact symbols, error text, route names, selectors, and config keys.
- Read likely files before broad scans.
- Broad scan is forbidden unless targeted searches fail and the reason is recorded.
- Track read files and important unread candidates.

## Evidence vs Inference

Label direct evidence separately from inference. Do not present a guessed cause as confirmed.

## Cause Analysis

Cause analysis must identify:

- Observed behavior.
- Expected behavior.
- Reproduction or static evidence.
- Root cause.
- Alternatives ruled out.

Do not implement before cause analysis unless Fast Track conditions are met.

## Reproduction Check

When possible, reproduce the issue or identify a static proof that explains why reproduction is unavailable.

## Regression Check

Run focused tests around the changed behavior. Add broader checks when shared code, data flow, permissions, or public interfaces are affected.

## Minimal Diff Verification

Confirm the diff touches only intended files and avoids unrelated refactoring.

## Browser or Manual Verification

For web apps, verify with browser tooling when available. If unavailable, write manual steps and mark browser verification as blocked/manual.
