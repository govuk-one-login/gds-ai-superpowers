---
name: prepare-stories
kind: composite
description: >
  Turn a reviewed Technical Design into a developer-ready, accessibility-checked
  backlog by running the product pipeline end to end: decompose the TD (and its
  source requirements) into traceable user stories, then review the UI-facing ones
  against WCAG 2.2 AA — each step gating every change past you. Use for "prepare the
  stories", "take this TD to a backlog", "decompose and accessibility-check the
  stories", "get the stories ready for the developers", "run the story pipeline". It
  is pure orchestration — it owns no decomposition or accessibility logic of its own;
  it reads each atomic skill from disk and follows it. It does NOT create Jira tickets
  (a human transcribes the Jira-ready output), does NOT certify accessibility
  conformance, and does NOT sign off the backlog — a named product owner accepts the
  stories and a specialist certifies accessibility.
---

# Prepare Stories (composite)

You orchestrate the product pipeline: a reviewed Technical Design in, a
developer-ready and accessibility-checked story set out, every change gated by the
human. You are a **thin recipe** — you add sequencing and a consolidated handoff, and
hand the one shared story set from step to step. You contain **no** decomposition or
accessibility logic of your own: all method lives in the atomic skills you run. If you
ever find yourself slicing a story or citing a WCAG SC directly, that logic belongs in
an atomic skill, not here.

## What you run, and how

You run two atomic skills, in this **mandatory order**, against a **single shared
story set**:

1. `../decompose-to-stories/SKILL.md` — TD + requirements → traceable,
   Jira-ready user stories.
2. `../check-accessibility/SKILL.md` — review the UI-facing stories against
   WCAG 2.2 AA; add accessibility acceptance criteria; flag design-level gaps to the TD.

**Read-then-follow** (the `produce-tech-design` / gstack `autoplan` pattern): at each
step, Read that skill's `SKILL.md` from disk and follow its workflow inline — its
scoping, its analysis, and its gated write-back. Run only the scoping + analysis +
gated-write-back stages.

## The one rule that diverges from autoplan: never auto-decide

`autoplan` auto-decides intermediate questions. **You do not.** Every Accept / Modify /
Reject / Defer gate raised by a sub-skill goes to the human unchanged. Your value is
sequencing and continuity, not deciding on their behalf. Story sign-off and
accessibility certification stay the human's (see CLAUDE.md "How skills behave").

## Workflow

### 1. Intake
Confirm the inputs both sub-skills need: the reviewed **TD** and the **original
requirements/brief** that seeded it. Announce: a one-line summary, the fixed sequence
(decompose → accessibility), and that every change is human-gated. If resuming, note
the current story-set state.

### 2. Step 1 — decompose-to-stories
Follow `../decompose-to-stories/SKILL.md` against the TD + requirements. It
produces the gated capability map, the grounded-hybrid stories, the coverage matrix,
and walks gaps/orphans back into the TD. Verify the story set exists and its stories
carry "Grounds in" blocks before continuing. Emit a phase summary.

### 3. Step 2 — check-accessibility
Follow `../check-accessibility/SKILL.md` against the **same story set**. It
filters the UI-facing stories from their "Grounds in" blocks, adds WCAG 2.2 AA
acceptance criteria, and flags design-level accessibility gaps back into the TD —
gated. Verify the accessibility-review artifact exists and the UI-facing stories were
reviewed (or explicitly deferred). Emit a phase summary.

**Degraded-input path:** if `decompose-to-stories` hit its own degraded path and
emitted ungrounded story stubs, **stop before the accessibility step** and report that
grounded stories are needed first — check-accessibility cannot scope stories it cannot
ground. Do not run it against ungrounded stubs.

### 4. Consolidate and hand off
Ensure both sub-skills' dispositions landed (the story set's and the
accessibility-review's proposed-updates tables, and any TD write-backs). Close with a
summary: capabilities/stories produced, requirement coverage, accessibility criteria
added, design-level accessibility findings raised and their owners, and what is **NOT**
done — Jira tickets (human transcribes the Jira-ready output), story sign-off (product
owner), and accessibility certification (specialist + audit + AT testing).

## Later slots (named, not built yet)
- `push-stories-to-jira` — once the programme grants an AI-usable Jira path, a step to
  create the Epics/Stories from the Jira-ready blocks and backfill the tracking index.
  Out of scope here; ticket creation stays human.

## What this skill does NOT do
- It contains no decomposition or accessibility logic — orchestration only.
- It never auto-decides a gate — every Accept / Modify / Reject / Defer goes to the
  human.
- It does not create Jira tickets, certify accessibility, or sign off the backlog.
- It does not run the steps out of order or in parallel — accessibility builds on the
  decomposed, grounded stories.
