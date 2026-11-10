// Power, noise, form factor and rack fit: columns joined onto data.csv from work/physical-*.csv
// and work/noise-systems.csv (see README.md).
#let rows = csv("data.csv", row-type: dictionary)
#let systems = csv("work/noise-systems.csv", row-type: dictionary)
#let rack-colour(v) = if v.starts-with("Rack-native") { rgb("#dbe7f5") } else if v.starts-with("Yes (passive") { rgb("#dff0dc") } else if v.starts-with("Yes, with") { rgb("#fbefcf") } else { rgb("#f6d6d6") }

= Power, noise, form factor and rack fit

*Board W* is the vendor TDP/TBP of one GPU. *PSU needed* is what a buyer has to supply: the system PSU for a
one-card workstation when the GPU is a card, or the node (8-GPU server) or rack (NVL72) power figure when the GPU
only ships inside one. "Inferred" means no vendor recommendation was found. *Noise*: passive datacenter
GPUs have no fan, so their noise is the host server's. *Card* gives the card's own dBA from a review, where one
exists. *System* gives the published acoustic figure for the typical host (table at the end of this section).
*Rack*: #box(fill: rack-colour("Rack-native"), inset: 1.5pt)[Rack-native] ships only in rack servers;
#box(fill: rack-colour("Yes (passive"), inset: 1.5pt)[Passive] fits standard GPU servers, needs their airflow;
#box(fill: rack-colour("Yes, with"), inset: 1.5pt)[Caveats] workstation/consumer card, fits some 4U chassis;
#box(fill: rack-colour("No"), inset: 1.5pt)[No] not practical.

#set text(6pt)
#table(
  columns: (auto, 1.1fr, auto, 1fr, 1.9fr, 0.8fr, 0.9fr, 1.2fr, 2fr),
  inset: 2.5pt,
  stroke: 0.3pt + luma(180),
  align: (x, y) => if x in (0, 2) { right } else { left },
  table.header(
    ..([\#], [GPU], [Board W], [Connector], [PSU needed], [Cooling], [Noise (dBA)], [Physical form], [Rack fit]).map(h => table.cell(fill: luma(225), strong(h))),
  ),
  ..rows.map(r => (
    r.rank,
    strong(r.gpu),
    r.board_power_w,
    r.power_connector,
    r.psu_needed,
    r.cooling,
    [#if r.noise_dba != "" [Card: #r.noise_dba \ ] #if r.at("noise_system_dba", default: "") != "" [System: #r.noise_system_dba] #if r.noise_dba == "" and r.at("noise_system_dba", default: "") == "" [—]],
    r.physical_form,
    table.cell(fill: rack-colour(r.rack_mountable))[*#r.rack_mountable.split(" (").first().split(",").first()* — #r.rack_notes],
  )).flatten(),
)

#v(6pt)
== Host system acoustics (reference)

#set text(6.5pt)
#table(
  columns: (1.4fr, 1fr, auto, 2fr, 1.6fr),
  inset: 2.5pt,
  stroke: 0.3pt + luma(180),
  table.header(
    ..([System / card], [Represents], [dBA], [Basis], [Source]).map(h => table.cell(fill: luma(225), strong(h))),
  ),
  ..systems.map(s => (strong(s.item), s.applies_to_gpus.split(";").join(", "), s.noise_dba, s.noise_basis, link(s.source, s.source))).flatten(),
)
