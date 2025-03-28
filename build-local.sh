#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/../zmk/app"


USE_CACHE=true
for arg in "$@"; do
    if [ "$arg" = "--no-cache" ]; then
        USE_CACHE=false
        break
    fi
done

if [ "$USE_CACHE" = false ]; then
  ../.venv/bin/west build -p \
    -d "$SCRIPT_DIR/build/left-local" \
    -b nice_nano_v2 -- \
    -DSHIELD="chocofi_left nice_view_adapter nice_view" \
    -DZMK_CONFIG="$SCRIPT_DIR/config-test" 
else
  ../.venv/bin/west build  \
    -d "$SCRIPT_DIR/build/left-local" 
fi 

echo "Waiting for both NICENANO to be mounted..."

while [ ! -d "/Volumes/NICENANO" ] || [ ! -d "/Volumes/NICENANO 1" ]; do
  sleep 1
done

echo "Copying files to NICENANOs..."

cp "$SCRIPT_DIR/build/left-local/zephyr/zmk.uf2" /Volumes/NICENANO/
