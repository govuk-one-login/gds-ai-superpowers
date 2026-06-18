# WCAG 2.2 AA — accessibility spine

> **Assisted draft — pending review by the programme's accessibility owner.**
> WCAG is legally load-bearing for UK public-sector services (Public Sector Bodies
> (Websites and Mobile Applications) Accessibility Regulations 2018), so the
> normative text must be confirmed by the accountable accessibility owner before this
> file is relied on. Cite the SC by id; never inline or paraphrase the normative
> wording in a skill's output.

This is the **spine** of the library's accessibility standard, the equivalent of
`stride.md` for security: it enumerates the criteria; the per-platform **lenses**
(`ios.md`, `android.md`) say how each is realised off the web. Use this file for the
**web** realisation directly (HTML / ARIA), and as the normative anchor every lens
cites back to.

**Edition: WCAG 2.2 (W3C Recommendation, October 2023).** This file carries the full
**Level A + AA** success-criteria set — AAA is out of scope (UK public-sector
conformance target is AA). Currency note: WCAG 2.2 superseded 2.1; **4.1.1 Parsing was
removed** (now obsolete); and 2.2 added six new criteria at A/AA — **2.4.11 Focus Not
Obscured (Minimum)**, **2.5.7 Dragging Movements**, **2.5.8 Target Size (Minimum)**,
**3.2.6 Consistent Help**, **3.3.7 Redundant Entry**, **3.3.8 Accessible
Authentication (Minimum)**. If WCAG 3.0 lands, treat the change here as a tracked
update with reasoning (assurance trail), as `owasp.md` does for the 2025 edition.

How to cite: in a finding, name the full id, e.g. "WCAG 2.5.8 Target Size (Minimum),
AA". The plain-language **intent** below is a working gloss for routing, not the
normative text — the normative wording lives at w3.org/TR/WCAG22/.

## Principle 1 — Perceivable

| SC | Lvl | Intent (gloss) | Web realisation (HTML/ARIA) |
|----|-----|----------------|-----------------------------|
| 1.1.1 Non-text Content | A | Every image/icon/control has a text alternative | `alt`; `aria-label`/`aria-labelledby`; empty `alt=""` for decorative |
| 1.2.1 Audio-only / Video-only (Prerecorded) | A | Alternative for audio-only and video-only media | transcript; described audio track |
| 1.2.2 Captions (Prerecorded) | A | Captions for prerecorded audio in video | `<track kind="captions">` |
| 1.2.3 Audio Description or Media Alternative | A | Description/alt for prerecorded video | transcript or audio description |
| 1.2.4 Captions (Live) | AA | Captions for live audio | live caption service |
| 1.2.5 Audio Description (Prerecorded) | AA | Audio description for prerecorded video | described track |
| 1.3.1 Info and Relationships | A | Structure/relationships conveyed programmatically, not just visually | semantic elements, `<label>`, `<th>`/scope, headings, `aria-describedby` |
| 1.3.2 Meaningful Sequence | A | Reading/navigation order is correct | DOM order matches visual order |
| 1.3.3 Sensory Characteristics | A | Instructions don't rely on shape/size/position/sound alone | "select the **Save** button", not "the button on the right" |
| 1.3.4 Orientation | AA | Works in both portrait and landscape | no orientation lock unless essential |
| 1.3.5 Identify Input Purpose | AA | Common input fields' purpose is programmatically set | `autocomplete` tokens |
| 1.4.1 Use of Color | A | Colour is not the only means of conveying info | add text/icon/pattern alongside colour |
| 1.4.2 Audio Control | A | Auto-playing audio >3s can be paused/stopped | pause control |
| 1.4.3 Contrast (Minimum) | AA | Text contrast ≥ 4.5:1 (3:1 large text) | token palette meeting ratios |
| 1.4.4 Resize Text | AA | Text resizable to 200% without loss | relative units; no fixed-px traps |
| 1.4.5 Images of Text | AA | Use real text, not images of text | CSS-styled text |
| 1.4.10 Reflow | AA | No 2-D scroll at 320 CSS px width | responsive layout / reflow |
| 1.4.11 Non-text Contrast | AA | UI components & graphics ≥ 3:1 | control borders/states meet 3:1 |
| 1.4.12 Text Spacing | AA | Content survives user text-spacing overrides | no clipping when spacing increased |
| 1.4.13 Content on Hover or Focus | AA | Hover/focus popups dismissable, hoverable, persistent | tooltip handling |

## Principle 2 — Operable

| SC | Lvl | Intent (gloss) | Web realisation (HTML/ARIA) |
|----|-----|----------------|-----------------------------|
| 2.1.1 Keyboard | A | All functionality available from the keyboard | native controls; manage `tabindex` |
| 2.1.2 No Keyboard Trap | A | Focus can always move away | no trap; modal focus managed |
| 2.1.4 Character Key Shortcuts | A | Single-key shortcuts can be turned off/remapped | guard single-key shortcuts |
| 2.2.1 Timing Adjustable | A | Time limits adjustable/extendable | warn + extend session |
| 2.2.2 Pause, Stop, Hide | A | Moving/auto-updating content can be paused | pause control |
| 2.3.1 Three Flashes or Below Threshold | A | No content flashes > 3×/sec | avoid flashing |
| 2.4.1 Bypass Blocks | A | Skip repeated blocks | "skip to content" link; landmarks |
| 2.4.2 Page Titled | A | Pages have descriptive titles | `<title>` |
| 2.4.3 Focus Order | A | Focus order preserves meaning/operability | logical DOM/focus order |
| 2.4.4 Link Purpose (In Context) | A | Link purpose clear from text/context | meaningful link text |
| 2.4.5 Multiple Ways | AA | More than one way to find a page | nav + search/sitemap |
| 2.4.6 Headings and Labels | AA | Headings and labels are descriptive | clear `<h*>` and `<label>` |
| 2.4.7 Focus Visible | AA | Keyboard focus indicator is visible | visible `:focus-visible` style |
| 2.4.11 Focus Not Obscured (Minimum) | AA | Focused element not fully hidden by other content | sticky headers don't hide focus |
| 2.5.1 Pointer Gestures | A | Multipoint/path gestures have a single-pointer alternative | tap alternative to swipe/pinch |
| 2.5.2 Pointer Cancellation | A | Down-event doesn't trigger; abort/undo possible | act on up-event |
| 2.5.3 Label in Name | A | Visible label is in the accessible name | accessible name contains visible text |
| 2.5.4 Motion Actuation | A | Motion-operated functions have a UI alternative & can be disabled | button alternative to shake/tilt |
| 2.5.7 Dragging Movements | AA | Dragging has a single-pointer (non-drag) alternative | tap/buttons alternative to drag |
| 2.5.8 Target Size (Minimum) | AA | Pointer targets ≥ 24×24 CSS px (with exceptions) | spacing/size of tap targets |

## Principle 3 — Understandable

| SC | Lvl | Intent (gloss) | Web realisation (HTML/ARIA) |
|----|-----|----------------|-----------------------------|
| 3.1.1 Language of Page | A | Default language is set | `<html lang>` |
| 3.1.2 Language of Parts | AA | Language changes are marked | `lang` on parts |
| 3.2.1 On Focus | A | Focus alone doesn't cause a change of context | no surprise nav on focus |
| 3.2.2 On Input | A | Changing a setting doesn't auto-change context unexpectedly | no surprise submit on input |
| 3.2.3 Consistent Navigation | AA | Repeated nav is in a consistent order | shared layout |
| 3.2.4 Consistent Identification | AA | Same-function components identified consistently | consistent labels/icons |
| 3.2.6 Consistent Help | A | Help mechanisms appear in a consistent location | help link in same place |
| 3.3.1 Error Identification | A | Errors identified in text | describe the error in text |
| 3.3.2 Labels or Instructions | A | Inputs have labels/instructions | `<label>`, hints |
| 3.3.3 Error Suggestion | AA | Suggest a correction where known | actionable error text |
| 3.3.4 Error Prevention (Legal, Financial, Data) | AA | Reversible/checked/confirmed for significant actions | confirm step |
| 3.3.7 Redundant Entry | A | Don't ask for the same info twice in a process | prefill/carry forward |
| 3.3.8 Accessible Authentication (Minimum) | AA | No cognitive-function test required to authenticate (with exceptions) | no puzzle/transcription-only auth; allow paste/passkeys |

## Principle 4 — Robust

| SC | Lvl | Intent (gloss) | Web realisation (HTML/ARIA) |
|----|-----|----------------|-----------------------------|
| 4.1.2 Name, Role, Value | A | Every UI component exposes name/role/state to AT | native semantics or correct ARIA |
| 4.1.3 Status Messages | AA | Status changes announced without moving focus | `role="status"` / `aria-live` |

> **4.1.1 Parsing** was **removed** in WCAG 2.2 — do not cite it. (Modern parsers
> handle the conditions it covered; it is no longer a conformance requirement.)

## Using this spine
- For a **web** surface, cite the SC id and apply the web realisation column directly.
- For a **native** surface (iOS/Android), cite the **same SC id as the normative
  anchor** and read the platform lens (`ios.md` / `android.md`) for how the criterion
  is realised there — the lens's native affordance is a non-normative realisation
  note, not a separate normative criterion.
- Source (normative): w3.org/TR/WCAG22/. Quick reference: w3.org/WAI/WCAG22/quickref/.

## Deep tier
Authored **testing-technique** files (how to test, AT method, platform deltas, thresholds by
reference — **never** the normative SC text) for the SCs most often contested at story level.
**Pending the accessibility owner's review**, like this spine. **Pull one only when an SC's
applicability to a story is contested or unclear** — not for routine checks.
- 1.3.1 Info and Relationships — deep: deep/wcag-1-3-1.md
- 1.4.3 Contrast (Minimum) — deep: deep/wcag-1-4-3.md
- 2.4.11 Focus Not Obscured (Minimum) — deep: deep/wcag-2-4-11.md
- 2.5.8 Target Size (Minimum) — deep: deep/wcag-2-5-8.md
- 4.1.2 Name, Role, Value — deep: deep/wcag-4-1-2.md
