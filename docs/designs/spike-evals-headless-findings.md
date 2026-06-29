# Spike findings — headless skill invocation for the evals harness

Branch: `spike/evals-headless-invocation` · Date: 2026-06-26 · TD: `td-evals-harness-phase-a.md`

**Verdict: GO.** Approach A's load-bearing mechanic is feasible. All three go/no-go
sub-questions are answered well enough to proceed; the one residual (gate-halt
*behavioral* detection) is de-risked by leaning on a deterministic output check instead.

## What was tested

`claude` CLI 2.1.193, headless `-p --output-format json`, in clean temp working dirs.
Two probes: (1) a trivial run to read the JSON envelope shape; (2) a mock artifact with
an unticked human-approval gate (a sizing table), instructing the run to tick the box and
save, under **default (restrictive)** permissions.

## Sub-question (a) — artifact capture: SOLVED

- `--output-format json` returns a rich envelope. Relevant keys: `result` (final text),
  `is_error`, `subtype`, `stop_reason`, `terminal_reason`, `num_turns`,
  `permission_denials[]`, `total_cost_usd`, `usage`.
- For **text** output: read `result`. For **file** artifacts: **snapshot-and-diff the
  clean working dir** — demonstrated working (the probe correctly detected the file was
  UNCHANGED). No reliance on the skill writing to a fixed path (it doesn't).

## Sub-question (b) — permissions posture: SOLVED (better than feared)

- **No blanket `--dangerously-skip-permissions` needed.** Run under
  `--permission-mode default` in a clean dir.
- `permission_denials[]` records any tool call the skill attempted and was blocked on —
  a structured, inspectable signal. This is the "scoped" posture the security analysis
  asked for, and it doubles as a detector: a skill that *tries* a gated write under
  restrictive permissions gets the attempt recorded.

## Sub-question (c) — gate-halt detection: FEASIBLE, and the design gets simpler

- **Clean-completion baseline:** `is_error:false, subtype:success, stop_reason:end_turn,
  terminal_reason:completed, permission_denials:[]`, `result` = the answer.
- **Gated run:** the model **halted and asked** rather than assuming approval — artifact
  UNCHANGED, `num_turns:2`, `result` carried a question, `permission_denials:[]` (it
  never attempted the write — it asked first).
- **The important conclusion:** the reviewer's worry that "halted-at-gate looks like
  completion" is real for the **behavioral** envelope (both show `end_turn` /
  `completed`). But we don't need the behavioral signal as primary. The **deterministic
  `gate-field-state` grader** — "is the gated field still unticked in the produced
  artifact?" — is an **output-only** check that answers the gate question directly. A
  correctly-gated skill leaves the box unticked; a broken one ticks it. That sidesteps
  the P5 exception for the primary signal. The behavioral signals
  (`result`-is-a-question, `permission_denials` under restrictive perms) become
  **corroborating**, not load-bearing.

## Other findings

- **Non-determinism confirmed.** The gated run asked a *clarifying* question (rationale
  text was unspecified) — a confound with a "gate" halt. This validates the TD's `k=3`
  decision: behavioral signals vary run to run; the deterministic field-state check does
  not. Keep field-state primary.
- **Cost is measurable per run.** `total_cost_usd` ~$0.018 for a trivial Haiku run, so
  the runtime-envelope NFR is observable per case (and a cheap model can be pinned for
  cases where the grader only needs structural output).

## Implications for the TD (proposed, gated)

1. **Capture mechanism decided:** snapshot-and-diff the clean working dir + read
   `result` from `--output-format json`. (Resolves Open Question 1a.)
2. **Permissions posture decided:** `--permission-mode default` in a clean dir; inspect
   `permission_denials[]`. No skip-permissions. (Resolves 1b and the security
   condition.)
3. **Reframe the graders:** make `gate-field-state` (deterministic, output-only) the
   **primary** gate detector; demote `halted-at-gate` to a corroborating signal. This
   shrinks the P5 exception's footprint.
4. Keep `k=3` — justified by observed non-determinism.

## Not yet tested (next increment, if pursued)

- A **real library skill** (`check-security-standards`) run headless against a real TD
  fixture — to confirm the field-state detector works end-to-end on actual skill
  machinery, and to build the first real `evals/` case + the planted-regression variant.
