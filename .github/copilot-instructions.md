# Copilot Instructions

This file tells GitHub Copilot how to work in this repository. Read it fully before making any change.

---

## Skills

Skills are available at `.github/skills/`. Key skills: `backlog-manager`, `research`, `technical-writer`, `code-review`, `strategy-author`, `decisions`.

Prose quality skills: `citation-discipline`, `speculation-control`, `remove-ai-slop`. Apply these whenever writing or editing documentation, ADRs, or any factual prose (see [Prose quality mandate](#prose-quality-mandate)).

> If no skill fits, note the gap in `BACKLOG.md` and proceed without synthesising a substitute.

---

## Backlog mandate

The backlog is `BACKLOG.md` at the repo root. Use the `backlog-manager` skill from `.github/skills/backlog-manager/SKILL.md`. Read it at the start of every session.

---

## ADR mandate

Every non-trivial architectural or design decision must be recorded as an ADR in `docs/adr/`. Use the `decisions` skill from `.github/skills/decisions/SKILL.md`. Format is MADR. Files named `docs/adr/ADR-NNNN-short-title.md`.

**ADRs are mandatory.** Write an ADR whenever you:
- Change the schema of any registry file that consumers depend on
- Change the Rego rule interface (e.g. `deny` rule output shape)
- Add a new policy language or evaluation mechanism
- Make a decision that is costly to reverse

The ADR must be committed in the same PR as the change. Never defer an ADR.

---

## PROGRESS.md mandate

Append a dated entry to `PROGRESS.md` after every meaningful session or PR. Never edit old entries — append only. Format: `## YYYY-MM-DD` then what changed and why. Include a Mini-Retro at the end of every entry.

---

## CHANGELOG.md mandate

Record every user-facing change in `CHANGELOG.md`. Follow Keep-a-Changelog 1.0.0. New entries go under `## [Unreleased]` at the top.

---

## Prose quality mandate

All documentation, ADRs, and factual prose committed to this repository must pass three quality checks before merge. Apply the corresponding skills from `.github/skills/`:

- **`citation-discipline`** — every factual claim must cite a verifiable source at the point of claim.
- **`speculation-control`** — interpretations and causal claims must be distinguishable from facts.
- **`remove-ai-slop`** — formulaic transitions and alignment artefacts must be removed. Write direct technical prose.

---

## Repository purpose

This repository is the Policy Management Point (PMP) and Policy Administration Point (PAP) in a three-repo PBAC system:

| Repository | Role |
|---|---|
| `Governance-Framework` (this repo) | PMP + PAP — canonical Rego source, invariant registry |
| `Policy-LSP` | PDP + PEP — enforces policy via OPA in an LSP server |
| `Agent-Evaluation` | Policy Verification Point — tests agent compliance |

This repository owns the canonical Rego source and the invariant registry. It does not enforce policy and does not evaluate agents.

---

## Policy rules

- All Rego changes require a passing `opa test ./...` before committing.
- Never modify invariant IDs — append only, deprecate don't delete.
- When adding a Rego rule, add a corresponding invariant registry entry in `registry/invariants.json` in the same PR.
- When adding an invariant, check whether Agent-Evaluation has a scenario covering it — if not, note the gap in the PR description.
- When adding a context attribute to a Rego rule, register it in `registry/pip-attributes.json` first.

---

## Distribution model — no outbound workflows

**This repository never pushes to other repositories.**

If you find yourself writing a workflow step that:
- Opens a PR in another repository
- Pushes commits to another repository
- Calls another repository's workflow dispatch API

— stop. Re-read `docs/adr/ADR-0002-pull-not-push.md`. Consumers pull from this repository on their own schedule. This repository has no knowledge of its consumers.

---

## No enforcement logic

**This repository contains no enforcement logic.**

If you find yourself:
- Writing Go code
- Calling `opa eval` or the OPA REST API
- Running an agent or scoring an agent response
- Implementing an LSP server or MCP tool

— stop. Re-read `docs/adr/ADR-0003-no-enforcement-here.md`. That work belongs in Policy-LSP or Agent-Evaluation.

---

## How to pick up a task

All planned work is in `BACKLOG.md`. Each item includes `status`, `Outcome`, `Context`, and `Notes`. Pick the lowest-numbered item with status `ready`, read it fully, then implement exactly what it describes. Do not implement more than one item per PR.

---

## Documentation alignment — mandatory on every PR

Before marking a PR ready:

1. `PROGRESS.md` — append a dated entry with what changed and a Mini-Retro.
2. `CHANGELOG.md` — record user-facing changes under `## [Unreleased]`.
3. `BACKLOG.md` — update the status of any completed item; add new items if work was identified.
4. `docs/adr/` — write an ADR for any non-trivial architectural decision.
5. `not-doing.md` — document any reasonable approach that was explicitly rejected.

---

## Continuous Improvement & Learning

> Complete the work. Improve the system. If something was hard, slow, or confusing — fix it, document it, or raise it.

### Identity as Architect

You are the Architect of this repository, not just a user. Complete work and improve the system doing the work. If something was hard, slow, or confusing — fix it, document it, or raise it.

### Every Session Ends with a Mini-Retro

Before closing any session or completing any PR, append a Mini-Retro to `PROGRESS.md`. Answer these four questions briefly and honestly:

1. Did the process work?
2. What slowed down or went wrong?
3. What single change would prevent this next time?
4. Is this a pattern?

Do not just answer — make the change. If the answer is "document it", document it now.

### What "Done" Means

- [ ] The work is complete and `opa test ./...` passes
- [ ] `PROGRESS.md` is updated with a Mini-Retro
- [ ] Any new decisions are recorded as ADRs in `docs/adr/`
- [ ] Any structural improvements spotted are raised in `BACKLOG.md`
- [ ] `CHANGELOG.md` updated if behaviour changed
- [ ] `remove-ai-slop` run on committed prose
- [ ] No outbound workflow targets another repository
- [ ] No enforcement logic was added

---

## Chain-of-Thought Reasoning

Before acting on any task in this repository, reason explicitly through these steps:

1. **Policy correctness first** — Before adding or modifying a Rego rule, ask: "Does this rule express the invariant accurately? Are the positive and negative cases tested?"

2. **Invariant completeness** — Ask: "Is there a corresponding invariant registry entry? Does it have an `agent_evaluation.scenario_ids` link?"

3. **PIP contract** — Ask: "Does this rule reference any context attributes? Are they in `registry/pip-attributes.json`?"

4. **Distribution boundary** — Ask: "Am I about to write something that pushes to another repository?" If yes, stop.

5. **Enforcement boundary** — Ask: "Am I about to add a runtime that evaluates files against policies?" If yes, stop.

6. **Consumer impact** — Ask: "Does this change affect the shape of the `deny` rule output, the schema of a registry file, or the PIP attribute contract?" If yes, write an ADR.

---

## Repository layout

```
policies/
  security.rego             # Hardcoded credential detection
  filenames.rego            # Markdown SCREAMING_SNAKE_CASE enforcement
  content.rego              # Go file package comment requirement
  imports.rego              # Library import graph enforcement (stub)
  openapi.rego              # API spec x-nfr metadata enforcement (stub)

registry/
  invariants.json           # Canonical invariant registry
  nfr-taxonomy.json         # Controlled vocabulary for x-nfr metadata fields
  pip-attributes.json       # Canonical PIP context attribute names and types

tests/
  security_test.rego
  filenames_test.rego
  content_test.rego

scripts/
  check_coverage.py         # Coverage gap reporter (informational)
  export_invariants.py      # Invariant list exporter for consumers

docs/adr/
  ADR-0001-rego-as-canonical.md
  ADR-0002-pull-not-push.md
  ADR-0003-no-enforcement-here.md
  ADR-0004-pip-attribute-schema.md

.github/
  copilot-instructions.md   # This file
  skills/                   # davidamitchell/Skills submodule
  workflows/
    ci.yml                  # opa-test, registry-lint, coverage-report
    sync-skills.yml         # Weekly skills submodule update

BACKLOG.md
PROGRESS.md
CHANGELOG.md
not-doing.md
```

---

> AI agents: this file is the single source of truth for how to work in this repository. If an instruction here conflicts with a general Copilot behaviour, this file takes precedence.
