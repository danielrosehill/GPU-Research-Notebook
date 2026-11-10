---
name: gpu-research
description: Run a dated, end-to-end research job for the GPU Research Notebook - gather current GPU data from the web, write it to a dated CSV, then render a Typst PDF stamped with the research date and "researched by Claude Code". Use for any new GPU table, comparison, pricing, scarcity or availability question in this repo.
---

# GPU research (CSV -> Typst PDF, always dated)

GPU prices, stock and cloud availability go stale within weeks. Every output this skill
produces carries the absolute date the research was done, in the folder name, the CSV
companion `meta.json`, and the PDF header, banner and footer.

## Output layout

```
research/YYYY-MM-DD-<slug>/
  data.csv       canonical dataset (one row per item, sources column per row)
  meta.json      title, subtitle, date, researched_by, model, valid_note
  report.typ     imports ../../templates/research-report.typ, lays out data.csv
  report.pdf     rendered output (committed)
  README.md      question, scope, column definitions, rubric, caveats
  work/          raw per-batch CSVs from research agents (kept for audit)
```

`YYYY-MM-DD` is today's date (`date +%F`), never a remembered date. A re-run of the same
question is a new folder with a new date; never overwrite an older snapshot.

## Steps

1. **Frame.** Pin the question, the item list, the columns and any scoring rubric in
   `README.md` before researching. Rubrics must define both ends of the scale.
2. **Research in parallel.** Split items into batches of ~12 and launch one research agent
   per batch in a single message (`model: sonnet`). Each prompt carries today's date, the
   exact CSV header, field rules, the rubric, and an absolute output path
   `work/batch-<x>.csv`. Agents must cite 2-4 URLs they actually read per row and rate
   row confidence high/medium/low. Tell them egress is not in the US, so retailer stock
   pages are geo-skewed: prefer vendor pages, published reports and news.
3. **Merge.** `uv run --no-project python scripts/merge_csv.py --out <dir>/data.csv
   --sort ... [--mean name=a,b,c] [--rank rank] <dir>/work/batch-*.csv`
   (see the script docstring). Spot-check outliers (prices off by 10x, a scarcity score
   that contradicts the clouds column) and fix in the batch file, then re-merge.
4. **Meta.** Write `meta.json` with `date` = today, `researched_by` = "Claude Code",
   `model` = the model ID doing the run.
5. **Render.** Copy the newest `research/*/report.typ` as a starting point, adapt columns,
   then `typst compile --root . <dir>/report.typ` from the repo root. Open the PDF
   (or `pdftotext`) to check nothing overflows.
6. **Ship.** Commit the folder and push.

## Conventions

- Currency USD unless stated; say whether a price is MSRP, street, OEM or derived.
- Scarcity scores: 1 = readily available, 5 = effectively unobtainable via that channel.
- Mark anything inferred rather than read as such in the relevant basis/notes column.
