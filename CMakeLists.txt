cmake_minimum_required(VERSION 3.14)

include(cmake/prelude.cmake)

project(
    GeoTileViewer
    VERSION 0.1.0
    DESCRIPTION "The application provides three input fields: latitude (lat), longitude (lon), and zoom. Based on the entered data, the corresponding satellite image fragment is downloaded from a public mapping service (e.g., Google Maps Tiles API) and displayed on the screen. As you move the cursor over the map area, the window title displays the coordinates of the point under the cursor in two coordinate systems: WGS84 and UTM."
    HOMEPAGE_URL "https://github.com/AlferovKirill/GeoTileViewer"
    LANGUAGES CXX
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare library ----

add_library(
    GeoTileViewer_lib OBJECT
    source/lib.cpp
)

target_include_directories(
    GeoTileViewer_lib ${warning_guard}
    PUBLIC
    "\$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source>"
)

target_compile_features(GeoTileViewer_lib PUBLIC cxx_std_20)

find_package(fmt REQUIRED)
target_link_libraries(GeoTileViewer_lib PRIVATE fmt::fmt)

# ---- Declare executable ----

add_executable(GeoTileViewer_exe source/main.cpp)
add_executable(GeoTileViewer::exe ALIAS GeoTileViewer_exe)

set_property(TARGET GeoTileViewer_exe PROPERTY OUTPUT_NAME GeoTileViewer)

target_compile_features(GeoTileViewer_exe PRIVATE cxx_std_20)

target_link_libraries(GeoTileViewer_exe PRIVATE GeoTileViewer_lib)

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
