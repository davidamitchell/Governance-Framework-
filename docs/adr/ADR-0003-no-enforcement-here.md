# ADR-0003 — This repository contains no enforcement logic

Date: 2026-03-11
Status: accepted

## Context

The three-repo PBAC system has clear boundaries:

| Repository | Role |
|---|---|
| `Governance-Framework` (this repo) | PMP and PAP — owns canonical Rego source and invariant registry |
| `Policy-LSP` | PDP and PEP — enforces policy via OPA embedded in an LSP server |
| `Agent-Evaluation` | Policy Verification Point — tests agent compliance against evaluation datasets |

There is a recurring temptation to add enforcement logic to this repository because it already contains the Rego source. For example: running `opa eval` on a file, running an LSP server that consumers connect to, or evaluating agent responses against the policies.

## Decision

This repository contains no enforcement logic, no LSP server, no evaluation runner, and no OPA evaluation calls.

The boundary test: if you find yourself writing Go code, running an agent, calling OPA's eval API, or evaluating file content against a policy rule — stop. That work belongs in Policy-LSP or Agent-Evaluation.

The only OPA operation that runs in this repository's CI is `opa test ./...`, which executes unit tests to verify the Rego rules are syntactically correct and logically sound. This is authoring-time verification of the rules themselves, not enforcement against real input.

## Consequences

- Consumers must implement their own enforcement pipelines. This is documented in each consumer's ADRs.
- This repository remains small, fast to clone, and free of runtime dependencies.
- The `scripts/` directory contains Python utilities for registry management and coverage reporting. These scripts read and validate JSON — they do not call OPA or evaluate Rego.
- CI has three jobs: `opa-test` (unit tests), `registry-lint` (JSON validation), and `coverage-report` (informational gap reporting). None of these jobs enforce policy against real content.

## Related

- `ADR-0001-rego-as-canonical.md` — why Rego is the policy language
- `ADR-0002-pull-not-push.md` — why this repo does not push to consumers
- `.github/copilot-instructions.md` — explicit agent instruction not to add enforcement logic
- `not-doing.md` — explicit list of things this repository will never do
