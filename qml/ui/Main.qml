import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtLocation
import QtPositioning

import ui

ApplicationWindow {
    id: root

    visible: true

    width: 1200
    height: 900

    minimumWidth: 196
    minimumHeight: 128

    title: Qt.application.name

    menuBar: MenuBar {
        Menu {
            title: qsTr("Settings")
            
            Menu {
                title: qsTr("Language")
                
                Repeater {
                    model: translation_controller.supportedLanguagesList
                    delegate: MenuItem {
                        text: modelData
                        checked: translation_controller.currentLanguage === modelData
                        checkable: true
                        
                        onTriggered: {
                            translation_controller.setLanguage(modelData)
                        }
                    }
                }
            }
            MenuSeparator {}
            Action {
                text: qsTr("Exit");
                shortcut: StandardKey.Quit;
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("About")

            Action {
                text: qsTr("Help")
            }
            Action {
                text: qsTr("About program")
                onTriggered: {
                    aboutDialog.open()
                }
            }
        }
    }

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map

        property geoCoordinate startCentroid

        anchors.fill: parent

        plugin: mapPlugin
        center: QtPositioning.coordinate(infoPane.k_latitude, infoPane.k_longitude)
        zoomLevel: infoPane.zoom

        PinchHandler {
            id: pinch

            target: null

            onActiveChanged: if (active) {
                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                map.zoomLevel += Math.log2(delta)
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                map.bearing -= delta
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel

            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland" ? PointerDevice.Mouse | PointerDevice.TouchPad : PointerDevice.Mouse
            rotationScale: 1 / 120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag

            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }
        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }
        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }
        MouseArea {
            anchors.fill: parent

            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPositionChanged: {
                var coord = map.toCoordinate(Qt.point(mouseX, mouseY))

                if (coord.isValid) {
                    infoPane.referencedLatitude = coord.latitude
                    infoPane.referencedLongitude = coord.longitude
                }
            }
        }
    }
    InfoPane {
        id: infoPane

        anchors {
            top: parent.top
            right: parent.right

            margins: 12
        }

        onSetNewCoordinates: {
            map.center = QtPositioning.coordinate(infoPane.latitude, infoPane.longitude)
            map.zoomLevel = infoPane.zoom
        }
    }

    Dialog {
        id: aboutDialog

        title: qsTr("About program")
        standardButtons: Dialog.Ok
        
        modal: true
        anchors.centerIn: Overlay.overlay

        padding: 16

        ColumnLayout {
            spacing: 8

            Text {
                text: qsTr("Author: ") + Qt.application.organization
                Layout.fillWidth: true
            }
            Text {
                text: qsTr("Version: ") + Qt.application.version
                Layout.fillWidth: true
            }
            Text {
                text: qsTr("Homepage:") + ' <a href="' + Qt.application.domain + '">' + Qt.application.domain + '</a>'
                textFormat: Text.RichText
                wrapMode: Text.Wrap

                Layout.fillWidth: true

                onLinkActivated: function(link) {
                    Qt.openUrlExternally(link)
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }
}