#!/usr/bin/env bash
# ============================================================
#  fastfetch-random.sh
#  Elige aleatoriamente uno de tres configs de fastfetch
#  y lo ejecuta cada vez que se llama el script.
# ============================================================

# ── Directorio donde viven tus configs ──────────────────────
CONFIG_DIR="${HOME}/.config/fastfetch"

# ── Lista de archivos de configuración ──────────────────────
CONFIGS=(
  "${CONFIG_DIR}/config1.jsonc"
  "${CONFIG_DIR}/config2.jsonc"
  "${CONFIG_DIR}/config3.jsonc"
)

# ── Verificar que fastfetch está instalado ───────────────────
if ! command -v fastfetch &>/dev/null; then
  echo "❌  fastfetch no está instalado o no está en el PATH." >&2
  exit 1
fi

# ── Verificar que los archivos existen ──────────────────────
VALID=()
for cfg in "${CONFIGS[@]}"; do
  if [[ -f "$cfg" ]]; then
    VALID+=("$cfg")
  else
    echo "⚠️  Config no encontrado, se omitirá: $cfg" >&2
  fi
done

if [[ ${#VALID[@]} -eq 0 ]]; then
  echo "❌  No se encontró ningún archivo de config válido en: ${CONFIG_DIR}" >&2
  exit 1
fi

# ── Elegir aleatoriamente ────────────────────────────────────
CHOSEN="${VALID[$(( RANDOM % ${#VALID[@]} ))]}"

# ── (Opcional) Mostrar cuál se eligió ───────────────────────
# Descomenta la línea siguiente si quieres verlo en pantalla:
# echo "🎲  Usando config: $(basename "$CHOSEN")"

# ── Ejecutar fastfetch con el config elegido ─────────────────
fastfetch --config "$CHOSEN"
