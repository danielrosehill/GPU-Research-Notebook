# Top 50 GPUs for AI training — 2026-11-10

Researched 2026-11-10 by Claude Code (claude-opus-5-5; research agents on Sonnet). Point-in-time snapshot: treat as stale after ~60 days.

- `data.csv`: the dataset (ranked by VRAM desc, then manufacturer, then name).
- `report.pdf`: rendered report (summary table, method, appendix with price basis and sources).
- `tiers.typ`: four-tier stratification (VRAM, cost, scarcity) from `rubrics/gpu-four-tier.json`, plus a VRAM x scarcity grid with cost tier per GPU (page 4 of the PDF).
- `method.typ`: scope, selection, price rules and the 1–5 scarcity rubric (also page 2 of the PDF).
- `physical.typ`: power, noise, form factor and rack fit section (pages 5-10 of the PDF), plus a host-system acoustics reference table.
- `work/batch-{a,b,c,d}.csv`: raw agent output before merge.
- `work/physical-{a,b,c,d}.csv`, `work/noise-systems.csv`, `work/noise-map.csv`, `work/physical-brief.md`: enrichment added 2026-11-10 (same day, same snapshot): the brief the agents followed, their per-GPU output, published server/rack acoustic figures, and the GPU -> system-noise mapping.

Columns: `rank, gpu, manufacturer, architecture, form_factor, vram_gb, memory_type, launch_year, new_price_usd_low, new_price_usd_high, price_basis, scarcity_serverless, scarcity_cloud_dedicated, scarcity_new_hardware, clouds, regions, confidence, sources, scarcity_composite, cost_mid_usd, vram_tier, vram_tier_label, cost_tier, cost_tier_label, scarcity_tier, scarcity_tier_label, board_power_w, power_connector, psu_needed, psu_needed_w, cooling, noise_dba, noise_basis, physical_form, rack_mountable, rack_notes, confidence_physical, sources_physical, noise_system_dba`. Tiers: 1 = least of the attribute, 4 = most.

Power, noise and rack columns:
- `psu_needed` / `psu_needed_w`: for a PCIe card, the system PSU for a one-card workstation; for SXM/OAM/superchip parts, the 8-GPU node power; for NVL72, the whole rack. Many figures are marked "inferred" (no vendor recommendation found).
- `noise_dba`: the card's own noise under load, from a review. Only 5 of the 50 have one (RTX 5090, 4090, 3090, RTX PRO 6000 Workstation; RTX A6000 is indirect). Passive datacenter cards have no fan.
- `noise_system_dba`: host-server acoustic figure, mostly Dell PowerEdge technical-guide LpA,m bystander values at 25C and 100% GPU load (Dell prints "dB"; treated as A-weighted), plus Lenovo specs. A leading `~` and "proxy" mean the figure is from the same chassis class with a different GPU, not a measurement of that GPU. Blank means no published figure was found (DGX B200/B300 guides, HPE, Supermicro, Lenovo SR680a/SR685a, MI350X/MI355X, Gaudi, Ascend publish none that was readable).
- `rack_mountable`: `Rack-native` (ships only in rack servers/racks), `Yes (passive, needs server airflow)`, `Yes, with caveats` (workstation or consumer cards: blower/open-air, 4U+ clearance, top power connectors), `No / impractical`.
- Low physical confidence: MI250, MI250X, Ascend 910C/910B, H20, H800, A800, L20, Quadro RTX 8000, A10G, P100.

Rebuild: from repo root, `uv run --no-project python scripts/merge_csv.py --out research/2026-11-10-top-50-ai-training-gpus/data.csv --sort "vram_gb:desc,manufacturer,gpu" --mean scarcity_composite=scarcity_serverless,scarcity_cloud_dedicated,scarcity_new_hardware --rank rank research/2026-11-10-top-50-ai-training-gpus/work/batch-*.csv`, then `uv run --no-project python scripts/apply_tiers.py rubrics/gpu-four-tier.json research/2026-11-10-top-50-ai-training-gpus/data.csv`, then `uv run --no-project python scripts/join_csv.py --key gpu research/2026-11-10-top-50-ai-training-gpus/data.csv research/2026-11-10-top-50-ai-training-gpus/work/physical-*.csv research/2026-11-10-top-50-ai-training-gpus/work/noise-map.csv` (merge_csv drops joined columns, so this must follow it), then `typst compile --root . research/2026-11-10-top-50-ai-training-gpus/report.typ`.
