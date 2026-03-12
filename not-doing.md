# Not Doing

This file records design suggestions that have been explicitly considered and deliberately set aside. For each item, the reason is documented so that future contributors understand the boundary and do not re-propose the same approach without new context.

This is a living document. Items may be promoted to the backlog if circumstances change.

---

## Run a Rego evaluation engine

**Suggested:** Add an OPA evaluation runner that checks files in this repository or in other repositories against the policies in `policies/`.

**Decision:** Not doing. Enforcement lives in [Policy-LSP](https://github.com/davidamitchell/Policy-LSP), which embeds OPA in an LSP server and evaluates files at edit time. Running an evaluation engine here would duplicate Policy-LSP's role, create undefined behaviour when policies diverge, and violate the boundary documented in ADR-0003. The only OPA operation in this repository is `opa test ./...`, which tests the Rego rules themselves.

---

## Own an LSP server or MCP tool

**Suggested:** Host the LSP server or MCP tool that connects editors to the policy engine in this repository, since it already owns the Rego source.

**Decision:** Not doing. The LSP server and MCP tool live in Policy-LSP. Governance-Framework is a policy repository, not a runtime. Hosting server infrastructure here would couple this repository to editor protocols, language server lifecycles, and JSON-RPC transport details that are Policy-LSP concerns. See ADR-0003.

---

## Run agent instruction evaluation

**Suggested:** Add evaluation scenarios and a runner to this repository to test whether agents produce compliant code according to the policies in `policies/`.

**Decision:** Not doing. Agent evaluation lives in [Agent-Evaluation](https://github.com/davidamitchell/Agent-Evaluation), which is purpose-built for that role. Adding evaluation here would duplicate Agent-Evaluation's tooling, create a second tracking system for compliance results, and blur the boundary between policy definition (here) and policy verification (Agent-Evaluation).

---

## Push changes to consumer repositories

**Suggested:** When a policy changes in this repository, automatically open a PR in Policy-LSP or Agent-Evaluation to propagate the update.

**Decision:** Not doing. The distribution model is pull-only (ADR-0002). Consumers pull from this repository on their own schedule. Implementing a push here would require maintaining tokens with write access to consumer repositories, knowing which repositories consume our policies, and coordinating release timing — all of which create coupling that violates the pull model. Consumers are responsible for their own sync workflows.

---

## Open PRs outside this repository's boundary

**Suggested:** Use GitHub Actions to open pull requests in other repositories (e.g. to update policy consumers when a new invariant is added).

**Decision:** Not doing. This is a special case of the pull-only distribution model (ADR-0002). No workflow in this repository targets another repository. If you find yourself writing a workflow step that references another repository's API or opens a PR in another repository — stop and re-read ADR-0002.

---

## Maintain knowledge of which repos consume its policies

**Suggested:** Add a `consumers.json` registry listing all repositories that consume policies from this repository, so that change notifications can be sent.

**Decision:** Not doing. Maintaining a consumer registry creates a coupling that the pull-only model is designed to avoid. New consumers can be added without any change to this repository. If a consumer wants to be notified of policy changes, they can watch this repository on GitHub or implement polling in their own workflow.

---

## Define enforcement mechanism implementations

**Suggested:** Include reference implementations of the PIP, PDP, or PEP interfaces in this repository alongside the Rego source.

**Decision:** Not doing. Reference implementations belong in the consumer repositories that implement those interfaces. This repository defines the contract (Rego rules, PIP attribute schema) but not the implementation. Policy-LSP is the canonical implementation of the PDP/PEP; it is the reference for how to consume policies from this repository.

---

## Maintain per-consumer policy forks

**Suggested:** Maintain separate policy branches or subdirectories for each consumer (e.g. `policies/policy-lsp/`, `policies/agent-evaluation/`) so consumers can have customised rule sets.

**Decision:** Not doing. Per-consumer policy forks undermine the purpose of a canonical policy repository. If consumers need different rules, they should contribute to the canonical set here. Versioned customisation should be addressed through Rego data documents or parameterisation, not through directory forks. Forks create synchronisation overhead that grows with every new consumer.
