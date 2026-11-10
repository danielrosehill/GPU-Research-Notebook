#!/usr/bin/env python3
"""Left-join extra columns from enrichment CSVs onto an existing data.csv, in place.

Stdlib only. Run with: uv run --no-project python scripts/join_csv.py ...

Example (physical/power/noise/rack enrichment of the 2026-11-10 top-50):
  uv run --no-project python scripts/join_csv.py \
    --key gpu \
    research/2026-11-10-top-50-ai-training-gpus/data.csv \
    research/2026-11-10-top-50-ai-training-gpus/work/physical-*.csv

Several enrichment files may cover the same keys with different columns
(e.g. physical-*.csv plus noise-map.csv). Row order of data.csv is kept. Enrichment columns are appended (or overwritten
if already present, so re-runs are idempotent). Exits non-zero if any key is
missing from either side, so a mistyped GPU name cannot silently drop a row.
"""
import argparse
import csv
import sys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("base")
    ap.add_argument("extras", nargs="+")
    ap.add_argument("--key", required=True)
    a = ap.parse_args()

    extra_cols, extra = [], {}
    for path in a.extras:
        with open(path, newline="") as f:
            r = csv.DictReader(f)
            for c in r.fieldnames:
                if c != a.key and c not in extra_cols:
                    extra_cols.append(c)
            for row in r:
                k = row[a.key].strip()
                cur = extra.setdefault(k, {})
                clash = [c for c in row if c != a.key and c in cur]
                if clash:
                    sys.exit(f"duplicate {k!r} for columns {clash} (in {path})")
                cur.update(row)

    with open(a.base, newline="") as f:
        r = csv.DictReader(f)
        base_cols = [c for c in r.fieldnames if c not in extra_cols]
        rows = list(r)

    keys = {row[a.key] for row in rows}
    missing = sorted(keys - extra.keys())
    unknown = sorted(extra.keys() - keys)
    if missing or unknown:
        sys.exit(f"key mismatch\n  no enrichment for: {missing}\n  not in base: {unknown}")

    with open(a.base, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=base_cols + extra_cols, extrasaction="ignore")
        w.writeheader()
        for row in rows:
            row.update({c: extra[row[a.key]].get(c, "") for c in extra_cols})
            w.writerow(row)
    print(f"joined {len(extra_cols)} columns onto {len(rows)} rows -> {a.base}")


if __name__ == "__main__":
    main()
