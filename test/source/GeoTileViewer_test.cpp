#include "lib.hpp"

auto main() -> int
{
  auto const lib = Library {};
  return lib.name == "GeoTileViewer" ? 0 : 1;
}
