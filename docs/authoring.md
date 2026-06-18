# Authoring skills for cadence

Conventions for writing and contributing skills. The library lives or dies on
discipline here — composability only works if each skill has a crisp boundary
and a description that triggers it at the right moment and not the wrong one.

## Anatomy

```
skills/<skill-name>/
└── SKILL.md           required: YAML frontmatter (name, kind, description) + instructions
```

Every skill is a flat folder one level deep under `skills/` (the depth Claude Code
discovers). Frontmatter carries `name:`, then `kind:` (`atomic` or `composite`),
then `description:`. There are no `atomic/`/`composite/` folders — the `kind:`
field is the distinction; INDEX.md groups by it.

Shared reference material does NOT go inside the skill. It goes in:
- `_standards/<domain>/<file>.md` — encoded standards, cited by relative path
- `_templates/<file>.md` — house output formats

Reference them from SKILL.md as `../_standards/...` and `../_templates/...` (one
`../` — skills and the shared trees are siblings under `skills/`).
`install.sh` drops one flat symlink per skill pointing at the skill's real folder
in the intact `skills/` tree, so these relative paths resolve against that real
location. Never copy a standards file into a skill — that creates drift, which is
the exact thing this library exists to prevent.

These `_standards/` files are the library's own, **cross-engagement** standards. A
consuming project's **product-specific** standards (e.g. a domain data-format spec) do NOT belong
here — they live in that project's `.claude/standards/` register, and skills read
them from the **project root**, not relative to a SKILL.md. See CLAUDE.md "Two
kinds of standards — library vs project". Keeping the library agnostic is deliberate.

Likewise a project declares the **code** its designs build on in
`.claude/source-map.md` (local paths or remote git URLs); skills read it from the
project root to ground designs in real modules and API contracts. And a generated
Technical Design stops at architecture / module / contract level — function-level
design is the developer's job, from the user stories. See CLAUDE.md.

If a skill reaches an **external service** (e.g. `frame-design`'s web research),
gate it: explicit user consent, send the minimum (generalised terms, never
proprietary content), treat the result as advisory. Prefer keeping work local — the
independent review (`cross-model-review`) runs a separate Claude subagent on-machine
rather than sending the design out. See CLAUDE.md "External service calls are gated".

## The description is the trigger

Claude decides whether to consult a skill from its `description` alone. With a
library of small skills the real failure mode is two skills with fuzzy,
overlapping triggers, so:

- State both **what it does** and **when to reach for it** (contexts, phrases).
- Be a little pushy — Claude tends to under-trigger. Include implied cases
  ("even when the request only implies a security analysis...").
- Keep each skill's purpose crisp and non-overlapping with others.

## Writing style

- Imperative instructions. Explain *why* a step matters rather than barking MUSTs.
- Keep SKILL.md focused; push detail into referenced files (progressive
  disclosure). Read a reference file only when the task touches its surface.
- State explicitly what the skill does **NOT** do — especially the boundary
  between drafting and any human approval/risk-acceptance step. That boundary is
  what keeps the human gate meaningful for assurance.

## Before you merge

1. Add a one-line entry to `skills/INDEX.md`.
2. Note the change in `CHANGELOG.md` — and if you touched `_standards/`, say
   what changed and why (assurance trail).
3. **Validate against real, already-approved work.** Take three or four
   completed, signed-off artifacts, feed the skill the same input the human had,
   and compare. The misses are the iteration backlog. A skill that hasn't been
   checked against real output is not ready.
4. Changes to `_standards/` get reviewed by the person who owns that standard.
5. **If you changed a composite** — added or removed a step, reordered the
   sequence, or changed a step's optionality — update `docs/flows.md` (the single
   pipeline map: the diagram + the step table for that composite). `install.sh`
   warns if a composite is missing from `flows.md` entirely, but it can't catch a
   stale step inside one — that's on you. Keep the map honest; it's the page people
   read to understand what runs when.
6. **Frontmatter is complete and the name is unique.** `name:`, `kind:`
   (`atomic`/`composite`), and a trigger `description:` are all present, and the
   folder name doesn't collide with an existing skill (they share one command
   namespace — `install.sh` will refuse a duplicate).

## Tooling

Anthropic's `skill-creator` skill scaffolds new skills and runs trigger-accuracy
evals — useful for tuning descriptions. Use it rather than hand-rolling.
