# WCAG 1.3.1 Info and Relationships (A) — deep

> Pending the programme accessibility owner's review (like the WCAG spine).
> Technique and testing guidance — **not** a restatement of the normative SC text.

Pull when 1.3.1 applicability to a story is contested or unclear.

**How to test (technique, by platform)**
- **Web:** structure conveyed programmatically, not just visually — real `<h1-6>`, `<ul>/<ol>`,
  `<table>` with `<th scope>`, `<label for>`/`aria-labelledby`, `<fieldset>/<legend>`. Inspect
  the accessibility tree; tab + screen-reader (NVDA/VoiceOver) and confirm relationships announce.
- **iOS:** grouping via `accessibilityElement(children:)`, headings trait, correct label/value/trait.
- **Android:** `labelFor`, heading semantics, `LiveRegion`; TalkBack reads the relationship.

**Pitfalls**
- Visual-only structure: bold text used as a heading; a layout table; spacing implying grouping.
- A placeholder used instead of a real label (disappears, not reliably announced).
- ARIA added on top of wrong/absent semantics rather than using native elements.

**Example / anti-example**
- *Bad:* `<div class="h2">` styled to look like a heading; screen reader announces nothing.
- *Good:* a real `<h2>`; the form field has a persistent associated `<label>`.

**Source (gated web)**: https://www.w3.org/WAI/WCAG22/Understanding/info-and-relationships (normative text + techniques live here — do not copy).
