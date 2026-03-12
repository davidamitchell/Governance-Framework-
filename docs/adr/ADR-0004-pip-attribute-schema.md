# ADR-0004 — PIP attribute schema is defined here

Date: 2026-03-11
Status: accepted

## Context

Rego rules in `policies/` reference context attributes injected at evaluation time via `input` (e.g. `input.agent_id`, `input.environment`, `input.data_classification`). These attributes are provided by the Policy Information Point (PIP), which is implemented by the consumer (Policy-LSP injects these attributes when it calls the OPA evaluator).

Without a canonical schema, the attribute names, types, and allowed values can diverge between the policy rules (defined here) and the PIP implementation (in Policy-LSP). This produces silent mismatches: a Rego rule might reference `input.data_class` while the PIP injects `input.data_classification`.

## Decision

The canonical names and types of all context attributes injected into Rego input at evaluation time are defined in `registry/pip-attributes.json`.

- This repository defines the schema (names, types, descriptions, allowed values).
- Consumers (Policy-LSP) implement the PIP interface against this contract.
- When a Rego rule needs a new context attribute, the attribute must be registered in `pip-attributes.json` before the Rego rule is merged.

## Consequences

- `registry/pip-attributes.json` is the single source of truth for PIP attribute names. Policy-LSP must not inject attributes not listed here without first updating this file.
- The `registry-lint` CI job validates that every attribute in `pip-attributes.json` has a non-empty `type` and `description`.
- Attribute names use `snake_case`. Consumers must use exactly these names when constructing the `input` document.
- Allowed values (where specified) are the exhaustive set. A PIP injecting a value outside the allowed set produces undefined behaviour in the Rego evaluation.

## Related

- `registry/pip-attributes.json` — the canonical attribute schema
- `ADR-0001-rego-as-canonical.md` — Rego as the policy language
- `ADR-0003-no-enforcement-here.md` — why PIP implementation is in Policy-LSP, not here
- `policies/security.rego` — example rule that would use `input.data_classification`
