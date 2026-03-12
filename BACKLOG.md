# Backlog

---

## W-0001

status: done
created: 2026-03-11
updated: 2026-03-11

### Outcome

Repository scaffold is complete: all standard files created, skills submodule configured, CI passing, OPA tests passing on seeded policies.

### Context

Initial repository setup. Establishes the canonical Rego source, invariant registry, PIP attribute schema, NFR taxonomy, OPA unit tests, CI pipeline, ADRs, and all standard documentation files following the idioms of Policy-LSP and Agent-Evaluation.

### Notes

Complete. See `policies/`, `tests/`, `registry/`, `docs/adr/`, `.github/workflows/ci.yml`, `BACKLOG.md`, `PROGRESS.md`, `CHANGELOG.md`, `not-doing.md`, `.github/copilot-instructions.md`, `.gitmodules`.

---

## W-0002

status: done
created: 2026-03-11
updated: 2026-03-11

### Outcome

Invariant registry is seeded with three active entries matching the three existing Policy-LSP rules. Coverage gaps are visible (all `agent_evaluation.scenario_ids` are empty).

### Context

Seeds `registry/invariants.json` with entries for `hardcoded-credential` (INV-0001), `markdown-naming-violation` (INV-0002), and `missing-package-comment` (INV-0003). Coverage gaps are expected at project inception and are tracked for future resolution.

### Notes

Complete. See `registry/invariants.json`. Coverage gaps are reported informally by `scripts/check_coverage.py` and the `coverage-report` CI job.

---

## W-0003

status: done
created: 2026-03-11
updated: 2026-03-11

### Outcome

NFR taxonomy is seeded with security, observability, and reliability categories with controlled vocabulary.

### Context

Seeds `registry/nfr-taxonomy.json` with three categories defining the controlled vocabulary for `x-nfr` extension fields used in API specs and schemas. The taxonomy is consumed by the stub `policies/openapi.rego` and by the Agent-Evaluation OpenAPI scenario dataset.

### Notes

Complete. See `registry/nfr-taxonomy.json`.

---

## W-0004

status: done
created: 2026-03-11
updated: 2026-03-11

### Outcome

PIP attribute schema is created with five canonical attributes. ADR-0004 documents the contract between this repository and Policy-LSP.

### Context

Creates `registry/pip-attributes.json` defining `agent_id`, `branch`, `environment`, `data_classification`, and `team`. Policy-LSP implements the PIP interface against this contract; this repository defines the schema.

### Notes

Complete. See `registry/pip-attributes.json` and `docs/adr/ADR-0004-pip-attribute-schema.md`.

---

## W-0005

status: ready
created: 2026-03-11
updated: 2026-03-11

### Outcome

A sync workflow in `davidamitchell/Policy-LSP` pulls `policies/` from this repository on a schedule or manual dispatch, and opens a PR for human review before applying the update.

### Context

This backlog item is a reminder that the consumer (Policy-LSP) must implement the pull workflow — it is not implemented here. Per ADR-0002, this repository never pushes to other repositories.

### Notes

Deliverable: `.github/workflows/sync-policies.yml` in `davidamitchell/Policy-LSP`. Not in scope for this repository.
