# Route Decision Examples

## Case A: Button Label Change

- Skill: `ai-existing-project-change`
- Route: Fast Track
- Agents: none
- Artifacts: none
- Review level: orchestrator check
- Reason: clear, low-risk, easy to verify

## Case B: Unknown Save Failure

- Skill: `ai-existing-project-change`
- Route: Standard, Heavy if data-loss or auth risk appears
- Agents: optional explorer, one worker
- Artifacts: STATE, WORK-PACKAGE, VERIFICATION
- Review level: risk-based reviewer
- Reason: cause unknown, existing behavior affected

## Case C: New Authenticated Business Web App

- Skill: `ai-new-project-delivery`
- Route: Heavy
- Agents: up to two explorers, one worker, critical reviewer
- Artifacts: requirements, design, implementation plan, verification, final review
- Review level: critical review
- Reason: auth, business rules, and broad product impact

## Case D: Null Check in Existing Screen

- Skill: `ai-existing-project-change`
- Route: Fast Track
- Agents: none or one bounded worker
- Artifacts: none
- Review level: orchestrator check
- Reason: obvious cause, small diff, focused regression test

## Case E: Public API and DB Schema Change

- Skill: `ai-existing-project-change`
- Route: Heavy
- Agents: investigation agents, one worker, critical reviewer
- Artifacts: requirements, design, implementation plan, verification, final review
- Review level: critical review and go/no-go
- Reason: public contract and data model impact
