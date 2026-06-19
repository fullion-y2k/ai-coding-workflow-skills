# Concepts

## Cost-Aware Workflow

Cost-aware means avoiding unnecessary token usage from duplicated investigation, unclear handoffs, over-broad scans, and repeated failed implementation attempts. It does not mean always choosing the smallest model.

## Rework-Aware Workflow

Rework usually comes from weak acceptance criteria, skipped cause analysis, hidden scope expansion, and missing verification. The Skills force route selection and explicit scope before execution.

## Orchestrator vs Worker

The orchestrator owns decisions, route, scope, acceptance criteria, and final response. Workers execute bounded tasks from compact handoff packets. Workers do not ask users directly.

## Why Route Selection Matters

Small tasks should not pay the overhead of multiple agents and documents. Risky tasks should not skip human gates, investigation, or review.

## Why Subagents Are Not Always Cheaper

Subagents add setup context, handoff overhead, review time, and coordination risk. Use them only when independent investigation or bounded implementation is likely to reduce duplicated work.

## Human Gates

Ask humans only for blockers: missing product decisions, conflicting acceptance criteria, or multiple valid approaches with meaningful tradeoffs. Keep questions to one round when possible.
