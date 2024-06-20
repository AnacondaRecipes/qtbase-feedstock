#!/bin/sh

set -ex

if [[ "${target_platform}" == linux-* ]]; then
  CMAKE_ARGS="
    ${CMAKE_ARGS}
    -DQT_FEATURE_egl=ON
    -DQT_FEATURE_eglfs=ON
    -DQT_FEATURE_xcb=ON
    -DQT_FEATURE_xcb_xlib=ON
    -DQT_FEATURE_xkbcommon=ON
    -DQT_FEATURE_vulkan=OFF
    -DQT_FEATURE_wayland=OFF
  "
fi

cmake -S"${SRC_DIR}/${PKG_NAME}" -Bbuild -GNinja ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DCMAKE_UNITY_BUILD=OFF \
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
  -DQT_FEATURE_harfbuzz=OFF \
  -DQT_FEATURE_system_harfbuzz=OFF \
  -DQT_FEATURE_system_freetype=ON \
  -DQT_FEATURE_system_jpeg=ON \
  -DQT_FEATURE_system_pcre2=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_sqlite=ON \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_cups=ON \
  -DQT_FEATURE_framework=OFF \
  -DQT_FEATURE_gssapi=ON \
  -DQT_FEATURE_enable_new_dtags=OFF
cmake --build build --target install

pushd "${PREFIX}"

mkdir -p bin

if [[ -f "${SRC_DIR}"/build/user_facing_tool_links.txt ]]; then
  for links in "${SRC_DIR}"/build/user_facing_tool_links.txt; do
    while read _line; do
      ln -sf $_line
    done < ${links}
  done
fi

cat << EOF > bin/qt6.conf
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
