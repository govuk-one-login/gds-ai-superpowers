# WCAG 1.4.3 Contrast (Minimum) (AA) — deep

> Pending the programme accessibility owner's review (like the WCAG spine).
> Technique and thresholds-by-reference — **not** a restatement of the normative SC text.

Pull when 1.4.3 applicability or a contrast call is contested or unclear.

**How to test (technique)**
- Thresholds (per the SC): normal text **4.5:1**, large text (≥18pt, or ≥14pt bold) **3:1**.
  Measure foreground vs the *actual* background behind the text (gradient/image → worst case).
- Tools: a contrast checker / browser devtools; on device, design-token values. Test every
  state (hover, focus, disabled is exempt, placeholder is NOT exempt as it conveys content).

**Pitfalls**
- Text over an image or gradient where one region fails (use a scrim/overlay).
- Brand colours that pass for large text only, used at body size.
- Treating placeholder/secondary text as exempt — it carries info and must pass.
- Confusing this with 1.4.11 (non-text/UI-component contrast — separate SC).

**Example / anti-example**
- *Bad:* #999 on #fff body text ≈ 2.8:1 — fails.
- *Good:* #595959 on #fff ≈ 7:1 — passes for normal text with margin.

**Source (gated web)**: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum (normative + techniques — do not copy).
