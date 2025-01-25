#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ../zmk/app

echo "$SCRIPT_DIR"

# no cache
west build -p \
  -d "$SCRIPT_DIR/build/left" \
  -b nice_nano_v2 -- \
  -DSHIELD="chocofi_left nice_view_adapter nice_view" \
  -DZMK_CONFIG="$SCRIPT_DIR/config" &

west build -p \
  -d "$SCRIPT_DIR/build/right" \
  -b nice_nano_v2 -- \
  -DSHIELD="chocofi_right nice_view_adapter nice_view" \
  -DZMK_CONFIG="$SCRIPT_DIR/config" &

# cache
#west build -d "$SCRIPT_DIR/build/left" &
#west build -d "$SCRIPT_DIR/build/right" &

wait
cp "$SCRIPT_DIR/build/left/zephyr/zmk.uf2" "$SCRIPT_DIR/build/chocofi_left.uf2"
cp "$SCRIPT_DIR/build/right/zephyr/zmk.uf2" "$SCRIPT_DIR/build/chocofi_right.uf2"

cp "$SCRIPT_DIR/build/chocofi_left.uf2" /Volumes/NICENANO/
cp "$SCRIPT_DIR/build/chocofi_right.uf2" /Volumes/NICENANO\ 1/
