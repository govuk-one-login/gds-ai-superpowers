#!/usr/bin/env bash
# Compute the next semantic version from Conventional Commits since the last release tag.
#
#   scripts/next-version.sh
#
# Prints the next version (e.g. "0.2.0") to stdout, or "none" when there are no
# release-worthy commits since the last tag (docs/chore/ci/style only).
#
# Bump policy — from COMMIT_STANDARD.md (which already defines what is "breaking"
# for this repo: renaming a skill folder, or moving a cited _standards/ file —
# both of which must carry a `BREAKING CHANGE:` footer):
#   major  — any `BREAKING CHANGE:` footer, or a `type!:` marker in the subject
#   minor  — any `feat:`  (and `security(standards):` — a standards-content change)
#   patch  — any `fix:` / `security:` (tooling) / `refactor:` / `perf:`
#   none   — only docs / chore / ci / style → no release
#
# The PR merge is the human approval; this just reads the types that were reviewed.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Most recent release tag (vX.Y.Z). None yet ⇒ first release: use VERSION as-is.
last_tag="$(git -C "$REPO_ROOT" describe --tags --abbrev=0 --match 'v[0-9]*' 2>/dev/null || true)"
if [ -z "$last_tag" ]; then
  tr -d '[:space:]' < "$REPO_ROOT/VERSION"
  echo
  exit 0
fi

base="${last_tag#v}"

# Walk every commit message since the tag; keep the highest bump seen.
bump="none"
rank() { case "$1" in major) echo 3;; minor) echo 2;; patch) echo 1;; *) echo 0;; esac; }
raise() { [ "$(rank "$1")" -gt "$(rank "$bump")" ] && bump="$1"; return 0; }

while IFS= read -r -d '' msg; do
  subject="${msg%%$'\n'*}"

  # major: an explicit breaking marker anywhere in the message, or `type!:` subject.
  if printf '%s' "$msg" | grep -qE '(^|[[:space:]])BREAKING[ -]CHANGE:' \
     || printf '%s' "$subject" | grep -qE '^[a-z]+(\([^)]*\))?!:'; then
    raise major
    continue
  fi

  case "$subject" in
    feat:*|feat\(*\)*:*)                          raise minor ;;
    security\(standards\):*)                      raise minor ;;
    fix:*|fix\(*\)*:*)                            raise patch ;;
    perf:*|perf\(*\)*:*)                          raise patch ;;
    refactor:*|refactor\(*\)*:*)                  raise patch ;;
    security:*|security\(*\)*:*)                  raise patch ;;
    *)                                            : ;;  # docs/chore/ci/style → none
  esac
done < <(git -C "$REPO_ROOT" log "${last_tag}..HEAD" --no-merges --format='%B%x00')

if [ "$bump" = "none" ]; then
  echo "none"
  exit 0
fi

IFS=. read -r major minor patch <<EOF
$base
EOF
major="${major:-0}"; minor="${minor:-0}"; patch="${patch:-0}"
# strip any pre-release/build suffix from patch (defensive)
patch="${patch%%[-+]*}"

case "$bump" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
esac

echo "${major}.${minor}.${patch}"
