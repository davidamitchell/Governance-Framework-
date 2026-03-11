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

**ADRs are mandatory.** Write an ADR in `docs/adr/` whenever you:
- Change the invariant registry schema that other consumers depend on
- Change a Rego policy that has downstream policy enforcement effects
- Change a CLI interface that acceptance criteria reference
- Make a decision that is costly to reverse

The ADR must be committed in the same PR as the change. Never defer an ADR.

---

## PROGRESS.md mandate

Append a dated entry to `PROGRESS.md` after every meaningful session or PR. Never edit old entries — append only. Format: `## YYYY-MM-DD` then what changed and why. Append-only prevents merge conflicts.

---

## CHANGELOG.md mandate

Record every user-facing change in `CHANGELOG.md`. Follow Keep-a-Changelog 1.0.0. New entries go under `## [Unreleased]` at the top.

---

## Prose quality mandate

All documentation, ADRs, and factual prose committed to this repository must pass three quality checks before merge. Apply the corresponding skills from `.github/skills/`:

- **`citation-discipline`** — every factual claim must cite a verifiable source at the point of claim. Unsourced claims must be flagged `[SOURCE NEEDED]`, not silently omitted. All acronyms must be expanded on first use.
- **`speculation-control`** — interpretations, inferences, and causal claims must be distinguishable from facts. Causal language ("shaped", "framed", "determined") requires a cited source. If no source exists, reframe as description.
- **`remove-ai-slop`** — formulaic transitions, symmetric paragraph structure, and alignment artifacts must be removed. Prose should read as direct technical writing, not a structured exposition template.

These checks apply to: `README.md`, `PROGRESS.md`, ADRs in `docs/adr/`, and any Markdown file committed as documentation.

---

## Repository purpose

This repository is the **Policy Management Point (PMP)** and **Policy Administration Point (PAP)** in a three-repository Policy-Based Access Control (PBAC) system:

| Repository | Role | Responsibility |
|------------|------|----------------|
| **Governance-Framework** (this repo) | PMP + PAP | Owns canonical Rego source and the invariant registry |
| **Policy-LSP** | PDP + PEP | Enforces policy; pulls Rego from this repo on its own schedule |
| **Agent-Evaluation** | Policy Verification Point | Tests agent compliance against policies defined here |

**What this repo does:**
- Owns the canonical Rego source — the single source of truth for all policy rules
- Maintains the invariant registry (`registry/invariants.json`) mapping rules to policy files
- Defines the PIP (Policy Information Point) attribute schema that enforcement points must implement
- Defines the NFR taxonomy vocabulary used in API spec metadata
- Provides OPA unit tests for every Rego policy

**What this repo does NOT do:**
- Does not enforce policy — that is Policy-LSP's job
- Does not evaluate agents — that is Agent-Evaluation's job
- Does not push Rego to consumers — consumers pull on their own schedule
- Has no knowledge of its consumers

Rego is the single policy language across all enforcement points. Any change to a policy file in `policies/` is a breaking change for downstream consumers — treat it accordingly.

---

## How to pick up a task

All planned work is in `BACKLOG.md`. Each task is independently executable and includes:

- **Goal** — what to achieve
- **Constraints** — what must not change
- **Deliverables** — exact files to create or modify
- **Acceptance criteria** — the conditions that must be true when the task is done

Pick the lowest-numbered incomplete task, read it fully, then implement exactly what its Deliverables and Acceptance criteria specify. Do not implement more than one task per PR.

---

## Documentation alignment — mandatory on every PR

Every pull request **must** keep all documentation consistent with the code changes made. This is not optional. Before marking a PR ready:

1. **READMEs** — update every README whose described schema, behaviour, or file list changed.
2. **`BACKLOG.md`** — if a task was completed, mark it with `**Status:** done` and a brief description of what was done. If new work was identified, add a new task entry.
3. **`docs/adr/`** — if a non-trivial architectural or design decision was made (new registry schema, new Rego package, new CI job, new external dependency), create or update the relevant ADR. ADRs are the permanent record of *why* decisions were made.
4. **`.github/copilot-instructions.md`** (this file) — if a file format, naming convention, safety rule, or policy convention changed, update the relevant section here so future agents receive accurate context.
5. **`not-doing.md`** — if a reasonable approach was considered and explicitly rejected, document it there with the reason.

Failing to update these files will cause future agents to work from incorrect context and produce inconsistent implementations.

---

## Continuous Improvement & Learning

> Complete the work. Improve the system. If something was hard, slow, or confusing — fix it, document it, or raise it.

### Identity as Architect

You are the **Architect** of this repository, not just a user.
Your role is to complete work *and* to improve the system doing the work.
If something was hard, slow, or confusing — fix it, document it, or raise it.
Always ask: *"Is this the best version of this system, or just a working one?"*

### Every Session Ends with a Mini-Retro

Before closing any session or completing any PR, append a **Mini-Retro** to `PROGRESS.md`.
It is **not optional**. It is how the system learns.

Answer these four questions — briefly, honestly:

1. **Did the process work?** Was the approach sound? Did the plan hold?
2. **What slowed down or went wrong?** No blame — just facts.
3. **What single change would prevent this next time?** If nothing: say so.
4. **Is this a pattern?** Have you seen this friction before? If yes, it deserves a fix, not just a note.

Do not just answer — make the change. If the answer is "document it", document it now. If it is "add a backlog item", add it now.

### Improvement Comes in Classes — Look for the Class, Not Just the Instance

When something goes wrong or goes right, resist the urge to fix *just this case*.
Ask: **what class of problem is this?**

| Signal | Class to consider |
|---|---|
| You had to look something up that should be documented | → Add it to the agent instructions or a skill |
| A step was manual that could be automated | → Raise a backlog item or add a workflow |
| A decision was unclear or had to be re-made | → Write an ADR |
| A note or file was out of date | → Mark it `superseded_by`, don't delete it |
| The same friction appears in two retros | → It's a pattern. Prioritise fixing the root cause |
| Missing skill | → Add to backlog; do not synthesise a substitute |

### What "Done" Means

- [ ] The work is complete and all OPA tests pass (`opa test ./...`)
- [ ] `PROGRESS.md` is updated with a Mini-Retro
- [ ] Any new decisions are recorded as ADRs
- [ ] Any structural improvements spotted are raised in the backlog
- [ ] `CHANGELOG.md` updated if behaviour changed
- [ ] `remove-ai-slop` run on committed prose
- [ ] `citation-discipline` applied to any factual claims (all claims cite a source; unsourced claims flagged)
- [ ] `speculation-control` applied to factual prose (causal claims sourced; interpretations framed as interpretations)
- [ ] Registry updated if any policy rule was added, changed, or removed

---

## Chain-of-Thought Reasoning

Before acting on any task in this repo, reason explicitly through these steps:

1. **Consumer impact first** — Before changing any Rego policy, ask: "What downstream consumers depend on this rule? What will break if the rule changes?" Policy-LSP and Agent-Evaluation both consume from this repo. A policy change is a breaking change for them.

2. **Registry coherence** — Ask: "Does `registry/invariants.json` need to be updated to reflect this change?" Every active Rego rule must have a corresponding invariant entry. Every invariant entry must point to an existing rule.

3. **Test coverage** — Ask: "Do the OPA unit tests in `tests/` cover both the compliant and violating cases for this rule?" A rule with only a passing test or only a failing test provides no confidence.

4. **PIP attribute alignment** — If adding a new rule that reads from `input`, ask: "Is every input attribute I'm reading defined in `registry/pip-attributes.json`? If not, add it before writing the rule."

5. **Stub vs active rule** — Ask: "Should this be an active rule with full test coverage, or a stub that documents intent?" Stubs must be valid Rego that passes `opa test`. Never ship a stub that would fire in production.

6. **Schema change implication** — If changing a registry schema (invariants, nfr-taxonomy, pip-attributes), ask: "Does this schema version need to bump? Do downstream consumers need to be notified?" Record the decision as an ADR.

---

## Non-Negotiable Constraints

- **Never commit secrets.** No API keys, tokens, or credentials in source. Use environment variables or GitHub Secrets.
- **All Rego must be valid.** Every policy file must pass `opa check policies/`. Never commit syntactically invalid Rego.
- **Every active rule must have test coverage.** A Rego rule with no unit test in `tests/` has no value. Unit tests must cover both the compliant and violating cases.
- **Registry and policies must stay in sync.** Every active rule in `policies/` must have a corresponding entry in `registry/invariants.json`. Orphaned entries (pointing to deleted rules) must be removed.
- **Do not push to consumers.** This repo publishes policy; consumers pull. Never add a workflow step that pushes Rego to Policy-LSP, Agent-Evaluation, or any other repository.
- **Keep PROGRESS.md updated** after every meaningful commit. It is the primary handoff document between sessions.

---

## OPA / Rego standards

### Package naming

- All policies must live under the `governance.*` package namespace.
- Package names must match directory and filename: `policies/security.rego` → `package governance.security`.

### Rule style

- Use `import future.keywords.if` and `import future.keywords.contains` for idiomatic multi-value rules.
- The `deny` rule returns a **set of objects**. Each object must have at minimum `"id"` and `"message"` fields. Optional fields: `"level"` (`"error"` | `"warning"` | `"info"`), `"location"` (`{"line": int, "column": int}`), `"fix"` (`{"type": "rename" | "insert" | "delete", "value": string}`).
- Include a brief comment in each policy with an example compliant and violating input so agents can understand expected behaviour without reading the tests.

### Stub files

- Stub files (`imports.rego`, `openapi.rego`) must have a package declaration, a comment explaining intent, and a single placeholder deny rule that never fires.
- Stubs must be valid Rego that passes `opa test`. Never ship a stub that would fire in production.

### OPA unit tests

- Test files live in `tests/` with `_test.rego` suffix.
- Every test must import the policy under test and assert on the `deny` set.
- Every active rule must have at least one `test_<rule>_compliant` and one `test_<rule>_violating` test case.

### Running tests

```bash
# Run all OPA unit tests
opa test ./...

# Lint all Rego files
opa check policies/

# Check coverage
opa test --coverage ./...
```

---

## Registry standards

### `registry/invariants.json`

Schema per entry:
```json
{
  "id": "INV-0001",
  "description": "What must be true, stated as a verifiable claim",
  "category": "security | architecture | quality | nfr | intent",
  "severity": "error | warning",
  "policy_file": "policies/security.rego",
  "rule_id": "hardcoded-credential",
  "context_attributes": [],
  "nfr_taxonomy_refs": [],
  "agent_evaluation": {
    "scenario_ids": []
  },
  "status": "active | draft | deprecated",
  "added": "YYYY-MM-DD",
  "updated": "YYYY-MM-DD"
}
```

- IDs are sequential: `INV-0001`, `INV-0002`, etc. Never reuse a retired ID.
- `policy_file` and `rule_id` must point to an existing rule in an existing file.
- `status: deprecated` entries are kept for audit history — never delete them.
- `agent_evaluation.scenario_ids` lists the scenario IDs from Agent-Evaluation that test this invariant. Empty array means uncovered — this is a coverage gap.

### `registry/nfr-taxonomy.json`

Defines the controlled vocabulary for `x-nfr` extension fields in API specs. Do not add new fields without an ADR. Consumers depend on this vocabulary being stable.

### `registry/pip-attributes.json`

Defines canonical attribute names and types for Rego `input`. Policy-LSP implements the PIP interface against this contract. Any new attribute must be added here before being used in a policy rule.

---

## Bash and Python script standards

- Use `set -euo pipefail` at the top of every Bash script.
- Always quote variables (`"$var"`) to prevent word-splitting.
- In Python, use type hints and handle exceptions explicitly (e.g., `json.JSONDecodeError`).
- Scripts must check for required binaries at startup (e.g., `opa`, `python3`) and exit with a clear message if missing.

---

## CI / workflow standards

- `opa test ./...` must be a required CI step on every PR.
- `opa check policies/` (lint) must run before `opa test`.
- Coverage report (`opa test --coverage ./...`) runs as an informational step — not a hard gate (yet).
- Registry lint (`scripts/check_coverage.py`) validates that every active invariant entry points to an existing rule. Must pass on every PR.

---

## Repository layout

```
policies/                    # Canonical Rego source — single source of truth
  security.rego
  filenames.rego
  content.rego
  imports.rego               # Library import enforcement (stub)
  openapi.rego               # API spec metadata enforcement (stub)
registry/
  invariants.json            # Canonical invariant registry
  nfr-taxonomy.json          # Controlled vocabulary for x-nfr metadata fields
  pip-attributes.json        # Canonical PIP context attribute names and types
tests/                       # OPA unit tests (opa test ./...)
  security_test.rego
  filenames_test.rego
  content_test.rego
scripts/
  check_coverage.py          # Cross-references invariants.json against Agent-Evaluation datasets
  export_invariants.py       # Outputs invariant list for consumers
docs/adr/                    # Architecture Decision Records (MADR format)
  README.md
  ADR-0001-rego-as-canonical.md
  ADR-0002-pull-not-push.md
  ADR-0003-no-enforcement-here.md
  ADR-0004-pip-attribute-schema.md
README.md                    # Purpose, what it does, what it does NOT do, repo layout
BACKLOG.md                   # W-NNNN format backlog
PROGRESS.md                  # Append-only session log, newest first
CHANGELOG.md                 # Keep a Changelog format
not-doing.md                 # Explicit exclusions with rationale
.github/
  copilot-instructions.md    # Agent instructions (this file)
  skills/                    # Skills submodule (davidamitchell/Skills)
  workflows/
    ci.yml                   # OPA lint, test, and coverage jobs
    sync-skills.yml          # Skills submodule sync
.gitmodules                  # Skills submodule entry
```

---

## Safety rules

These rules apply to every PR regardless of which task is being implemented:

1. **Never push to consumers.** No workflow step may commit or push to Policy-LSP, Agent-Evaluation, or any other repository. Consumers pull from this repo — this repo never pushes to them.
2. **Never commit secrets.** No API keys, tokens, or credentials in source. Use GitHub Secrets.
3. **Never delete invariant entries.** Mark them `status: deprecated` instead. Deletion breaks audit history and may silently remove coverage data from Agent-Evaluation.
4. **Never silently change a Rego rule ID.** Rule IDs in the deny set objects are the contract with downstream consumers. Changing a rule ID is a breaking change — record it as an ADR and bump the affected invariant entry.
5. **Stubs must never fire.** A stub rule (`imports.rego`, `openapi.rego`) must have a deny condition that is always false. Verify this with an OPA unit test.

---

## How to validate your changes

```bash
# Check Rego syntax
opa check policies/

# Run all OPA unit tests
opa test ./...

# Run with coverage report
opa test --coverage ./...

# Validate registry coherence (requires Python 3)
python scripts/check_coverage.py
```

All OPA tests must pass before merging. Registry lint must pass before merging.
