cmake_minimum_required (VERSION 3.16)
project (QtTests LANGUAGES CXX)

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_AUTOMOC ON)

find_package (Qt6 CONFIG REQUIRED COMPONENTS Core Gui Widgets Network Sql Concurrent Test DBus OpenGL OpenGLWidgets PrintSupport Xml)

add_executable (concurrent_test test_concurrent.cpp)
target_link_libraries (concurrent_test PRIVATE Qt6::Concurrent)

add_executable (core_test test_core.cpp)
target_link_libraries (core_test PRIVATE Qt6::Core)

add_executable (dbus_test test_dbus.cpp)
target_link_libraries (dbus_test PRIVATE Qt6::DBus)

add_executable (gui_test test_gui.cpp)
target_link_libraries (gui_test PRIVATE Qt6::Gui)

add_executable (network_test test_network.cpp)
target_link_libraries (network_test PRIVATE Qt6::Network)

add_executable (opengl_test test_opengl.cpp)
target_link_libraries (opengl_test PRIVATE Qt6::OpenGL)

add_executable (openglwidgets_test test_openglwidgets.cpp)
target_link_libraries (openglwidgets_test PRIVATE Qt6::OpenGLWidgets)

add_executable (printsupport_test test_printsupport.cpp)
target_link_libraries (printsupport_test PRIVATE Qt6::PrintSupport)

add_executable (qmimedatabase_test test_qmimedatabase.cpp)
target_link_libraries (qmimedatabase_test PRIVATE Qt6::Core)

add_executable (sql_test test_sql.cpp)
target_link_libraries (sql_test PRIVATE Qt6::Sql)

add_executable (test_test test_test.cpp)
target_link_libraries (test_test PRIVATE Qt6::Test)

add_executable (widgets_test test_widgets.cpp)
target_link_libraries (widgets_test PRIVATE Qt6::Widgets)

add_executable (xml_test test_xml.cpp)
target_link_libraries (xml_test PRIVATE Qt6::Xml)

enable_testing ()
add_test (NAME test_concurrent COMMAND concurrent_test)
add_test (NAME test_core COMMAND core_test)
add_test (NAME test_dbus COMMAND dbus_test)
add_test (NAME test_gui COMMAND gui_test)
add_test (NAME test_network COMMAND network_test)
add_test (NAME test_printsupport COMMAND printsupport_test)
add_test (NAME test_qmimedatabase COMMAND qmimedatabase_test)
add_test (NAME test_sql COMMAND sql_test)
add_test (NAME test_test COMMAND test_test)
add_test (NAME test_widgets COMMAND widgets_test)
add_test (NAME test_xml COMMAND xml_test)

if (NOT WIN32)
  add_test (NAME test_opengl COMMAND opengl_test)
  add_test (NAME test_openglwidgets COMMAND openglwidgets_test)
endif ()
