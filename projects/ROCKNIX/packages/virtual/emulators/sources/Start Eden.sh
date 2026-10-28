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

# Make sure eden config directory exists
[ ! -d ${CONF_DIR} ] && cp -r ${IMMUTABLE_CONF_DIR} /storage/.config
[ ! -d ${CONF_DIR}/log ] && mkdir -p ${CONF_DIR}/log
[ ! -f "${CONF_DIR}/eden.gptk" ] && cp ${IMMUTABLE_CONF_DIR}/eden.gptk ${CONF_DIR}

# Run Eden fullscreen for global configuration (firmware / keys install, input mapping)
sway_fullscreen "eden" &
${GPTOKEYB} eden -c ${CONF_DIR}/eden.gptk & /usr/bin/eden

kill -9 $(pidof gptokeyb)
