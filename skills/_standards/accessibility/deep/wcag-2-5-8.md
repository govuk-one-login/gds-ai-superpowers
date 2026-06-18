# WCAG 2.5.8 Target Size (Minimum) (AA, new in 2.2) — deep

> Pending the programme accessibility owner's review (like the WCAG spine).
> Technique and thresholds-by-reference — **not** a restatement of the normative SC text.

Pull when 2.5.8 applicability is contested or unclear (often missed — it's new in WCAG 2.2).

**How to test (technique)**
- Minimum target **24×24 CSS px** (per the SC), OR sufficient spacing so a 24px circle centred
  on the target doesn't overlap a neighbour. Measure the hit target, not just the visible icon.
- Exceptions (per the SC): inline targets in a sentence, an equivalent control meeting the size
  elsewhere, or where the presentation is essential/UA-controlled.
- iOS/Android note: native platform guidance is larger (44pt iOS / 48dp Android) — meeting the
  platform HIG generally satisfies 2.5.8, but verify custom controls.

**Pitfalls**
- A 16px icon button with no padding to enlarge the touch target.
- Densely packed icon rows (toolbars, table-row actions) failing the spacing alternative.
- Measuring the glyph rather than the tappable area.

**Example / anti-example**
- *Bad:* 18px close "×" with 18px hit area, adjacent to another control.
- *Good:* same glyph with padding to a 24×24+ hit target (or 44pt/48dp on native).

**Source (gated web)**: https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum (normative + techniques — do not copy).
