---
name: review-security
kind: atomic
description: >
  Independently review an implemented diff through the **security** lens — a separate
  Claude subagent with fresh context reads the code cold and flags where the diff fails a
  security control or introduces a vulnerability (injection, broken access control / IDOR,
  secrets, weak crypto, unsafe deserialization, SSRF), citing the governing control
  (OWASP Top 10:2025, MASVS v2, NCSC). Use once a story is implemented to a green branch
  and the change is security-relevant — "security review of this diff", "check the code
  for vulnerabilities", "did we actually implement the security controls", or as the
  code-level security slot of the dev pipeline (`plan-and-implement`) after `review-code`.
  It is **risk-tiered** (runs when the diff touches a security-sensitive surface or the
  sizing warrants it; otherwise records a "Not Required" decision and skips), reuses the
  library's security standards, returns control-cited findings, and walks them back gated
  (host applies an approved trivial fix then re-runs the gate suite + confirms the oracle;
  substantive findings route back through the plan). It is the **security, code-level**
  lens — it does NOT do general correctness (that is `review-code`), does NOT re-do the
  TD-level checklist (that is `check-security-standards`), does NOT discover threats via
  STRIDE (that is `threat-model`), does NOT merge, and never accepts risk on the human's
  behalf.
---

# Review Security (review-security)

You orchestrate an **independent security review of an implemented diff by a separate
Claude subagent with fresh context** — a reviewer that did not write the code, reading it
cold through the security lens, as a security-minded reviewer would rather than as the
author defending it. You run the review, present its findings, and walk them back into the
branch **gated**. You never let the reviewer edit files, and you never accept its
suggestions on the dev's behalf.

The review runs **locally** — a Claude subagent dispatched with the Agent tool. Nothing is
sent to an external service.

## Where this sits among the security skills (two altitudes, the boundary)

The security standard is consumed at two altitudes by two skills — exactly as the
GDS Way standard is (check-engineering-standards at TD, review-code at code):

- **`check-security-standards` = TD level.** Does the *design* name the right controls? A
  conformance pass over the Security Considerations checklist.
- **`review-security` = code level (this skill).** Does the *diff* (a) **realise** the
  controls the TD committed, and (b) **introduce no new vulnerability**? An independent
  review of the actual code.

And beside it in the dev pipeline: **`review-code`** is the **general** correctness/quality
lens and explicitly defers security here; **`threat-model`** *discovers* threats at design
level (this skill checks code against known controls, it does not walk STRIDE).

## The thesis: `review-code`, pointed through the security lens

This reuses the `review-code` machinery — fresh-context, local, independent, **read-only**
reviewer; structured findings; gated write-back with a **host-applied trivial-fix path**
(treat that path with the same verify-then-believe discipline `implement-plan` uses). The
reviewer subagent stays read-only; the host applies only a fix the **human approved**, then
re-runs the gates. What changes from `review-code` is the **lens** (security, not general
correctness) and that findings are **cited to a control**.

## What you take as input
- The implemented **diff** — the **story branch vs its base** (`git diff <base>...HEAD`).
- The **story's acceptance criteria** + its **"Grounds in"** surface.
- The **TD's Security Considerations checklist** (the controls the design committed to) and
  the **accepted security sizing** — so the review can verify realisation and set its tier.

## Risk-tiering — when this runs
A dedicated security subagent on every diff is wasteful. Run it when **either**:
- the diff touches a **security-sensitive surface** — auth / session, access control /
  authorisation, input handling, crypto / key material, secrets / config, data access,
  external calls / egress, deserialization, file or process I/O (reuse `review-code`'s
  declared **security-sensitive path globs** where the project has them); **or**
- the accepted **sizing is Moderate / Major**.

Otherwise, **record the decision** — "code-level security review: Not Required (no
security-sensitive surface in diff; sizing None/Minor)" with the owner and reason — and
skip. A skip is a recorded, owned decision, never a silent omission. If the signals aren't
declared yet, default to **running** (fail safe), and say so.

## The lens it reviews
A single structured review that does two jobs:
- **Realisation** — for each control the TD's Security Considerations committed (e.g. "TLS
  in transit", "parameterised queries", "least-privilege IAM"), is it actually implemented
  in the diff, or is the commitment unmet?
- **New vulnerabilities** — does the diff introduce a security issue, mapped to its
  governing control: broken access control / IDOR (**A01:2025**), injection (**A05:2025**),
  supply-chain (**A03:2025**), crypto failures (**A04:2025**), on-device storage / key
  material (**MASVS-STORAGE/CRYPTO-***), transit / separation (**NCSC Principle 1 / 3**),
  and so on.

Severity is **by security impact** (a SQL injection is critical; a missing security header
is low), not by how large the code change is.

## Where the standards live
Read a `_standards/security/` lens only for a surface the diff touches (progressive
disclosure), using the **same surface-to-framework routing as
`../check-security-standards/SKILL.md`** — backend/web/API → `../_standards/security/owasp.md`;
mobile/on-device → `../_standards/security/masvs.md`; cloud/transit →
`../_standards/security/ncsc-cloud-principles.md`. Cite control identifiers; never inline
standards text.

**Depth on demand:** when about to record a control **Contested / applicability Unclear**
and its lens line carries a `deep:` pointer, pull that one control's deep file
(`../_standards/security/deep/<id>.md`) — its **Check** list is written for exactly this
(diff-level: "no string-built SQL", "scoped queries / no IDOR", "deps scanned in CI"). One
whole-file read; don't re-pull within this invocation. The lens stays the citable source.

## Workflow

### 1. Tier the review
Compute the diff (story branch vs its base). Apply the **risk-tiering** rule above: decide
**run** or **Not Required (recorded)**. If Not Required, write that decision to the report
and stop here. If running, set effort by sizing/surface (Moderate → standard; Major or a
high-risk surface → thorough).

### 2. Dispatch the independent reviewer (read-only, fresh context)
Spawn a subagent (Agent tool, fresh context) and give it: the **security-reviewer persona**,
the **base ref** (so it computes the diff itself), the **acceptance criteria + "Grounds in"**,
the **TD's committed security controls**, the **routing table**, and the **two-job rubric**
(realisation + new vulns). Ask for findings only — it must not edit anything.

Findings in an **exact machine-parseable format** — one per line as JSON, each cited to a
control:

```
{"control": "A01:2025|MASVS-STORAGE-1|NCSC Principle 1|…", "location": "file:line", "severity": "critical|high|medium|low", "kind": "realisation-gap|new-vuln", "issue": "...", "proposed_fix": "...", "confidence": "high|medium|low"}
```

Tell it: this is a **code-level** security review of a real diff; verify a doubtful claim
against the actual source; cite the governing control for every finding; do **not** re-do
the general correctness review (review-code owns that) or walk STRIDE (threat-model owns
discovery).

### 3. Triage
Drop env/noise findings; keep the real ones. Classify each **trivial/local** (a fix
confined to lines the diff touches, no new design decision — e.g. swap a string-built query
for a parameterised one) or **substantive** (changes the approach / implies a plan delta —
e.g. a missing authorisation layer).

### 4. Gated walk-back — one finding at a time
Present each finding (with its cited control and proposed fix) and ask **Accept / Modify /
Reject / Defer**. The reviewer never edits; on **Accept** the **host** acts by class:
- **Trivial/local** → host edits the branch, then **re-runs the repo's gate suite to green
  AND confirms the acceptance tests (the oracle) are unchanged**. A red branch is a block —
  revert or re-route; never leave it red.
- **Substantive** → route back **`generate-implementation-plan` → `implement-plan`** as a
  plan amendment, re-implement, re-gate — then `review-security` re-reviews.

A finding whose fix is a **risk acceptance** (e.g. "accept this residual exposure") is the
human's decision — propose and record the owner; never accept it yourself. Record every
disposition in the report (the assurance trail). The human owns the merge throughout.

### 5. Output
Produce the report (`../_templates/security-review-report-template.md`) — the tiering
decision (ran / Not Required + why), the control-cited findings, and the disposition table —
and hand back a **review-clean branch** (or one with routed substantive work pending).
Report: whether it ran, the findings by control, what was applied vs routed, the
host-reconfirmed gate results for any applied fix, and that the oracle is intact. Hand off to
the sibling `review-accessibility` check and ultimately the **human merge gate**.

## What this skill does NOT do
- It does not do the general correctness/quality review — that is `review-code` (the sibling
  beside it); this is the security lens only.
- It does not re-do the TD-level conformance checklist — that is `check-security-standards`;
  this verifies the diff **realises** what that committed, and hunts new vulns in the code.
- It does not discover threats via STRIDE — that is `threat-model` (design-level discovery).
- It does not let the reviewer edit files — the reviewer returns findings only; the **host**
  applies, and only what the **human approved**, with a gate re-run + oracle check after.
- It does not accept risk, merge, or sign off — it stops at a review-clean branch; risk
  acceptance and the merge stay the human's.
- It does not send the diff to any external service — the review is local.

## A note on validation
Validate against a real merged PR that had a known security issue (or seed one — a
string-built query, an unscoped object fetch): run the reviewer over the diff and confirm it
flags the issue and cites the right control. Recurring misses are the iteration backlog —
tighten the routing and the rubric (and the deep-tier `Check` lists), not the output by hand.
