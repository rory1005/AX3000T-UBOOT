#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="${UPSTREAM_REPO:-https://github.com/hanwckf/bl-mt798x.git}"
UPSTREAM_COMMIT="${UPSTREAM_COMMIT:-abe158087c80ed1896f2c281e2dae5e43ffbee41}"
BUILD_ROOT="${BUILD_ROOT:-$PWD/build}"
SRC_DIR="${SRC_DIR:-$BUILD_ROOT/bl-mt798x}"
OUT_DIR="${OUT_DIR:-$PWD/out}"
PATCH_FILE="${PATCH_FILE:-$PWD/patches/0001-ax3000t-an8855-512m.patch}"

if [[ "$(pwd -P)" == /mnt/* ]]; then
  echo "Warning: you are building under /mnt/*. Use the WSL Linux filesystem for fewer symlink and case-sensitivity problems." >&2
fi

for tool in git make aarch64-linux-gnu-gcc python3 dtc bison flex; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing dependency: $tool" >&2
    echo "On Ubuntu/Debian install: sudo apt-get install -y git build-essential gcc-aarch64-linux-gnu flex bison libssl-dev device-tree-compiler qemu-user-static python3 bc" >&2
    exit 1
  fi
done

mkdir -p "$BUILD_ROOT" "$OUT_DIR"

if [[ ! -d "$SRC_DIR/.git" ]]; then
  git clone "$UPSTREAM_REPO" "$SRC_DIR"
fi

cd "$SRC_DIR"
git fetch --tags origin
git checkout "$UPSTREAM_COMMIT"
git reset --hard "$UPSTREAM_COMMIT"
git clean -fdx

if git apply --reverse --check "$PATCH_FILE" >/dev/null 2>&1; then
  echo "Patch is already applied."
else
  git apply "$PATCH_FILE"
fi

SOC=mt7981 \
BOARD=ax3000t_an8855_512m \
MULTI_LAYOUT=1 \
FIXED_MTDPARTS=1 \
UBOOT_DIR=uboot-mtk-20250711 \
ATF_DIR=atf-20250711 \
./build.sh

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
cp -f output/mt7981_ax3000t_an8855_512m-*.bin "$OUT_DIR"/

cd "$OUT_DIR"
sha256sum *.bin > sha256sums.txt
cat sha256sums.txt
