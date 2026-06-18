---
name: produce-tech-design
description: >
  Produce a complete Technical Design from a product brief by running the
  architect pipeline end to end: frame the work with you, draft the TD, verify it
  against the engineering and security standards, threat-model it, and get an
  independent fresh-eyes review — each step refining ONE shared Technical Design and
  gating every non-trivial change past you (Accept / Modify / Reject / Defer).
  Use for "produce the tech design", "take this brief through to a full TD", "run
  the architect pipeline", "I have a brief, give me a reviewed Technical Design".
  It is pure orchestration — it owns no security or design logic of its own; it
  reads each atomic skill from disk and follows it. It does NOT approve the design
  or accept risk — humans gate every change and own sign-off.
---

# Produce Tech Design (composite)

You orchestrate the architect pipeline: a product brief in, a reviewed
Technical Design out, every change gated by the human. You are a **thin recipe** —
you add sequencing, hand the one shared TD from step to step, and keep a
consolidated audit trail. You contain **no** standards or design logic of your
own: all method lives in the atomic skills you run. If you ever find yourself
citing a control identifier or reading an `_standards/` file directly, that logic
belongs in an atomic skill, not here.

## What you run, and how

You run up to seven atomic skills, in this **fixed order**, against a **single shared
TD**. The order never changes; what varies is **whether the two heavy analyses run** —
gated by a recorded human decision, not by you (see "Risk-tiering" below):

1. `../../atomic/frame-design/SKILL.md` — interactive framing → a framed TD *(skip if a framed TD already exists)*
2. `../../atomic/generate-design-doc/SKILL.md` — deepen the framed TD into architecture *(always)*
3. `../../atomic/check-engineering-standards/SKILL.md` — verify the engineering-way commitments *(always)*
4. `../../atomic/check-platform-constraints/SKILL.md` — verify the design fits the platform's constraints *(always; self-scopes)*
5. `../../atomic/check-security-standards/SKILL.md` — verify against the security standards; **proposes the sizing** *(always)*
6. `../../atomic/threat-model/SKILL.md` — STRIDE the design *(conditional on the accepted sizing)*
7. `../../atomic/cross-model-review/SKILL.md` — independent review, separate Claude subagent *(default-on; skippable with a recorded reason)*

**Read-then-follow** (the gstack `autoplan` pattern): at each step, Read that
skill's `SKILL.md` from disk and follow its workflow inline — its scoping, its
analysis, and its gated write-back stage. Apply a **skip-list** as you follow:
skip "A note on validation", any duplicated "Output format" preamble, and anything
telemetry-like — run only the scoping + analysis + gated-write-back stages. (Our
atomic skills carry no heavy preamble today; the skip-list is stated so future
preamble-bearing skills are handled.)

## The one rule that diverges from autoplan: never auto-decide

`autoplan` auto-decides intermediate questions. **You do not.** Every
Accept / Modify / Reject / Defer gate raised by a sub-skill goes to the human
unchanged. Your value is sequencing and continuity, not deciding on their behalf.
Risk acceptance and sizing stay the human's (see CLAUDE.md "How skills behave").

## Risk-tiering: which steps run

The baseline (steps 1-5) always runs — it is cheap and it is the assurance floor, and
step 5 produces the **security sizing** the human accepts. The two **heavy** analyses
(threat-model, cross-model-review) are then gated, so a low-risk TD isn't put through a
full STRIDE walk and an independent fresh-context review it doesn't warrant. The hard
rule that keeps this assurance-safe: **a skipped step is a recorded, owned decision,
never a silent omission.** You do not decide the tier — the human does; you record it.

- **frame-design (step 1)** — skip only if a **framed TD already exists** (Goals, Context,
  NFRs, Assumptions, Standards, a direction). Otherwise run it.
- **threat-model (step 6)** — gated on the **accepted security sizing** (step 5):
  - **None / Minor** → do **not** run the STRIDE walk. Instead record the decision in the
    TD's Threat Modeling checklist row as **"Not Required"** with the owner and the
    one-line reason (the sizing). Every TD still carries an owned threat-modeling decision.
  - **Moderate / Major** → threat-model is **mandatory**; run it in full.
  - If the human has not accepted a sizing, do not skip — run it.
- **cross-model-review (step 7)** — **default-on.** A human may skip it for a low-risk TD,
  but only with a **recorded reason** in the Decision & change log. When in doubt, run it.

Record every skip (and why, and who owned it) in the TD's Decision & change log, exactly
like any other gated decision. The order in §"What you run" never changes; only whether a
gated step fires.

## Workflow

### 1. Intake
Read the product brief and CLAUDE.md. Announce: a one-line brief summary, the fixed
sequence (frame → draft → engineering → platform → security → threat model → cross-model
review), and that every change is human-gated. **Resume is cheap** because the one shared TD
is the durable state: if a prior session left a stage marker in the TD's Decision &
change log, pick up from there (use `/context-restore` to recover the working
context), and do not re-run completed steps. The pipeline is long — pausing between
steps and resuming later is expected, not an error.

### 2. Step 1 — frame-design *(skip if already framed)*
If a **framed TD already exists** (Goals, Context, NFRs, Assumptions, Standards, a
recommended direction), skip this step — note the skip in the Decision & change log and
go straight to step 2. Otherwise follow `../../atomic/frame-design/SKILL.md` against the
brief: it runs the interactive framing (scope, standards, research, NFRs, assumptions,
approach) and pre-populates a **framed TD** (understanding half; Architecture/Security
still empty). Verify the framed TD exists before continuing. Emit a phase summary.

### 3. Step 2 — generate-design-doc
Follow `../../atomic/generate-design-doc/SKILL.md` against the **framed TD** — it
builds on the framing and deepens the **Architecture / Infrastructure / Mobile
modules / Test approach / API** sections, leaving Security unset. It stops at
architecture + **public** API contracts; internal contracts, code-level design, and
low-level test contracts are `plan-and-implement`'s, per story. It also presents an
**Approach & key decisions** pre-flight for sign-off before the full draft. Verify
those sections are populated before continuing. Emit a phase summary.

### 4. Step 3 — check-engineering-standards
Follow `../../atomic/check-engineering-standards/SKILL.md` against the **same TD**. It
verifies the design **commits** to the engineering-way disciplines a TD should carry
(language choice, the per-`kind` coverage commitment, API versioning + shared-contract
change control, operability, the review/source-control model), proposes gated edits, and
**reports the coverage-bar source**. It is TD-level only — code-level realisation is the
implementation phase — and it defers any security row to the next step. Verify the
engineering commitments were addressed (accepted, modified, or explicitly deferred) before
continuing. Emit a phase summary.

### 5. Step 4 — check-platform-constraints
Follow `../../atomic/check-platform-constraints/SKILL.md` against the **same TD**. It
verifies the design **fits** the platform's declared constraints (data residency, approved
services, tenancy, quotas, egress) and — **only if** the design introduces or changes a
platform component (new pipeline / account / cloud service) — security-checks that new
surface, citing the existing controls. It reads the project's declared platform baseline;
an unchanged platform is inherited and cited, not re-verified. Verify the platform findings
were addressed (accepted, modified, or deferred) before continuing. Emit a phase summary.

### 6. Step 5 — check-security-standards
Follow `../../atomic/check-security-standards/SKILL.md` against the **same TD**. It
fills the Security checklist rows and proposes a sizing, gated. It does not touch
the Threat Modeling row. Verify the checklist rows were addressed (accepted,
modified, or explicitly deferred) before continuing. Emit a phase summary.

### 7. Step 6 — threat-model *(conditional on the accepted sizing)*
Gate on the security sizing the human accepted in step 5 (see "Risk-tiering"):
- **None / Minor** — do not run the STRIDE walk. Record the TD's **Threat Modeling** row
  as **"Not Required"** with the owner and the one-line reason (the sizing), note it in the
  Decision & change log, and continue. The decision is recorded; the heavy analysis is not run.
- **Moderate / Major** (or no accepted sizing) — follow `../../atomic/threat-model/SKILL.md`
  against the **same TD** in full. Its stage 7 walks threats back into the design and can
  flip the **Threat Modeling** row to "Completed (Ref: <the threat model document>)", and
  lists the open risk decisions.

### 8. Step 7 — cross-model-review *(default-on; skippable with a recorded reason)*
By default, follow `../../atomic/cross-model-review/SKILL.md` against the **complete TD**:
it dispatches a separate Claude subagent with fresh context (runs locally — nothing leaves
the machine), presents an independent critique, and gates findings back into the TD. For a
**low-risk** TD the human may skip it — only with a **recorded reason** in the Decision &
change log. When in doubt, run it. Emit a phase summary.

### 9. Consolidate and hand off
Ensure every sub-skill's dispositions landed in the TD's **Decision & change log** —
**including which gated steps ran and which were skipped, and who owned each skip**
(frame-design skipped? threat-model run or "Not Required"? cross-model-review run or
skipped-with-reason?). Close with a summary: sections drafted, platform fit confirmed,
security rows set (and who accepted each), the threat-modeling decision (run / Not
Required), and the **open risk decisions still awaiting a named owner**. State plainly
what is NOT yet done (human sign-off; any deferred items).

## Applying review comments (the revise loop — not waterfall)

The pipeline is a sequence, but a TD is not write-once. When a reviewer (or the
architect) comes back with a **list of comments** on the produced TD — after the
cross-model review, after human sign-off feedback, or at any point — do **not**
re-run the whole pipeline and do **not** hand-patch the TD silently. Run
`../../atomic/revise-design/SKILL.md` against the comment list and the TD: it maps
each comment to a section and walks it back gated (Accept / Modify / Reject /
Defer), appending each disposition to the Decision & change log. That is the
iterative path back into a TD, so feedback lands one comment at a time rather than
forcing a fresh pass.

## The full sequence (complete, risk-tiered)

This pipeline ships the **complete** architect sequence: **frame-design →
generate-design-doc → check-engineering-standards → check-platform-constraints →
check-security-standards → threat-model → cross-model-review**. No named slots remain
(see CHANGELOG). The order is fixed; the baseline (steps
1-5) always runs, and the two heavy steps (threat-model, cross-model-review) are
**risk-tiered** — gated on a recorded human decision, never a silent skip (see
"Risk-tiering"). Any future atomic slots in by phase.

## What this skill does NOT do
- It contains no standards or design logic — orchestration only.
- It never auto-decides a gate — every Accept / Modify / Reject / Defer goes to the
  human.
- It does not approve the TD or accept risk.
- It does not run the steps out of order or in parallel — each builds on the last.
