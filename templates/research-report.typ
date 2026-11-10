// Shared Typst template for dated research reports in this notebook.
// A report's report.typ imports this and calls `report.with(meta: json("meta.json"))`.
// meta.json fields: title, subtitle, date (YYYY-MM-DD), researched_by, model, valid_note.

#let report(meta: (:), paper: "a4", flipped: true, body) = {
  set document(title: meta.title, author: meta.researched_by)
  set page(
    paper: paper,
    flipped: flipped,
    margin: (x: 1.4cm, y: 1.6cm),
    header: context {
      set text(7.5pt, fill: luma(90))
      grid(
        columns: (1fr, auto),
        meta.title,
        [Research date: *#meta.date* · #meta.researched_by],
      )
      line(length: 100%, stroke: 0.4pt + luma(170))
    },
    footer: context {
      set text(7.5pt, fill: luma(90))
      grid(
        columns: (1fr, auto),
        [Point-in-time snapshot taken #meta.date. #meta.valid_note],
        counter(page).display("1 / 1", both: true),
      )
    },
  )
  set text(font: ("Liberation Sans", "DejaVu Sans"), size: 9pt)
  set par(justify: false)
  show heading.where(level: 1): set text(13pt)
  show heading.where(level: 2): set text(11pt)
  show link: set text(fill: rgb("#1f4e9a"))

  block(width: 100%, inset: (bottom: 6pt))[
    #text(18pt, weight: "bold", meta.title) \
    #text(10pt, fill: luma(60), meta.subtitle) \
    #v(2pt)
    #box(fill: rgb("#fff3cd"), inset: 5pt, radius: 3pt, stroke: 0.5pt + rgb("#e0b84c"))[
      #text(8.5pt)[*Research conducted #meta.date by #meta.researched_by (#meta.model).*
      AI-assisted desk research from public sources read on that date. Prices, stock and
      cloud availability change quickly: re-verify before any purchase decision.]
    ]
  ]
  body
}

// Colour a 1-5 scarcity score: green (available) to red (scarce).
#let scarcity-cell(v) = {
  let n = float(if v == "" { "0" } else { v })
  let fill = if n == 0 { white } else if n < 1.75 { rgb("#c8e6c9") } else if n < 2.5 { rgb("#e6f2c2") } else if n < 3.25 { rgb("#fff3b0") } else if n < 4.25 { rgb("#ffd8a8") } else { rgb("#f5b7b1") }
  table.cell(fill: fill, align(center, v))
}

// "12000", "15000" -> "$12,000-15,000"
#let usd(v) = {
  if v == "" { return "" }
  let s = str(int(float(v)))
  let out = ""
  let n = s.len()
  for (i, c) in s.clusters().enumerate() {
    if i > 0 and calc.rem(n - i, 3) == 0 { out += "," }
    out += c
  }
  out
}
#let price-range(lo, hi) = {
  if lo == "" and hi == "" { [—] }
  else if hi == "" or lo == hi { [\$#usd(if lo == "" { hi } else { lo })] }
  else if lo == "" { [\$#usd(hi)] }
  else { [\$#usd(lo)–#usd(hi)] }
}
