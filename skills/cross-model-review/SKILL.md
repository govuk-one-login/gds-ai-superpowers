---
name: cross-model-review
kind: atomic
description: >
  Get an independent review of a COMPLETE technical design from a separate agent
  with fresh context — a final second opinion before sign-off. Use when a TD has
  been drafted and reviewed and you want a fresh-eyes critique that has NOT seen the
  pipeline's reasoning: "independent review", "second opinion on the design", "fresh
  eyes on the tech design", "review before we sign off". It is the FINAL step of the
  architect pipeline. It runs entirely on-machine (a separate Claude subagent), so
  nothing leaves the estate. It surfaces and records findings, gated; it does NOT
  auto-apply the reviewer's suggestions, does NOT accept risk, and does NOT let the
  reviewer edit anything.
---

# Independent Review (cross-model-review)

You orchestrate an **independent review of a finished Technical Design by a separate
agent with fresh context** — the value is a reviewer that did not write the design
and has not seen the pipeline's reasoning, so it catches what a single chain of
reasoning rationalised. You run the review, present its findings, and walk them back
into the TD **gated**. You never let the reviewer edit files, and you never accept
its suggestions on the architect's behalf.

The review runs **locally** — a Claude subagent dispatched with the Agent tool.
Nothing is sent to an external service.

> **In `produce-tech-design` this step is default-on but skippable:** for a low-risk TD
> the human may skip it with a **recorded reason** in the Decision & change log. Run
> standalone, or when in doubt, it always executes. The skip is the human's call, never
> this skill's.

## Step 1 — Dispatch the independent reviewer

Spawn a subagent (Agent tool, fresh context) and give it: the **reviewer persona**,
the **path to the TD** (let it read the file itself, plus the brief and threat model
for context, and let it spot-check named modules in the source), and the **rubric**.
Ask for findings only — it must not rewrite the document. Each finding: a short
title, a severity (critical/high/medium/low), why it matters, and a concrete
suggested change. The reviewer should cover, in order:

- **Steelman** — what's genuinely strong (2-3 sentences).
- The **single riskiest assumption** and why.
- **Architecture** gaps or coupling — anything brittle, missing, or over/under-engineered.
- **Missing considerations** — failure modes, edge cases, operability the TD omits.
- **Security & standards blind spots** — without redoing the threat model, what looks unaddressed.
- Does the design **meet its stated NFRs / success criteria**? Where not?
- Anything the pipeline (framing → design → security → threat model) appears to have **missed**.

It is an **architecture-level** design — tell the reviewer not to ask for
function/line-level code (intentionally out of scope). Tell it to verify reuse
claims against the real source where one looks doubtful.

## Step 2 — Present the findings

Show the reviewer's output under a clear header so it's attributable:

```
INDEPENDENT REVIEW (Claude subagent, fresh context):
════════════════════════════════════════════════════
<reviewer output — keep its specifics; don't summarise them away>
════════════════════════════════════════════════════
```

Then add a short synthesis: where you agree, where you'd push back, and which
findings look most material. An independent reviewer flagging something is a
recommendation, not a verdict — the architect decides.

## Step 3 — Gated write-back

Walk the findings the architect wants to act on, **one at a time**: present the
finding and the concrete TD change it implies, ask **Accept / Modify / Reject /
Defer**, and write only what's approved into the TD, recording it in the Decision &
change log (source: `cross-model-review`). Never auto-apply a finding. Anything that
is a residual-risk acceptance stays the human's decision — and a High/Critical risk
cannot be "accepted" under a `[gap]` owner; it needs a named one.

## What this skill does NOT do
- It does not auto-apply the reviewer's suggestions — every change is gated.
- It does not let the reviewer edit files — the reviewer returns findings only.
- It does not accept risk or sign off the design — it informs the human's decision.
- It does not send the design to any external service — the review is local.

## A note on validation
The review is only as good as the rubric and the TD it's given. If the reviewer
repeatedly surfaces the same class of miss, that is signal to tighten an earlier
pipeline skill (framing, generate, the checks), not just to patch this TD.
