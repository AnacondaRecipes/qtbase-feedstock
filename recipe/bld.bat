@REM Support systems with neither capable OpenGL (desktop mode) nor DirectX 11 (ANGLE mode) drivers
@REM https://github.com/ContinuumIO/anaconda-issues/issues/9142
if not exist "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"
copy opengl32sw\opengl32sw.dll %LIBRARY_BIN%\opengl32sw.dll
if errorlevel 1 exit /b 1
if not exist %LIBRARY_BIN%\opengl32sw.dll exit /b 1

set OPENGLVER=dynamic

@REM https://bugreports.qt.io/browse/QTBUG-107009
set "PATH=%SRC_DIR%\build\lib\qt6\bin;%PATH%"

cmake -S"%SRC_DIR%/%PKG_NAME%" -B"%SRC_DIR%\build" -GNinja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DQT_UNITY_BUILD=ON ^
    -DINSTALL_BINDIR=lib/qt6/bin ^
    -DINSTALL_PUBLICBINDIR=bin ^
    -DINSTALL_LIBEXECDIR=lib/qt6 ^
    -DINSTALL_DOCDIR=share/doc/qt6 ^
    -DINSTALL_ARCHDATADIR=lib/qt6 ^
    -DINSTALL_DATADIR=share/qt6 ^
    -DINSTALL_INCLUDEDIR=include/qt6 ^
    -DINSTALL_MKSPECSDIR=lib/qt6/mkspecs ^
    -DINSTALL_EXAMPLESDIR=share/doc/qt6/examples ^
    -DINSTALL_DATADIR=share/qt6 ^
    -DQT_FEATURE_openssl=ON ^
    -DQT_FEATURE_openssl_linked=ON ^
    -DQT_FEATURE_glib=ON ^
    -DQT_FEATURE_gui=ON ^
    -DQT_FEATURE_sql=ON ^
    -DQT_FEATURE_testlib=ON ^
    -DQT_FEATURE_xml=ON ^
    -DQT_FEATURE_icu=ON ^
    -DQT_FEATURE_widgets=ON ^
    -DQT_FEATURE_sql_sqlite=ON ^
    -DQT_FEATURE_system_sqlite=ON ^
    -DQT_FEATURE_sql_mysql=OFF ^
    -DQT_FEATURE_sql_psql=ON ^
    -DQT_FEATURE_harfbuzz=OFF ^
    -DQT_FEATURE_jpeg=ON ^
    -DQT_FEATURE_system_jpeg=ON ^
    -DQT_FEATURE_system_png=ON ^
    -DQT_FEATURE_enable_new_dtags=OFF ^
    -DINPUT_opengl=%OPENGLVER%
if errorlevel 1 exit 1

cmake --build build --target install
if errorlevel 1 exit 1

xcopy /y /s %LIBRARY_PREFIX%\lib\qt6\bin\*.dll %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1

copy %LIBRARY_PREFIX%\lib\qt6\bin\qmake.exe %LIBRARY_PREFIX%\bin\qmake6.exe
if errorlevel 1 exit 1
copy %LIBRARY_PREFIX%\lib\qt6\bin\qtpaths.exe %LIBRARY_PREFIX%\bin\qtpaths6.exe
if errorlevel 1 exit 1
copy %LIBRARY_PREFIX%\lib\qt6\bin\androiddeployqt.exe %LIBRARY_PREFIX%\bin\androiddeployqt6.exe
if errorlevel 1 exit 1
copy %LIBRARY_PREFIX%\lib\qt6\bin\windeployqt.exe %LIBRARY_PREFIX%\bin\windeployqt6.exe
if errorlevel 1 exit 1

echo [Paths]                                                     > %LIBRARY_BIN%\qt6.conf
echo Prefix = %PREFIX:\=/%                                      >> %LIBRARY_BIN%\qt6.conf
echo Documentation = %LIBRARY_PREFIX:\=/%/share/doc/qt6         >> %LIBRARY_BIN%\qt6.conf
echo Headers = %LIBRARY_INC:\=/%/qt6                            >> %LIBRARY_BIN%\qt6.conf
echo Libraries = %LIBRARY_LIB:\=/%                              >> %LIBRARY_BIN%\qt6.conf
echo LibraryExecutables = %LIBRARY_LIB:\=/%/qt6                 >> %LIBRARY_BIN%\qt6.conf
echo Binaries = %LIBRARY_LIB:\=/%/qt6/bin                       >> %LIBRARY_BIN%\qt6.conf
echo Plugins = %LIBRARY_LIB:\=/%/qt6/plugins                    >> %LIBRARY_BIN%\qt6.conf
echo QmlImports = %LIBRARY_LIB:\=/%/qt6/qml                     >> %LIBRARY_BIN%\qt6.conf
echo ArchData = %LIBRARY_LIB:\=/%/qt6                           >> %LIBRARY_BIN%\qt6.conf
echo Data = %LIBRARY_PREFIX:\=/%/share/qt6                      >> %LIBRARY_BIN%\qt6.conf
echo Translations = %LIBRARY_PREFIX:\=/%/share/qt6/translations >> %LIBRARY_BIN%\qt6.conf
echo Examples = %LIBRARY_PREFIX:\=/%/share/doc/qt6/examples     >> %LIBRARY_BIN%\qt6.conf
echo Tests = %LIBRARY_PREFIX:\=/%/tests                         >> %LIBRARY_BIN%\qt6.conf
echo HostData = %LIBRARY_PREFIX:\=/%/lib/qt6                    >> %LIBRARY_BIN%\qt6.conf
echo HostBinaries = %LIBRARY_LIB:\=/%/qt6/bin                   >> %LIBRARY_BIN%\qt6.conf
echo HostLibraryExecutables = %LIBRARY_LIB:\=/%/qt6             >> %LIBRARY_BIN%\qt6.conf
echo HostLibraries = %LIBRARY_LIB:\=/%                          >> %LIBRARY_BIN%\qt6.conf
copy "%LIBRARY_BIN%\qt6.conf" "%PREFIX%\qt6.conf"
