// Eval harness types — the checks.yaml schema (the contributor-facing contract,
// change-controlled per GDSW-API-1; see ../docs/designs/td-evals-harness-phase-a.md).

/** A single declarative assertion the runner interprets. */
export type Check =
  | GateFieldStateCheck
  | ControlIdPresentCheck
  | NoInlinedStandardCheck
  | HaltedAtGateCheck;

/**
 * Static, output-only. The PRIMARY gate detector (spike finding): a correctly-gated
 * skill must leave the named human-approval fields unticked — it proposes, the human
 * ticks. Asserts each named row's checkbox is still `[ ]` in the produced artifact.
 */
export interface GateFieldStateCheck {
  type: "gate-field-state";
  /** Artifact (relative to the working dir) to inspect. */
  file: string;
  /** Row labels whose `[ ]` checkbox the skill must NOT have ticked. */
  must_remain_unticked: string[];
  description?: string;
}

/** Static, output-only. The produced artifact must cite at least one real control ID. */
export interface ControlIdPresentCheck {
  type: "control-id-present";
  file: string;
  /** Pass if ANY of these substrings/patterns appears (e.g. "A0", "MASVS", "NCSC"). */
  any_of: string[];
  description?: string;
}

/** Static, output-only. Guards the single-source-of-truth rule: no standard text inlined. */
export interface NoInlinedStandardCheck {
  type: "no-inlined-standard";
  file: string;
  /** Verbatim phrases that should NEVER appear (would indicate copied standard prose). */
  forbidden_phrases?: string[];
  description?: string;
}

/**
 * Behavioral, trace-derived — the one acknowledged P5 exception, demoted to CORROBORATING
 * by the spike. Checks the run envelope rather than the artifact.
 */
export interface HaltedAtGateCheck {
  type: "halted-at-gate";
  /** Pass if the run did NOT auto-apply a gated change (no denials, or it asked first). */
  expect_no_denied_writes?: boolean;
  description?: string;
}

/** The full checks.yaml for one case. */
export interface CaseSpec {
  /** Target skill folder name (e.g. "check-security-standards"). */
  skill: string;
  /** The input artifact the skill acts on, relative to the case `input/` dir. */
  artifact: string;
  /** Optional model override (else the runner's default / the user's). */
  model?: string;
  /** Extra repo-relative dirs to expose to the headless run (e.g. for `_standards/`). */
  add_dirs?: string[];
  checks: Check[];
}

export interface CheckResult {
  type: Check["type"];
  pass: boolean;
  reason: string;
}

export interface CaseResult {
  case: string;
  skill: string;
  pass: boolean;
  checks: CheckResult[];
  envelope: RunEnvelope;
}

/** The subset of the `claude -p --output-format json` envelope the harness reads. */
export interface RunEnvelope {
  is_error: boolean;
  subtype?: string;
  stop_reason?: string;
  terminal_reason?: string;
  num_turns?: number;
  permission_denials?: unknown[];
  total_cost_usd?: number;
  result?: string;
}
