#!/bin/bash
# Hook: PreToolUse (Edit|MultiEdit|Write)
# Bloquea ediciones en la rama base cuando hay worktrees activos.
# Soporta múltiples worktrees en paralelo via .claude/.worktrees_active/

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('input',{}).get('file_path',''))" 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0

SENTINELS_DIR="$CLAUDE_PROJECT_DIR/.claude/.worktrees_active"

[ ! -d "$SENTINELS_DIR" ] && exit 0
SENTINEL_FILES=("$SENTINELS_DIR"/*)
[[ ! -e "${SENTINEL_FILES[0]}" ]] && exit 0

[[ "$FILE_PATH" == "$CLAUDE_PROJECT_DIR/.claude/"* ]] && exit 0

ACTIVE_TREES=""
for sentinel in "$SENTINELS_DIR"/*; do
    [ -f "$sentinel" ] || continue
    WORKTREE_PATH=$(cat "$sentinel")
    [[ "$FILE_PATH" == "$WORKTREE_PATH"/* ]] && exit 0
    ACTIVE_TREES="$ACTIVE_TREES\n  - $WORKTREE_PATH"
done

echo "Worktrees activos:$ACTIVE_TREES" >&2
echo "Edita dentro de un worktree, no en la rama base. Para desactivar: rm .claude/.worktrees_active/<nombre>" >&2
exit 2
