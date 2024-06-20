#!/bin/sh

set -ex

test -f ${PREFIX}/bin/qt6.conf

cmake -Stest -Bbuild -GNinja
cmake --build build --target all
ctest --test-dir build --output-on-failure

./build/hello
