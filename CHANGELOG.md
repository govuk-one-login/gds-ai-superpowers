# Changelog

Tracks changes to skills and — importantly — to the encoded standards in
`_standards/`. Standards drift over time (framework versions, guidance updates);
this is the record of what changed and when, which feeds the assurance trail.

## [Unreleased]

### Changed
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
- **Library versioning.** A top-level `VERSION` file (starting at `0.1.0`) is the source of the
  bundle version; a standards change should bump it and republish (assurance trail for bundle
  consumers).
- Initial release of cadence — a generic, sector-agnostic skill library for Claude Code.
- Four lifecycle composites: `produce-tech-design` (architect), `prepare-stories` (product),
  `plan-and-implement` (dev), `assure-quality` (QA).
- 17 atomic skills covering architecture, breakdown, implementation, and QA phases.
- Four `_standards/` domains: security (OWASP Top 10:2025 / MASVS v2 / NCSC),
  accessibility (WCAG 2.2 AA + iOS/Android lenses), engineering-way (ENG-* house IDs),
  and platform (PLAT-* house IDs).
- Risk-tiering in `produce-tech-design` (threat-model and cross-model-review gated on
  accepted human decision).
- Three code-level review lenses in `plan-and-implement`: general (review-code), security
  (review-security), accessibility (review-accessibility), all risk-tiered.
- Deep-tier standard files for on-demand control depth (security ×17, engineering-way ×3,
  accessibility ×5).
