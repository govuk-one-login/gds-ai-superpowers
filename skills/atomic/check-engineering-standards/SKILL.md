---
name: check-engineering-standards
description: >
  Verify a Technical Design against the library's engineering-way standard and check
  the engineering disciplines a TD should commit to are present and correctly cited. Use
  for "does this design meet our engineering standards / the engineering-way", "check this TD
  against the engineering standard", "are the right engineering commitments named",
  "fill the engineering conformance section", or the engineering step of producing a TD.
  It maps the design's surfaces to the ENG-* controls that govern them (testing, API
  compatibility, code review, languages, source control, operability) and proposes gated
  edits. This is a TD-level CONFORMANCE check against the design-commitment controls — it
  does NOT review code or a diff (that is the implementation phase), does NOT re-do the
  security or accessibility checks (those are check-security-standards / check-accessibility),
  and does NOT accept risk or sign off (a human decides and accepts).
---

# Check Engineering Standards

You are acting as a lead engineer doing a **conformance pass** over a Technical Design:
given the engineering-way standard this programme holds, which **design commitments**
does this TD need to make, are they named, and is the design's engineering posture sound?
Your output feeds an assurance trail, so cite the `ENG-*` control identifiers and never
hand-wave.

Your job is to **verify the design commits to the engineering disciplines that belong in a
TD, and report any gaps**. Your job is **not** to review the code (that is the
implementation phase) or to accept a residual gap (that is a named human's decision).

## Altitude — you check commitments, not code (read this first)

The engineering standard is consumed at **two altitudes**, and this skill owns only the
TD-level half. A TD can carry a *commitment*; it cannot carry a *coverage run*. So you tick
only the **design-commitment controls**:

- `ENG-LANG-1` — the language the design chooses (and a justification if it's a new one).
- `ENG-API-2` / `ENG-API-4` — the API versioning + backward-compatibility strategy.
- `ENG-API-1` — that the design names how shared/public contracts are change-controlled.
- `ENG-TEST-1` — that the design **commits to a per-`kind` coverage bar** (the *number* and
  its enforcement are realised and checked code-side).
- `ENG-OPS-2` / `ENG-OPS-3` — the operability and documentation approach.
- `ENG-SCM-1` / `ENG-REVIEW-1` — the source-control + review model the team commits to.

The **code-level realisation** of every control (actual coverage ≥ bar, linter idiom, the
in-diff API break, anti-vacuous tests, no-PII-in-logs in code) is **not yours** — it is
already enforced by `generate-implementation-plan`, `review-code`, and the named code-level
check slot. Do not pretend to tick a code-level control from a TD.

## The boundary vs `check-security-standards` (keeps the two distinct)

Some `ENG-*` controls cross-reference a security control. Where they do, you verify the
**engineering discipline** and **defer the security tick** to `check-security-standards`:

- `ENG-OPS-1` (no PII in logs) → A09 / MASVS-STORAGE-1 — you check "logs are structured and
  a no-PII rule is in force"; the **security conformance row** is `check-security-standards`'.
- `ENG-LANG-3` (deps pinned/scanned) → A03:2025 — you check "a lockfile + scanner exist";
  the supply-chain security row is `check-security-standards`'.
- `ENG-SCM-2` (secrets) → A09 — you check "secret scanning is on, history clean"; the
  security row is `check-security-standards`'.

One row, one owning skill. You **never** write the TD's Security Considerations rows.

## Where the standard lives

Read an `_standards/engineering-way/` file only for a surface the design actually touches
(progressive disclosure). Start at `../../_standards/engineering-way/README.md` (the register), then:

- Testing commitment / coverage bar → `../../_standards/engineering-way/testing.md`
- API / shared-module contracts → `../../_standards/engineering-way/api-compatibility.md`
- Review + source-control model → `../../_standards/engineering-way/code-review.md`, `../../_standards/engineering-way/source-control.md`
- Language / stack choice → `../../_standards/engineering-way/languages.md`
- Operability / monitoring / docs → `../../_standards/engineering-way/operability.md`

Cite control identifiers (e.g. "ENG-TEST-1", "ENG-API-2"). Never copy the standard's text
into the TD — one source of truth.

## Depth on demand (the deep tier)
When you are about to record an ENG control as **Contested / Deferred / applicability Unclear**
and its lens line carries a `deep:` pointer, pull that one control's deep file
(`../../_standards/engineering-way/deep/<id>.md`) — a single whole-file Read of our authored
check / pitfalls / example — to resolve the call. Do **not** pull for routine lens-answered
checks, and don't re-pull within this invocation. The lens stays the citable source. See
CLAUDE.md "How standards are read".

## Workflow

### 1. Scope the surfaces
From the TD, list the engineering surfaces in play (which tiers/`kind`s, HTTP APIs, shared
modules, services that run). Read only the matching `_standards/engineering-way/*` file(s).

### 2. Conformance pass, per commitment control
For each design-commitment control above, determine whether the TD makes the commitment and
cites it correctly:
- Is the **language** named and supported (`ENG-LANG-1`)?
- Does the design commit to a **coverage bar** per tier (`ENG-TEST-1`)? **Report the bar's
  source** — `[source: project .claude/standards]` if the project declares one, else
  `[source: engineering-way reference default]` (backend 85 / web 90 / iOS 85 / Android 75). An
  undeclared bar with no config is a gap, not a silent pass.
- Is there an **API versioning + compatibility** strategy, and a **shared-contract
  change-control** rule (`ENG-API-1/2/4`)?
- Is the **operability** approach (monitoring, ADRs) named (`ENG-OPS-2/3`)?
- Is the **review + source-control** model named (`ENG-REVIEW-1`, `ENG-SCM-1`)?

For any control that cross-refs security, check the engineering discipline only and note the
security row is `check-security-standards`'.

### 3. Emit the conformance finding set
Produce a structured list — per control: current TD state → proposed commitment + cited
`ENG-*` ID (+ bar source where relevant) → gap. Use
`../../_templates/engineering-standards-review-template.md`. This is the durable analysis
artifact, produced whether or not any write-back is accepted.

### 4. Gated write-back (the gstack model — one finding at a time)
For each finding, present the concrete change to the TD (the commitment to add/correct) and
ask **Accept / Modify / Reject / Defer**. Write only what is approved into the TD, and
append the disposition + owner + date to the TD's Decision & change log (source:
`check-engineering-standards`). Never batch-write. Any gap accepted as a residual stays the
human's decision.

## Where it sits
Architecture phase, in `produce-tech-design`: generate-design-doc →
**check-engineering-standards** → check-platform-constraints → check-security-standards →
threat-model → cross-model-review. It is the engineering sibling of
`check-security-standards`, run before it.

## What this skill does NOT do
- It does not review code or a diff — it is TD-level; code-level realisation is the
  implementation phase (`generate-implementation-plan`, `review-code`, the code-level slot).
- It does not re-do security or accessibility — it defers those rows to
  `check-security-standards` / `check-accessibility`.
- It does not invent controls the standard does not name, and does not inline the standard's
  text into the TD.
- It does not set or accept a residual gap — it proposes; a human accepts.
- It does not sign off the engineering section or the design.

## A note on validation
Validate against a TD whose engineering approach a lead has already signed off: run the
conformance pass on the same design and compare. Divergences (a missed commitment, a wrong
bar source, an over-reaching tick into code-level territory) are the iteration backlog —
tighten the routing and operating principles, not the output.
