---
name: decompose-to-stories
kind: atomic
description: >
  Break a reviewed Technical Design (and the original product requirements
  that seeded it) down into a set of user stories a developer can actually build.
  Use this whenever the work is turning a finished design into a backlog — phrases
  like "decompose this design into stories", "break the TD into user stories",
  "write the stories for this feature", "turn this design into a backlog", "what
  stories come out of this design", "prepare the stories for the developers", or
  when an architect/product owner has a signed-off (or near-final) TD and needs the
  next layer down. Produces vertical, INVEST-shaped stories in a grounded hybrid
  form (user-value frame + Given/When/Then acceptance criteria + a "Grounds in"
  block naming the TD components/contracts each story touches), with full
  requirement ↔ story ↔ TD-element traceability and a coverage check, rendered
  Jira-ready (capability = Epic, story = Story) for manual ticket creation. It
  works at story/acceptance-criteria level and **stops above function/line code** —
  that is the developer's job. It is the step AFTER `produce-tech-design`. It does
  NOT design the architecture (that is generate-design-doc), does NOT run security
  checks or threat-model, does NOT write to Jira, and does NOT sign off the
  backlog — a named product owner accepts the stories.
---

# Decompose to Stories

You are acting as a product-minded delivery lead turning a signed-off Technical
Design into a backlog a team can build. Your output goes to developers (and, later,
to a code-writing skill) and is read by a product owner who must be able to sign it
off for an assurance-critical engagement. It must be specific, traceable, and written so
that nothing the design promised is silently dropped on the way to the backlog.

Your job is to **transpose a design into vertical, buildable user stories**, ground
each one in the real components and contracts the TD names, and prove that every
requirement is covered. Your job is **not** to design the code inside those
components (the developer owns that), to create the Jira tickets (no Jira access —
a human transcribes from your artifact), or to sign off the backlog (a named
product owner accepts it).

## Where the template lives

Fill the house template at `../_templates/story-set-template.md` (relative to
this SKILL.md). Read it first and mirror its structure exactly — the ticket-tracking
index, the capability map, the Jira-ready story block shape, the coverage matrix,
and the proposed-design-updates table. Reviewers and the transcribing human read
these in a fixed shape; do not invent a different one.

## What you take as input

Two inputs, and you need both to do the job well:

1. **The finished Technical Design** — the `tech-design-template` artifact the
   architect pipeline (`produce-tech-design`) produced. It carries the Goals,
   Architecture (components tagged reused/extended/new), API contracts, NFRs, and
   Considerations you ground stories in.
2. **The original product requirements / brief** that seeded the TD — the same
   brief `frame-design` consumed. You need this *as well as* the TD because the TD
   is the architect's compression of intent; the raw requirements carry the
   user-value granularity that proves coverage. The TD tells you *how it's built*;
   the requirements tell you *what was promised*.

**Discover the inputs** (mirror `generate-design-doc`): find the project root by
walking up to the **nearest ancestor containing a `.claude/` directory** (fall back
to the git toplevel). Locate the brief from the project root, the same place
`frame-design` read it; locate the TD where the pipeline writes it. If the user
named files explicitly, use those. If either input is missing, **ask** — do not
assume. With no brief at all, fall back to the TD's *Goals / Context* as the
requirement source and flag the reduced traceability that results.

**Degraded input — TD not at architecture stage.** If the TD is only *framed*
(Architecture / API sections still empty, per the template's draft note), the
"Grounds in" block and component-level coverage cannot be satisfied — the design
hasn't said what the components are yet. Stop and say so; do not invent
architecture. On request you may produce capability-level story stubs from the
Goals/NFRs, marking every story "ungrounded — TD not at architecture stage".

## The method: capability map first, then slice

The hard, error-prone move in decomposition is **transposing axes**. A TD is
organised by *component* (auth service, profile module, search endpoint); a
good backlog is organised by *user value* (a vertical slice a user can feel). Slice
straight off the component list and you get horizontal, by-layer stories ("build
the API", "build the database") that no user can accept and no team can demo. So
make the transposition explicit and gate it, the same way `frame-design` and
`generate-design-doc` split understanding from architecture.

### 1. Intake and ground
Read the TD and the requirements in full. Establish a stable **requirement-ID
scheme**: if the brief carries an explicit, ID'd requirements list, reuse those
IDs; otherwise mint `R1, R2, …` over the discrete requirement statements and record
the mapping in the artifact. Confirm the TD has reached architecture stage
(Architecture populated; API table present or explicitly `N/A`); if not, take the
degraded-input path above.

Requirements often live in **more than one place** — a formal requirements table, an
in-scope list, citizen-need statements. Minting IDs across them involves real
judgement: you will sometimes **merge** two phrasings of one need or **split** a
compound line into several. Make every such merge/split **explicit** in the artifact
(e.g. "folded the in-scope 'trust-list checking' line into R3 'validate certificate
chain'"). Those judgements move what counts as covered, so record them — never merge
or split silently.

### 2. Phase 1 — Capability map (gated)
Transpose the TD's components/contracts and the requirements into a small set of
user-value **capabilities** — epic-level groupings of related user value. ("Capability"
and "epic" mean the same thing here; the artifact renders each capability as a Jira
Epic.) For each capability record the requirement(s) and the TD element(s) it spans.

Present the capability map to the human for confirmation **before** slicing — this
is the cheapest point to catch by-layer drift or a missing slice. Ask **Accept /
Modify / Reject / Defer** on the map as a whole and on any capability they question.
Do not slice until the map is agreed.

### 3. Phase 2 — Slice each capability into stories
For each confirmed capability, produce vertical, right-sized stories in the grounded
hybrid form (below). A good story is a thin end-to-end increment of user value, not
a layer. Mine the TD's **NFRs, Considerations, and Security Considerations** for the
unhappy paths — every story should carry at least one negative / edge acceptance
criterion wherever the design implies a failure mode, so the backlog is not
happy-path-only.

**Prefer the fewest independently-valuable slices over one story per UI step.** The
failure mode here is the mirror image of by-layer slicing: over-decomposing a single
flow into a story per screen (open → verify → consent → cancel → confirm) when
several of those steps cannot be demoed or accepted on their own. "Validate the
request" and "cancel the consent screen" are not stories a user can feel in
isolation — they are steps of a story. Apply the *Independent* and *Valuable* INVEST
tests as a **ceiling on fragmentation**, not just *Small* as a floor: if a candidate
story is not independently demoable, fold it into the story whose value it serves
(its acceptance criteria carry it). Aim for the smallest set of stories that each
deliver a slice a user or tester can actually feel.

Each story has three parts:

- **User-value frame** — `As a <role>, I want <capability>, so that <benefit>`.
- **Acceptance criteria** — `Given <context>, when <action>, then <observable
  outcome>`. Describe *observable behaviour*, never internal mechanism.
- **"Grounds in" block** — the real TD component(s) and API contract(s) the story
  exercises, named at module / contract level (e.g. "Component: profile module
  (extended); Contract: POST /v1/profile").

**Size to Small + Testable — and size honestly.** Check each story is *Small* (a few
days, vertically sliced — split it if not) and *Testable* (the acceptance criteria
are checkable). A story that bundles **a new module + a new API contract + its
error/timeout handling** is almost always too big — split it (e.g. cross-device
"new session module + polling + result endpoint + timeout" is several stories, not
one). An under-sized story hides real work from the plan, so when in doubt mark it
larger and propose the split rather than flattering the estimate. The other INVEST
criteria (Negotiable, Estimable) are review judgement the product owner applies at
sign-off — you flag, they judge.

### 4. Police the architecture cap (hard line)
A story says *what* the user can do and *which* TD modules/contracts are involved —
never *how* to write the code inside them. Before emitting, self-check every
acceptance criterion and "Grounds in" entry: if it names a function signature, a
data-structure internal, an algorithm, or line-level logic, that is a **cap breach**
— rewrite it as observable behaviour, or drop it to the developer. This is a model
self-review, not a deterministic linter, but it is the wall the whole library's
architect/developer split rests on; hold it.

### 5. Coverage pass
Build the **coverage matrix**: requirement → the stories that satisfy it; story →
the requirement(s) and TD element(s) it traces to. Detect **orphans** both ways:
- a **requirement no story covers** → a promise about to be dropped;
- a **story tracing to no requirement or no TD element** → either invented scope or
  a sign the TD is missing something.
Orphans are findings for stage 6 — do not silently absorb them.

**Represent reuse explicitly.** Where one capability's stories are reused by another
(a cross-device flow reusing the same verify / consent / share stories as the
same-device flow), show it in the matrix — e.g. "R4 → S3 (C1), reused in C2" — so
the reused requirement's coverage in the *second* capability is visible, not a blind
spot. A requirement that looks covered only inside capability A but is also needed in
capability B must say so, or B silently looks thinner than it is. Reuse keeps the
backlog DRY; making it visible keeps the coverage honest.

### 6. Gated walk-back (two distinct channels — never one silent dump)
The story set is the primary artifact and is always produced. Then walk findings to
the human, one at a time. There are **two channels; keep them separate**:

- **Primary-artifact acceptance (story sign-off).** Walk the human through the
  capability map and the stories for acceptance. Default to accepting at the
  **capability level**, surfacing individual stories only where the human flags one
  or the coverage pass marked it an orphan — this keeps the gate meaningful without
  forcing a 20-story line-by-line slog. Sign-off is the human's; you draft and
  propose.
- **Finding write-back into the TD (the gstack spine).** Each gap, contradiction, or
  orphan you found while slicing is a finding **proposed back into the source TD**,
  one at a time — e.g. an uncovered requirement that implies a missing component, or
  a story you could not ground because the TD was silent. For each, present the
  concrete change to a **named TD field/section** (typically *Assumptions & open
  questions* or the *Decision & change log*), ask **Accept / Modify / Reject /
  Defer**, and write ONLY what they approve, tagging the point in the TD body with
  the house `[gap]` marker where it was a silence. Record every proposal and its
  disposition + owner in the artifact's proposed-design-updates table. Do NOT batch
  these into one edit and skip the walk — that is the exact failure this gate exists
  to prevent.

### 7. Output
Report the story-set artifact's file path; the capability/story counts; the coverage
result (100% covered, or the list of orphans raised as findings); the dispositions
recorded; and a one-line handoff: "backlog ready for human ticket creation in Jira —
work the tracking index; nothing was pushed to Jira." State plainly what remains
open (any deferred findings, any ungrounded stories) and who owns it.

## Output format — Jira-ready for manual transcription

The artifact's real destination is Jira, but there is no AI Jira access on the
programme — a human creates the tickets by hand. So render in Jira's field shape so
transcription is copy-paste, not re-interpretation, and so a future Jira-enabled
skill can read the same blocks and create the issues automatically:

- Each **capability** renders as a Jira **Epic** block; each **story** as a Jira
  **Story** block with `Epic Link` to its capability.
- A story block carries the fields a human pastes: Issue type, Epic Link, Summary,
  Description (the value frame + Grounds-in), Acceptance criteria, Labels
  (`req:R<i>`, `td:<component-or-API-row>` — this is how traceability rides into
  Jira), and a Small/Testable note.
- A **ticket-tracking index** at the top lists every story with a blank **Jira key**
  column the human fills in as they create each ticket.

Building or calling any Jira integration is out of scope (see "does NOT do").

## What this skill does NOT do
- It does not design functions or write code, and does not go below story /
  acceptance-criteria level — function- and line-level design is the developer's
  job. It actively polices that cap (stage 4).
- It does not create Jira tickets or call any Jira API/MCP. It produces a
  Jira-ready artifact; a human transcribes it. (A future `push-stories-to-jira`
  slot may automate this once access exists — not built here.)
- It does not sign off or accept the backlog. It drafts, proves coverage, and
  proposes; a named product owner accepts the stories.
- It does not run the security checks or threat-model, and does not touch the TD's
  Security Considerations.
- It does not invent scope to fill a gap. A requirement with no design behind it,
  or a story it cannot ground, is surfaced as a finding and walked back to the TD —
  never silently turned into a story with assumed behaviour.
- It does not silently rewrite the TD. Every write-back is proposed one finding at a
  time and written only on approval.

## A note on validation
Validate against a real TD that a human already decomposed into a signed-off
backlog: feed the skill the same TD + brief and compare its capability map and
stories to the real backlog. Where they diverge — a capability grouped differently,
a missed slice, a by-layer story, an over-grounded one that breached the cap — that
divergence is the iteration backlog. Tighten this skill's Phase 1 transposition and
operating principles, not the output by hand.
