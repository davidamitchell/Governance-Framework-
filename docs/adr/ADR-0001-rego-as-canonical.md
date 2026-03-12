# ADR-0001 — Rego is the canonical policy language

Date: 2026-03-11
Status: accepted

## Context

The PBAC system spans three repositories. Policy-LSP enforces policy at the editor/agent level using OPA. Agent-Evaluation tests agent compliance. This repository (Governance-Framework) owns the canonical policy source.

A single policy language must be chosen for all enforcement points. Candidates considered:

- **Rego** — OPA's native policy language; structured, declarative, testable with `opa test`, supported by open-source tooling, and already in use in Policy-LSP.
- **CEL (Common Expression Language)** — used by Kubernetes admission webhooks; narrower scope than Rego, harder to test independently.
- **Custom YAML/JSON rules** — simpler to write but requires a custom engine, no standard test tooling.

## Decision

Rego is the single policy language across all enforcement points. All policy rules are authored in `.rego` files in `policies/`. All enforcement points (Policy-LSP/OPA, future Gatekeeper, future HCP Vault) consume Rego from this repository.

No other policy language is introduced without superseding this ADR.

## Consequences

- Policy rules are testable with `opa test ./...` — CI enforces this.
- Consumers must be able to execute OPA (or the OPA Go SDK). This is documented in each consumer's own ADRs.
- The OPA version constraint is managed in each consumer's own dependency files; this repository has no build dependency on OPA itself.
- Authors of new policy rules must know Rego. This is the accepted cost of having a single, well-tested language.

## Related

- `ADR-0002-pull-not-push.md` — distribution model for Rego files
- `ADR-0003-no-enforcement-here.md` — why this repo does not run OPA
- `policies/security.rego`, `policies/filenames.rego`, `policies/content.rego` — active Rego rules
