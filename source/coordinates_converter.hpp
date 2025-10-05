#pragma once

#include <QObject>
#include <QVariant>
#include <QList>

class CoordinatesConverter : public QObject {
    Q_OBJECT

public:
    explicit CoordinatesConverter(QObject* parent = nullptr);

    /**
     * @brief Convert coordinates from WGS84 format to UTM
     */
    Q_INVOKABLE QList<QVariant> fromWGS84toUTM(double latitude, double longitude); // NOLINT(modernize-use-trailing-return-type)
};
