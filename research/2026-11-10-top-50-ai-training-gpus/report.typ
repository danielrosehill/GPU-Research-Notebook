#import "/templates/research-report.typ": report, scarcity-cell, price-range
#let meta = json("meta.json")
#let rows = csv("data.csv", row-type: dictionary)
#let list-cell(v) = v.split(";").map(s => s.trim()).filter(s => s != "").join(", ")
#show: report.with(meta: meta, paper: "a4", flipped: true)

= Summary table

Scarcity indexes run 1 (readily available) to 5 (effectively unobtainable through that channel).
*Srv* = serverless inference platforms; *Ded* = dedicated cloud instances (hyperscalers and neoclouds);
*New* = buying new hardware; *Comp* = composite, the mean of the three. Prices are USD per new unit;
see the appendix for what each price represents.

#set text(7pt)
#table(
  columns: (auto, 1.5fr, auto, auto, auto, 1fr, auto, auto, auto, auto, 2.2fr, 1.4fr),
  inset: 3pt,
  stroke: 0.3pt + luma(180),
  align: (x, y) => if x in (0, 3) { right } else { left },
  table.header(
    ..([\#], [GPU], [Maker], [VRAM GB], [Memory], [New price (USD)], [Srv], [Ded], [New], [Comp], [Cloud availability], [Regions]).map(h => table.cell(fill: luma(225), strong(h))),
  ),
  ..rows.map(r => (
    r.rank,
    strong(r.gpu),
    r.manufacturer,
    r.vram_gb,
    r.memory_type,
    price-range(r.new_price_usd_low, r.new_price_usd_high),
    scarcity-cell(r.scarcity_serverless),
    scarcity-cell(r.scarcity_cloud_dedicated),
    scarcity-cell(r.scarcity_new_hardware),
    scarcity-cell(r.scarcity_composite),
    list-cell(r.clouds),
    list-cell(r.regions),
  )).flatten(),
)

#set text(9pt)
#pagebreak()
#include "tiers.typ"

#set text(9pt)
#pagebreak()
#include "physical.typ"

#set text(9pt)
#pagebreak()
= Method

#include "method.typ"

#pagebreak()
= Appendix: price basis, confidence and sources

#set text(6.5pt)
#table(
  columns: (auto, 1.1fr, auto, auto, 2.4fr, 2.6fr),
  inset: 3pt,
  stroke: 0.3pt + luma(180),
  table.header(
    ..([\#], [GPU], [Arch / form], [Conf.], [Price basis], [Sources]).map(h => table.cell(fill: luma(225), strong(h))),
  ),
  ..rows.map(r => (
    r.rank,
    strong(r.gpu),
    [#r.architecture \ #r.form_factor \ #r.launch_year],
    r.confidence,
    r.price_basis,
    [#r.sources.split(";").map(s => s.trim()).filter(s => s != "").map(s => link(s, s)).join(linebreak()) \ _Physical/power (#r.confidence_physical):_ \ #r.sources_physical.split(";").map(s => s.trim()).filter(s => s != "").map(s => link(s, s)).join(linebreak())],
  )).flatten(),
)
