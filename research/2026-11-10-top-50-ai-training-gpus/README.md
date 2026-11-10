# Top 50 GPUs for AI training — 2026-11-10

Researched 2026-11-10 by Claude Code (claude-opus-5-5; research agents on Sonnet). Point-in-time snapshot: treat as stale after ~60 days.

- `data.csv`: the dataset (ranked by VRAM desc, then manufacturer, then name).
- `report.pdf`: rendered report (summary table, method, appendix with price basis and sources).
- `method.typ`: scope, selection, price rules and the 1–5 scarcity rubric (also page 2 of the PDF).
- `work/batch-{a,b,c,d}.csv`: raw agent output before merge.

Columns: `rank, gpu, manufacturer, architecture, form_factor, vram_gb, memory_type, launch_year, new_price_usd_low, new_price_usd_high, price_basis, scarcity_serverless, scarcity_cloud_dedicated, scarcity_new_hardware, clouds, regions, confidence, sources, scarcity_composite`.

Rebuild: from repo root, `uv run --no-project python scripts/merge_csv.py --out research/2026-11-10-top-50-ai-training-gpus/data.csv --sort "vram_gb:desc,manufacturer,gpu" --mean scarcity_composite=scarcity_serverless,scarcity_cloud_dedicated,scarcity_new_hardware --rank rank research/2026-11-10-top-50-ai-training-gpus/work/batch-*.csv` then `typst compile --root . research/2026-11-10-top-50-ai-training-gpus/report.typ`.
