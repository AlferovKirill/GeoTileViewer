import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ui

Pane {
    id: root

    // Moscow
    readonly property real k_latitude: 55.7558
    readonly property real k_longitude: 37.6173

    readonly property real k_zoom: 14

    readonly property real min_zoom: 1
    readonly property real max_zoom: 100

    property real zoom: k_zoom

    property real latitude: k_latitude
    property real longitude: k_longitude

    property real referencedLatitude: k_latitude
    property real referencedLongitude: k_longitude

    property var utmReferencedCoordinates: CoordinatesConverter.fromWGS84toUTM(root.referencedLatitude, root.referencedLongitude)

    property var supportedMapTypes

    signal setNewViewType(index: int)
    signal setNewCoordinates

    function newCoordinatesHandler() {
        root.latitude = Number(latitudeTextField.text)
        root.longitude = Number(longitudeTextField.text)
        root.zoom = Number(zoomTextField.text)

        root.setNewCoordinates()
    }
    function resetCoordinatesHandler() {
        root.latitude = root.k_latitude
        root.longitude = root.k_longitude
        root.zoom = root.k_zoom

        root.setNewCoordinates()
    }

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
            text: qsTr("View type")
            font.bold: true

            Layout.fillWidth: true
        }
        ComboBox {
            model: root.supportedMapTypes
            textRole: "name"

            Layout.fillWidth: true

            onCurrentIndexChanged: {
                root.setNewViewType(currentIndex)
            }
        }
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
                text: root.utmReferencedCoordinates[0]
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Pole:") }
            Label {
                text: root.utmReferencedCoordinates[1] ? "N" : "S"
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Easting:") }
            Label {
                text: root.utmReferencedCoordinates[2].toFixed(3)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label { text: qsTr("Northing:") }
            Label {
                text: root.utmReferencedCoordinates[3].toFixed(3)
                horizontalAlignment: Text.AlignRight

                Layout.fillWidth: true
            }
        }
        Rectangle {
            color: systemPalette.dark

            height: 2
            radius: height / 2

            Layout.fillWidth: true
        }
        Label {
            text: qsTr("Set coordinates")
            font.bold: true

            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label {
                text: qsTr("Latitude:")
                Layout.preferredWidth: 110
            }
            TextField {
                id: latitudeTextField
                
                text: root.latitude
                validator: DoubleValidator {
                    locale: "en_US"
                    notation: DoubleValidator.StandardNotation
                }
                
                Layout.fillWidth: true

                onAccepted: {
                    root.newCoordinatesHandler()
                }
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label {
                text: qsTr("Longitude:")
                Layout.preferredWidth: 110
            }
            TextField {
                id: longitudeTextField

                text: root.longitude
                validator: DoubleValidator {
                    locale: "en_US"
                    notation: DoubleValidator.StandardNotation
                }
                
                Layout.fillWidth: true

                onAccepted: {
                    root.newCoordinatesHandler()
                }
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Label {
                text: qsTr("Zoom:")
                Layout.preferredWidth: 110
            }
            TextField {
                id: zoomTextField

                text: root.zoom
                validator: DoubleValidator {
                    locale: "en_US"
                    notation: DoubleValidator.StandardNotation
                }

                Layout.fillWidth: true

                onAccepted: {
                    root.newCoordinatesHandler()
                }
            }
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Button {
                text: qsTr("Reset")
                Layout.fillWidth: true

                onClicked: {
                    root.resetCoordinatesHandler()
                }
            }
            Button {
                text: qsTr("Set")
                Layout.fillWidth: true

                onClicked: {
                    root.newCoordinatesHandler()
                }
            }
        }
    }
}
