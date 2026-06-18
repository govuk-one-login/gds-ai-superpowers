# WCAG 4.1.2 Name, Role, Value (A) — deep

> Pending the programme accessibility owner's review (like the WCAG spine).
> Technique and testing guidance — **not** a restatement of the normative SC text.

Pull when 4.1.2 applicability is contested or unclear. The AT-critical SC for custom controls.

**How to test (technique)**
- Every interactive component exposes a **name** (accessible label), a **role** (what it is),
  and **value/state** (checked, expanded, selected) to assistive tech, and changes are notified.
- **Web:** prefer native elements (`<button>`, `<input>`, `<select>`); for custom widgets use
  the correct ARIA role + state (`aria-expanded`, `aria-checked`, `aria-selected`) and keep it
  in sync. Verify in the accessibility tree + a screen reader.
- **iOS:** label / trait / value; `.accessibilityValue`, update on change.
- **Android:** `contentDescription`, role via semantics, `stateDescription`; announce changes.

**Pitfalls**
- A `<div onclick>` "button" with no role/name/keyboard — invisible/unusable to AT.
- A custom toggle that looks on/off visually but never exposes `aria-checked`/state.
- A name from placeholder/title only, or a name that doesn't match the visible label (also 2.5.3).

**Example / anti-example**
- *Bad:* `<div class="toggle">` with a CSS knob; screen reader says nothing actionable.
- *Good:* `<button role="switch" aria-checked="true">Notifications</button>`, state updated on tap.

**Source (gated web)**: https://www.w3.org/WAI/WCAG22/Understanding/name-role-value (normative + techniques — do not copy).
