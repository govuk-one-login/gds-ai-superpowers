# WCAG 2.2 AA — native Android lens

> **Assisted draft — pending review by the programme's accessibility owner.**
>
> **NOT YET VALIDATED — no built Android story.** Android is not exercised by any
> current programme work (current work is iOS-only). This lens is encoded
> **method-complete** so the library is ready when Android work lands, but it has not
> been checked against a real, signed-off Android backlog. Treat its native
> realisations as un-validated until then, and **exclude it from the skill's
> validation success-criterion** for now.

Use this lens for **native Android** surfaces (Jetpack Compose / Views). It does not
replace the spine: WCAG 2.2 (`wcag.md`) is the normative standard; this file says how
each relevant criterion is **realised** on Android.

## Native-citation integrity (load-bearing rule)

Android accessibility is delivered through the platform accessibility APIs and
Material guidance, which are **guidance, not numbered success criteria**. So:

- **Cite the WCAG SC id as the sole normative anchor.** That is the legally
  load-bearing reference.
- The Android API / affordance in the "native realisation" column is an **explicitly
  non-normative realisation note** — never present a Material figure (e.g. the 48dp
  target) as if it were itself a WCAG criterion.

Where Android guidance is stricter than WCAG (48dp vs the 24px in 2.5.8), apply the
stricter native figure as the realisation but still cite the WCAG SC as the anchor.

## Realisation by success criterion

Only SCs with a meaningful native-Android realisation are listed; web-page constructs
that do not apply to a native screen are governed by the spine.

| WCAG SC (normative anchor) | Android realisation (non-normative) | Checkable acceptance phrasing |
|----------------------------|--------------------------------------|-------------------------------|
| 1.1.1 Non-text Content | `contentDescription` on images/icons; decorative `importantForAccessibility="no"` / `Modifier.clearAndSetSemantics` | "every actionable icon has a TalkBack label; decorative images are excluded" |
| 1.3.1 Info and Relationships | semantics: roles (`Role.Button`), `heading()`, label↔control association; `mergeDescendants` for grouping | "each field/value is announced with its label and role by TalkBack" |
| 1.3.2 Meaningful Sequence | traversal order matches visual order (`traversalIndex` where needed) | "TalkBack reads the screen in the intended order" |
| 1.3.4 Orientation | support portrait and landscape unless essential | "the screen works in both orientations" |
| 1.4.1 Use of Color | pair colour with text/icon/shape | "status is not conveyed by colour alone" |
| 1.4.3 Contrast (Minimum) | colour tokens ≥ 4.5:1 (3:1 large) | "text meets 4.5:1" |
| 1.4.4 Resize Text / 1.4.10 Reflow | **font scaling** (`sp` units); layouts reflow at largest font scale | "all text scales with the system font-size setting without clipping" |
| 1.4.11 Non-text Contrast | control/state indicators ≥ 3:1 | "focus/selection/borders meet 3:1" |
| 2.1.1 Keyboard / operability | full **TalkBack** + Switch Access operability | "every action is reachable and operable via TalkBack and Switch Access" |
| 2.4.3 Focus Order | accessibility focus order is logical; dialogs manage focus | "focus order is logical; a dialog returns focus on dismiss" |
| 2.4.7 Focus Visible / 2.4.11 Focus Not Obscured | visible focus indicator; focused element not hidden by chrome | "the focused control is visible and not obscured" |
| 2.5.1 Pointer Gestures / 2.5.7 Dragging | provide tap/button alternatives to swipe/drag/pinch | "any drag/swipe action has a single-tap alternative" |
| 2.5.3 Label in Name | accessible name contains the visible label | "spoken name includes the visible label" |
| 2.5.8 Target Size | touch targets meet Material's **48×48dp** minimum (stricter than WCAG's 24px) | "interactive targets are ≥ 48×48dp" |
| 3.3.1 Error Identification / 3.3.2 Labels or Instructions | errors and instructions exposed to AT, not colour/position only | "errors are announced in text and tied to their field" |
| 3.3.7 Redundant Entry | prefill/carry-forward earlier entries | "the flow does not re-ask for data already provided" |
| 3.3.8 Accessible Authentication | biometrics / passkeys / paste; no transcription puzzle | "the user can authenticate without a cognitive-function test" |
| 4.1.2 Name, Role, Value | semantics expose role+state for custom controls | "every custom control exposes name, role, and state to TalkBack" |
| 4.1.3 Status Messages | `liveRegion` semantics / `announceForAccessibility` | "status changes are announced without stealing focus" |

Source (non-normative): Android accessibility developer guide
(developer.android.com/guide/topics/ui/accessibility); Material Design accessibility.
Normative anchor remains w3.org/TR/WCAG22/.
