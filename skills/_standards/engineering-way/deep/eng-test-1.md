# ENG-TEST-1 Coverage bar — deep

Pull when the coverage commitment is contested or its applicability/source is unclear.

**Check**
- A per-`kind` coverage bar exists and the CI gate **fails** below it (not warns).
- Resolve the bar by precedence: the project's `.claude/standards/` value **wins**; else the
  engineering-way reference default (backend 85 / web 90 / iOS 85 / Android 75). **Report the source**
  in the finding: `[source: project .claude/standards]` vs `[source: engineering-way reference default]`.
- A full-stack repo may carry more than one bar (an 85% backend area + a 90% web area).
- An undeclared bar with no repo config is a **finding** ("coverage bar undeclared"), not a pass.

**Pitfalls**
- Reporting coverage in CI but not gating on it (the number drifts down unnoticed).
- Applying the reference default silently when the project actually declared a different one.
- Treating a high % as quality — coverage guards quantity; pair with ENG-TEST-3 (real assertions).

**Example / anti-example**
- *Bad:* "coverage is 80%, close enough" on a backend (bar is 85, gate not enforced).
- *Good:* gate fails at <85% backend; finding records `[source: engineering-way reference default]`.

**Source**: `../testing.md` (lens). The numbers are this programme's library-owned defaults.
