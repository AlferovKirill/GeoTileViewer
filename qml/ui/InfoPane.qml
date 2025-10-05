import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ui

Pane {
    id: root

    readonly property real k_zoom: 10

    readonly property real min_zoom: 1
    readonly property real max_zoom: 100

    property real zoom: k_zoom

    property double latitude
    property double longitude

    property double referencedLatitude
    property double referencedLongitude

    property var utmCoordinates: CoordinatesConverter.fromWGS84toUTM(root.referencedLatitude, root.referencedLongitude)

    width: mainLayout.contentWidth
    height: mainLayout.contentHeight

    padding: 12

    background: Rectangle {
        color: systemPalette.window
        opacity: 0.8

        radius: 8

        border {
            color: systemPalette.dark
            width: 2
        }
    }

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }

    ColumnLayout {
        id: mainLayout

        spacing: 8
        anchors.fill: parent

        Label {
            text: qsTr("Referenced coordinates (WGS84)")
            font.bold: true

            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Latitude:") }
            Label {
                text: Number(root.referencedLatitude).toFixed(6)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Longitude:") }
            Label {
                text: Number(root.referencedLongitude).toFixed(6)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        Label {
            text: qsTr("Referenced coordinates (UTM)")
            font.bold: true

            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("UTM zone:") }
            Label {
                text: root.utmCoordinates[0] + (root.utmCoordinates[1] ? "N" : "S")
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Easting:") }
            Label {
                text: root.utmCoordinates[2].toFixed(3)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Northing:") }
            Label {
                text: root.utmCoordinates[3].toFixed(3)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
    }
}
