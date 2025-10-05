# Parent project does not export its library target, so this CML implicitly
# depends on being added from it, i.e. the testing is done only from the build
# tree and is not feasible from an install location

project(GeoTileViewerTests LANGUAGES CXX)

# ---- Tests ----

add_executable(GeoTileViewer_test source/GeoTileViewer_test.cpp)
target_link_libraries(GeoTileViewer_test PRIVATE GeoTileViewer_lib)
target_compile_features(GeoTileViewer_test PRIVATE cxx_std_17)

add_test(NAME GeoTileViewer_test COMMAND GeoTileViewer_test)

# ---- End-of-file commands ----

add_folders(Test)
