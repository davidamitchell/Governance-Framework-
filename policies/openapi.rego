package governance.openapi

import future.keywords.if
import future.keywords.contains

# API spec x-nfr metadata enforcement.
#
# This policy will enforce that OpenAPI spec files declare the required
# non-functional requirement (NFR) metadata extensions defined in
# registry/nfr-taxonomy.json. For example, every path operation that handles
# confidential data must declare x-nfr.security.data-classification.
#
# Currently a stub — the deny rule never fires. A real implementation would
# parse input.spec (a parsed OpenAPI document) and cross-reference declared
# x-nfr fields against the controlled vocabulary in nfr-taxonomy.json.

deny contains msg if {
    # Placeholder — this condition is never true.
    input.never_fires == true
    msg := {
        "id":      "openapi-nfr-missing",
        "level":   "error",
        "message": sprintf("OpenAPI path '%v' is missing required x-nfr metadata.", [""]),
        "location": {"line": 1, "column": 1},
    }
}
