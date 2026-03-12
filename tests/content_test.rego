package governance.content_test

import future.keywords.if
import future.keywords.contains

# deny fires for a Go file that does not begin with a comment
test_deny_go_missing_comment if {
    some msg in data.governance.content.deny
    msg.id == "missing-package-comment"
} with input as {
    "filename":      "main.go",
    "extension":     ".go",
    "file_contents": "package main\n\nfunc main() {}\n",
}

# deny fires for a Go file with leading whitespace and no comment
test_deny_go_leading_whitespace_no_comment if {
    some msg in data.governance.content.deny
    msg.id == "missing-package-comment"
} with input as {
    "filename":      "handler.go",
    "extension":     ".go",
    "file_contents": "\npackage handler\n",
}

# deny does NOT fire for a Go file that starts with a line comment
test_no_deny_go_line_comment if {
    count(data.governance.content.deny) == 0
} with input as {
    "filename":      "main.go",
    "extension":     ".go",
    "file_contents": "// Package main is the entry point.\npackage main\n",
}

# deny does NOT fire for a Go file that starts with a block comment
test_no_deny_go_block_comment if {
    count(data.governance.content.deny) == 0
} with input as {
    "filename":      "main.go",
    "extension":     ".go",
    "file_contents": "/* Copyright 2026 */\npackage main\n",
}

# deny does NOT fire for _test.go files (exempted)
test_no_deny_go_test_file if {
    count(data.governance.content.deny) == 0
} with input as {
    "filename":      "main_test.go",
    "extension":     ".go",
    "file_contents": "package main_test\n",
}

# deny does NOT fire for non-Go files
test_no_deny_non_go_file if {
    count(data.governance.content.deny) == 0
} with input as {
    "filename":      "README.md",
    "extension":     ".md",
    "file_contents": "# Title\n",
}
