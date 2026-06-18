#!/usr/bin/env bash
# Install the Assured Engineering Superpowers skills into Claude Code's skills directory.
#
#   ./install.sh           install globally into ~/.claude/skills
#   ./install.sh --local   install into ./.claude/skills of the current directory
#
# HOW THIS WORKS, AND WHY
# -----------------------
# Claude Code discovers skills FLAT: a skill must sit at
# `.claude/skills/<name>/SKILL.md` (one level deep), and the folder name is what
# becomes the slash command (`/<name>`). A SKILL.md any deeper is not discovered
# at all. Our skills live one level deep under `skills/<name>/`, alongside the
# shared `skills/_standards/` and `skills/_templates/` reference trees (which
# have no SKILL.md and so are never discovered as skills). The atomic-vs-composite
# distinction lives in each SKILL.md's `kind:` frontmatter, not in the folders.
#
# We drop one flat symlink per skill:
#
#   .claude/skills/threat-model -> <repo>/skills/threat-model
#
# The link target is the real folder inside the intact repo tree, so the skills'
# `../_standards/...` and `../_templates/...` references still resolve (they
# resolve against the target's real location, not the link). The tree must stay
# intact in the clone; we only add pointers into it. A `git pull` in the clone
# updates everyone — no re-run needed for content changes.
#
# Per-skill links also mean the library COEXISTS with other skills in the same
# `.claude/skills` directory instead of trying to own it. We never clobber a
# folder we did not create.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"

if [[ "${1:-}" == "--local" ]]; then
  CLAUDE_DIR="$(pwd)/.claude"
else
  CLAUDE_DIR="$HOME/.claude"
fi

SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR"

# Migrate an old whole-tree install. Earlier versions did `ln -s skills
# .claude/skills`, which nests skills two levels deep (undiscoverable). If we
# find that exact symlink, convert it to a real directory we can drop per-skill
# links into. A symlink pointing somewhere ELSE is not ours — refuse to touch it.
if [[ -L "$SKILLS_DIR" ]]; then
  existing_target="$(readlink "$SKILLS_DIR")"
  if [[ "$existing_target" == "$SKILLS_SRC" ]]; then
    echo "Migrating old whole-tree symlink ($SKILLS_DIR -> $existing_target) to per-skill links."
    rm -f "$SKILLS_DIR"
  else
    echo "ERROR: $SKILLS_DIR is a symlink to '$existing_target', not this repo's skills."
    echo "Refusing to touch it. Remove it yourself, or use --local to install into a repo."
    exit 1
  fi
fi

mkdir -p "$SKILLS_DIR"

created=()
relinked=()
skipped=()      # already correctly linked to this library
conflicts=()    # a foreign file/dir holds the name — left untouched
seen=" "        # space-delimited list of skill names, for duplicate detection

# Enumerate skills: any directory under skills/ that contains a SKILL.md. The
# leading-underscore dirs (_standards, _templates) contain no SKILL.md, so they
# are naturally excluded — they are reached only via the skills' relative paths.
# (Skills are one level deep, but we keep the find depth-agnostic for safety.)
while IFS= read -r skill_md; do
  skill_dir="$(cd "$(dirname "$skill_md")" && pwd)"
  skill_name="$(basename "$skill_dir")"
  link="$SKILLS_DIR/$skill_name"

  # Folder names become slash-command names, so they must be unique across the
  # whole tree (atomic/ and composite/ share one command namespace).
  case "$seen" in
    *" $skill_name "*)
      echo "ERROR: two skills share the folder name '$skill_name' — slash-command"
      echo "names must be unique. Rename one of them. Offending dir: $skill_dir"
      exit 1
      ;;
  esac
  seen="$seen$skill_name "

  if [[ -L "$link" ]]; then
    if [[ "$(readlink "$link")" == "$skill_dir" ]]; then
      skipped+=("$skill_name")            # already correct
    else
      ln -sfn "$skill_dir" "$link"        # our link, but stale target — refresh
      relinked+=("$skill_name")
    fi
    continue
  fi

  if [[ -e "$link" ]]; then
    echo "WARNING: $link already exists and is not one of our symlinks."
    echo "         Leaving it untouched; '/$skill_name' will NOT point at this library."
    conflicts+=("$skill_name")
    continue
  fi

  ln -s "$skill_dir" "$link"
  created+=("$skill_name")
done < <(find "$SKILLS_SRC" -name SKILL.md -type f | sort)

echo
echo "Installed into: $SKILLS_DIR"

print_list() {
  # $1 = label, rest = names; safe when the array is empty under `set -u`.
  local label="$1"; shift
  [[ "$#" -eq 0 ]] && return 0
  echo "$label"
  local n
  for n in "$@"; do echo "  /$n"; done
}

print_list "Linked (new):"        ${created[@]+"${created[@]}"}
print_list "Re-linked (updated):" ${relinked[@]+"${relinked[@]}"}
print_list "Already linked:"      ${skipped[@]+"${skipped[@]}"}

if [[ "${#conflicts[@]}" -gt 0 ]]; then
  echo "Conflicts (a foreign file/dir holds the name — NOT pointing at this library):"
  for n in "${conflicts[@]}"; do echo "  /$n"; done
  echo "  Rename the skill folder, or move the conflicting entry aside, then re-run."
fi

# Verify the shared _standards/ files resolve — probe a link WE own (not a
# foreign conflict). Because our link points at the real folder in the repo,
# `pwd -P` from inside it lands on the true path, where `../_standards` lives.
probe_name=""
for n in ${created[@]+"${created[@]}"} ${relinked[@]+"${relinked[@]}"} ${skipped[@]+"${skipped[@]}"}; do
  probe_name="$n"; break
done
if [[ -n "$probe_name" ]]; then
  real="$(cd "$SKILLS_DIR/$probe_name" && pwd -P)"
  if [[ -f "$real/../_standards/security/stride.md" ]]; then
    echo
    echo "Shared _standards/ resolve through the link: OK"
  else
    echo
    echo "WARNING: shared _standards/ did not resolve from $real"
    echo "         The repo tree may be incomplete. Re-clone or check skills/_standards/."
  fi
fi

# Drift guard for the standards deep tier: every `deep: deep/<id>.md` pointer in a
# lens must resolve to a real file, and every deep/ file must be pointed at by some
# lens (no dangling pointers, no orphan deep files). Cheap grep test; non-fatal warn.
std_root="$SKILLS_SRC/_standards"
if [[ -d "$std_root" ]]; then
  drift=0
  # 1. every pointer resolves
  while IFS= read -r line; do
    f="${line%%:*}"; rest="${line#*:}"
    ptr="$(printf '%s\n' "$rest" | sed -n 's/.*deep:[[:space:]]*\(deep\/[A-Za-z0-9._-]*\.md\).*/\1/p')"
    [[ -z "$ptr" ]] && continue
    domain_dir="$(dirname "$f")"
    if [[ ! -f "$domain_dir/$ptr" ]]; then
      echo "DRIFT: dangling deep pointer in ${f#$std_root/} -> $ptr"; drift=1
    fi
  done < <(grep -rn 'deep:[[:space:]]*deep/' "$std_root" --include='*.md' 2>/dev/null | grep -v '/deep/')
  # 2. every deep file is referenced
  while IFS= read -r df; do
    base="$(basename "$df")"; domain="$(basename "$(dirname "$(dirname "$df")")")"
    if ! grep -rqs "deep/$base" "$std_root/$domain"/*.md 2>/dev/null; then
      echo "DRIFT: orphan deep file (no lens points at it): ${df#$std_root/}"; drift=1
    fi
  done < <(find "$std_root" -path '*/deep/*.md' 2>/dev/null)
  echo
  if [[ "$drift" -eq 0 ]]; then
    echo "Standards deep-tier drift guard: OK (all pointers resolve, no orphans)"
  else
    echo "WARNING: standards deep-tier drift detected (see DRIFT lines above)."
  fi
fi

# Drift guard for the composite flow map: every composite skill must be named in
# docs/flows.md, so the pipeline map can't silently fall behind a new or renamed
# composite. Composites are now identified by `kind: composite` in their SKILL.md
# frontmatter (the folders are flat). Cheap grep test; catches a missing
# composite, not a stale step inside one. Non-fatal warn.
flows_doc="$REPO_ROOT/docs/flows.md"
if [[ -f "$flows_doc" ]]; then
  flow_drift=0
  while IFS= read -r comp_md; do
    cname="$(basename "$(dirname "$comp_md")")"
    if ! grep -q "$cname" "$flows_doc"; then
      echo "DRIFT: composite '$cname' is not documented in docs/flows.md"; flow_drift=1
    fi
  done < <(grep -rlE '^kind:[[:space:]]*composite[[:space:]]*$' "$SKILLS_SRC" --include=SKILL.md 2>/dev/null)
  echo
  if [[ "$flow_drift" -eq 0 ]]; then
    echo "Composite flow-map drift guard: OK (every composite is in docs/flows.md)"
  else
    echo "WARNING: composite(s) missing from docs/flows.md (see DRIFT lines above)."
  fi
fi

echo
echo "Done. Run 'claude' in your working repo and type '/' to confirm the"
echo "commands above are discoverable. To update: 'git pull' in this clone"
echo "(re-run install.sh only if a new skill was added or a link is broken)."
