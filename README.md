# GDS AI Superpowers - Proof of Concept

A Proof-of-Concept demo library of reusable **skills** for [Claude Code](https://claude.com/claude-code)
that encode the engineering, security, accessibility, and delivery standards used on
UK government (GDS / GOV.UK) digital work. Think of each skill as an experienced
practitioner you can summon by name — a security architect, an accessibility
reviewer, a QA engineer — who already knows the standards and walks you through the
work, one decision at a time.

The library does the standards; **you keep control**. Every skill drafts, checks, and
proposes — it never signs off, accepts risk, or merges code on your behalf. Those stay
human decisions, on purpose, because this is built for UK government assurance
work — where a human sign-off has to mean something.

> **How to read this**
> - **Product / delivery lead, new to this?** Read *What it is*, *How it works*, *The
>   lifecycle*, and *Your first run*. That's the whole idea in about five minutes — you
>   don't need to install anything to understand what your team can do with it.
> - **Engineer setting it up?** You'll also want *What you need*, *Install*, and *Give
>   the skills your project's context* — that last one is what makes the skills ground
>   themselves in *your* codebase instead of guessing.

---

## What it is

On any assurance-critical engagement, the same standards apply over and over: secure
by design, WCAG 2.2 AA accessibility, test coverage bars, a real audit trail for
every decision. Getting them right by memory, on every design and every change, is
where teams drift.

This library encodes those standards **once** and hands them to an AI assistant as a
set of focused tools. Ask for a technical design and it runs the same security check
your reviewer would. Ask it to break that design into developer tickets and it applies
the same accessibility rules. The design, the code, and the review all check against
the *identical* encoded standard — so there's no drift between what one person
remembers and what another does.

The design principle behind the whole thing: **standards are owned by the work, not
the role.** A security check lives in one file and is reused by every skill that
touches security — the architect's design, the developer's code, the reviewer's gate.
Fix it in one place, everyone is current.

The library is **product-agnostic**. It ships only the cross-engagement standards and
the skills that apply them. Your specific project — its codebase, its compliance
obligations, how its system is deployed — you tell it, by dropping a few small files
into your own project (see [*Give the skills your project's context*](#give-the-skills-your-projects-context-claude)).

---

## How it works

If you've never used a tool like this, here's the mental model.

**Skills are commands Claude can run.** Once installed, each skill is a slash command —
you type `/produce-tech-design` or `/threat-model` and Claude follows that skill's
expert playbook. Claude also picks the right skill automatically when you describe a
task ("turn this brief into a tech design") — each skill carries a description that
tells Claude when to reach for it.

**They work *with* you, not at you.** A skill asks one question at a time, the way a
good colleague in a design session would — pushing on vague scope, surfacing what the
brief left unsaid. It doesn't fire a wall of questions and disappear.

**Every change is gated.** When a skill finds something — a security control to add, a
risk, a missing acceptance criterion — it brings that one finding to you with the
concrete change it suggests, and asks: **Accept / Modify / Reject / Defer.** It writes
only what you approve. Nothing is silently rewritten, and the decision and who made it
are recorded — that record is the audit trail.

**Humans own the decisions that matter.** Skills draft and check; they never accept a
security risk, certify accessibility, approve a design, or merge code. Those gates stay
yours. This is deliberate: for assurance-critical work, the human sign-off has to mean
something.

**It stays at the right altitude.** A technical design describes the architecture and
the public interfaces other teams build against — it stops above the code, and it
doesn't wander off into hardening your source control setup. The lower-level "how the
code is written" is a separate, later step. Skills know their boundaries.

---

## The lifecycle

The skills compose into a pipeline for each phase of delivery, and **each phase has one
front-door command** you reach for by stage. Every step gates each change past a human;
the merge, the risk acceptance, and the sign-off stay human.

| Phase | Command | What it does |
|-------|---------|--------------|
| **Architecture** | `/produce-tech-design` | a product brief → a framed, drafted, security-checked, threat-modelled, independently reviewed Technical Design |
| **Breakdown** | `/prepare-stories` | a Technical Design + its requirements → traceable, accessibility-checked, Jira-ready user stories |
| **Implementation** | `/plan-and-implement` | one story → acceptance tests → a build plan → code (a strong model plans, a cheaper one writes, fenced by the plan and your repo's tests) → a reviewed branch |
| **QA** | `/assure-quality` | run the **built** software against the story's acceptance criteria, leaving durable end-to-end tests behind |

Each front-door command is a thin recipe — all the real work lives in smaller skills it
runs in order, and every one of those also runs on its own (`/threat-model`,
`/check-accessibility`, `/verify-story`, and so on).

For the full map of each pipeline — every step, which are optional, where it stops, and
where a human gates — see [`docs/flows.md`](docs/flows.md).

---

## What you need

These skills run **inside Claude Code**, Anthropic's agentic coding tool. If your team
hasn't used it before:

- **Claude Code** — install it from [claude.com/claude-code](https://claude.com/claude-code).
  It runs in a terminal or as a Mac/Windows desktop app. (Product people: you don't need
  to install anything to *understand* the library — this is for whoever sets it up.)
- **Git** and a terminal — to fetch this library once.
- **A project to use it on** — the repo or workspace where your actual design and code
  live. The skills run there, not in this library's folder.

---

## Install

You clone this library once, then install it into Claude Code. Installing drops a small
pointer (a symlink) for each skill into Claude Code's skills folder, each pointing back
into your clone — so a `git pull` later updates every skill at once. The pointers sit
alongside any other skills you have; nothing is overwritten.

```bash
git clone <your-clone-url> ~/repos/gds-ai-superpowers
cd ~/repos/gds-ai-superpowers
./install.sh            # installs for all your projects (global)
./install.sh --local    # installs only into the current repo's ./.claude/skills
```

That makes the commands available — `/produce-tech-design`, `/prepare-stories`,
`/plan-and-implement`, `/assure-quality`, and every smaller skill — in any repo where
you installed them.

**To update:** `git pull` in the clone. Re-run `./install.sh` only when a new skill was
added or a pointer broke.

### Or install without cloning (agent-manager)

If you just want to *use* the skills (not author them), install the published bundle with
the [`@ai-agent-manager/cli`](https://github.com/ai-agent-manager/agent-manager) tool — no
clone needed:

```bash
npx -y @ai-agent-manager/cli@latest https://govuk-one-login.github.io/gds-ai-superpowers
```

This installs a versioned snapshot (pick your skills in the prompt, or pin a
`bundle-version:` for CI). It's macOS/Linux only and updates via re-running rather than
`git pull` — see [`docs/onboarding-prompt.md`](docs/onboarding-prompt.md) for the details
and trade-offs.

### Prefer to let Claude do it

After cloning, start Claude Code in the repo and paste the onboarding prompt from
[`docs/onboarding-prompt.md`](docs/onboarding-prompt.md). It runs the `setup` skill,
which installs, runs safety checks, and verifies everything is discoverable — and
update / re-link / health-check become prompt-driven too. The only unavoidable manual
step is the first `git clone`: a model can't fetch a repo it can't see, and we keep it a
visible step rather than a blind pipe-to-shell on purpose (the doc explains why).

---

## Your first run — a worked example

Say your team is building **"apply for a resident parking permit"**: residents apply
online, council staff review, the applicant gets a reference number and an email, and
permits renew yearly. You have a one-page brief.

In your project repo (with Claude Code running and the skills installed), you type:

```
/produce-tech-design
```

and point it at the brief. Here's what happens — and where *you* stay in control:

1. **It frames the work with you.** One question at a time: who applies, what's in and
   out of scope, what already exists to reuse, the non-functional needs (how many
   applications a day? how fast? what personal data?), and the high-level approach. It
   pushes back when an answer is vague.
2. **It drafts the design, grounded in your real code.** Because you've told it where
   your code lives (next section), it reuses your existing notifications library and
   your forms components instead of inventing them — and it tags each part of the
   design *reuse / extend / new*.
3. **It checks its direction with you first.** Before writing the full document it shows
   you a short *Approach & key decisions* summary and waits for your **Accept** — so you
   can redirect cheaply, or hand the summary to a colleague for async sign-off.
4. **It applies the standards.** It checks the design against the standards your project
   declared *and* the library's security standards, and threat-models it — scoped to the
   permit flow (the form, the API, the personal data), **not** your source control or
   deploy pipeline, which it treats as your already-assured platform. Every finding comes
   to you as **Accept / Modify / Reject / Defer**.
5. **It gets a second opinion.** A fresh, independent review reads the finished design
   cold and flags anything thin. Same gated walk.

Out comes one reviewed Technical Design with a full decision log — and a human (you)
signs it off. Then the rest of the lifecycle follows the same shape:

```
/prepare-stories       → the design becomes accessibility-checked, traceable, Jira-ready stories
/plan-and-implement    → one story becomes tested code on a branch (you own the merge)
/assure-quality        → the running service is verified against the story, with e2e tests left behind
```

At no point does it merge, accept a risk, or certify anything. You do.

---

## Give the skills your project's context (`.claude/`)

This is the part that turns a generic library into something that knows *your* project.
The library is product-agnostic, so it doesn't ship anything about your service. You
tell it — by putting a few small files in a `.claude/` folder at the root of **your**
project (not in this library). The skills read them automatically.

There are two kinds of standards, and the distinction matters:

- **The library's standards** (security, accessibility, the engineering standard) ship
  inside this repo and apply to every engagement. You don't touch these.
- **Your project's standards and context** live in *your* repo's `.claude/` folder —
  the compliance rules this service must meet, the code it builds on, how it's run.
  These are yours to declare.

There are three context files, and each already has a template in this library to copy:

| Put this in your project | What it tells the skills | Copy from this template |
|--------------------------|--------------------------|--------------------------|
| `.claude/standards/INDEX.md` | the standards this service must meet — e.g. WCAG 2.2 AA, relevant data-protection regulation, and your **platform / CI-CD security baseline** (how code reaches production, assured once so designs don't re-litigate it) | [`_templates/project-standards-template.md`](skills/_templates/project-standards-template.md) |
| `.claude/source-map.md` | where your code lives, so designs **reuse real modules and real APIs** instead of inventing them | [`_templates/project-source-map-template.md`](skills/_templates/project-source-map-template.md) |
| `.claude/qa-drivers.md` | how to drive your running system for QA (the API, a browser, a device simulator) | [`_templates/project-qa-drivers-template.md`](skills/_templates/project-qa-drivers-template.md) |

For the parking-permit service, a minimal setup looks like:

```
your-permit-project/
└── .claude/
    ├── standards/
    │   └── INDEX.md        # WCAG 2.2 AA; relevant data-protection law;
    │                       # Platform/CI-CD baseline (PRs reviewed, signed pipeline → prod)
    ├── source-map.md       # the permit backend repo; the shared notifications library;
    │                       # the form-component library
    └── qa-drivers.md       # how to call the permit API and drive a browser against the running site
```

With `source-map.md` in place, the design reuses your notifications library by name
rather than proposing a new one. With the **platform baseline** declared in
`standards/INDEX.md`, the threat model cites it and moves on, instead of drilling into
your repo settings and reviewer rules. That's the difference between a design grounded
in your reality and one that guesses.

**You don't have to set all this up first.** Every skill works without these files — it
just asks you more, and offers to scaffold a template when it would help. But the more
context you declare, the more the output is about *your* service and the less you have
to correct. Declare it once; every future design and review inherits it.

---

## Available skills

[`skills/INDEX.md`](skills/INDEX.md) is the full, current list — one line each. In brief:

- **Four phase commands** — the lifecycle front doors above: `produce-tech-design`,
  `prepare-stories`, `plan-and-implement`, `assure-quality`.
- **The smaller skills they sequence** (each also runs standalone) — e.g. `frame-design`,
  `generate-design-doc`, `check-engineering-standards`, `check-platform-constraints`,
  `check-security-standards`, `threat-model`, `cross-model-review`, `revise-design`
  (architecture); `decompose-to-stories`, `check-accessibility` (breakdown);
  `generate-acceptance-tests`, `generate-implementation-plan`, `implement-plan`,
  `review-code`, `review-security`, `review-accessibility` (implementation); `verify-story` (QA).
- **Shared standards** in [`skills/_standards/`](skills/_standards/) — `security/`
  (STRIDE, OWASP Top 10:2025, MASVS v2, NCSC Cloud Principles, Secure by Design),
  `accessibility/` (WCAG 2.2 AA + web / iOS / Android lenses), `gds-way/` (the
  engineering standard: testing, API compatibility, code review, languages, source
  control, operability), and `platform/` (platform fit constraints: residency, approved
  services, tenancy, quotas, egress). Cited by every skill that touches that surface,
  never copied.
- **`setup`** — install / update / verify the library itself (prompt-driven).

Named but not yet built (see [`CLAUDE.md`](CLAUDE.md) for the roadmap):
a `push-stories-to-jira` step, and the mobile QA drivers.

---

## Contributing

The `_standards/` files are the library's encoded compliance posture. Treat changes to
them like code: open a PR, reviewed by the person who owns that standard. That history
is the audit trail of how the encoded standards evolved — it matters for assurance.

When adding a skill: read [`docs/authoring.md`](docs/authoring.md), add a line to
[`skills/INDEX.md`](skills/INDEX.md), and validate it against real, already-approved work
before merging. The [release history](../../releases) (tags + auto-generated notes) is the
record of changes.

Commit messages follow [`COMMIT_STANDARD.md`](COMMIT_STANDARD.md) (Conventional Commits).
Changes under `_standards/` carry extra weight — note the *why* in the commit body, since
they alter every dependent skill's output (the commit is the assurance trail).

---

## License

Released under the [MIT License](LICENSE).
