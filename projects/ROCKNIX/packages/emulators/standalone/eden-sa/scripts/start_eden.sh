#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

. /etc/profile
set_kill set "-9 eden"

# Load gptokeyb support files
control-gen_init.sh
source /storage/.config/gptokeyb/control.ini
get_controls

# Filesystem vars
IMMUTABLE_CONF_DIR="/usr/config/eden"
CONF_DIR="/storage/.config/eden"
ROMS_DIR="/storage/roms/switch"
SAVESTATES_DIR="/storage/roms/savestates/switch"

# Make sure eden config directory exists
[ ! -d ${CONF_DIR} ] && cp -r ${IMMUTABLE_CONF_DIR} /storage/.config
[ ! -d ${CONF_DIR}/log ] && mkdir -p ${CONF_DIR}/log

# Keep nand/sdmc/keys beside the roms so they survive config resets
for d in nand sdmc keys; do
  [ ! -d ${ROMS_DIR}/eden/${d} ] && mkdir -p ${ROMS_DIR}/eden/${d}
done
mkdir -p /storage/.local/share
rm -rf /storage/.local/share/eden
ln -sf ${ROMS_DIR}/eden /storage/.local/share/eden

# Make sure gptokeyb mapping file exists
[ ! -f "${CONF_DIR}/eden.gptk" ] && cp ${IMMUTABLE_CONF_DIR}/eden.gptk ${CONF_DIR}

# Emulation Station Features
GAME=$(echo "${1}"| sed "s#^/.*/##")
PLATFORM=$(echo "${2}"| sed "s#^/.*/##")

# Set the cores to use
CORES=$(get_setting "cores" "${PLATFORM}" "${GAME}")
unset EMUPERF
[ "${CORES}" = "little" ] && EMUPERF="${SLOW_CORES}"
[ "${CORES}" = "big" ] && EMUPERF="${FAST_CORES}"

# Run Eden fullscreen
sway_fullscreen "eden" &
${GPTOKEYB} eden -c ${CONF_DIR}/eden.gptk &

${EMUPERF} /usr/bin/eden -f -g "${1}"
kill -9 $(pidof gptokeyb)
