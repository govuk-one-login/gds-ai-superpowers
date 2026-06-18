# CLAUDE.md — Assured Engineering Superpowers

Context and working conventions for Claude Code sessions in this repo. Read this
before creating or editing skills.

## What this repo is

A composable library of agentic skills for Claude Code, encoding the
engineering, security, accessibility, and delivery standards used on
assurance-critical, regulated-sector engagements. Skills are small and
single-purpose; roles compose them into their own workflows.

Core principle: **standards are owned by the work, not the role.** A security or
accessibility check is encoded once, in `skills/_standards/`, and reused by every
skill that touches that surface — the architect's design, the dev's code, the
reviewer's gate all apply the identical check. This prevents drift and is the
whole reason the library exists.

## Layout

```
skills/                 Every skill is a flat folder skills/<name>/ (one level deep —
                        what Claude Code discovers). The atomic-vs-composite distinction
                        lives in each SKILL.md's `kind:` frontmatter, not in the folders;
                        INDEX.md groups them for humans.
├── _standards/      Shared reference files (the encoded standards). NOT skills — no SKILL.md.
│   ├── security/    stride, owasp (Top 10:2025), masvs (v2), ncsc-cloud-principles, ncsc-secure-by-design
│   ├── accessibility/ wcag (2.2 AA spine), ios, android (per-platform lenses)
│   ├── engineering-way/ engineering slice: README register (ENG-* house IDs) + testing, api-compatibility, code-review, languages, source-control, operability
│   └── platform/    platform-constraints lens (PLAT-* house IDs): residency, approved services, tenancy, quotas, egress, change-surface
├── _templates/      House output formats (threat-model-template, tech-design-template, project-*-template).
│
│   kind: atomic — single-purpose skills (apply a standard, run a check, make an artifact):
├── frame-design/             built — interactive office-hours framing (pipeline entry)
├── generate-design-doc/      built — deepen a framed TD into code-grounded architecture
├── check-engineering-standards/ built — verify a TD's engineering-way commitments (ENG-*); TD-level; gated
├── check-platform-constraints/ built — verify a TD fits the platform's constraints (PLAT-*); + conditional security pass on a new platform component; gated
├── check-security-standards/ built — verify a TD against the security standards; gated
├── threat-model/             built — STRIDE spine + OWASP/MASVS/NCSC lenses; gated write-back
├── cross-model-review/       built — independent final review (separate Claude subagent); gated
├── revise-design/            built — apply a review-comment list to a TD iteratively (Accept/Modify/Reject/Defer); routes off-cap/other-skill comments; gated
├── decompose-to-stories/     built — TD + requirements → traceable, Jira-ready user stories; gated
├── check-accessibility/      built — review stories against WCAG 2.2 AA; gated write-back
├── generate-acceptance-tests/    built — story criteria → failing acceptance tests (the oracle); gated
├── generate-implementation-plan/ built — story+tests+code → impl plan (below the cap); model rec; gated
├── implement-plan/           built — dispatch a cheaper model to code to green; owns model-tiering
├── review-code/              built — independent subagent reviews the diff (general correctness); catches vacuous tests; gated apply/route
├── review-security/          built — independent subagent reviews the diff (security lens, control-cited); risk-tiered; gated apply/route
├── review-accessibility/     built — independent subagent reviews the diff (WCAG lens, SC-cited; static); risk-tiered; defers runtime residue to QA AT; gated
├── verify-story/             built (API+web; mobile gated) — QA the running build vs acceptance criteria; verify-by-automating
├── setup/                    built — install/update/verify the library itself
│
│   kind: composite — thin recipes that sequence atomic skills:
├── produce-tech-design/      built — frame → generate → check-security → threat-model → cross-model-review
├── prepare-stories/          built — decompose-to-stories → check-accessibility (product pipeline)
├── plan-and-implement/       built — acceptance-tests → impl-plan → implement → review-code → review-security → review-accessibility (risk-tiered); model-tiered
├── assure-quality/           built — verify-story; the QA-phase front door (grows with more QA atomics)
└── INDEX.md         One line per skill (grouped atomic/composite) — keep current; it's how people discover skills.
docs/
├── authoring.md           Conventions for writing AND contributing skills (read before authoring or changing a composite).
├── flows.md               The single map of the composite pipelines — every step, its kind (mandatory / conditional / stop / not-built), and its gate. Keep current when a composite changes.
└── onboarding-prompt.md   Paste-in prompts for install/update.
install.sh                 Developer/local install: one flat symlink per skill into .claude/skills.
scripts/build-bundle.sh    Builds the agent-manager bundle (dist/agents/, gitignored) for consumer/CI install.
VERSION                    Library version; drives the bundle version (bump on a standards change).
CHANGELOG.md               Tracks skill AND standards changes (assurance trail).
```

Two install paths: `install.sh` (developer/local — links to your live clone, `git
pull` updates instantly) and the **agent-manager bundle** (`scripts/build-bundle.sh`
→ `npx @ai-agent-manager/cli@latest https://deloittedigitaluk.github.io/assured-engineering-superpowers` — a
versioned snapshot for consumers/CI; see `docs/onboarding-prompt.md`). Releases are
automatic: on merge to `main`, `.github/workflows/publish-bundle.yml` derives the next
semver from the Conventional Commits (`scripts/next-version.sh`; type→bump in
`COMMIT_STANDARD.md`), tags it, and publishes to GitHub Pages, accumulating versions on
the `gh-pages` branch. The reviewed PR merge is the approval. The bundle is a
*generated* artifact; the repo stays the single source of truth.

## Critical conventions

**How skills get installed (and the flat layout).** Claude Code discovers skills
FLAT: a skill must sit at `.claude/skills/<name>/SKILL.md` (one level deep), and
the **folder name is the slash command** (`/<name>`) — the `name:` frontmatter is
only a display label. A SKILL.md any deeper is not discovered at all. Our skills
therefore live one level deep at `skills/<name>/` (the atomic-vs-composite split
is carried by each SKILL.md's `kind:` frontmatter — see below — not by folders).
`install.sh` drops one flat symlink per skill:
`.claude/skills/threat-model -> <repo>/skills/threat-model`, coexisting with any
other skills already in `.claude/skills`. Keep each skill's folder name unique
across the whole library — they share one command namespace.

**The `kind:` frontmatter.** Every SKILL.md carries `kind: atomic` or
`kind: composite` after `name:`. This is the single source of the atomic/composite
distinction now that the folders are flat: `install.sh`'s flow-map drift guard
finds composites by `kind: composite`, and INDEX.md groups by it. A new skill must
declare its `kind`.

**Relative paths to shared files.** Skills reference shared files as
`../_standards/...` and `../_templates/...` (relative to the skill's SKILL.md —
one `../` because skills and the `_standards/`/`_templates/` trees are siblings
under `skills/`). These resolve because the per-skill symlink points at the
skill's **real** folder inside the intact `skills/` tree, so the relative path
resolves against that real location (the clone), not the link. So: the tree must
stay intact in the clone, and you must never **copy** a standard out of it (that
forks the single source of truth) — but linking individual skill folders in is
exactly how install works now. `install.sh` is the only thing that should create
those links. (The agent-manager bundle distribution is the one sanctioned
exception — a *generated* artifact that copies the whole tree intact; see
`scripts/build-bundle.sh`.)

**Never inline a standard.** Skills cite control identifiers (e.g. "A01:2025
Broken Access Control", "MASVS-STORAGE-1", "NCSC Principle 3") and read the
relevant `_standards/` file when needed. Do not copy standards text into a skill
or into a skill's output. One source of truth.

**How standards are read — two tiers, depth on demand.** Each standard is a thin
**lens** (`_standards/<domain>/<file>.md`, always read for the surface in play) plus,
for the controls that warrant it, a **deep file** (`_standards/<domain>/deep/<control-id>.md`)
holding *our authored* operational depth (check / pitfalls / example / authoritative link —
never reproduced normative text). The read protocol every standards-reading skill follows:
1. **Always** read the lens; resolve the check there if you can.
2. **Pull a control's deep file only at the moment you are about to record it as
   `Contested`, `Deferred`, or applicability `Unclear`** — and only if its lens line shows a
   `deep:` pointer. The pull is a single whole-file `Read` of `deep/<id>.md` (~200-400
   tokens). Depth is the exception, gated on a named output state, **not** a per-control
   "is this hard?" judgement.
3. **Don't re-pull** a control already pulled this skill invocation (the memo does not cross
   subagent boundaries).
4. **Escalate to the gated web source** (the deep file's link) only when local depth is
   insufficient — advisory, external-send-gated, never routine.
The **lens line stays the single citable source** for a control's identity and mapping; a
deep file only *adds* operational detail, never restates or overrides the mapping. A control
the lens already answers gets **no** deep file and **no** `deep:` cue (opt-in — the lens does
not grow for it). The `deep:` pointer is a binding contract: `install.sh` verification asserts
every pointer resolves and no deep file is orphaned (drift guard).

**Two kinds of standards — library vs project. Keep them distinct.** This repo is
product-agnostic, so it owns only **cross-engagement** standards in
`skills/_standards/` (currently security), read by skills **relative to the
SKILL.md** (`../_standards/...`). A **consuming project** declares its own
**product/domain** standards (e.g. a domain data-format spec, GDPR, WCAG, house
coding conventions) in `.claude/standards/` in that repo — a register (`INDEX.md`) plus
optional per-standard reference files; the house format is
`_templates/project-standards-template.md`. Skills discover the project register
from the **project root** (git toplevel of the working repo) and honour it
**alongside** the library's standards. Never embed a product-specific standard in
this repo, and never read project standards relative to a SKILL.md — the two live
in different places and are read by different paths. `generate-design-doc` is the
first consumer (it records declared standards in the design and suggests others,
gated); checks and `threat-model` will consume the register in later increments.

**Project source map.** A project also declares the code its designs should be
grounded in — a `.claude/source-map.md` register (local paths or remote git URLs)
in the consuming repo, read from the project root (same discovery as the standards
register; `_templates/project-source-map-template.md` is the house format).
`generate-design-doc` explores those sources to ground the architecture in real
modules and API contracts rather than inventing them. Remote URLs are cloned only
read-only, shallow, and gated; nothing is ever executed from a referenced repo.

**Designs stop at architecture level — the boundary, named precisely.** A generated
Technical Design specifies the architecture and the **public** API contracts (what
another team/service/app builds against). What stays **in** the TD: components as
reuse/extend/new (test *infrastructure* counts as an asset — same lens), public API
contracts, the coverage *commitment* (the bar), and the high-level operational
decisions that carry a real choice. What goes **out**, down to `plan-and-implement`
(per story): internal module-to-module contracts, function/line design, project/file
structure, and low-level test *contracts* (specific cases, mocks, assertions). The
rule of thumb: the TD says *what is built and what others build against*; the dev
pipeline says *how the code is written*. Skills that produce or refine a TD honour
this cap — and scope operational "Considerations" to real decisions, never generic
boilerplate. (The split is HLD-vs-LLD answered as **TD vs plan-and-implement** — the
library does not mint a separate low-level architect doc; the low level is the
per-story implementation plans, already modular.)

**Model the change, inherit the platform (the horizontal boundary).** Just as the
vertical cap stops a TD going below architecture, a horizontal one stops it sprawling
into the delivery substrate. The TD and its security analysis are scoped to what the
change introduces; the source repo, PR/review rules, CI/CD pipeline and its
supply-chain integrity (OWASP A03:2025), deploy/IaC config, and cloud IAM baseline are
**inherited platform** — assured once at platform level (NCSC Secure by Design) and
**cited, not re-modelled**, unless the change alters them. `frame-design`,
`threat-model`, and `check-security-standards` defer to a project-declared **platform
/ CI-CD baseline** in `.claude/standards/` for these surfaces (Option A); the named
`check-platform-constraints` skill is the eventual verifier of that baseline. The
failure mode this prevents: a change that merely *ships via* a PR + pipeline pulls the
pipeline into the model, and the security pass hardens GitHub instead of the change.

**Commits follow Conventional Commits** — the format in `COMMIT_STANDARD.md`
(`type(scope): imperative summary`). A change under `_standards/` is the
weighty case: use `security(standards):`, say *why* in the body, and add a
matching `CHANGELOG.md` entry — that triple is the assurance trail. (This is a
pointer to `COMMIT_STANDARD.md`, not a copy of it — same single-source rule.)

**The description is the trigger.** Claude decides whether to use a skill from
its `description` frontmatter alone. Make it state both what the skill does AND
when to reach for it, including implied cases. Be slightly pushy (Claude tends to
under-trigger). The biggest risk in a composable library is two skills with
fuzzy, overlapping triggers — keep each purpose crisp and non-overlapping.

**State what a skill does NOT do.** Especially the boundary between drafting and
any human approval / risk-acceptance step. For assurance-critical work, the human
gate must stay meaningful — skills draft and flag; humans approve and accept risk.

**Standards are current as of this build:**
- OWASP Top 10 = the **2025** edition (released Jan 2026), not 2021. Translate
  legacy references per `_standards/security/owasp.md`.
- MASVS = **v2** (eight control groups; L1/L2/R levels removed).
- Engineering-way standard = **library-owned** controls (`_standards/engineering-way/`),
  minting **house `ENG-*` IDs** (we own their stability — do not renumber casually).
  Controls marked `realises:` encode sound engineering practice; controls marked
  `house convention:` are owned by a specific skill or repo artifact. Coverage *numbers*
  and the `ENG-API-*` controls are **house convention** (no external source page). Because
  this standard has no external live site, it does not require re-grounding; changes are
  maintained directly in the library.
If you touch a standard, check it's still current and note the change in
CHANGELOG.md with reasoning (assurance trail).

## How skills behave: the gstack model

This library is modelled on **gstack** (a mature Claude Code skill library): a
skill that analyses an artifact does not stop at a standalone report — it feeds
its findings back into the artifact it analysed, *gated by human approval*. Build
every analysis/review skill this way. The pattern has three parts:

1. **Analyse and emit the structured artifact — always.** Produce the skill's own
   output (e.g. the threat model document) in the house template. This is the
   durable record and the input a composite consumes downstream. It is produced
   whether or not any write-back happens.
2. **Walk findings back into the source artifact — one at a time, gated.** Take
   each non-trivial finding to the human individually, with the concrete change it
   implies for the source artifact (a design-doc field, a plan section), and write
   ONLY what they approve. Never batch every finding into a single write and skip
   the walk — dumping findings into a deliverable instead of walking the user
   through them is the failure mode this rule exists to prevent (gstack calls it
   the "anti-shortcut" clause).
3. **Risk acceptance stays human.** Where a write-back is itself a risk-acceptance
   decision (a security sizing, a "threat model not required" field, accepting a
   residual risk), the skill *proposes and records* the decision and its owner; it
   never makes the acceptance itself. Same human gate as "What's deliberately NOT
   automated" below — gstack reaches it through per-finding approval, and so do we.

Composites then sequence these gated skills (see the build order below); they add
no analysis logic of their own.

**External service calls are gated.** Where a skill reaches the web (e.g.
`frame-design`'s landscape research), that is an external send: get explicit user
consent first, send the minimum (generalised category terms — never proprietary
content), and treat the result as advisory. Prefer keeping work **local** — the
independent review (`cross-model-review`) runs a separate Claude subagent on-machine
rather than sending the design to an external model, precisely so nothing leaves the
estate. Any reviewer's output is advisory and gated back in like any other finding.

## How to build a new skill (the loop)

**`docs/authoring.md` is the contribution rulebook** — conventions for writing a
skill, the description-as-trigger discipline, the "state what it does NOT do" rule,
and the "before you merge" checklist (INDEX entry, CHANGELOG note, validate against
real work, and — for composites — update `docs/flows.md`). Read it before authoring a
skill or changing a composite's sequence.

1. Read `docs/authoring.md` and an existing skill (`threat-model`) as the
   reference pattern.
2. Write `skills/<name>/SKILL.md` with `name:`, `kind:` (atomic/composite), and a
   when-to-trigger `description:` in frontmatter; then persona, workflow, per-item
   output structure, and an explicit "does NOT do" section.
3. Put any reusable standard in `skills/_standards/<domain>/` and reference it by
   relative path — don't inline it. Put any output format in `skills/_templates/`.
4. Add a one-line entry to `skills/INDEX.md` and a note to `CHANGELOG.md`.
5. **Validate against real, already-approved work** before trusting it: feed the
   skill the same input a human had for a completed, signed-off artifact, and
   compare. The misses are the iteration backlog — tighten the persona's
   operating principles, not the output by hand.

## The planned library (build order)

The architect flow is the first target. Build atomic pieces bottom-up, then
assemble composites once the pieces are trustworthy.

**Architect's atomic skills, in suggested order:**
1. `frame-design` — DONE. Interactive office-hours framing (scope, standards,
   research, NFRs, assumptions, approach); pipeline entry; pre-populates a framed TD.
2. `generate-design-doc` — DONE. Deepens a framed TD into code-grounded architecture.
3. `check-security-standards` — DONE. Verifies a TD against named controls
   (conformance), distinct from threat-model (discovery).
4. `threat-model` — DONE. STRIDE discovery + gated write-back.
5. `cross-model-review` — DONE. Independent final review by a separate Claude
   subagent with fresh context (runs locally; gated write-back).
6. `check-engineering-standards` — DONE. Verifies a TD against the
   engineering-way standard (`_standards/engineering-way/`, ENG-* controls): the
   design-commitment controls only (TD-level), engineering sibling of
   check-security-standards. Built with its standard (the third `_standards/` domain).
7. `check-platform-constraints` — DONE. Verifies a TD **fits** the platform's declared
   constraints (`_standards/platform/`, PLAT-* house IDs: residency, approved services,
   tenancy, quotas, egress) and — **only when the design introduces/changes a platform
   component** — security-checks that new surface, citing existing controls (NCSC CP /
   A03 / A08 / ENG-OPS/SCM). The "fit" surface no other check owned; the inherited
   platform is cited, not re-verified. Built with its standard (the fourth `_standards/`
   domain).
8. The architect atomic set is now complete — frame → generate → engineering →
   platform → security → threat-model → cross-model-review, plus the revise-design
   re-entry loop.

**QA / QE (verification):**
- `verify-story` — BUILT (API + web drivers; mobile gated on per-repo validation). The
  running-system verification gate after the dev pipeline: drives the real API/browser/
  simulator (driver by `kind`) against the story's acceptance criteria and **verifies by
  writing durable e2e tests**; classifies env-vs-real failures before filing; routes
  confirmed defects back as failing tests (oracle → implement-plan), gated; never fixes
  product code or merges. Concrete tools live in the project's `.claude/qa-drivers.md`
  register (the library stays agnostic — it cites capabilities).

**Other high-value atomic skills:**
- `check-accessibility` — BUILT. WCAG 2.2 AA (spine + iOS/Android/web lenses in
  `_standards/accessibility/`); reviews UI-facing stories (filtered via their
  "Grounds in" block) and adds a11y acceptance criteria, plus a gated channel that
  flags design-level a11y blockers back to the TD. Story + design level only — the
  dev-side code / running-UI review is a named later increment. Drafts and flags;
  does not certify conformance.

**Composites:**
- `produce-tech-design` (architect) — BUILT and **complete**: frame-design →
  generate-design-doc → check-engineering-standards → check-platform-constraints →
  check-security-standards → threat-model → cross-model-review. No slots remain
  **Risk-tiered:** the baseline (steps 1-5) always runs;
  the two heavy steps are gated on a recorded human decision — threat-model on the
  accepted security sizing (None/Minor → "Not Required", recorded; Moderate/Major →
  run), cross-model-review default-on but skippable-with-reason; frame-design skipped
  if a framed TD already exists. Every skip is an owned entry in the Decision & change
  log — the composite never decides the tier. The `revise-design` re-entry loop applies
  review comments to a finished TD.
- `prepare-stories` (product) — BUILT: decompose-to-stories → check-accessibility.
  Thin product pipeline (TD + requirements → vertical, traceable, Jira-ready stories,
  then WCAG 2.2 AA review of the UI-facing ones), gated, never auto-deciding. A
  `push-stories-to-jira` slot is named for when an AI-usable Jira path exists —
  ticket creation is human today.
- `plan-and-implement` (dev) — BUILT: generate-acceptance-tests →
  generate-implementation-plan → implement-plan → `review-code` → `review-security`. The
  first pipeline to cross the architecture cap downward (writes code from a story);
  **model-tiered** — a capable host plans/supervises, a cheaper dispatched model writes the
  code fenced by the plan + the repo's gate suite (dispatch mechanism proven, design Spike
  0/0.5), then an independent fresh-context subagent reviews the diff (`review-code`,
  reusing the `cross-model-review` pattern with a host-applied trivial-fix path), then the
  **code-level security** (`review-security`) and **accessibility** (`review-accessibility`)
  reviews — same pattern, both **risk-tiered** — run on a security-relevant / UI-touching
  diff; human owns the merge. **Naming principle: `check-*` skills work at design/story level
  (conformance against named controls); `review-*` skills work at code/diff level
  (independent subagent on the diff).** So each standard is consumed at two altitudes by two
  skills — `check-security-standards`+`review-security`, `check-accessibility`+`review-accessibility`,
  and the engineering-way standard by `check-engineering-standards`+`review-code`. The **three
  code-level review lenses are complete** (general / security / accessibility); accessibility's
  runtime residue is deferred to the QA `accessibility-at-testing` slot. The only remaining
  named dev follow-on is the machine shared-module API-compat gate (`ENG-API-1` — the dev
  pipeline already routes shared-API breaks to the TD process; building it as a discrete gate
  is a separate increment).

Composites stay THIN — a named sequence plus glue. If a composite starts
containing its own standards logic, that logic belongs in an atomic skill.

**`docs/flows.md` is the single map of these pipelines** — every composite's steps,
each step's kind (mandatory / conditional / stop-degraded / re-entry / named-not-built)
and its gate, plus the cross-composite lifecycle and the re-entry loops. It is the
"one place" to see what runs when and what's optional. Keep it current whenever a
composite's sequence or a step's optionality changes (it's in the authoring.md
"before you merge" checklist, and `install.sh` warns if a composite is missing from it).

**Composites map to SDLC phases — they are the library's discoverable front doors.**
The organising principle is one composite per lifecycle phase, so a builder reaches for
the library by phase: **architecture** (`produce-tech-design`) → **breakdown**
(`prepare-stories`) → **implementation** (`plan-and-implement`) → **QA**
(`assure-quality`). A phase composite is justified by its **role** (the phase entry
point that accrues atomics over time), so it is legitimate even while it sequences a
single atomic — that is a phase home, not the composite-of-one anti-pattern. The phase
boundary is real: e.g. `review-code` and code-level checks are **implementation**
(they review the diff), while `verify-story` is **QA** (it verifies the running build).
The thin rule still holds — a phase composite owns no logic; it sequences atomics.

## What's deliberately NOT automated

Service Design and UX are out of scope for now. Lead approvals, story
sign-off, and the merge gate stay human — skills prepare and check; they do not
approve. This is intentional for assurance-critical work.
