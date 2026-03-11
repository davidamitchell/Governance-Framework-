# Progress

---

## 2026-03-11

Initial repository scaffold. Created all required files for the Governance-Framework PMP/PAP repository following the idioms of Policy-LSP and Agent-Evaluation.

Changes:
- `policies/security.rego`, `policies/filenames.rego`, `policies/content.rego`: copied verbatim from `davidamitchell/Policy-LSP`. These are now the source of truth; Policy-LSP will pull from here on its own schedule.
- `policies/imports.rego`, `policies/openapi.rego`: stub files with package declarations, intent comments, and placeholder deny rules that never fire. Valid Rego that passes `opa test`.
- `tests/security_test.rego`, `tests/filenames_test.rego`, `tests/content_test.rego`: OPA unit tests covering all three active policies. Eight tests per file covering both positive (deny fires) and negative (deny does not fire) cases.
- `registry/invariants.json`: three active entries (INV-0001 through INV-0003) matching the three Rego rules. All `agent_evaluation.scenario_ids` are empty — these are the first coverage gaps.
- `registry/nfr-taxonomy.json`: security, observability, reliability categories with controlled vocabulary.
- `registry/pip-attributes.json`: five canonical PIP context attributes (agent_id, branch, environment, data_classification, team).
- `scripts/check_coverage.py`: reads invariants.json, reports coverage gaps. Informational only, exits 0.
- `scripts/export_invariants.py`: outputs invariant list in json or tsv format for consumers.
- `docs/adr/ADR-0001-rego-as-canonical.md` through `ADR-0004-pip-attribute-schema.md`: four ADRs documenting the core architectural decisions.
- `docs/adr/README.md`: ADR index.
- `README.md`: full project README with purpose, what it does, what it does NOT do, repo layout, quick start.
- `BACKLOG.md`: W-0001 through W-0005 seeded; W-0001 through W-0004 done.
- `CHANGELOG.md`: initial unreleased entry.
- `not-doing.md`: explicit exclusions with rationale.
- `.github/copilot-instructions.md`: agent instructions following the shared framework.
- `.github/workflows/ci.yml`: three jobs — opa-test, registry-lint, coverage-report.
- `.github/workflows/sync-skills.yml`: weekly skills submodule update.
- `.gitmodules`: skills submodule entry pointing to davidamitchell/Skills.

**Mini-Retro**
1. Did the process work? Yes — reference repos (Policy-LSP, Agent-Evaluation) provided clear idioms for all files. No ambiguity in the required structure.
2. What slowed down or went wrong? OPA is not available in the sandbox environment, so tests could not be run locally. CI will verify the Rego tests on first push.
3. What single change would prevent friction next time? A devcontainer with OPA pre-installed would allow local `opa test` runs during authoring. This is a W-0006 candidate.
4. Is this a pattern? Initial scaffold sessions always have this limitation. The CI workflow is the authoritative test runner for OPA.
