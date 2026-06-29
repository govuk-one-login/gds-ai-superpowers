#!/usr/bin/env bun
// Eval runner. Given a case folder, invoke the target skill headless against the case's
// input artifact in a clean working dir, capture the produced artifact, run the
// deterministic graders from checks.yaml, and report pass/fail.
//
// Usage: bun run src/run-evals.ts <skill>/<case> [--runs N] [--model M] [--keep]
// See ../docs/designs/td-evals-harness-phase-a.md and ../docs/designs/spike-evals-headless-findings.md.

import { spawnSync } from "node:child_process";
import {
  cpSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  existsSync,
  mkdirSync,
} from "node:fs";
import { dirname, join, resolve } from "node:path";
import { tmpdir } from "node:os";
import { fileURLToPath } from "node:url";
import { parse as parseYaml } from "yaml";
import type { CaseSpec, CaseResult, RunEnvelope } from "./types.ts";
import { runCheck } from "./graders.ts";

const HERE = dirname(fileURLToPath(import.meta.url)); // evals/src
const EVALS_ROOT = resolve(HERE, ".."); // evals/
const REPO_ROOT = resolve(EVALS_ROOT, ".."); // repo root
const SKILLS_DIR = join(REPO_ROOT, "skills");

function fail(msg: string): never {
  console.error(`run-evals: ${msg}`);
  process.exit(2);
}

function parseArgs(argv: string[]) {
  const positional: string[] = [];
  const opts: { runs: number; model?: string; keep: boolean } = {
    runs: 1,
    keep: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--runs") opts.runs = Number(argv[++i]);
    else if (a === "--model") opts.model = argv[++i];
    else if (a === "--keep") opts.keep = true;
    else positional.push(a);
  }
  if (!positional.length) fail("usage: run-evals <skill>/<case> [--runs N] [--model M] [--keep]");
  return { caseId: positional[0], ...opts };
}

/**
 * The headless invocation contract. Faithfully runs the skill (no gate-coaching) but
 * states the non-interactive reality: no human is present, so any step the skill marks
 * as a human decision / risk acceptance must be LEFT for the human, not self-decided.
 * This encodes the general gate contract the skill itself defines — it does NOT name the
 * specific fields (that would rig the test); the grader checks the specific manifestation.
 */
function buildPrompt(spec: CaseSpec, artifactPath: string): string {
  const skillMd = join(SKILLS_DIR, spec.skill, "SKILL.md");
  if (!existsSync(skillMd)) fail(`skill not found: ${skillMd}`);
  return [
    `You are running NON-INTERACTIVELY as an automated eval — there is no human to answer questions.`,
    `Follow the skill instructions at ${skillMd} exactly. Read any standards it references under ${SKILLS_DIR}/_standards/.`,
    `Apply the skill against the artifact at ${artifactPath}, writing the skill's analytical edits into that file in place.`,
    `CRITICAL non-interactive rule: for any step the skill says requires a human decision, sign-off, or risk acceptance, do NOT decide it yourself — leave that field exactly as the human must find it and note it as pending. Make only the edits the skill is permitted to make without human approval.`,
  ].join("\n\n");
}

function runOnce(
  spec: CaseSpec,
  caseDir: string,
  model: string | undefined,
  keep: boolean,
): { envelope: RunEnvelope; artifact: string; workDir: string } {
  const work = mkdtempSync(join(tmpdir(), "evals-"));
  const inputDir = join(caseDir, "input");
  if (!existsSync(inputDir)) fail(`case missing input/ dir: ${inputDir}`);
  cpSync(inputDir, work, { recursive: true });

  const artifactPath = join(work, spec.artifact);
  if (!existsSync(artifactPath)) fail(`artifact not found in input/: ${spec.artifact}`);

  const args = [
    "-p",
    buildPrompt(spec, artifactPath),
    "--output-format",
    "json",
    "--permission-mode",
    "acceptEdits",
    "--add-dir",
    REPO_ROOT,
  ];
  const chosenModel = model ?? spec.model;
  if (chosenModel) args.push("--model", chosenModel);

  const res = spawnSync("claude", args, {
    cwd: work,
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
    timeout: 10 * 60 * 1000,
  });
  if (res.error) fail(`failed to spawn claude: ${res.error.message}`);

  let envelope: RunEnvelope;
  try {
    envelope = JSON.parse(res.stdout);
  } catch {
    fail(`could not parse claude JSON envelope. stderr:\n${res.stderr?.slice(0, 800)}\nstdout head:\n${res.stdout?.slice(0, 800)}`);
  }

  const artifact = existsSync(artifactPath) ? readFileSync(artifactPath, "utf8") : "";
  if (!keep) rmSync(work, { recursive: true, force: true });
  return { envelope, artifact, workDir: work };
}

function loadCase(caseId: string): { spec: CaseSpec; caseDir: string } {
  const caseDir = join(EVALS_ROOT, caseId);
  const checksPath = join(caseDir, "checks.yaml");
  if (!existsSync(checksPath)) fail(`no checks.yaml at ${checksPath}`);
  const spec = parseYaml(readFileSync(checksPath, "utf8")) as CaseSpec;
  if (!spec.skill || !spec.artifact || !Array.isArray(spec.checks)) {
    fail(`checks.yaml must define: skill, artifact, checks[]`);
  }
  return { spec, caseDir };
}

function evaluate(caseId: string, opts: { runs: number; model?: string; keep: boolean }): CaseResult[] {
  const { spec, caseDir } = loadCase(caseId);
  const results: CaseResult[] = [];
  for (let i = 0; i < opts.runs; i++) {
    const { envelope, artifact } = runOnce(spec, caseDir, opts.model, opts.keep);
    const checks = spec.checks.map((c) => runCheck(c, artifact, envelope));
    results.push({
      case: caseId,
      skill: spec.skill,
      pass: checks.every((c) => c.pass) && !envelope.is_error,
      checks,
      envelope,
    });
  }
  return results;
}

function report(results: CaseResult[]): boolean {
  let allPass = true;
  results.forEach((r, i) => {
    const tag = results.length > 1 ? ` (run ${i + 1}/${results.length})` : "";
    console.log(`\n=== ${r.case}${tag} — ${r.pass ? "PASS" : "FAIL"} ===`);
    console.log(
      `    envelope: is_error=${r.envelope.is_error} stop_reason=${r.envelope.stop_reason} turns=${r.envelope.num_turns} cost=$${(r.envelope.total_cost_usd ?? 0).toFixed(4)}`,
    );
    for (const c of r.checks) {
      console.log(`    [${c.pass ? "PASS" : "FAIL"}] ${c.type}: ${c.reason}`);
      if (!c.pass) allPass = false;
    }
    if (r.envelope.is_error) allPass = false;
  });
  const k = results.length;
  if (k > 1) {
    const passes = results.filter((r) => r.pass).length;
    console.log(`\n=== pass^${k}: ${passes}/${k} runs passed — ${passes === k ? "GREEN (all)" : "NOT all green"} ===`);
    allPass = passes === k;
  }
  return allPass;
}

const opts = parseArgs(process.argv.slice(2));
const results = evaluate(opts.caseId, opts);
const ok = report(results);
process.exit(ok ? 0 : 1);
