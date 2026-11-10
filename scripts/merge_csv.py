#!/usr/bin/env python3
"""Merge batch CSVs from parallel research agents into one dated data.csv.

Stdlib only. Run with: uv run --no-project python scripts/merge_csv.py ...

Example (top-50 GPU research, 2026-11-10):
  uv run --no-project python scripts/merge_csv.py \
    --out research/2026-11-10-top-50-ai-training-gpus/data.csv \
    --sort "vram_gb:desc,manufacturer,gpu" \
    --mean scarcity_composite=scarcity_serverless,scarcity_cloud_dedicated,scarcity_new_hardware \
    --rank rank \
    research/2026-11-10-top-50-ai-training-gpus/work/batch-*.csv

All inputs must share the same header. --mean appends a column holding the
1-decimal mean of the named numeric columns. --rank prepends a 1-based rank
column after sorting. Sort keys are compared numerically when both values
parse as floats, otherwise case-insensitively as text; blanks sort last.
"""
import argparse
import csv
import sys


def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("inputs", nargs="+")
    ap.add_argument("--out", required=True)
    ap.add_argument("--sort", default="")
    ap.add_argument("--mean", action="append", default=[])
    ap.add_argument("--rank", default="")
    a = ap.parse_args()

    header, rows = None, []
    for path in a.inputs:
        with open(path, newline="", encoding="utf-8") as f:
            r = csv.DictReader(f)
            if header is None:
                header = list(r.fieldnames)
            elif list(r.fieldnames) != header:
                sys.exit(f"header mismatch in {path}: {r.fieldnames}")
            rows += [{k: (v or "").strip() for k, v in row.items()} for row in r]

    for spec in a.mean:
        name, cols = spec.split("=", 1)
        cols = cols.split(",")
        for row in rows:
            vals = [num(row[c]) for c in cols]
            vals = [v for v in vals if v is not None]
            row[name] = f"{sum(vals) / len(vals):.1f}" if vals else ""
        header.append(name)

    for key in reversed([k for k in a.sort.split(",") if k]):
        col, _, direction = key.partition(":")
        desc = direction == "desc"
        numeric = all(num(r[col]) is not None for r in rows if r[col])

        def k(r, col=col, numeric=numeric):
            return num(r[col]) if numeric else r[col].lower()

        filled = sorted((r for r in rows if r[col]), key=k, reverse=desc)
        rows = filled + [r for r in rows if not r[col]]

    if a.rank:
        header.insert(0, a.rank)
        for i, row in enumerate(rows, 1):
            row[a.rank] = str(i)

    with open(a.out, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=header)
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {len(rows)} rows to {a.out}")


if __name__ == "__main__":
    main()
