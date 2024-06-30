@ECHO ON

if not exist %LIBRARY_BIN%\qt6.conf exit 1
if not exist %PREFIX%\qt6.conf exit 1

pushd test

cmake -G"NMake Makefiles" -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" .
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

ctest -C Release --output-on-failure
if errorlevel 1 exit 1

hello.exe
if errorlevel 1 exit 1
