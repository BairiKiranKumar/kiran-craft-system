#!/usr/bin/env bash
# Install or update the Craft System in a website project.
# Usage: bash install.sh /path/to/website-project
# - Copies AGENTS.md and craft/ (craft/ is replaced, so updates arrive cleanly).
# - Creates CLAUDE.md with "@AGENTS.md", or appends that line to an existing CLAUDE.md.
# - Seeds design/ from the templates ONLY for files that do not exist yet. Never overwrites design/.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:-}"
if [[ -z "$DEST" || ! -d "$DEST" ]]; then
  echo "Usage: bash install.sh /path/to/website-project (folder must exist)" >&2
  exit 2
fi
DEST="$(cd "$DEST" && pwd)"
if [[ "$DEST" == "$SRC" ]]; then
  echo "Run this against a website project, not the craft system folder itself." >&2
  exit 2
fi

# 1. Shared system (replace craft/ wholesale; it must never hold project-specific edits)
rm -rf "$DEST/craft"
cp -R "$SRC/craft" "$DEST/craft"

# 2. Agent rules
if [[ -f "$DEST/AGENTS.md" ]] && ! grep -q "Craft System" "$DEST/AGENTS.md"; then
  cp "$DEST/AGENTS.md" "$DEST/AGENTS.project-backup.md"
  echo "Existing AGENTS.md backed up to AGENTS.project-backup.md; merge any project rules into design/creative-brief.md."
fi
cp "$SRC/AGENTS.md" "$DEST/AGENTS.md"

if [[ ! -f "$DEST/CLAUDE.md" ]]; then
  cp "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"
elif ! grep -qx "@AGENTS.md" "$DEST/CLAUDE.md"; then
  printf '\n@AGENTS.md\n' >> "$DEST/CLAUDE.md"
  echo "Added @AGENTS.md import to existing CLAUDE.md."
fi

# 3. Project-specific files (seed once, never overwrite)
mkdir -p "$DEST/design"
seed() { [[ -f "$DEST/design/$2" ]] || cp "$SRC/craft/templates/$1" "$DEST/design/$2"; }
seed creative-brief.md creative-brief.md
seed brand.example.md brand.md
seed tokens.example.json tokens.json
seed motion-spec.md motion-spec.md
seed research-kit.md research-kit.md
[[ -f "$DEST/design/DECISIONS.md" ]] || printf '# Decisions log\n\n| Date | Decision | Alternatives rejected | Evidence | Known debt |\n|---|---|---|---|---|\n' > "$DEST/design/DECISIONS.md"

# 4. Impeccable design skills & anti-pattern engine
if command -v npx >/dev/null 2>&1; then
  echo "Installing Impeccable design skills into $DEST..."
  (cd "$DEST" && npx -y impeccable install -y --project) || echo "Warning: npx impeccable install failed or timed out; run 'npx impeccable install' manually if needed."
else
  echo "Note: npx not found. Run 'npx impeccable install' once Node.js/npm is available."
fi

# 5. Git ignore defaults (seed once if missing)
if [[ ! -f "$DEST/.gitignore" ]]; then
  cat << 'EOF' > "$DEST/.gitignore"
node_modules/
*.exe
**/skills/impeccable/scripts/bin/
design/qa-output/
*.log
EOF
fi

echo "Craft System installed in $DEST"
echo "Next: fill design/creative-brief.md (locks go under 'Existing features that must not change'),"
echo "replace the example brand.md and tokens.json, then: python3 craft/qa/validate_tokens.py design/tokens.json"

