#!/usr/bin/env python3
"""check_coverage.py — cross-reference invariants.json against Agent-Evaluation datasets.

Reads registry/invariants.json and reports which invariants have no linked
Agent-Evaluation scenario IDs (agent_evaluation.scenario_ids is empty).

This script is informational only — it exits 0 regardless of coverage gaps so
that CI is never blocked. Coverage gaps are expected at project inception and
are tracked in the invariant registry as they are addressed.

Usage:
    python scripts/check_coverage.py
    python scripts/check_coverage.py --registry registry/invariants.json
"""

import argparse
import json
import sys
from pathlib import Path


def load_invariants(path: Path) -> list:
    with path.open() as f:
        return json.load(f)


def check_coverage(invariants: list) -> list:
    """Return a list of invariants with no linked scenario IDs."""
    gaps = []
    for inv in invariants:
        scenario_ids = inv.get("agent_evaluation", {}).get("scenario_ids", [])
        if not scenario_ids:
            gaps.append(inv)
    return gaps


def main() -> int:
    parser = argparse.ArgumentParser(description="Check invariant coverage against Agent-Evaluation scenarios.")
    parser.add_argument(
        "--registry",
        default="registry/invariants.json",
        help="Path to invariants.json (default: registry/invariants.json)",
    )
    args = parser.parse_args()

    registry_path = Path(args.registry)
    if not registry_path.exists():
        print(f"ERROR: registry file not found: {registry_path}", file=sys.stderr)
        return 1

    invariants = load_invariants(registry_path)
    gaps = check_coverage(invariants)

    total = len(invariants)
    covered = total - len(gaps)

    print(f"Coverage report — {covered}/{total} invariants have Agent-Evaluation scenarios linked.")
    print()

    if gaps:
        print("Coverage gaps (no scenario_ids linked):")
        for inv in gaps:
            print(f"  {inv['id']}  [{inv['severity']}]  {inv['description'][:80]}")
    else:
        print("All invariants have at least one linked scenario ID.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
