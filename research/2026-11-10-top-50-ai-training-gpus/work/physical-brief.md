# Brief: physical/power/noise/rack enrichment (2026-11-10)

Today is 2026-11-10. Research physical deployment attributes for each GPU listed and write a CSV.

Output: exactly this header, one row per GPU, `gpu` copied VERBATIM from the list (it is the join key):

gpu,board_power_w,power_connector,psu_needed,psu_needed_w,cooling,noise_dba,noise_basis,physical_form,rack_mountable,rack_notes,confidence_physical,sources_physical

Field rules:
- board_power_w: vendor TDP/TBP of one GPU (number; if variants differ, the main variant, note others in psu_needed).
- power_connector: e.g. "1x 12V-2x6 (16-pin)", "2x 8-pin PCIe", "CPU 8-pin (EPS)", "via baseboard (54V/48V busbar)".
- psu_needed: short text on what power supply a buyer needs. Single PCIe card: vendor-recommended system PSU for a 1-card workstation (e.g. "1000W ATX 3.1 (NVIDIA rec.)"); if no vendor rec., state the inferred figure and say "inferred". Datacenter-only parts (SXM/OAM/superchip/rack): the system/node figure, e.g. "8-GPU HGX node ~14.3 kW max; 6x 3.3 kW PSUs (DGX H100 spec)", or rack figure for NVL72 (~120-140 kW, liquid). Include 3-phase/208-415V needs where relevant.
- psu_needed_w: one number in watts matching psu_needed (system PSU for cards, node max for modules, rack for NVL72). Blank if unknown.
- cooling: passive (needs chassis airflow) / blower / open-air axial / liquid / air or liquid.
- noise_dba: number or range in dBA. Note honestly what it is. Consumer/workstation cards: measured review figures under load (say distance). Passive datacenter cards have no fan of their own: give the host server/system noise if published (e.g. DGX spec sheets, OEM acoustic specs, reviews), else blank. Never invent a number.
- noise_basis: what the figure measures and how obtained, e.g. "card, TechPowerUp review, gaming load, 50cm", "DGX B200 system, vendor spec", "inferred from typical 8-GPU 4U/8U server" (mark inferred).
- physical_form: slots, length/height, or module type; e.g. "PCIe FHFL dual-slot, 267mm", "OAM module", "SXM5 on HGX 8-GPU baseboard".
- rack_mountable: one of: "Rack-native" (only ships in rack servers/racks), "Yes (passive, needs server airflow)", "Yes, with caveats" (fits some rack chassis, e.g. blower or workstation cards in 4U GPU servers, or consumer cards that need 4U+ open chassis / power adapters), "No / impractical".
- rack_notes: typical chassis and U height (e.g. "DGX/HGX 8U air or 4U liquid", "2U 4-GPU or 4U 8-10-GPU PCIe servers", "NVL72 = one 48U liquid-cooled rack ~1.36 t"), plus gotchas (power connector orientation, card height above 4U clearance, blower vs open-air in dense racks, rack weight, liquid plumbing).
- confidence_physical: high/medium/low.
- sources_physical: 2-4 URLs you actually read, `;`-separated.

Quote any field containing commas (standard CSV). No blank lines, no commentary in the file. Egress is not in the US; prefer vendor datasheets, OEM server spec sheets, and reviews (TechPowerUp, ServeTheHome, Tom's Hardware, Phoronix, Gamers Nexus) for acoustics.
