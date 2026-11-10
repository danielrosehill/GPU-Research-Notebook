#!/usr/bin/env python3
"""Tag each row of a research data.csv with four-tier labels from a rubric JSON.

Usage (from repo root):
  uv run --no-project python scripts/apply_tiers.py rubrics/gpu-four-tier.json \
    research/2026-11-10-top-50-ai-training-gpus/data.csv

Adds/overwrites: cost_mid_usd, vram_tier, vram_tier_label, cost_tier, cost_tier_label,
scarcity_tier, scarcity_tier_label. Edits data.csv in place. Stdlib only.
"""
import csv
import json
import sys


def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def tier_for(x, tiers):
    if x is None:
        return "", ""
    for t in tiers:
        if x >= t["min"] and (t["max"] is None or x < t["max"]):
            return str(t["tier"]), t["label"]
    return "", ""


def main(rubric_path, data_path):
    rubric = json.load(open(rubric_path))["dimensions"]
    with open(data_path, newline="", encoding="utf-8") as f:
        r = csv.DictReader(f)
        header, rows = list(r.fieldnames), list(r)

    inputs = {
        "vram": lambda row: num(row["vram_gb"]),
        "cost": lambda row: num(row["cost_mid_usd"]),
        "scarcity": lambda row: num(row["scarcity_composite"]),
    }
    for row in rows:
        prices = [p for p in (num(row["new_price_usd_low"]), num(row["new_price_usd_high"])) if p is not None]
        row["cost_mid_usd"] = f"{sum(prices) / len(prices):.0f}" if prices else ""
        for dim, spec in rubric.items():
            row[spec["column"]], row[spec["column"] + "_label"] = tier_for(inputs[dim](row), spec["tiers"])

    for col in ["cost_mid_usd"] + [c for s in rubric.values() for c in (s["column"], s["column"] + "_label")]:
        if col not in header:
            header.append(col)
    with open(data_path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=header)
        w.writeheader()
        w.writerows(rows)
    print(f"tagged {len(rows)} rows in {data_path}")


if __name__ == "__main__":
    main(*sys.argv[1:3])
