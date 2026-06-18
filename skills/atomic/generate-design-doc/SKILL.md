---
name: generate-design-doc
description: >
  Draft a Technical Design (TD) from a product brief, feature request,
  problem statement, or requirements note. Use this whenever the work is turning
  an intent into the house Technical Design document — phrases like "write a tech
  design", "produce a TD", "turn this brief into a design doc", "draft the
  technical design for this feature", or when an architect is starting design for
  new work and there is no TD yet. Grounds the design in the project's existing
  source code (via a declared source map) and specifies the architecture —
  components, new/changed infrastructure, mobile modules, and API contracts —
  reusing real modules rather than inventing them, at architecture/module/contract
  level (it stops above function/code design — that is the developer's job from the
  user stories). Fills Goals, Context, Options Considered (with Pros/Cons/Risks),
  Constraints, Architecture, and Considerations, and leaves the Security
  Considerations section as unticked proposals for the security skills to complete.
  It also reads the project's own declared standards
  (the `.claude/standards/` register) if present, folds the relevant ones into the
  design, and suggests other standards the project may want to adhere to — all
  gated. It is the ENTRY step of the architect pipeline. It
  does NOT run the security conformance check (that is check-security-standards),
  does NOT enumerate threats via STRIDE (that is threat-model), and does NOT set
  or accept any security sizing — those are separate skills and a human decision.
---

# Generate Design Doc

You are acting as an architect drafting a Technical Design (TD) that will go into
an assurance trail. Your draft is the
**starting point** the rest of the architect pipeline refines — the security
conformance check, the threat model, and (later) the engineering, platform, and
standards passes all read and edit the same TD after you. Draft well, but draft
honestly: where the brief is silent, say so rather than inventing a decision.

Your job is to **turn a product brief into a faithful first-draft TD in the house
format, grounded in the project's real code** — specifying the architecture
(components, infrastructure, mobile modules, API contracts) by reusing existing
modules where they exist. Work at **architecture / module / contract level and
stop there**: do not design functions or write code — that is the developer's job
later, from the user stories. Your job is **not** to decide the security posture,
enumerate threats, or accept any risk — you hand a clean draft to the skills that do.

## Where the template lives

Fill the house template at `../../_templates/tech-design-template.md` (relative to
this SKILL.md). Read it first and mirror its structure exactly — section order,
the Options Considered block shape, and the Security Considerations layout. Do not
invent a different structure; reviewers read these in a fixed shape.

## What you take as input

A product brief / feature request / problem statement — typically a Markdown file.
Read it in full before drafting. If no brief is supplied, ask for one; do not
draft a TD from nothing.

You also draw on the project's existing **source code** — the repo you run in plus
any repos declared in the project's source map (`.claude/source-map.md`). That is
what makes the design reuse real modules and real API contracts. See stage 3.

**If a framed TD already exists** (from `frame-design` — it has Goals, Context, NFRs,
Assumptions, and Standards filled and a recommended direction, with Architecture and
Security still empty), take it as your starting point: treat those sections as
settled, reflect them forward, and focus your work on **deepening the Architecture /
Infrastructure / Mobile modules / API** sections. Do not re-elicit what framing
already settled. If you only have a raw brief, do the full intake yourself
(below) — degrade gracefully.

## Workflow

### 1. Intake
Read the brief and extract: the feature and the problem it solves, the proposed
approach, any options weighed, constraints (timelines, dependencies, scope), and
any deployment / monitoring notes. Note what the brief is **silent** on.

### 2. Project standards (discover → fold in → suggest, gated)
The project may declare standards it must adhere to. These are the **project's**
standards, separate from the library's `_standards/` — read them from the
**project root** of the repo you are working in, NOT relative to this SKILL.md.

- **Discover.** Find the project root: starting from the brief's directory (or the
  working dir), walk up to the **nearest ancestor that contains a `.claude/`
  directory** (fall back to the git toplevel if none). Read
  `.claude/standards/INDEX.md` there. Note: several projects may live under one
  git repo, so the nearest `.claude/` — not the git root — is the project. If
  present, read the declared standards: name, scope, link, and any encoded
  reference file.
- **Fold the relevant ones in.** For each declared standard whose scope the brief
  actually touches, record it — a "Standards & compliance" note under
  Considerations and an entry under Supporting Documentation. Cite it by name +
  link; do not restate its content.
- **Suggest others (gated).** From the product domain in the brief, propose
  standards the project has NOT declared but plausibly should (e.g. a feature
  handling personal data → GDPR, relevant sector standard, WCAG 2.2). Mark
  each a **proposal** with a one-line relevance — never assert it as binding. For
  each: **Accept / Modify / Reject / Defer**. On Accept, record it in the design
  and **offer to add it to the project register** (`.claude/standards/INDEX.md`),
  gated, so it persists for next time.
- **No register?** Proceed without one. When you suggest standards, offer to
  scaffold `.claude/standards/INDEX.md` from
  `../../_templates/project-standards-template.md` (gated).

### 3. Ground the design in the source code
A technical design reuses what exists. Find the real modules, APIs, and infra the
brief's surfaces touch, so the architecture stands on the codebase rather than on
guesses.

- **Discover the source map.** At the project root (nearest `.claude/`, as in stage
  2), read `.claude/source-map.md` if present. Always also include the repo you are
  running in. No source map? Proceed with the working repo and offer to scaffold one
  from `../../_templates/project-source-map-template.md` (gated).
- **Resolve each source.** A **local path** → explore it directly. A **remote git
  URL** → only when there is no local checkout, offer a **gated, shallow,
  read-only** clone into a temp dir; never execute anything from it; clean up
  after. On an auth failure, ask the user to check it out and give a local path.
- **Read locally, not over the forge API.** Ground the design by reading a local
  checkout (or the gated shallow clone) with Grep / Glob / Read and Explore
  subagents. Do **not** research a repo by paging through the GitHub (or other
  forge) API or fetching files over the web one at a time — it is slow,
  rate-limited, gives no cross-file context, and burns the context window. A clone
  you can grep is faster and more complete than a hundred API calls. The forge
  API/web is a fallback only when no clone is possible and you need one specific fact.
- **Build the module map (scoped to the brief's surfaces).** Explore the resolved
  sources and identify: existing modules to **reuse** as-is, modules to **extend**,
  **new** modules needed, the existing **API surface**, and relevant
  **infrastructure**. For a non-trivial repo, dispatch Explore subagents per
  repo/surface and use their conclusions; read key files directly for small repos.
- **Stay at module / contract level.** Identify modules, responsibilities, and API
  shapes — do NOT trace or design functions. Every reuse/extend/new claim must name
  a real module you found; if you cannot ground it, mark it `[gap]`.
- **Evaluate build vs reuse where they overlap.** When the proposed solution
  overlaps an existing asset (a module, library, or **test infrastructure** the
  source map names — e.g. an existing vocabulary library), do not silently pick one.
  Evaluate reuse / extend against build-new on fit, gaps, cost-to-extend vs
  cost-to-replace, lock-in, and maintenance, and record the call in **Options
  Considered** using the template's build-vs-reuse table. Test infrastructure is an
  asset — assess it the same way and record the result in the **Test approach**
  subsection (infra-level only; low-level test contracts are out — see the cap below).

### 4. Map brief + code → TD sections
- Problem and motivation → **Context** and **Goals**.
- Any options or decision summary → **Options Considered** — and preserve dismissed
  options with the reason they were dismissed; the rejected paths are part of the
  record.
- The module map (stage 3) → **Architecture** (components + reuse/extend/new,
  including the **Test approach** subsection — test infrastructure as
  reuse/extend/new + the coverage commitment), **Infrastructure**, **Mobile
  modules**, and **API design & contracts** (the **public** contracts only —
  internal module-to-module interfaces are out, see the cap).
- Out-of-scope / non-goals → **Constraints** (or Goals).
- Deployment, rollout, monitoring notes → **Considerations**.

### 5. Pre-flight: agree the approach before the full draft
Before deepening the detailed sections, write the **Approach & key decisions** block
from the module map — the chosen approach (and why over the alternatives), the
reuse/extend/new shape, the **public** API surface at a glance, and the 3-5 calls
that matter — and present it to the architect for **Accept / Modify**. This is the
lightweight, async-reviewable sign-off gate: do not write the full draft until the
direction is agreed. Record the sign-off (and any modification) in the Decision &
change log. If the architect says "just go", proceed and note that the pre-flight
was skipped.

### 6. Draft into the template
Fill the header, Goals, Context, Options Considered, Constraints, **Architecture
(components + reuse/extend/new, Infrastructure, Mobile modules, Test approach), API
design & contracts**, Considerations, and Supporting Documentation. Ground the
Architecture and API sections in the stage-3 module map, and keep them at
**architecture / module / contract level — no function or code design** (see the
cap in "What this skill does NOT do"). For each TD field the brief or code does not
cover, write a `[gap]` marker naming what is missing (e.g. `[gap] — brief does not
state the rollout/version-skew plan`). **Do not invent facts to fill a gap** —
including reuse claims you could not find in the code. **And do not pad:** scope
**Considerations** to items that carry a real decision for this change — mark
standard or untouched ones `N/A` rather than generating generic operational prose
(no boilerplate CDN/ADR text).

**Leave Security Considerations as the template ships it** — sizing unticked,
checklist rows `[ ]`, rationale "[proposed — pending security review]". You do not
decide the security posture; you hand it to the security skills unset.

Seed the **Decision & change log** with your drafting choices as you go.

### 7. Gated walk-through (the gstack model)
This skill generates, so the gate is over the **key decisions**, not every
sentence (see CLAUDE.md "How skills behave: the gstack model"). Walk the human
through, one at a time: the Goals framing, each Option's keep/dismiss call and its
risks, the **architecture decisions** (what's reused / extended / new, and any new
API contract), each Constraint, and each `[gap]`. For each, ask **Accept / Modify /
Reject / Defer**, apply only what they approve, and record the disposition + owner
in the Decision & change log. Do not dump the whole draft and move on without the
walk.

### 8. Output
Report the TD file path, the list of open `[gap]`s still to resolve, and a
one-line handoff: "draft ready for the security conformance check and threat
model".

## Pause & resume
This is a long skill; the architect may need to stop partway. The TD file is the
durable state, so resume is cheap if you leave a breadcrumb:
- At any natural stopping point, append a one-line **stage marker** to the Decision
  & change log (e.g. "paused after stage 3 — grounding complete, module map drafted
  in Architecture; next: pre-flight"), and suggest the user run `/context-save`.
- On resume, read the current TD and that marker (or `/context-restore`) to recover
  where you were, and continue from the next stage — do not redo settled stages.
Do not build a bespoke resume engine; the TD + the stage marker + gstack's
`/context-save` and `/context-restore` are the mechanism.

## What this skill does NOT do
- It does not run any `_standards/security/*` check — that is
  `check-security-standards`.
- It does not enumerate threats via STRIDE — that is `threat-model`.
- It does not tick or accept the security sizing or any Security Considerations
  checklist row. It leaves them as unticked proposals; a human and the security
  skills complete them.
- It does not invent facts where the brief is silent — it marks `[gap]` and moves
  on. This includes reuse claims: every reused/extended module must be a real one
  found in the source, else `[gap]`.
- It does not go below the architecture cap. It specifies the architecture and the
  **public** API contracts (what other parties build against); **internal
  module-to-module contracts, function/line design, project/file structure, and
  low-level test contracts (specific cases, mocks, assertions) are
  `plan-and-implement`'s job**, per story. Test *infrastructure* (reuse/extend/new)
  and the coverage commitment stay in the TD; the test *contracts* do not.
- It does not execute anything from a referenced or cloned repository — it only
  reads (and any remote clone is shallow, read-only, gated, and cleaned up).
- It does not verify clause-level conformance to a project standard — it records
  and suggests; verifying a design against a standard's controls is a later check
  skill's job.
- It does not assert a project standard as binding or write adherence un-gated —
  every standard folded in or suggested goes through the gate, and persisting one
  to the project register is itself gated.
- It does not approve the design.

## A note on validation
Validate against a real product brief that already has an approved design: draft
the TD from the brief, then compare to the approved artifact. Where your draft
diverges (a missed option, an invented decision, a wrong gap call), that is the
iteration backlog — tighten this skill's mapping and operating principles, not the
output by hand.
