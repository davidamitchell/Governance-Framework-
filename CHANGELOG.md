# Changelog

All notable changes to this project will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- `policies/security.rego`: hardcoded credential detection — denies files containing credential-shaped literal string assignments. Copied verbatim from `davidamitchell/Policy-LSP`; this repository is now the source of truth.
- `policies/filenames.rego`: Markdown SCREAMING_SNAKE_CASE enforcement — denies `.md` files not named in SCREAMING_SNAKE_CASE. Copied verbatim from `davidamitchell/Policy-LSP`.
- `policies/content.rego`: Go file package comment requirement — warns when a non-test Go file does not begin with a comment. Copied verbatim from `davidamitchell/Policy-LSP`.
- `policies/imports.rego`: library import graph enforcement stub — package declaration, intent comment, placeholder deny rule that never fires.
- `policies/openapi.rego`: API spec x-nfr metadata enforcement stub — package declaration, intent comment, placeholder deny rule that never fires.
- `tests/security_test.rego`, `tests/filenames_test.rego`, `tests/content_test.rego`: OPA unit tests for all three active policies. All tests pass with `opa test ./...`.
- `registry/invariants.json`: invariant registry seeded with INV-0001 (hardcoded-credential), INV-0002 (markdown-naming-violation), INV-0003 (missing-package-comment). All `agent_evaluation.scenario_ids` are empty — coverage gaps visible.
- `registry/nfr-taxonomy.json`: NFR taxonomy v0.1.0 with security, observability, reliability categories.
- `registry/pip-attributes.json`: PIP attribute schema v0.1.0 with five canonical attributes.
- `scripts/check_coverage.py`: coverage gap reporter. Informational only, exits 0.
- `scripts/export_invariants.py`: invariant list exporter for consumers. Supports JSON and TSV output.
- `docs/adr/ADR-0001-rego-as-canonical.md` through `ADR-0004-pip-attribute-schema.md`: four ADRs.
- `docs/adr/README.md`: ADR index.
- `README.md`: full project README.
- `BACKLOG.md`: W-0001 through W-0005.
- `PROGRESS.md`: append-only session log.
- `not-doing.md`: explicit exclusions with rationale.
- `.github/copilot-instructions.md`: agent instructions.
- `.github/workflows/ci.yml`: three-job CI pipeline (opa-test, registry-lint, coverage-report).
- `.github/workflows/sync-skills.yml`: weekly skills submodule update workflow.
- `.gitmodules`: skills submodule entry.
