package governance.security_test

import future.keywords.if
import future.keywords.contains

# deny fires for an api_key assignment with a 20+ character value
test_deny_api_key_assignment if {
    some msg in data.governance.security.deny
    msg.id == "hardcoded-credential"
} with input as {
    "filename":      "config.go",
    "file_contents": `api_key = "abcdef1234567890abcde"`,
}

# deny fires for password assignment
test_deny_password_assignment if {
    some msg in data.governance.security.deny
    msg.id == "hardcoded-credential"
} with input as {
    "filename":      "app.go",
    "file_contents": `password = "supersecretpassword12345"`,
}

# deny fires for access_token with colon separator (YAML style)
test_deny_access_token_yaml if {
    some msg in data.governance.security.deny
    msg.id == "hardcoded-credential"
} with input as {
    "filename":      "config.yaml",
    "file_contents": `access_token: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9abc"`,
}

# deny does NOT fire for a clean file with no credential patterns
test_no_deny_clean_file if {
    count(data.governance.security.deny) == 0
} with input as {
    "filename":      "main.go",
    "file_contents": `x := os.Getenv("API_KEY")`,
}

# deny does NOT fire for .example files (excluded)
test_no_deny_example_file if {
    count(data.governance.security.deny) == 0
} with input as {
    "filename":      "config.example",
    "file_contents": `api_key = "abcdef1234567890abcde"`,
}

# deny does NOT fire for _test.go files (excluded)
test_no_deny_test_go_file if {
    count(data.governance.security.deny) == 0
} with input as {
    "filename":      "config_test.go",
    "file_contents": `password = "testpassword1234567890"`,
}

# deny does NOT fire for go.sum (excluded)
test_no_deny_go_sum if {
    count(data.governance.security.deny) == 0
} with input as {
    "filename":      "go.sum",
    "file_contents": `api_key = "abcdef1234567890abcde"`,
}

# deny does NOT fire for short values (under 20 characters)
test_no_deny_short_value if {
    count(data.governance.security.deny) == 0
} with input as {
    "filename":      "config.go",
    "file_contents": `api_key = "short"`,
}
