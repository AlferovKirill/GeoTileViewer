cmake_minimum_required(VERSION 3.14)

include(cmake/prelude.cmake)

project(
    GeoTileViewer
    VERSION 0.1.0
    DESCRIPTION "The application provides three input fields: latitude (lat), longitude (lon), and zoom. Based on the entered data, the corresponding satellite image fragment is downloaded from a public mapping service (e.g., Google Maps Tiles API) and displayed on the screen. As you move the cursor over the map area, the window title displays the coordinates of the point under the cursor in two coordinate systems: WGS84 and UTM."
    HOMEPAGE_URL "https://github.com/AlferovKirill/GeoTileViewer"
    LANGUAGES CXX
)

set(AUTHOR "Alferov Kirill")
set(CMAKE_PREFIX_PATH "$ENV{HOME}/Qt/6.5.3/gcc_64")

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare project warnings ----

add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE -Wall -Wextra -Wpedantic -Wconversion)
target_compile_features(project_warnings INTERFACE cxx_std_17)

# ---- Declare library ----

find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    QuickControls2
    LinguistTools
    Location
    Positioning
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

file(GLOB_RECURSE LIB_SOURCES "source/*.cpp")
list(REMOVE_ITEM LIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/source/main.cpp")

add_library(GeoTileViewer_lib OBJECT ${LIB_SOURCES})

target_include_directories(GeoTileViewer_lib ${warning_guard} PUBLIC "\$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source>")

target_link_libraries(GeoTileViewer_lib PRIVATE project_warnings)
target_link_libraries(GeoTileViewer_lib PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Location
    Qt6::Positioning
)

# ---- Declare executable ----

add_executable(GeoTileViewer_exe source/main.cpp)
add_executable(GeoTileViewer::exe ALIAS GeoTileViewer_exe)

set_property(TARGET GeoTileViewer_exe PROPERTY OUTPUT_NAME GeoTileViewer)

target_link_libraries(GeoTileViewer_exe PRIVATE GeoTileViewer_lib)

set_target_properties(GeoTileViewer_exe PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# ---- Declare paths for configure files ----

set(CONFIG_TEMPLATE_DIR ${CMAKE_SOURCE_DIR}/config)
set(CONFIG_OUTPUT_DIR ${CMAKE_SOURCE_DIR}/source/config)

include(cmake/config/project_description.cmake)

# ---- Declare QML modules and assets ----

file(GLOB_RECURSE QML_UI_FILES RELATIVE "${CMAKE_SOURCE_DIR}" CONFIGURE_DEPENDS "qml/ui/*.qml")

qt_add_qml_module(GeoTileViewer_exe
    URI app
    RESOURCE_PREFIX /
    VERSION 1.0
    QML_FILES ${QML_UI_FILES}
)

add_subdirectory(assets)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Developer mode ----

if(NOT GeoTileViewer_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of GeoTileViewer"
  )
endif()

include(cmake/dev-mode.cmake)
