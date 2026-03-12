#!/usr/bin/env python3
"""export_invariants.py — output the invariant list for consumers.

Reads registry/invariants.json and writes a consumer-friendly summary to
stdout (or a file). Consumers — such as Policy-LSP or Agent-Evaluation — pull
this repo and run this script to get a stable, machine-readable list of active
invariants and the Rego rules that enforce them.

Output formats:
    json   — full invariant objects (default)
    tsv    — tab-separated: id, severity, rule_id, policy_file, description

Usage:
    python scripts/export_invariants.py
    python scripts/export_invariants.py --format tsv
    python scripts/export_invariants.py --format json --status active
    python scripts/export_invariants.py --output invariants_export.json
"""

import argparse
import json
import sys
from pathlib import Path


def load_invariants(path: Path) -> list:
    with path.open() as f:
        return json.load(f)


def filter_invariants(invariants: list, status: str | None) -> list:
    if status is None:
        return invariants
    return [inv for inv in invariants if inv.get("status") == status]


def format_json(invariants: list) -> str:
    return json.dumps(invariants, indent=2)


def format_tsv(invariants: list) -> str:
    lines = ["id\tseverity\trule_id\tpolicy_file\tdescription"]
    for inv in invariants:
        line = "\t".join([
            inv.get("id", ""),
            inv.get("severity", ""),
            inv.get("rule_id", ""),
            inv.get("policy_file", ""),
            inv.get("description", "").replace("\n", " "),
        ])
        lines.append(line)
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Export invariant list for consumers.")
    parser.add_argument(
        "--registry",
        default="registry/invariants.json",
        help="Path to invariants.json (default: registry/invariants.json)",
    )
    parser.add_argument(
        "--format",
        choices=["json", "tsv"],
        default="json",
        help="Output format: json (default) or tsv",
    )
    parser.add_argument(
        "--status",
        choices=["active", "draft", "deprecated"],
        default=None,
        help="Filter by status (default: all)",
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Output file path (default: stdout)",
    )
    args = parser.parse_args()

    registry_path = Path(args.registry)
    if not registry_path.exists():
        print(f"ERROR: registry file not found: {registry_path}", file=sys.stderr)
        return 1

    invariants = load_invariants(registry_path)
    invariants = filter_invariants(invariants, args.status)

    if args.format == "json":
        output = format_json(invariants)
    else:
        output = format_tsv(invariants)

    if args.output:
        Path(args.output).write_text(output)
        print(f"Exported {len(invariants)} invariants to {args.output}")
    else:
        print(output)

    return 0


if __name__ == "__main__":
    sys.exit(main())
