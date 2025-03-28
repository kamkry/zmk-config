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
    -d "$SCRIPT_DIR/build/left" \
    -b nice_nano_v2 -- \
    -DSHIELD="chocofi_left nice_view_adapter nice_view" \
    -DZMK_CONFIG="$SCRIPT_DIR/config" &

    ../.venv/bin/west build -p \
    -d "$SCRIPT_DIR/build/right" \
    -b nice_nano_v2 -- \
    -DSHIELD="chocofi_right nice_view_adapter nice_view" \
    -DZMK_CONFIG="$SCRIPT_DIR/config" &

else
    west build -d "$SCRIPT_DIR/build/left" &
    west build -d "$SCRIPT_DIR/build/right" &
fi

wait

echo "Waiting for both NICENANO and NICENANO 1 to be mounted..."

while [ ! -d "/Volumes/NICENANO" ] || [ ! -d "/Volumes/NICENANO 1" ]; do
  status_nicenano="[ ] NICENANO (right)"
  status_nicenano1="[ ] NICENANO 1 (left)"

  [ -d "/Volumes/NICENANO" ] && status_nicenano="[✔] NICENANO (right)"
  [ -d "/Volumes/NICENANO 1" ] && status_nicenano1="[✔] NICENANO 1 (left)"

  echo -ne "\r$status_nicenano   $status_nicenano1"
  sleep 1
done

echo -e "\nBoth NICENANO and NICENANO 1 are now available!"
echo "Copying files to NICENANOs..."

cp "$SCRIPT_DIR/build/right/zephyr/zmk.uf2" "$SCRIPT_DIR/build/chocofi_right.uf2"
cp "$SCRIPT_DIR/build/left/zephyr/zmk.uf2" "$SCRIPT_DIR/build/chocofi_left.uf2"

cp "$SCRIPT_DIR/build/chocofi_right.uf2" /Volumes/NICENANO/
cp "$SCRIPT_DIR/build/chocofi_left.uf2" /Volumes/NICENANO\ 1/

echo "Done!"