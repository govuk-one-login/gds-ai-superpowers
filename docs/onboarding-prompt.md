# Onboarding prompt

After you've cloned the repo (`git clone <repo-url> && cd gds-ai-superpowers`),
start Claude Code in the repo and paste the prompt below. It drives the install
for you and verifies it worked, so you don't run commands by hand.

---

> Set up the GDS AI Superpowers skill library on my machine. Read `install.sh`
> and `README.md` first so you follow the intended setup. Install globally
> unless I tell you otherwise. It links one symlink per skill into
> `~/.claude/skills` alongside anything already there — if a skill's name
> collides with something I already have (the installer will say so and leave
> the existing one alone), stop and tell me rather than guessing. After
> installing, verify `/threat-model` and `/setup` are discoverable as slash
> commands (each linked one level deep) and that their shared `_standards/`
> references resolve through the links, and tell me plainly whether it's healthy.

---

If the library is already installed and you just want the latest version, paste
this instead:

> Update the GDS AI Superpowers skill library: pull the latest, re-verify the
> install, and tell me what changed — especially anything under `_standards/`,
> since that affects security and compliance output.

Both prompts trigger the `setup` skill, which carries the safety checks and the
post-install verification. Once the library is installed, every lifecycle
operation (update, re-link, health check) is a sentence like the above — no
command list to follow.

## Why the one clone step is manual

A model can't fetch a repo it can't see, so the initial `git clone` is
unavoidable. We keep it a visible, readable step rather than a "paste this and
run it blind" one-liner on purpose: a blind pipe-to-shell install is exactly the
software-supply-chain pattern this library's own `threat-model` skill flags
(OWASP A03:2025). A plain clone of a reviewed repo, then a script you can read,
is the posture we want to model.

## Installing via agent-manager (bundle distribution)

The clone-and-`install.sh` flow above is the **developer / local** path — links
point at your live clone, so `git pull` updates everything instantly. It's the
right path if you're authoring or editing skills.

For **consumers** who just want the skills installed (and for CI), GDS AI Superpowers is also
published as an **agent-manager bundle** (the `@ai-agent-manager/cli` tool, the
Claude Code plugin-marketplace installer). This installs a **versioned snapshot**
rather than a live clone.

Interactive (pick tools + skills in a TUI):

```bash
npx -y @ai-agent-manager/cli@latest https://govuk-one-login.github.io/gds-ai-superpowers
# choose Claude Code, a scope (system → ~/.claude/skills, or repo → ./.claude/skills),
# and the GDS AI Superpowers skills you want.
```

Headless / CI (pin a version, list skills) — create `ai-skills.yml`:

```yaml
tools: claude-code
scope: repo            # or: system
bundle-version: 0.1.0  # pin; omit for latest
skills:
  - produce-tech-design
  - threat-model
  - plan-and-implement
```

```bash
npx -y @ai-agent-manager/cli@latest https://govuk-one-login.github.io/gds-ai-superpowers --config ai-skills.yml
```

Either way, agent-manager downloads the bundle, caches it under
`~/.agentman/bundles/<version>/`, and symlinks each chosen skill into your skills
directory. Because the bundle ships the whole tree intact, every skill's shared
`../_standards/` and `../_templates/` references still resolve.

**Things to know about the bundle path:**

- **It's a snapshot, not a live clone.** Updates don't arrive via `git pull` — you
  re-run with `--update` to pull a newer published version. A standards change is
  only picked up once a new bundle version is published (see
  `scripts/build-bundle.sh` and `CHANGELOG.md` — version-bump-on-standards-change
  is the assurance trail for bundle consumers).
- **macOS / Linux only, in practice.** agent-manager installs by symlink; on
  Windows it falls back to *copying* a skill's folder, which orphans the shared
  `_standards/`/`_templates/` trees and breaks the library's references. Windows users
  need developer-mode/admin symlinks, or should use the clone + `install.sh` path.
- **Releases are automatic** (maintainers): there's no manual version bump or tag.
  When a PR merges to `main`, the `Release & publish bundle` workflow
  (`.github/workflows/publish-bundle.yml`) derives the next [semantic version](https://semver.org)
  from the Conventional Commits since the last release tag
  (`scripts/next-version.sh` — see the type→bump table in `COMMIT_STANDARD.md`),
  bumps `VERSION`, rolls `CHANGELOG.md`, tags `vX.Y.Z`, and publishes the bundle to the
  `gh-pages` branch (served by GitHub Pages at `https://govuk-one-login.github.io/gds-ai-superpowers`).
  Versions accumulate, so pinned `bundle-version:` installs keep working. **The reviewed
  PR merge is the approval** — commit types you already wrote drive the version, so label
  them correctly (a `feat:` → minor, `fix:` → patch, `BREAKING CHANGE:` → major; a
  docs/chore-only merge publishes nothing).

  **One-time setup:** the repo must be **public**, and Pages must be enabled —
  Settings → Pages → Source: *Deploy from a branch* → `gh-pages` / root. The `.sha256`
  sidecar the build emits gives consumers real integrity verification on Pages. To build
  the `dist/agents/` tree locally without publishing, just run `./scripts/build-bundle.sh`.

  **If you later protect `main`** (require PRs): the workflow pushes its `chore(release):`
  commit + tag back to `main`, so grant the release workflow bypass, or move to a
  release-PR model — otherwise the push-back is rejected.
