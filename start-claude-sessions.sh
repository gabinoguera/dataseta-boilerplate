#!/bin/bash

# =============================================================================
# start-claude-sessions.sh
# Abre Terminal.app con múltiples TABS, cada uno en un worktree con claude.
#
# Solo se procesan los worktrees definidos en WORKTREES (más abajo). El resto
# de directorios en Aurea/ (p. ej. repos de referencia como aurea-reference,
# react-video-editor) no se tocan.
#
# REQUISITO: Terminal y Cursor con permisos de Accesibilidad.
# =============================================================================

AUREA_BASE="$HOME/Documents/Aurea"

# Solo estos worktrees se abren. Editar según necesidad.
WORKTREES=(
  "aurea-b2c-prod-aws"
  "aurea-sidebar-media"
  "aurea-sidebar-text"
)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${CYAN}🚀 Iniciando sesiones de Claude en Terminal.app (tabs)${NC}"
echo ""

# Verificar solo los worktrees de la lista
for wt in "${WORKTREES[@]}"; do
  if [ ! -d "$AUREA_BASE/$wt" ]; then
    echo -e "${YELLOW}⚠️  Worktree no encontrado: $wt${NC}"
    exit 1
  fi
done

# Copiar configuración oculta (.claude, .playwright-mcp, .mcp.json) desde el
# primer worktree de la lista al resto, si existen allí y faltan en el destino.
CONFIG_SOURCE="$AUREA_BASE/${WORKTREES[0]}"
HIDDEN_ITEMS=(
  ".claude"
  ".playwright-mcp"
  ".mcp.json"
)

echo -e "${CYAN}Sincronizando configuración oculta (.claude, mcp, etc.)...${NC}"
for wt in "${WORKTREES[@]}"; do
  wt_path="$AUREA_BASE/$wt"

  # No tiene mucho sentido copiar de sí mismo; se salta si es el source.
  if [ "$wt_path" = "$CONFIG_SOURCE" ]; then
    continue
  fi

  for item in "${HIDDEN_ITEMS[@]}"; do
    src="$CONFIG_SOURCE/$item"
    dest="$wt_path/$item"

    if [ -e "$src" ] && [ ! -e "$dest" ]; then
      if [ -d "$src" ]; then
        echo -e "  → Copiando directorio $item de ${WORKTREES[0]} a $wt"
        cp -R "$src" "$dest"
      else
        echo -e "  → Copiando archivo $item de ${WORKTREES[0]} a $wt"
        cp "$src" "$dest"
      fi
    fi
  done
done
echo ""

# Construir el script de AppleScript dinámicamente
APPLE_SCRIPT="tell application \"Terminal\"
  activate
  
  -- Tab 1: crear primera ventana con primer comando
  do script \"cd '$AUREA_BASE/${WORKTREES[0]}' && clear && echo '📁 ${WORKTREES[0]}' && echo '' && if [ ! -d openspec ] && command -v openspec >/dev/null 2>&1; then openspec init; else claude; fi\"
  delay 0.3
"

# Agregar tabs adicionales dinámicamente
for i in $(seq 1 $((${#WORKTREES[@]} - 1))); do
  APPLE_SCRIPT+="
  -- Tab $((i+1)): crear nuevo tab con Cmd+T y ejecutar en selected tab
  tell application \"System Events\" to keystroke \"t\" using {command down}
  delay 0.3
  do script \"cd '$AUREA_BASE/${WORKTREES[$i]}' && clear && echo '📁 ${WORKTREES[$i]}' && echo '' && if [ ! -d openspec ] && command -v openspec >/dev/null 2>&1; then openspec init; else claude; fi\" in selected tab of the front window"
done

APPLE_SCRIPT+="
  
  delay 0.2
  
  -- Volver al primer tab (Cmd+1)
  tell application \"System Events\"
    tell process \"Terminal\"
      keystroke \"1\" using command down
    end tell
  end tell
end tell"

# Ejecutar el script de AppleScript
osascript <<EOF
$APPLE_SCRIPT
EOF

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Terminal.app abierto con ${#WORKTREES[@]} tabs${NC}"
  echo ""
  echo "Worktrees:"
  for i in "${!WORKTREES[@]}"; do
    echo "  • Tab $((i+1)): ${WORKTREES[$i]}"
  done
  echo ""
  echo "Atajos útiles:"
  echo "  • Cambiar tabs: Cmd+1, Cmd+2, Cmd+3, etc."
  echo "  • Siguiente tab: Cmd+Shift+]"
  echo "  • Tab anterior: Cmd+Shift+["
  echo "  • Nuevo tab: Cmd+T"
  echo "  • Cerrar tab: Cmd+W"
  echo "  • Nueva Linea: Control+J"
else
  echo -e "${YELLOW}⚠️  Error: Terminal necesita permisos de Accesibilidad${NC}"
  echo "   Ajustes > Privacidad y Seguridad > Accesibilidad > Terminal ✓ y Cursor ✓"
fi
