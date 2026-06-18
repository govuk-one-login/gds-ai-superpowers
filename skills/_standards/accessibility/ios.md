# WCAG 2.2 AA — native iOS lens

> **Assisted draft — pending review by the programme's accessibility owner.**

Use this lens for **native iOS** surfaces (SwiftUI / UIKit). It does **not** replace
the spine: WCAG 2.2 (`wcag.md`) is the normative standard. This file says how each
relevant success criterion is **realised** on iOS.

## Native-citation integrity (load-bearing rule)

iOS accessibility is delivered through Apple's APIs and Human Interface Guidelines,
which are **guidance, not numbered success criteria**. So:

- **Cite the WCAG SC id as the sole normative anchor** (e.g. "WCAG 1.3.1 Info and
  Relationships, AA-conformance target"). That is the legally load-bearing reference.
- The Apple API / affordance in the "native realisation" column is an **explicitly
  non-normative realisation note** — *how* you satisfy the SC on iOS. Never present an
  Apple HIG figure (e.g. the 44pt target) as if it were itself a WCAG criterion.

This keeps the library's "cite the control, never inline/paraphrase" rule honest where
the platform has no numbered control of its own. Where iOS guidance is stricter than
WCAG (44pt vs the 24px in 2.5.8), apply the stricter native figure as the realisation
but still cite the WCAG SC as the anchor.

## Realisation by success criterion

Only the SCs with a meaningful native-iOS realisation are listed. SCs absent here are
either web-page constructs that do not apply to a native screen (e.g. 2.4.1 Bypass
Blocks, 2.4.2 Page Titled, 2.4.5 Multiple Ways, 3.1.1 Language of Page in its web
form) or inherit the spine's intent unchanged.

| WCAG SC (normative anchor) | iOS realisation (non-normative) | Checkable acceptance phrasing |
|----------------------------|---------------------------------|-------------------------------|
| 1.1.1 Non-text Content | `accessibilityLabel` on images/icons; decorative views `accessibilityHidden(true)` | "every actionable icon has a VoiceOver label; decorative images are hidden from VoiceOver" |
| 1.3.1 Info and Relationships | accessibility traits (`.header`, `.button`), grouping, `accessibilityElement(children:)`; label↔control association | "each field/value is announced with its label and role by VoiceOver" |
| 1.3.2 Meaningful Sequence | accessibility element order matches visual order | "VoiceOver reads the screen in the intended order" |
| 1.3.4 Orientation | support portrait and landscape unless essential | "the screen works in both orientations" |
| 1.4.1 Use of Color | pair colour with text/SF Symbol/shape | "status is not conveyed by colour alone" |
| 1.4.3 Contrast (Minimum) | colour tokens ≥ 4.5:1 (3:1 large); honour Increase Contrast | "text meets 4.5:1; respects Increase Contrast" |
| 1.4.4 Resize Text / 1.4.10 Reflow | **Dynamic Type** (scalable fonts); layouts reflow at largest sizes | "all text scales with Dynamic Type to the largest accessibility size without clipping or truncation" |
| 1.4.11 Non-text Contrast | control/state indicators ≥ 3:1 | "focus/selection/borders meet 3:1" |
| 2.1.1 Keyboard / operability | full **VoiceOver** + Full Keyboard Access + Switch Control operability | "every action is reachable and operable via VoiceOver and Switch Control" |
| 2.4.3 Focus Order | accessibility/focus order is logical; modals trap focus correctly | "focus order is logical; a sheet returns focus on dismiss" |
| 2.4.7 Focus Visible / 2.4.11 Focus Not Obscured | visible focus for keyboard/Switch; focused element not hidden by sticky chrome | "the focused control is visible and not obscured by toolbars" |
| 2.5.1 Pointer Gestures / 2.5.7 Dragging | provide tap/button alternatives to swipe/drag/pinch | "any drag/swipe action has a single-tap alternative" |
| 2.5.3 Label in Name | `accessibilityLabel` contains the visible label text | "spoken name includes the visible label" |
| 2.5.8 Target Size | tap targets meet Apple's **44×44pt** minimum (stricter than WCAG's 24px) | "interactive targets are ≥ 44×44pt" |
| 3.3.1 Error Identification / 3.3.2 Labels or Instructions | errors and field instructions exposed to AT, not colour/position only | "errors are announced in text and tied to their field" |
| 3.3.7 Redundant Entry | prefill/carry-forward earlier entries | "the flow does not re-ask for data already provided" |
| 3.3.8 Accessible Authentication | support Face ID / Touch ID / passkeys / paste; no transcription puzzle | "the user can authenticate without a cognitive-function test (biometrics/passkey/paste allowed)" |
| 4.1.2 Name, Role, Value | correct accessibility traits/values; custom controls expose role+state | "every custom control exposes name, role, and state to VoiceOver" |
| 4.1.3 Status Messages | `UIAccessibility.post(notification: .announcement/.screenChanged)` / SwiftUI `accessibilityAnnouncement` | "status changes (e.g. 'shared') are announced without stealing focus" |

## High-value iOS interactions
Common iOS surfaces and the criteria they most often need: a **form / consent screen**
(every field and choice labelled and announced — 1.3.1; 44pt action targets — 2.5.8;
authentication without a cognitive puzzle — 3.3.8); a **camera / scan capture**
(VoiceOver guidance for aiming, and — at design level, not a story criterion — whether
a non-camera alternative exists, 1.1.1); and a **confirmation / status change**
(announced as a status message — 4.1.3). Dynamic Type across all of them (1.4.4).

Source (non-normative): Apple Human Interface Guidelines — Accessibility
(developer.apple.com/design/human-interface-guidelines/accessibility); UIKit/SwiftUI
accessibility APIs. Normative anchor remains w3.org/TR/WCAG22/.
