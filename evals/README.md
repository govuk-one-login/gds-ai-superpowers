# evals — skill regression harness (Phase A)

Runs the library's own skills **headless** against sanitized reference cases and grades
the output with deterministic assertions. It catches the regression that most threatens
an assurance library: a change to a skill, a standard, or the model that silently
degrades output **or erodes a human-approval gate**.

Design: [`../docs/designs/td-evals-harness-phase-a.md`](../docs/designs/td-evals-harness-phase-a.md).
Feasibility spike: [`../docs/designs/spike-evals-headless-findings.md`](../docs/designs/spike-evals-headless-findings.md).

## What it does

For a case, the runner:
1. copies the case's `input/` into a clean temp working dir,
2. invokes the target skill headless (`claude -p --output-format json --permission-mode acceptEdits --add-dir <repo>`),
3. reads the produced/edited artifact and the run envelope,
4. runs the deterministic graders declared in `checks.yaml`,
5. prints per-check PASS/FAIL and exits non-zero on any failure.

## Run it

```bash
cd evals
# one-time, behind a TLS-inspecting proxy: export your CA bundle first
NODE_EXTRA_CA_CERTS=~/.claude/system-ca-bundle.pem bun install

# run a case
bun run src/run-evals.ts check-security-standards/baseline

# k=3 consistency run (gate assertions must be green on all three)
bun run src/run-evals.ts check-security-standards/baseline --runs 3

# keep the working dir for inspection; pin a model
bun run src/run-evals.ts check-security-standards/baseline --keep --model claude-sonnet-4-6
```

## Case format (the contributor contract — change-controlled, GDSW-API-1)

```
evals/<skill>/<case>/
  input/            # the working dir seed; the artifact the skill acts on lives here
    <artifact>      # e.g. td.md
  golden/           # (optional) sanitized approved reference, for the manual quality read
  checks.yaml       # declarative assertions (the schema)
```

`checks.yaml`:

```yaml
skill: <skill-folder-name>
artifact: <file in input/ the skill edits>
model: <optional model override>
checks:
  - type: gate-field-state        # PRIMARY gate detector (deterministic, output-only)
    file: <artifact>
    must_remain_unticked: [ ... ] # human-approval rows the skill must NOT tick itself
  - type: control-id-present      # quality floor: cites real controls
    file: <artifact>
    any_of: ["A0", "MASVS", "NCSC"]
  - type: no-inlined-standard     # single-source-of-truth: no pasted standard prose
    file: <artifact>
    forbidden_phrases: [ ... ]
  - type: halted-at-gate          # CORROBORATING only (the P5 exception)
    expect_no_denied_writes: true
```

## Phase A scope and limits

- **Quality is a manual read** against `golden/` for now; the LLM-judge is Phase B.
- **Sanitized/synthetic cases only** — never commit raw signed-off artifacts (public repo).
- The harness's own correctness is proven by a **planted-regression** fixture (a
  deliberately broken skill the graders must catch) — see the TD's Test approach.
