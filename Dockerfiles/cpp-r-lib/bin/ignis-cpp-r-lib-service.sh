#!/bin/bash
set -e
echo "[INFO] Ejecutando cpp-r-lib"

export R_SERVICE_DIR="${IGNIS_SERVICE_DIR}/r"
mkdir -p -m 700 "${R_SERVICE_DIR}"

SCRIPT=$(find "${IGNIS_JOB_DIR}" -name '*.R' | head -n 1)

if [[ -z "$SCRIPT" ]]; then
  echo "[ERROR] No se encontró ningún script R en el trabajo"
  exit 1
fi

echo "[INFO] Ejecutando $SCRIPT"
$IGNIS_HOME/bin/r_demo "$SCRIPT"
