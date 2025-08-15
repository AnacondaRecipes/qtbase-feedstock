#!/bin/sh

set -ex

test -f ${PREFIX}/bin/qt6.conf

cmake -Stest -Bbuild -GNinja -DCMAKE_BUILD_TYPE=Release
cmake --build build --target all --config Release

if [ "$(uname)" = "Linux" ]; then
    # Ensure /etc/machine-id exists and is valid for D-Bus/Qt
    if [ -f /etc/machine-id ] && [ ! -s /etc/machine-id ]; then
        dbus-uuidgen --ensure
    fi

    xvfb-run -a --server-args="-screen 0 1024x768x24" ctest --test-dir build --verbose
else
    ctest --test-dir build --output-on-failure
fi
