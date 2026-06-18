#!/usr/bin/env bash
# Build an agent-manager bundle from the cadence skills tree.
#
#   ./scripts/build-bundle.sh [version]
#
# Produces (under dist/, which is gitignored):
#   dist/agents/index.json                     version index the CLI fetches first
#   dist/agents/<version>/bundle.zip           the bundle (manifest.json + skills + shared trees)
#   dist/agents/<version>/bundle.zip.sha256    integrity hash
#   dist/agents/<version>/manifest.json        also embedded in the zip (kept here for reference)
#
# This is the publishable tree an agent-manager bundle server serves at
# <base-url>/agents/... . Host-agnostic: copy dist/agents/* to the server (e.g.
# bootstrap.deloittecloud.co.uk) once the publish target/convention is agreed.
#
# WHY THE WHOLE TREE IS COPIED. agent-manager discovers skills one level deep
# (<bundleRoot>/<skill>/SKILL.md) and, on install, symlinks each selected skill
# dir from its extracted cache into .claude/skills. A cadence skill references
# ../_standards and ../_templates, so those shared trees must sit beside the
# skills inside the bundle. We therefore copy skills + _standards + _templates
# flat at the bundle root — the same intact tree the repo has. This bundle is a
# GENERATED distribution artifact; the repo stays the single source of truth, and
# nothing here is hand-maintained. A standards change ⇒ bump VERSION ⇒ rebuild.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"

# Version: explicit arg wins, else the VERSION file.
VERSION="${1:-}"
if [[ -z "$VERSION" && -f "$REPO_ROOT/VERSION" ]]; then
  VERSION="$(tr -d '[:space:]' < "$REPO_ROOT/VERSION")"
fi
if [[ -z "$VERSION" ]]; then
  echo "ERROR: no version. Pass one as an argument or create a VERSION file." >&2
  exit 1
fi

PUBLISHED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
OUT="$REPO_ROOT/dist/agents/$VERSION"
STAGE="$OUT/bundle"
rm -rf "$OUT"
mkdir -p "$STAGE"

echo "Building cadence bundle v$VERSION"

# 1. Stage the bundle root: every skill dir (one that has a SKILL.md) plus the two
#    shared trees, all flat at the root.
skill_dirs=()
while IFS= read -r skill_md; do
  d="$(cd "$(dirname "$skill_md")" && pwd)"
  name="$(basename "$d")"
  cp -R "$d" "$STAGE/$name"
  skill_dirs+=("$name")
done < <(find "$SKILLS_SRC" -name SKILL.md -type f | sort)
cp -R "$SKILLS_SRC/_standards" "$STAGE/_standards"
cp -R "$SKILLS_SRC/_templates" "$STAGE/_templates"
echo "  staged ${#skill_dirs[@]} skills + _standards + _templates"

# 2. manifest.json — version + published (both required by the CLI) + agents[]
#    (id/name/description/tags) parsed from each SKILL.md frontmatter, for the
#    interactive skill picker. The full trigger description lives in SKILL.md; the
#    manifest carries a short first-sentence summary for display.
agents_json="$(
  for name in "${skill_dirs[@]}"; do
    SKILL_ID="$name" perl -0777 -ne '
      if (/\A---\s*\n(.*?)\n---/s) {
        my $fm = $1;
        my ($kd) = $fm =~ /^kind:\s*(.+?)\s*$/m;
        $kd ||= "atomic";
        my $desc = "";
        if    ($fm =~ /^description:\s*[>|]?\s*\n(.*)\z/ms) { $desc = $1; }
        elsif ($fm =~ /^description:\s*(.+?)\s*$/m)         { $desc = $1; }
        $desc =~ s/\s+/ /g; $desc =~ s/^\s+|\s+$//g;
        my $short = $desc;
        if ($short =~ /^(.*?\.)\s/) { $short = $1; }   # first sentence
        $short = substr($short, 0, 240);
        print "$ENV{SKILL_ID}\t$kd\t$short\n";
      }
    ' "$STAGE/$name/SKILL.md"
  done | jq -R -s '
    split("\n") | map(select(length > 0)) | map(split("\t")) |
    map({
      id:          .[0],
      name:        (.[0] | gsub("-"; " ") | (.[0:1] | ascii_upcase) + .[1:]),
      description: .[2],
      tags:        ["agent-skill", .[1]]
    }) | sort_by(.id)
  '
)"

jq -n \
  --arg published "$PUBLISHED" \
  --arg version "$VERSION" \
  --argjson agents "$agents_json" \
  '{published: $published, version: $version, agents: $agents}' \
  > "$STAGE/manifest.json"
cp "$STAGE/manifest.json" "$OUT/manifest.json"
echo "  wrote manifest.json ($(jq '.agents | length' "$STAGE/manifest.json") agents)"

# 3. Zip the bundle root (explicit entries → clean paths at the zip root, matching
#    what the CLI's extractor expects: manifest.json at the root).
zip_entries=(manifest.json _standards _templates "${skill_dirs[@]}")
( cd "$STAGE" && zip -qr "$OUT/bundle.zip" "${zip_entries[@]}" )
( cd "$OUT" && shasum -a 256 bundle.zip > bundle.zip.sha256 )
rm -rf "$STAGE"
echo "  wrote bundle.zip + bundle.zip.sha256"

# 4. index.json — list every built version present under dist/agents/.
INDEX="$REPO_ROOT/dist/agents/index.json"
versions_json="$(
  for vd in "$REPO_ROOT"/dist/agents/*/; do
    [[ -f "$vd/manifest.json" ]] || continue
    jq '{version, published}' "$vd/manifest.json"
  done | jq -s 'sort_by(.version)'
)"
jq -n --arg lastUpdated "$PUBLISHED" --argjson agents "$versions_json" \
  '{lastUpdated: $lastUpdated, agents: $agents}' > "$INDEX"
echo "  wrote index.json"

echo "Done. Publishable tree at: $REPO_ROOT/dist/agents/"
echo "  index:  dist/agents/index.json"
echo "  bundle: dist/agents/$VERSION/bundle.zip"
