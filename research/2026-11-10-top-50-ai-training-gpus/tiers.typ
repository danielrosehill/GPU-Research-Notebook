// Four-tier stratification: rubric from /rubrics/gpu-four-tier.json, applied to data.csv.
#let rubric = json("/rubrics/gpu-four-tier.json")
#let rows = csv("data.csv", row-type: dictionary)
#let short(name) = name.replace("NVIDIA ", "").replace("AMD Instinct ", "").replace("AMD ", "").replace("Intel ", "").replace("Huawei ", "").replace("GeForce ", "")
#let fmt(v) = if v == none { "" } else { str(v) }

= Four-tier stratification

Each GPU gets a tier from 1 (least of the attribute) to 4 (most) on three axes. Rubric version
#rubric.version, file `rubrics/gpu-four-tier.json`. #rubric.convention

#set text(8pt)
#grid(columns: (1fr, 1fr, 1fr), gutter: 8pt,
  ..rubric.dimensions.pairs().map(((dim, spec)) => [
    *#(if dim == "vram" { "VRAM" } else { upper(dim.first()) + dim.slice(1) })* — #emph(spec.source)
    #table(columns: (auto, auto, auto, 1fr), inset: 3pt, stroke: 0.3pt + luma(180),
      table.header(..([T], [Label], [Range], [Meaning]).map(h => table.cell(fill: luma(225), strong(h)))),
      ..spec.tiers.map(t => (str(t.tier), t.label,
        if t.max == none { [≥ #fmt(t.min)] } else { [#fmt(t.min)–<#fmt(t.max)] }, t.meaning)).flatten())
  ]))

#v(6pt)
== Grid: VRAM tier × scarcity tier

Rows are VRAM tiers (Frontier at top), columns scarcity tiers (Abundant at left). Each name carries its
cost tier: *C1* Budget … *C4* Premium, *C?* no reliable new price. The top-left corner (big memory, easy to
get) is where buyers want to be. It is nearly empty: memory and availability trade off against each other.

#let vlabels = ("4": "Frontier", "3": "High", "2": "Mid", "1": "Entry")
#let slabels = ("1": "Abundant", "2": "Available", "3": "Constrained", "4": "Scarce")
#let fills = ("1": rgb("#c8e6c9"), "2": rgb("#e6f2c2"), "3": rgb("#ffd8a8"), "4": rgb("#f5b7b1"))
#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  inset: 4pt,
  stroke: 0.4pt + luma(170),
  table.header(table.cell(fill: luma(225))[*VRAM \\ Scarcity*],
    ..("1", "2", "3", "4").map(s => table.cell(fill: fills.at(s), align(center, strong[S#s #slabels.at(s)])))),
  ..("4", "3", "2", "1").map(v => (
    table.cell(fill: luma(235), strong[V#v #vlabels.at(v)]),
    ..("1", "2", "3", "4").map(s => {
      let hits = rows.filter(r => r.vram_tier == v and r.scarcity_tier == s)
      hits.map(r => [#short(r.gpu) #text(fill: luma(100))[(C#if r.cost_tier == "" { "?" } else { r.cost_tier })]]).join(linebreak())
    }),
  )).flatten(),
)
