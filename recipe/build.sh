#!/bin/sh

set -ex

# workaround to get PBP to see that OSX_SDK_DIR is used
# and thus get it forwarded to the build
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo $OSX_SDK_DIR
fi

# OpenGL support
if [[ "${target_platform}" == linux-* ]]; then
  CMAKE_ARGS="
    ${CMAKE_ARGS}
    -DQT_FEATURE_opengl=ON
    -DQT_FEATURE_egl=ON
    -DQT_FEATURE_eglfs=ON
    -DQT_FEATURE_xcb=ON
    -DQT_FEATURE_xcb_egl_plugin=ON
    -DQT_FEATURE_xcb_glx_plugin=ON
    -DQT_FEATURE_xcb_xlib=ON
    -DQT_FEATURE_xlib=ON
    -DQT_FEATURE_xkbcommon=ON
    -DQT_FEATURE_vulkan=ON
    -DQT_FEATURE_wayland=ON
  "
else
  # TODO: Somehow set APPLICATION_EXTENSION_API_ONLY on OSX to avoid this?
  # ld: warning: linking against a dylib which is not safe for use in application extensions: $PREFIX/lib/libz.dylib
  CMAKE_ARGS="
    ${CMAKE_ARGS}
    -DQT_FORCE_WARN_APPLE_SDK_AND_XCODE_CHECK=ON
    -DQT_APPLE_SDK_PATH=${CONDA_BUILD_SYSROOT}
    -DQT_MAC_SDK_VERSION=${OSX_SDK_VER}
  "
fi

cmake --log-level STATUS -S"${SRC_DIR}/${PKG_NAME}" -Bbuild -GNinja ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DQT_UNITY_BUILD=ON \
  -DBUILD_WITH_PCH=OFF \
  -DINSTALL_BINDIR=lib/qt6/bin \
  -DINSTALL_PUBLICBINDIR=bin \
  -DINSTALL_LIBEXECDIR=lib/qt6 \
  -DINSTALL_DOCDIR=share/doc/qt6 \
  -DINSTALL_ARCHDATADIR=lib/qt6 \
  -DINSTALL_DATADIR=share/qt6 \
  -DINSTALL_INCLUDEDIR=include/qt6 \
  -DINSTALL_MKSPECSDIR=lib/qt6/mkspecs \
  -DINSTALL_EXAMPLESDIR=share/doc/qt6/examples \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DQT_FEATURE_zstd=ON \
  -DQT_FEATURE_icu=ON \
  -DQT_FEATURE_concurrent=ON \
  -DQT_FEATURE_dbus=ON \
  -DQT_FEATURE_dbus_linked=OFF \
  -DQT_FEATURE_gui=ON \
  -DQT_FEATURE_sql=ON \
  -DQT_FEATURE_testlib=ON \
  -DQT_FEATURE_xml=ON \
  -DQT_FEATURE_widgets=ON \
  -DQT_FEATURE_sql_sqlite=ON \
  -DQT_FEATURE_system_sqlite=ON \
  -DQT_FEATURE_sql_mysql=ON \
  -DQT_FEATURE_sql_psql=ON \
  -DQT_FEATURE_mtdev=OFF \
  -DQT_FEATURE_system_harfbuzz=ON \
  -DQT_FEATURE_system_freetype=ON \
  -DQT_FEATURE_system_jpeg=ON \
  -DQT_FEATURE_system_pcre2=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_sqlite=ON \
  -DQT_FEATURE_system_xcb_xinput=ON \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_cups=ON \
  -DQT_FEATURE_framework=OFF \
  -DQT_FEATURE_gssapi=ON \
  -DQT_FEATURE_enable_new_dtags=OFF
cmake --build build --target install --parallel ${CPU_COUNT}

# Include the build config in the package for reference later.
mkdir -p ${PREFIX}/share/qt6
cp ./build/config.summary ${PREFIX}/share/qt6/

pushd "${PREFIX}"

mkdir -p bin

if [[ -f "${SRC_DIR}"/build/user_facing_tool_links.txt ]]; then
  for links in "${SRC_DIR}"/build/user_facing_tool_links.txt; do
    while read _line; do
      if [[ -n "${_line}" ]]; then
        ln -sf ${_line}
      fi
    done < ${links}
  done
fi

# You can find the expected values of these files in the log
# For example Translations will be listed as
# INSTALL_TRANSLATIONSDIR
# This file should be in the location of the user's executable
# for conda, this becomes PREFIX/bin/
# https://doc.qt.io/qt-6/qt-conf.html
cat << EOF >${PREFIX}/bin/qt6.conf
[Paths]
Prefix = ${PREFIX}
Documentation = ${PREFIX}/share/doc/qt6
Headers = ${PREFIX}/include/qt6
Libraries = ${PREFIX}/lib
LibraryExecutables = ${PREFIX}/lib/qt6
Binaries = ${PREFIX}/lib/qt6/bin
Plugins = ${PREFIX}/lib/qt6/plugins
QmlImports = ${PREFIX}/lib/qt6/qml
ArchData = ${PREFIX}/lib/qt6
Data = ${PREFIX}/share/qt6
Translations = ${PREFIX}/share/qt6/translations
Examples = ${PREFIX}/share/doc/qt6/examples
Tests = ${PREFIX}/tests
EOF

popd
