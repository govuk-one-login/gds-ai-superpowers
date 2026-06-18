# Changelog

Tracks changes to skills and — importantly — to the encoded standards in
`_standards/`. Standards drift over time (framework versions, guidance updates);
this is the record of what changed and when, which feeds the assurance trail.

## [Unreleased]

### Added
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
