*Question.* Which ~50 GPUs (and merchant GPU-class accelerators) are most prevalent in AI training worldwide
as of 2026-11-10, and for each: VRAM, manufacturer, new-unit price, how scarce it is through three channels,
and where it can be rented.

*Scope and selection.* The list was fixed before research by Claude Code from installed-base prevalence in
training clusters, clouds and research labs: NVIDIA data-center parts from Volta (V100) through Blackwell Ultra
(GB300/B300), China-market variants (H800, H20, A800, L20), workstation and consumer cards widely used for
fine-tuning (RTX PRO 6000, RTX 6000 Ada, RTX 5090/4090/3090, etc.), AMD Instinct MI210 through MI355X, Intel
Gaudi 2/3 and Max 1550, and Huawei Ascend 910B/910C. Cloud-only ASICs that cannot be bought as hardware
(Google TPU, AWS Trainium/Inferentia, Meta MTIA) are excluded. Gaudi and Ascend are not GPUs strictly but are
included because they are bought and deployed as GPU alternatives. NVIDIA Rubin is excluded as not yet
prevalent. "Most prevalent" is a judgement, not a measured ranking; the table is ordered by VRAM, not prevalence.

*Ordering.* VRAM per GPU descending, then manufacturer, then name.

*Prices.* USD for one new unit. Where a part is only sold inside 8-GPU baseboards or racks (e.g. GB200/GB300,
MI355X), the per-GPU figure is derived from system pricing and marked as such. Consumer cards show MSRP to
typical 2026 street. Blank means no reliable new price was found (often end-of-life). Research ran from Israel
without US egress, so figures come from vendor pages, press and analyst reports rather than live US retailer
stock.

*Scarcity indexes (integer 1–5 per channel).*
- 1 — readily available, many providers, no meaningful wait.
- 2 — generally available, occasional quota or capacity limits.
- 3 — available but constrained: quotas, waitlists, few providers or sales-led only.
- 4 — hard to get: very few providers, long lead times, allocation, or grey-market only.
- 5 — effectively unobtainable through that channel: not offered, export-banned or end-of-life without stock.

*Channels.* Serverless = per-second/per-request GPU platforms (Modal, RunPod Serverless, Baseten, Replicate, fal,
Beam, Cerebrium, Koyeb, Cloud Run GPUs, Azure Container Apps, Cloudflare Workers AI, Huawei ModelArts).
Dedicated cloud = on-demand or reserved instances on hyperscalers (AWS, Azure, GCP, OCI) and neoclouds
(CoreWeave, Lambda, Nebius, Crusoe, RunPod, Vast.ai, etc.). New hardware = buying new units today. Composite =
unweighted mean of the three, a rough global picture.

*Process.* Four parallel research agents (Claude Sonnet) each covered ~12 GPUs with web search, citing 2–4 URLs
read per row and rating row confidence; Claude Code (Opus) merged, spot-checked and rendered. Scores are
analyst judgement from those sources, not measured data. Raw batch files are kept in `work/`.
