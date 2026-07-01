# Changelog

Tracks changes to skills and — importantly — to the encoded standards in
`_standards/`. Standards drift over time (framework versions, guidance updates);
this is the record of what changed and when, which feeds the assurance trail.

## [Unreleased]

### Added
- **`tech-writer` skill (atomic).** A two-pass prose-quality review for Technical
  Designs and story sets, walking every proposed edit back into the document one at a
  time, gated (Accept / Modify / Reject / Defer). Pass 1 clears cross-section
  duplication (WRITE-REP-1) before any line-level edits; pass 2 applies plain English
  (WRITE-PLAIN-*), abbreviation discipline (WRITE-ABBR-*), verbose-phrase trimming
  (WRITE-REP-2), and technical term/code formatting (WRITE-TECH-*) in priority order.
  Clarity first, conciseness second. Wired as the final step of `produce-tech-design`
  (step 8, after cross-model-review) and `prepare-stories` (step 3, after
  check-accessibility); also runs standalone on any document. Does not restructure
  content, change meaning, check document structure, or certify publication readiness.
- **`_standards/writing/govuk-style.md` (new standards domain).** Encodes the
  GOV.UK technical writing controls (WRITE-* house IDs) used by `tech-writer`:
  WRITE-PLAIN-1/2 (active voice, sentence length, substitution list), WRITE-ABBR-1/2
  (spell out on first use; known-exception list), WRITE-REP-1/2 (cross-section
  duplication; verbose phrases), WRITE-TECH-1/2 (introduce terms on first use; code
  formatting for literals). Primary source: GOV.UK Content Design guidance and style
  guide. One source of truth — cited by control ID, never copied into a skill.
- **`flows.md` updated.** `produce-tech-design` diagram and step table now show step 8
  (`tech-writer`, mandatory). `prepare-stories` diagram and step table now show step 3
  (`tech-writer`, mandatory).
- **`deep-edit` skill (atomic).** A standalone editorial skill that extends
  `tech-writer`'s prose checks with structural intervention: merging duplicate sections,
  reordering sections for better flow, splitting overloaded sections, and moving
  misplaced paragraphs — all gated (Accept / Modify / Reject / Defer). Works on any
  document regardless of template. Two passes: structure first (1.1 cross-section
  duplication, 1.2 section order, 1.3 overloaded sections, 1.4 misplaced paragraphs),
  then the same line-level prose checks as `tech-writer` (WRITE-PLAIN-*, WRITE-ABBR-*,
  WRITE-REP-2, WRITE-TECH-*). Standalone only — not wired into any composite pipeline.
  Does not delete information, change meaning, or propose a wholesale new outline.

### Changed
- **GDS fork — re-applied the GDS layer.** Replaced the genericised `engineering-way` (ENG-*)
  engineering standard with the **GDS Way** (`_standards/gds-way/`, GDSW-* controls, grounded in
  gds-way.cabinet-office.gov.uk), restored the GOV.UK Service Standard examples in
  `project-standards-template`, and rebranded to **GDS AI Superpowers** (Pages URL →
  `govuk-one-login.github.io/gds-ai-superpowers`). This is a fork of
  `DeloitteDigitalUK/assured-engineering-superpowers` (MIT; upstream copyright preserved in `LICENSE`).
- **Flattened the skill layout** from `skills/atomic|composite/<name>/` to a single-level
  `skills/<name>/`, to match the Claude Code plugin-marketplace layout that external skill
  installers (e.g. the `@ai-agent-manager/cli` agent-manager) discover. The atomic-vs-composite
  distinction now lives in each SKILL.md's new `kind:` frontmatter field (and INDEX.md grouping),
  not in folders. Skills' shared-file references changed from `../../_standards|_templates/...` to
  `../_standards|_templates/...` accordingly; cross-skill references from `../../atomic|composite/<name>/`
  to `../<name>/`. `install.sh` (resolve-check + composite drift guard now keyed off `kind: composite`),
  CLAUDE.md, `docs/authoring.md`, `docs/flows.md`, and `skills/INDEX.md` updated to match. No skill
  behaviour changed — this is a structural/distribution change. Every relative reference re-verified
  to resolve (link-check: 91/91).

### Added
- **agent-manager bundle distribution.** `scripts/build-bundle.sh` generates a publishable
  bundle (`dist/agents/index.json` + `dist/agents/<version>/bundle.zip` + sha256) from the
  skills tree, installable via the `@ai-agent-manager/cli` CLI
  (`npx @ai-agent-manager/cli@latest <bundle-url>`). The bundle copies the whole tree intact so
  `../_standards`/`../_templates` references resolve once a skill is symlinked from the CLI's
  cache. Verified end-to-end against the real CLI (v0.16.0): all 22 skills discovered, installed
  as symlinks, references resolve. Documented in `docs/onboarding-prompt.md` (interactive +
  headless), alongside the existing clone + `install.sh` developer path. `dist/` is gitignored
  (generated artifact). Windows is unsupported on this path (symlink-only; copy fallback orphans
  the shared trees).
- **GitHub Pages publishing + commit-driven releases.**
  `.github/workflows/publish-bundle.yml` releases on merge to `main`: it derives the next
  semantic version from the Conventional Commits since the last tag (`scripts/next-version.sh`),
  bumps `VERSION`, rolls this changelog, tags `vX.Y.Z`, and publishes the bundle to the
  `gh-pages` branch, served at `https://govuk-one-login.github.io/gds-ai-superpowers`. The reviewed PR
  merge is the human approval — no manual bump or tag. Versions accumulate (the workflow seeds
  from the already-published branch and regenerates the index across all of them), so pinned
  `bundle-version:` installs keep working. No third-party actions; integrity `.sha256` is served
  and verified. The type→bump policy is documented in `COMMIT_STANDARD.md`; `next-version.sh` is
  unit-tested and the release flow verified locally across versions.
- **Library versioning.** A top-level `VERSION` file (semver, starting at `0.1.0`) records the
  current release; it is maintained automatically by the release workflow. `build-bundle.sh`
  orders the index with a semver-aware sort so `0.10.0` ranks above `0.9.0` (the CLI treats the
  last index entry as "latest").
- Initial release of GDS AI Superpowers — a skill library for Claude Code.
- Four lifecycle composites: `produce-tech-design` (architect), `prepare-stories` (product),
  `plan-and-implement` (dev), `assure-quality` (QA).
- 17 atomic skills covering architecture, breakdown, implementation, and QA phases.
- Four `_standards/` domains: security (OWASP Top 10:2025 / MASVS v2 / NCSC),
  accessibility (WCAG 2.2 AA + iOS/Android lenses), GDS Way (GDSW-* house IDs),
  and platform (PLAT-* house IDs).
- Risk-tiering in `produce-tech-design` (threat-model and cross-model-review gated on
  accepted human decision).
- Three code-level review lenses in `plan-and-implement`: general (review-code), security
  (review-security), accessibility (review-accessibility), all risk-tiered.
- Deep-tier standard files for on-demand control depth (security ×17, GDS Way ×3,
  accessibility ×5).
