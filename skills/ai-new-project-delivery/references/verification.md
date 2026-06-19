# Verification

## Build

Run the project build command when available. If no build exists, state that clearly.

## Test

Run focused tests for the changed area first. Add broader tests when the route is Heavy or the implementation touches shared behavior.

## Lint/Format

Run repository-defined lint or format checks when available. Do not introduce new tooling unless it is part of the task.

## Browser Verification

For web apps, verify the main user flow with browser tooling when available. Capture the URL, actions, observed result, and any console/network issues relevant to the change.

## Manual Verification Fallback

If browser tooling is unavailable, write manual steps and mark browser verification as blocked/manual.

## Acceptance Criteria Check

Map each acceptance criterion to evidence: command output, test, browser observation, or manual step.

## Remaining Risk

List only concrete residual risks, such as unavailable external services, untested browsers, or blocked integration checks.
