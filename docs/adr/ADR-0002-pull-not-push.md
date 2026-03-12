# ADR-0002 — Policy distribution is pull-only

Date: 2026-03-11
Status: accepted

## Context

In a multi-repo PBAC system, policy changes authored in Governance-Framework must reach consumers (Policy-LSP, Agent-Evaluation). Two distribution models were considered:

- **Push model** — Governance-Framework opens PRs or pushes commits in consumer repositories when policies change.
- **Pull model** — Consumers run their own workflows on their own schedule to pull the latest policies from Governance-Framework.

The push model requires Governance-Framework to:
- Maintain knowledge of which repositories consume its policies.
- Hold write tokens for all consumer repositories.
- Coordinate release timing with every consumer.
- Be updated whenever a new consumer is added.

These requirements couple this repository to its consumers, violating the principle of separation of concerns and creating a maintenance burden that grows with each new consumer.

## Decision

Policy distribution is pull-only. Consumers are responsible for pulling from this repository on their own schedule via their own GitHub Actions workflows.

This repository:
- Never pushes to other repositories.
- Never opens pull requests in other repositories.
- Maintains no knowledge of which repositories consume its policies.
- Exposes no workflow_dispatch target intended to be called from other repositories.

Consumers (e.g. Policy-LSP) implement a sync workflow in their own repository that checks out or fetches `policies/` from this repository's `main` branch on a schedule or manual dispatch, and opens a PR for human review before applying the update.

See `BACKLOG.md` W-0005 for the reminder that the pull workflow lives in Policy-LSP, not here.

## Consequences

- Adding a new consumer requires no change to this repository.
- Consumers can pin to a specific commit SHA of Governance-Framework for stability.
- Policy skew between this repository and a consumer is possible if the consumer does not run its sync workflow. This is a consumer concern, not a publisher concern.
- This repository cannot force consumers to update — that is intentional. Human review of policy updates before they take effect in a consumer is a safety property.

## Related

- `ADR-0001-rego-as-canonical.md` — policy language decision
- `ADR-0003-no-enforcement-here.md` — why this repo has no enforcement logic
- `BACKLOG.md` W-0005 — reminder that sync workflow belongs in Policy-LSP
- `.github/copilot-instructions.md` — prohibition on outbound workflows
