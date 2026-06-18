---
name: setup
description: >
  Install, update, re-link, or verify the cadence skill library on
  this machine. Use whenever the user says things like "set up
  cadence", "install the skills", "update the skill library",
  "re-link my skills", "did my skills install correctly", or asks why a skill
  from this library isn't being discovered. Wraps install.sh with safety checks
  and post-install verification, and explains what it did. Reach for this for
  any lifecycle operation on the library itself (as opposed to using one of the
  skills inside it).
---

# Setup — manage the cadence library

This skill manages the library's own installation. It is the friendly, safe
wrapper around `install.sh` at the repo root. Use it to install, update,
re-link, or verify — and to diagnose discovery problems.

Claude Code discovers skills **flat**: each must sit at
`.claude/skills/<name>/SKILL.md`, and the folder name is the slash command. So
`install.sh` drops **one flat symlink per skill** into `.claude/skills`
(`.claude/skills/threat-model -> <repo>/skills/atomic/threat-model`) rather than
linking the whole tree. Each link points at the skill's real folder in the
intact clone, so its `../../_standards/...` and `../../_templates/...` references
still resolve against that real location. Everything below preserves that, and
never clobbers a skill folder the library did not create.

## First, work out what the user is asking for

- **Install / set up** — first time on this machine.
- **Update** — already installed; pull latest and re-verify.
- **Re-link** — symlink missing or broken; recreate it.
- **Verify / diagnose** — a skill isn't being discovered, or they want a health check.

If it's ambiguous, run the verification steps first (they're read-only and
safe) and let the result tell you which case you're in.

## Locate the repo

This skill lives inside the repo at `skills/atomic/setup/`. The repo root is two
levels up from the skills tree. Resolve it before doing anything:

```bash
# From the setup skill directory, the repo root is ../../.. ; install.sh is there.
REPO_ROOT="$(cd "$(dirname "<this-SKILL.md-dir>")/../../.." && pwd)"
```

If you cannot locate `install.sh` and `README.md` at that root, stop and tell
the user the library doesn't appear to be a complete checkout, and ask them to
confirm where they cloned it.

## Install (first time)

1. Read `install.sh` and `README.md` at the repo root so you understand the
   intended setup before running anything.
2. Decide scope with the user if they haven't said:
   - **Global** (`~/.claude/skills`) — available in every repo they work in.
   - **Local** (`./.claude/skills` in the current repo) — scoped to one repo.
   Default to asking which they want; for a shared engagement, global is usual.
3. **Safety check — do not skip.** A real `.claude/skills` directory with other
   skills in it is now the *normal* case — per-skill links are added alongside,
   nothing is overwritten. Two things `install.sh` still guards, which you should
   report if they fire: (a) a per-skill name **collision** — a folder/file
   already holds a skill's name (e.g. another `/threat-model`); the installer
   leaves it untouched and that command will NOT point at this library, so offer
   to rename or move the conflicting entry; (b) `.claude/skills` is itself a
   **symlink to somewhere other than this repo** — the installer refuses to
   touch it. (An old whole-tree symlink *to this repo* is migrated automatically.)
4. Run the installer:
   ```bash
   cd "$REPO_ROOT"
   ./install.sh            # global
   # or: ./install.sh --local   (run from the target repo)
   ```
5. Run the verification block below and report the result.

## Update

```bash
cd "$REPO_ROOT"
git pull --ff-only
```

Because each link points at a real file in the clone, a content update needs no
re-link — `git pull` is enough. Re-run `./install.sh` only when a **new skill
was added** (it needs its own link) or a link is missing/broken (the pull output
or verification will tell you). After updating, glance at `CHANGELOG.md` and tell
the user what changed, paying attention to any `_standards/` changes since those
alter security/compliance output.

## Re-link

If verification shows the symlink is missing or dangling, re-run `./install.sh`
(or `--local`). Apply the same safety check as install before recreating.

## Verify / diagnose (read-only, always safe)

Run these and report plainly:

```bash
# 1. Which of this library's skills are linked, and at the right depth?
#    Each should be a per-skill symlink at .claude/skills/<name> pointing into
#    this repo. (A skill is discoverable only when SKILL.md is exactly one level
#    deep: .claude/skills/<name>/SKILL.md.)
for n in threat-model setup; do
  link=~/.claude/skills/$n
  if [ -L "$link" ]; then
    echo "$n -> $(readlink "$link")"
  elif [ -e "$link" ]; then
    echo "$n: EXISTS but is not our symlink (name collision)"
  else
    echo "$n: not linked"
  fi
done

# 2. Do a linked skill's shared-standard references resolve through the link?
#    `pwd -P` follows the link to the real folder, where ../../_standards lives.
( cd ~/.claude/skills/threat-model 2>/dev/null \
  && test -f "$(pwd -P)/../../_standards/security/stride.md" \
  && echo "shared _standards resolve: OK" ) \
  || echo "shared _standards resolve: BROKEN or skill not linked — re-run install.sh"
```

Interpretation:
- **Per-skill symlink → this repo, standards resolve OK** → healthy.
- **`<name>` not linked** → not installed (or a new skill with no link yet);
  run `install.sh`.
- **`<name>` EXISTS but is not our symlink** → a name collision; another skill
  (or a copy) owns that command. Offer to rename our folder or move theirs aside.
- **Standards BROKEN** → the clone tree is incomplete, or the link is dangling.
  Check the clone is whole, then re-run `install.sh`.

## What this skill does NOT do
- It does not clone the repo. The repo must already be on the machine — a model
  can't fetch a repo it can't see. The one-line bootstrap (`git clone … &&
  ./install.sh`) lives in the README and is intentionally a visible, readable
  step rather than a blind pipe-to-shell.
- It does not modify skills or standards content — only the installation.
- It does not overwrite an existing non-symlink skills directory.
