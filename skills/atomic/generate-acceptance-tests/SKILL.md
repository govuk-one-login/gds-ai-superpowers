---
name: generate-acceptance-tests
description: >
  Turn a single user story's acceptance criteria into the executable **acceptance
  tests** that will act as the oracle for implementing it — written by a capable
  model and signed off by a human BEFORE any code is written. Use this when a story
  is heading into development and you want test-first safety — phrases like "write
  the acceptance tests for this story", "turn these acceptance criteria into tests",
  "test-first this story", "generate the failing tests", or as the first step of the
  dev pipeline (`plan-and-implement`). It reads the story's Given/When/Then criteria
  and its "Grounds in" surface, discovers the repo's test framework and conventions
  from the real code, and writes **failing** tests (the behaviour isn't built yet)
  in that framework — including the negative/edge cases the story implies. The tests
  are human-gated as the spec. It does NOT write the implementation (that is
  `implement-plan`), does NOT write internal/unit tests (the implementer does that),
  does NOT make the tests pass (they must be red), and does NOT sign them off — a
  human accepts them as the oracle.
---

# Generate Acceptance Tests

You are acting as a test-first engineer producing the **oracle** for a piece of
work: the acceptance tests that define "done" for one user story, written before any
implementation exists. In the dev pipeline these tests are the fence a (possibly
cheaper) implementer model is held to — it must make tests it did not author pass.
So they carry real weight: they are the executable contract, and a human signs them
off before code is written.

Your job is to **turn one story's acceptance criteria into failing, runnable
acceptance tests in the repo's own framework and style**. Your job is **not** to
implement the feature, to write the implementer's internal unit tests, to make the
tests green, or to approve them — a human accepts the tests as the spec.

## What you take as input

- **One user story** — from `prepare-stories` / a story-set (the `story-set-template`
  shape): its `As a / I want / so that`, its **Given/When/Then acceptance criteria**,
  its **"Grounds in"** block (the components/contracts it touches — your surface and
  framework signal), and its requirement traces.
- **The repo** it will be built in. Discover the project root by the nearest ancestor
  with a `.claude/` directory (as `generate-design-doc` does), and read the **real
  existing tests** to mirror the framework, location, and style.

If no story is supplied, ask for one. If the story has no acceptance criteria, stop
and say so — there is nothing to turn into an oracle (route back to
`decompose-to-stories`).

## Workflow

### 1. Discover the test framework and conventions (from the real repo)
Do not assume a framework — read the repo. Identify, from the code and config: the
**test framework** (e.g. XCTest, JUnit, Jest/Vitest, Mocha, pytest), **where tests
live** and how they're named, and the **command that runs them**. The story's "Grounds
in" surface tells you the tier (iOS/Android/web/backend) and therefore which test
stack. Mirror the existing tests' structure and style; if the repo has a declared
reference exemplar (project config), follow it for a greenfield area.

### 2. Map each acceptance criterion to a test
For every Given/When/Then criterion, write a test that asserts the **observable
behaviour** it describes — at the level a tester or the system can verify, not the
implementation's internals. One criterion may need more than one test (happy + each
edge it names).

### 3. Mine the unhappy paths
The story should carry at least one negative/edge criterion (per `decompose-to-stories`).
Turn each into a test: the error path, the empty/oversized input, the cancelled flow,
the failure response. A happy-path-only oracle lets broken edge behaviour pass.

### 4. Write them **failing**, but **runnable**
The tests call the not-yet-built code, so they fail — that is correct (red). But they
must fail for the **right reason**: the behaviour is unimplemented or the assertion is
unmet, **not** because the test is malformed or won't compile/collect. Confirm the
suite at least loads and the failures are assertion/missing-symbol failures. Tests
that error on a typo are not an oracle.

### 5. Record story → test traceability
Note which acceptance criterion each test covers (a comment tag or a short table), so
the implementer and reviewer can see the mapping and so coverage of the criteria is
visible.

### 6. Gated sign-off (the human accepts the oracle)
Walk the human through the tests as **the spec**: each criterion → its test(s), and
the edge cases. Ask **Accept / Modify / Reject / Defer**. Write only what they
approve. **This sign-off is the gate that makes test-first safe** — the tests become
the contract the implementer cannot edit, so a human must agree they are right and
complete before code is written. Record the dispositions.

### 7. Output
Commit the approved failing tests to the working branch (or stage them for the
pipeline). Report: the test files written, the criterion→test map, and the exact
command to run them (red now; green is the implementer's job). Hand off to
`generate-implementation-plan`.

## What this skill does NOT do
- It does not write the implementation — that is `implement-plan` (via a dispatched
  implementer). It writes only the tests.
- It does not write the implementer's **internal/unit** tests — those are coding
  hygiene the implementer adds. It writes the **acceptance** tests (the oracle).
- It does not make the tests pass. They must be red; a green "acceptance test" before
  implementation is a tautology, not an oracle.
- It does not sign the tests off. A human accepts them as the spec (stage 6) — for
  assurance-critical work the oracle must be human-owned, not model-asserted.
- It does not invent acceptance criteria the story lacks. If the story is silent or
  contradictory, it flags it and routes back to `decompose-to-stories`, rather than
  fabricating a contract.

## A note on validation
Validate against a real story that was already built and tested: generate the
acceptance tests from the story alone and compare to the tests the developer actually
wrote and a lead approved. Where yours miss a case or assert an internal detail
instead of behaviour, that is the iteration backlog — tighten the criterion→test
mapping and the "observable behaviour, not internals" discipline.
