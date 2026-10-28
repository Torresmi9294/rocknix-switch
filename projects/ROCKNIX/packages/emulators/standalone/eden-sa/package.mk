# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="eden-sa"
PKG_VERSION="v0.2.1"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://git.eden-emu.dev/eden-emu/eden"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ffmpeg mesa SDL2 boost zlib libusb zstd openssl opus qt6 ${VULKAN}"
PKG_LONGDESC="Eden - Nintendo Switch emulator"
PKG_GIT_CLONE_BRANCH=""
GET_HANDLER_SUPPORT="git"

# NOTE: Eden fetches third-party deps through CPM at configure time. If the
# build sandbox has no network, pre-seed CPM_SOURCE_CACHE (see pre_configure_target)
# or switch PKG_URL to an Eden source tarball that bundles them.

PKG_CMAKE_OPTS_TARGET+=" -DENABLE_QT=ON \
                         -DENABLE_QT_TRANSLATION=OFF \
                         -DENABLE_UPDATE_CHECKER=OFF \
                         -DENABLE_WEB_SERVICE=OFF \
                         -DENABLE_WERROR=OFF \
                         -DENABLE_LIBUSB=ON \
                         -DUSE_DISCORD_PRESENCE=OFF \
                         -DYUZU_CMD=OFF \
                         -DYUZU_ROOM=OFF \
                         -DYUZU_ROOM_STANDALONE=OFF \
                         -DYUZU_TESTS=OFF \
                         -DYUZU_USE_BUNDLED_QT=OFF \
                         -DYUZU_USE_BUNDLED_FFMPEG=OFF \
                         -DYUZU_USE_BUNDLED_SDL3=ON \
                         -DYUZU_USE_BUNDLED_OPENSSL=OFF \
                         -DYUZU_DISABLE_LLVM=ON \
                         -DYUZU_CRASH_DUMPS=OFF"

pre_configure_target() {
  export CXXFLAGS+=" -fpch-preprocess"
  # Persist CPM downloads between builds
  export CPM_SOURCE_CACHE="${PKG_BUILD}/.cache/cpm"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp -a ${PKG_BUILD}/.${TARGET_NAME}/bin/eden ${INSTALL}/usr/bin
    cp -a ${PKG_DIR}/scripts/start_eden.sh ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/eden
    cp -a ${PKG_DIR}/config/common/* ${INSTALL}/usr/config/eden
}
