# Governance-Framework

Policy Management Point (PMP) and Policy Administration Point (PAP) for the PBAC system.

This repository owns the canonical Rego source and the invariant registry. It does not enforce policy and does not evaluate agents.

---

## What this repository does

- Maintains the **canonical Rego policy files** in `policies/`. All enforcement points pull from here.
- Maintains the **invariant registry** in `registry/invariants.json` — a machine-readable list of what must be true, which Rego rule enforces it, and which Agent-Evaluation scenarios cover it.
- Defines the **NFR taxonomy** (`registry/nfr-taxonomy.json`) — controlled vocabulary for `x-nfr` metadata fields in API specs.
- Defines the **PIP attribute schema** (`registry/pip-attributes.json`) — canonical names and types of context attributes injected into Rego `input` at evaluation time.
- Runs `opa test ./...` in CI to verify all Rego rules are syntactically correct and logically sound.
- Provides utility scripts for registry management and coverage reporting.

## What this repository does NOT do

- **No enforcement** — this repository does not call `opa eval`, run an LSP server, or evaluate any file against a policy rule. Enforcement lives in [Policy-LSP](https://github.com/davidamitchell/Policy-LSP).
- **No agent evaluation** — this repository does not run agents or score responses. That lives in [Agent-Evaluation](https://github.com/davidamitchell/Agent-Evaluation).
- **No push to consumers** — consumers pull from this repository on their own schedule. This repository never opens PRs or pushes commits to other repositories. See `ADR-0002`.
- **No consumer registry** — this repository has no knowledge of which repositories consume its policies.

---

## System context

```
Governance-Framework  (this repo)
  │  canonical Rego source
  │  invariant registry
  │  PIP attribute schema
  │
  ├── pulled by ──▶  Policy-LSP        (PDP + PEP — enforces policy via OPA)
  │
  └── pulled by ──▶  Agent-Evaluation  (Policy Verification Point — tests agent compliance)
```

---

## Repository layout

```
policies/                   # Canonical Rego source — single source of truth
  security.rego             # Hardcoded credential detection
  filenames.rego            # Markdown SCREAMING_SNAKE_CASE enforcement
  content.rego              # Go file package comment requirement
  imports.rego              # Library import graph enforcement (stub)
  openapi.rego              # API spec x-nfr metadata enforcement (stub)

registry/
  invariants.json           # Canonical invariant registry
  nfr-taxonomy.json         # Controlled vocabulary for x-nfr metadata fields
  pip-attributes.json       # Canonical PIP context attribute names and types

tests/                      # OPA unit tests — run with: opa test ./...
  security_test.rego
  filenames_test.rego
  content_test.rego

scripts/
  check_coverage.py         # Cross-references invariants.json against Agent-Evaluation datasets
  export_invariants.py      # Outputs invariant list for consumers

docs/adr/                   # Architecture Decision Records (MADR format)
  ADR-0001-rego-as-canonical.md
  ADR-0002-pull-not-push.md
  ADR-0003-no-enforcement-here.md
  ADR-0004-pip-attribute-schema.md

.github/
  copilot-instructions.md   # Instructions for AI agents working in this repo
  skills/                   # Skills submodule (davidamitchell/Skills)
  workflows/
    ci.yml                  # OPA tests, registry lint, coverage report
    sync-skills.yml         # Weekly skills submodule update

BACKLOG.md                  # Work items (W-NNNN format)
PROGRESS.md                 # Append-only session log
CHANGELOG.md                # Keep a Changelog format
not-doing.md                # Explicit exclusions with rationale
```

---

## Running OPA tests locally

```bash
# Install OPA: https://www.openpolicyagent.org/docs/latest/#running-opa
opa test ./...
```

All tests must pass before merging any change to `policies/` or `tests/`.

---

## Adding a policy rule

1. Add or modify the Rego file in `policies/`.
2. Add a unit test in `tests/` — `opa test ./...` must pass.
3. Add a corresponding entry in `registry/invariants.json` (append only — never edit existing IDs).
4. If the rule uses a new context attribute, register it in `registry/pip-attributes.json` first.
5. Update `CHANGELOG.md` and `PROGRESS.md`.

---

> AI agents working in this repository: see [`.github/copilot-instructions.md`](.github/copilot-instructions.md).
