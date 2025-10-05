#pragma once

#include <cstddef>

constexpr const char* project_name = "GeoTileViewer";
constexpr const char* project_version = "0.1.0";
constexpr const char* project_homepage_url = "https://github.com/AlferovKirill/GeoTileViewer";
constexpr const char* project_description = "The application provides three input fields: latitude (lat), longitude (lon), and zoom. Based on the entered data, the corresponding satellite image fragment is downloaded from a public mapping service (e.g., Google Maps Tiles API) and displayed on the screen. As you move the cursor over the map area, the window title displays the coordinates of the point under the cursor in two coordinate systems: WGS84 and UTM.";
constexpr const char* author = "Alferov Kirill";

constexpr size_t major = 0;
constexpr size_t minor = 1;
constexpr size_t patch = 0;
