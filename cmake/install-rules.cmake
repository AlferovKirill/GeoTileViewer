install(
    TARGETS GeoTileViewer_exe
    RUNTIME COMPONENT GeoTileViewer_Runtime
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
