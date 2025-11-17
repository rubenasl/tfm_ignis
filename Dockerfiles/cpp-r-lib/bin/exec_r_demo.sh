#!/bin/bash

echo "[DEBUG] Estoy dentro de exec_r_demo.sh"
echo "[DEBUG] Argumento recibido: $1"
ls -l /workspace/

SCRIPT_NAME=$(basename "$1")

if [ -f "/workspace/$SCRIPT_NAME" ]; then
    cp "/workspace/$SCRIPT_NAME" /tmp/script.R
else
    echo "[ERROR] No se encontró el archivo $SCRIPT_NAME dentro de /workspace"
    exit 1
fi

export LD_LIBRARY_PATH=/usr/lib/R/lib:/usr/local/lib/R/site-library/RInside/lib:$LD_LIBRARY_PATH

echo "[INFO] Ejecutando /opt/ignis/bin/r_demo con /tmp/script.R"
exec /opt/ignis/bin/r_demo /tmp/script.R
