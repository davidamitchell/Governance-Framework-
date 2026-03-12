package governance.imports

import future.keywords.if
import future.keywords.contains

# Library import graph enforcement.
#
# This policy will enforce which external libraries agents are permitted to
# import. Enforcement prevents dependency sprawl and ensures all libraries
# have been reviewed against the organisation's supply-chain policy.
#
# Currently a stub — the deny rule never fires. A real implementation would
# check input.imports (a list of import paths) against an allowlist or
# blocklist defined in a companion data document.

deny contains msg if {
    # Placeholder — this condition is never true.
    input.never_fires == true
    msg := {
        "id":      "import-graph-violation",
        "level":   "error",
        "message": sprintf("Import '%v' is not permitted by the library allowlist.", [""]),
        "location": {"line": 1, "column": 1},
    }
}
