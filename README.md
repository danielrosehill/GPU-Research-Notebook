# GPU Research Notebook

A mini notebook for researching GPUs: specs, comparisons, pricing, availability and anything else worth writing down along the way.

## Layout

- `notes/` — one Markdown file per GPU, comparison or research question, named `YYYY-MM-DD-topic.md`.
- `research/YYYY-MM-DD-slug/` — structured research runs: `data.csv` + Typst `report.pdf`, dated and marked as researched by Claude Code.
- `.claude/skills/gpu-research/` — the end-to-end skill for those runs (research → CSV → PDF).
- `templates/research-report.typ` — shared Typst template (date banner, header, footer, scarcity colouring).
- `scripts/merge_csv.py` — merges per-agent batch CSVs, adds composite columns, sorts and ranks.

## Research index

| Date | Topic |
|---|---|
| 2026-11-10 | [Top 50 GPUs for AI training: VRAM, price, scarcity, availability](research/2026-11-10-top-50-ai-training-gpus/) |

## Conventions

- Date every note and research run (absolute dates) and cite sources.
- Mark figures as confirmed (read from a source) or assumed.
- Prices: state currency, region and the date seen.
- Never overwrite an old snapshot: a re-run is a new dated folder.
