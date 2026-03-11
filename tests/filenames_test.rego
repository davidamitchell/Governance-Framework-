package governance.filenames_test

import future.keywords.if
import future.keywords.contains

# deny fires for a lowercase markdown filename
test_deny_lowercase_md if {
    some msg in data.governance.filenames.deny
    msg.id == "markdown-naming-violation"
} with input as {
    "filename": "readme.md",
}

# deny fires for a kebab-case markdown filename
test_deny_kebab_case_md if {
    some msg in data.governance.filenames.deny
    msg.id == "markdown-naming-violation"
} with input as {
    "filename": "my-document.md",
}

# deny fires for a mixed-case markdown filename
test_deny_mixed_case_md if {
    some msg in data.governance.filenames.deny
    msg.id == "markdown-naming-violation"
} with input as {
    "filename": "MyDocument.md",
}

# deny does NOT fire for a SCREAMING_SNAKE_CASE markdown filename
test_no_deny_screaming_snake_case if {
    count(data.governance.filenames.deny) == 0
} with input as {
    "filename": "README.md",
}

# deny does NOT fire for a file with numbers in the name
test_no_deny_with_numbers if {
    count(data.governance.filenames.deny) == 0
} with input as {
    "filename": "ADR_0001.md",
}

# deny does NOT fire for non-markdown files
test_no_deny_non_markdown if {
    count(data.governance.filenames.deny) == 0
} with input as {
    "filename": "main.go",
}

# deny does NOT fire for a .go file that happens to contain "md" in the name
test_no_deny_go_file if {
    count(data.governance.filenames.deny) == 0
} with input as {
    "filename": "cmd.go",
}
