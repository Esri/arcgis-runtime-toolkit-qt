import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Esri.ArcGISExtras 1.1

Item {

    property real scaleFactor: System.displayScaleFactor

    // NorthArrowController must be registered as a QML type in C++ code
    NorthArrowController {
        id: controller
        objectName: "northArrowController"
    }

    height: 25 * scaleFactor
    width: 25 * scaleFactor
    opacity: 0.85

    Image {
        anchors.fill: parent
        source: "qrc:/qt-project.org/imports/Esri/ArcGISRuntime/Toolkit/Controls/images/NorthArrow.png"
        fillMode: Image.PreserveAspectFit
        rotation: -1 * controller.heading

        // When zooming in a Scene, the heading will adjust by a miniscule amount. Using the < comparison rather than === prevents flickering while zooming
        visible: controller.autoHide && (controller.heading < 1e-05 || controller.heading === 360) ? false : true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                controller.heading = 0;
            }
        }
    }
}