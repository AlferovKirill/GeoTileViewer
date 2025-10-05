#include "coordinates_converter.hpp"

#include <GeographicLib/UTMUPS.hpp>

CoordinatesConverter::CoordinatesConverter(QObject* parent) : QObject(parent) {}

QList<QVariant> CoordinatesConverter::fromWGS84toUTM(double latitude, double longitude) { // NOLINT(modernize-use-trailing-return-type, readability-convert-member-functions-to-static)
    int zone {0};
    bool northp {false};

    double x_coord (0.0);
    double y_coord {0.0};

    GeographicLib::UTMUPS::Forward(latitude, longitude, zone, northp, x_coord, y_coord);

    return QList<QVariant>{ zone, northp, x_coord, y_coord };
}
