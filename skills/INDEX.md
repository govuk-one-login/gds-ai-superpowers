# Skill Index

One line per skill: what it does, and when to reach for it. Keep this current —
it is how people discover what exists. Updating it is a contribution requirement.

## Atomic skills

### Standards & checks
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `check-security-standards` | Verifies a design against the named security standards (OWASP Top 10:2025, MASVS v2, NCSC Cloud Principles, Secure by Design) and completes the Security Considerations checklist, proposing gated edits. Conformance check — verifies controls; does not discover threats (that's threat-model) or accept sizing. | "does this meet our security standards", "fill the security checklist", "are the right controls named"; the security step of producing a TD. |
| `check-accessibility` | Reviews a story set against **WCAG 2.2 AA** (web + iOS + Android lenses): filters UI-facing stories via their "Grounds in" block, adds platform-correct accessibility acceptance criteria, and flags design-level a11y blockers back to the TD — both gated. Story + design level only. Drafts and flags; does NOT certify conformance, write the accessibility statement, review built UI code, or replace AT testing. | "check accessibility", "WCAG", "add a11y acceptance criteria", "accessibility review of these stories"; the accessibility step of `prepare-stories`. |
| `check-engineering-standards` | Verifies a **TD** against the **GDS Way standard** (`_standards/gds-way/`, GDSW-* controls): checks the design **commits** to the disciplines a TD should carry — language choice, the per-`kind` coverage commitment (reports the bar source), API versioning + shared-contract change control, operability, review/source-control model — and proposes gated edits. TD-level only (code-level realisation is the dev pipeline); defers security/a11y rows to their skills. The engineering sibling of check-security-standards in `produce-tech-design`. Does NOT review code, accept a gap, or sign off. | "does this design meet our engineering standards", "check the engineering commitments", "are the right GDSW controls named"; the engineering step of producing a TD. |
| `check-platform-constraints` | Verifies a **TD fits** the platform's constraints (`_standards/platform/`, PLAT-* house IDs: data residency, approved-services list, tenancy/isolation, resource/quota limits, network egress) read against the project's declared platform baseline — and, **only when the design introduces/changes a platform component** (new pipeline / account / cloud service), security-checks that new surface by citing existing controls (NCSC Cloud Principles, OWASP A03/A08, GDS Way GDSW-OPS/SCM). The platform-fit step of `produce-tech-design`, before check-security-standards. Does NOT verify the change's application-level security (that's check-security-standards), re-verify an unchanged platform (cited, not re-checked), accept a gap, or sign off. | "does this design fit our platform", "approved services / region / quotas / egress", "we're standing up a new pipeline/account — is that sound"; the platform step of producing a TD. |

### Generation
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `frame-design` | Interactive office-hours-style framing before any TD is written: scope, standards discussion, prior-art research (internal + privacy-gated web), NFRs, assumptions/risks, and approach — one question at a time. Pre-populates a framed TD for generate-design-doc. Entry of the architect pipeline. | "frame this", "scope this", "help me think this through", "office hours for this design", starting design from a PRD. |
| `generate-design-doc` | Drafts a Technical Design from a product brief, **grounded in the project's existing code** (via `.claude/source-map.md`): specifies architecture, infrastructure, mobile modules, and API contracts as reuse/extend/new, capped above function/code level. Reads the project's declared standards (`.claude/standards/`) and suggests others; leaves Security Considerations for the security skills; gates key decisions. Entry step of the architect pipeline. | "write a tech design", "turn this brief into a TD", "draft the technical design for this feature". |
| `decompose-to-stories` | Breaks a reviewed TD **plus its source requirements** into vertical, INVEST-shaped user stories: a gated capability map (transposes the TD's component axis into user value) then grounded-hybrid stories (value frame + Given/When/Then + a "Grounds in" block naming TD components/contracts). Full requirement↔story↔TD-element traceability + coverage; gaps walk back into the TD, gated. Output is **Jira-ready** (capability=Epic, story=Story) for manual ticket creation. Stops above function/code; never writes to Jira or signs off the backlog. | "decompose this design into stories", "break the TD into user stories", "prepare the stories/backlog for the developers". |

| `generate-acceptance-tests` | Turns one story's Given/When/Then criteria into **failing acceptance tests** (the oracle) in the repo's discovered framework/style, including edge/negative cases; human-gated as the spec. First step of the dev pipeline. Does NOT implement, write unit tests, make them pass, or sign them off. | "write the acceptance tests for this story", "test-first this story", "generate the failing tests". |
| `generate-implementation-plan` | Story + approved acceptance tests + real code → a function/file-level **implementation plan** (the first skill BELOW the architecture cap): files/functions, the gate commands + coverage target, a recommended implementer model, and a shared-module API check (routes unapproved breaks to the TD). The human-gated contract. Does NOT write code, write the tests, or approve its own plan. | "plan the implementation for this story", "how should we build this", "write the build plan". |
| `implement-plan` | Executes an approved plan by **dispatching a chosen (default cheaper) model** to write code to green against the repo's gate suite; per-run model recommendation, block-and-escalate, and the host **independently re-verifies**. Owns the model-tiering. Does NOT merge, let the implementer edit the oracle, or trust its self-report. | "implement this plan", "build this story", "run the implementer". |
| `review-code` | Independent review of the implemented **diff** by a separate Claude subagent with fresh context (runs locally): judges correctness, edge cases, reuse, idiom, and — its specific mandate — **catches the cheap implementer's tautological unit tests** (anti-pattern checklist). Risk-scaled effort (default med; auto-high on shared-module / security-sensitive diffs). Gated walk-back: host applies an approved trivial fix then **re-runs the gate suite + confirms the oracle**, routes substantive findings via generate-implementation-plan → implement-plan. The **general** correctness/quality lens — does NOT re-do security/accessibility (sibling slots), let the reviewer edit, merge, or accept risk. | "review this code", "review the diff", "code review", "check the implementation"; the review step of `plan-and-implement` after implement-plan. |

| `review-security` | Independent **security** review of the implemented **diff** by a separate Claude subagent with fresh context (runs locally): checks the diff **realises** the controls the TD committed and **introduces no new vuln** (injection, broken access/IDOR, secrets, crypto, SSRF…), each finding **cited to its control** (OWASP/MASVS/NCSC). **Risk-tiered** — runs when the diff is security-relevant (security-sensitive surface or sizing Moderate/Major), else records "Not Required". Gated walk-back like review-code (host applies trivial fix + re-gates + confirms oracle; substantive routes back via the plan). The **security, code-level** lens — does NOT do general correctness (review-code), re-do the TD checklist (check-security-standards), discover threats (threat-model), merge, or accept risk. | "security review of this diff", "check the code for vulnerabilities", "did we implement the security controls"; the code-level security step of `plan-and-implement` after review-code. |

| `review-accessibility` | Independent **accessibility** review of the implemented **diff** by a separate Claude subagent with fresh context (runs locally): flags the **statically-detectable** WCAG 2.2 AA failures in the UI code (missing alt/labels/names, non-semantic markup, ARIA absent or state not synced, target sizes below threshold, missing focus-visible/lang, heading order, missing live-regions), each **cited to its WCAG SC** (web/iOS/Android lens), and checks the diff realises the a11y acceptance criteria check-accessibility added. **Risk-tiered** — runs when the diff touches a UI surface, else "Not Required". Gated walk-back like review-security. Produces a **deferred-to-AT list** (rendered contrast, real screen-reader announcement, live focus) for the QA `accessibility-at-testing` slot — a green pass is NOT "accessibility done". The **accessibility, code-level** lens — does NOT do general correctness/security (review-code/review-security), re-do the story/design review (check-accessibility), drive the app with AT or certify conformance, merge, or accept risk. | "accessibility review of this diff", "check the UI code for WCAG issues", "did we implement the a11y criteria"; the code-level accessibility step of `plan-and-implement` after review-security. |

_(the dev pipeline's three code-level review lenses — review-code / review-security / review-accessibility — are now all built)_

### Verification (QA/QE)
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `verify-story` | Verifies the **running, built** software against a story's acceptance criteria by driving the real system (API/browser/simulator, driver picked by `kind`) and **codifying each verified criterion as a durable e2e test** (verify-by-automating). Classifies failures (env vs real) before filing; routes confirmed defects back to the dev pipeline **as failing tests**, gated. API + web drivers first-class; mobile gated on per-repo validation. Never fixes product code, never merges. | "QA this story", "verify it works end to end", "test the running app against the acceptance criteria", "do we have enough e2e tests". |

### Review & analysis
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `threat-model` | Structured threat model — STRIDE method with OWASP Top 10:2025, MASVS v2, NCSC Cloud Principles, and Secure by Design as lenses. Then (gstack-style) walks findings back into the source design one at a time, writing only approved updates. Drafts, flags, and proposes; never accepts risk. | Producing or extending a design that handles secrets, keys, or PII; "threat model this", "is this flow safe", "what's the attack surface". |
| `cross-model-review` | Independent final review of a complete TD by a separate Claude subagent with fresh context (runs locally — nothing leaves the machine). Presents the critique and walks findings back into the TD, gated. Never auto-applies or accepts risk. | "independent review", "second opinion on the design", "fresh eyes on the TD", final sign-off check. |
| `revise-design` | Applies a **list of review comments** to a TD (or story set / threat model) iteratively: normalises the comments into discrete items, maps each to a section, and walks each back one at a time (Accept/Modify/Reject/Defer), recording dispositions in the Decision & change log. The non-waterfall path back into an artifact after any step. **Routes** comments that belong to another skill (security/engineering/a11y/threat-model) or below the architecture cap (code-level → `plan-and-implement`) rather than applying them. Never batch-rewrites, accepts risk, or signs off. | "here are my review comments, work through them", "address this feedback on the TD", "apply these review comments", "revise the design from these comments". |

### Writing quality
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `tech-writer` | Reviews a completed Technical Design or story set for writing quality — plain English, abbreviations, cross-section repetition, and technical term/code formatting — then walks each proposed edit back into the document one at a time, gated. Two-pass: document-level duplication first (WRITE-REP-1), then line-level clarity checks (WRITE-PLAIN-*, WRITE-ABBR-*, WRITE-REP-2, WRITE-TECH-*). Drafts and proposes; never auto-applies. The last step of `produce-tech-design` and `prepare-stories`; also runs standalone. | "review the writing", "make this clearer", "plain English pass", "check the prose", "abbreviation check", "tidy up the writing"; the writing-quality step of either composite pipeline. |
| `deep-edit` | Like `tech-writer` but with structural intervention: can also merge duplicate sections, reorder sections for better flow, split overloaded sections, and move misplaced paragraphs — all gated. Standalone only; works on any document regardless of template. Two passes: structure first (duplication, order, splits, misplaced paragraphs), then line-level plain English, abbreviations, verbose phrases, and technical terms/code formatting. | "deep edit this", "restructure this document", "the structure is wrong", "this document is hard to follow", "editorial review"; any document that needs more than a prose pass or that does not follow a standard template. |

### Utility
| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `setup` | Install, update, re-link, or verify the library on this machine. Wraps `install.sh` with safety checks and post-install verification. | "set up gds-ai-superpowers", "update the skills", "why isn't my skill being discovered". |

## Composite skills

> The full pipeline map — every composite's steps, which are optional, where it stops,
> and where a human gates — is in [`../docs/flows.md`](../docs/flows.md).

| Skill | What it does | Reach for it when |
|-------|--------------|-------------------|
| `produce-tech-design` | Runs the architect pipeline end to end: frame-design → generate-design-doc → check-engineering-standards → check-platform-constraints → check-security-standards → threat-model → cross-model-review, refining one shared TD and gating every change (Accept/Modify/Reject/Defer). **Risk-tiered:** baseline always runs; the heavy steps are gated on a recorded human decision (threat-model on the accepted sizing; cross-model-review default-on/skippable; frame-design skipped if already framed) — every skip recorded, never auto-decided. Complete — no slots remain. | "produce the tech design", "take this brief through to a full TD", "run the architect pipeline". |
| `prepare-stories` | Runs the product pipeline: decompose-to-stories → check-accessibility, against one shared story set, gating every change. Thin orchestration; never auto-decides. Produces a developer-ready, WCAG-2.2-AA-checked, Jira-ready backlog. Does not create Jira tickets, certify accessibility, or sign off the backlog. | "prepare the stories", "take this TD to a backlog", "get the stories ready for the developers". |
| `plan-and-implement` | Runs the dev pipeline on one story: generate-acceptance-tests → generate-implementation-plan → implement-plan → review-code → review-security → review-accessibility (last two risk-tiered), gating every step; a chosen (default cheaper) model writes the code, independent subagents review the diff (general + security + accessibility), the human owns the merge. Thin orchestration; never auto-decides. The three code-level review lenses are complete. Does not merge or approve breaking changes. | "implement this story end to end", "take this story to code", "run the dev pipeline". |
| `assure-quality` | The **QA-phase** front door: runs verify-story against a built story to verify the running build against its acceptance criteria and leave durable e2e tests. Thin orchestration; never auto-decides; stops at a verified branch — the human merges. Grows with regression / performance / exploratory / AT-testing atomics. Does not merge, certify release, or fix product code. | "QA this story", "assure quality", "run the QA phase", "verify the built feature works". |

_(`plan-and-implement` (dev) follows as its pieces mature. A `push-stories-to-jira`
slot is named for when an AI-usable Jira path exists — ticket creation is human today.)_

## Shared standards (`_standards/`)
Not skills — reference files that skills cite. Edit once, every consumer is current.

**Two tiers (depth on demand).** Each lens file below is the thin, always-loaded index. Where
a control warrants it, a `<domain>/deep/<control-id>.md` file holds authored operational depth
(check / pitfalls / example / link) that a skill pulls **only** when about to record a control
Contested / Deferred / applicability Unclear — a single whole-file read, never the whole
standard. See CLAUDE.md "How standards are read". Today: security ×17, GDS Way ×3,
accessibility ×5 deep files (the WCAG ones pending the accessibility owner's review).

| File | Encodes | Used by |
|------|---------|---------|
| `_standards/security/stride.md` | STRIDE method + domain prompts | threat-model |
| `_standards/security/owasp.md` | OWASP Top 10:2025 | threat-model, check-security-standards, review-security |
| `_standards/security/masvs.md` | OWASP MASVS v2 | threat-model, check-security-standards, review-security |
| `_standards/security/ncsc-cloud-principles.md` | 14 NCSC Cloud Security Principles | threat-model, check-security-standards, review-security |
| `_standards/security/ncsc-secure-by-design.md` | NCSC Secure by Design posture | threat-model, check-security-standards |
| `_standards/accessibility/wcag.md` | WCAG 2.2 AA spine (full A/AA SCs + web realisation) | check-accessibility, review-accessibility |
| `_standards/accessibility/ios.md` | iOS realisation lens (anchored to WCAG SCs) | check-accessibility, review-accessibility |
| `_standards/accessibility/android.md` | Android realisation lens (anchored to WCAG SCs; not yet validated) | check-accessibility, review-accessibility |
| `_standards/gds-way/README.md` | GDSW-* register + conventions (house IDs, hybrid bars, provenance, no-duplication boundary) | check-engineering-standards |
| `_standards/gds-way/testing.md` | GDSW-TEST-* — coverage bars (hybrid), test pyramid, anti-vacuous (→review-code), CI gate | check-engineering-standards, generate-implementation-plan, review-code |
| `_standards/gds-way/api-compatibility.md` | GDSW-API-* — shared-contract change control, versioning, documented contracts | check-engineering-standards, generate-implementation-plan |
| `_standards/gds-way/code-review.md` | GDSW-REVIEW-* — peer review before merge, small PRs, what review covers | check-engineering-standards |
| `_standards/gds-way/languages.md` | GDSW-LANG-* — supported languages, idiom via linter, dependency hygiene | check-engineering-standards, review-code |
| `_standards/gds-way/source-control.md` | GDSW-SCM-* — protected main, coding in the open, conventional commits | check-engineering-standards |
| `_standards/gds-way/operability.md` | GDSW-OPS-* — structured logging (no PII), monitoring/alerting, docs-as-code/ADRs | check-engineering-standards |
| `_standards/platform/platform-constraints.md` | PLAT-* — platform fit constraints (residency, approved services, tenancy, quotas, egress, change-surface); categories here, values project-declared; PLAT-6 triggers the conditional security pass | check-platform-constraints |
| `_standards/writing/govuk-style.md` | WRITE-* — GOV.UK technical writing controls: plain English (WRITE-PLAIN-*), abbreviations (WRITE-ABBR-*), repetition/redundancy (WRITE-REP-*), technical terms and code formatting (WRITE-TECH-*) | tech-writer, deep-edit |
