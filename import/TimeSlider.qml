/*******************************************************************************
 *  Copyright 2012-2020 Esri
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Control {
    id: timeSlider

    enum LabelMode { None, Thumbs, Ticks }

    /*!
      \qmlproperty enum labelMode
      \brief How to apply labels to the Slider.
      Valid options are:

      \value LabelMode.Node No labels are applied
      \value LabelMode.Thumbs Labels are applied to the slider thumbs.
      \value LabelMode.Ticks Labels are applied to the slider tick marks.

      The default is \c LabelMode.Thumbs.
      */
    property int labelMode: TimeSlider.LabelMode.Thumbs

    /*!
      \qmlproperty int labelSliderTickInterval
      \brief The interval at which slider ticks should be labelled
      The default is \c 10.
     */
    property int labelSliderTickInterval: 20

    /*!
      \qmlproperty GeoView geoView
      \brief The GeoView for this tool. Should be a SceneView or a MapView.
     */
    property var geoView;

    property var controller: TimeSliderController { }

    /*!
      \qmlproperty var fullExtentLabelFormat
      \brief The format for displaying
      \l {https://doc.qt.io/qt-5/qml-qtqml-date.html}{Date} values
      for the full time extent. - for example "yy/MM/dd".
      The default is \l {https://doc.qt.io/qt-5/qt.html#DateFormat-enum}
      {\c Qt.DefaultLocaleShortDate}.
      \sa Qt.formatDateTime
    */
    property string fullExtentLabelFormat:
        Qt.locale().dateTimeFormat(Locale.ShortFormat);

    /*!
      \qmlproperty var timeStepIntervalLabelFormat
      \brief The date format for displaying time step intervals -
      for example "yy/MM/dd".
      The default is \l {https://doc.qt.io/qt-5/qt.html#DateFormat-enum}
      {\c Qt.DefaultLocaleShortDate}.
      \sa Qt.formatDateTime
      */
    property var timeStepIntervalLabelFormat:
        Qt.locale().dateTimeFormat(Locale.ShortFormat);

    /*!
      \qmlproperty bool startTimePinned
      \brief Whether the start time of the time window can
      be manipulated
      The default is \c false.
    */
    property bool startTimePinned: false

    /*!
      \qmlproperty bool endTimePinned
      \brief Whether the end time of the time window can
      be manipulated
      The default is \c false.
    */
    property bool endTimePinned: false

    /*!
      \qmlproperty bool playbackLoop
      \brief Whether to loop when the animation reaches the
      end of the slider.
      The default is \c "true".
    */
    property bool playbackLoop: true

    /*!
      \qmlproperty bool playbackReverse
      \brief Whether to reverse the animation direction when
      the animation reaches the end of the slider.
      \note This property has no effect if \l playbackLoop
      is \c false.
      The default is \c false.
    */
    property bool playbackReverse: false

    background: Rectangle { }

    contentItem: GridLayout {
        columns: 5

        Label {
            id: startLabel
            horizontalAlignment: Qt.AlignLeft
            palette: timeSlider.palette
            Connections {
                target: controller
                onExtentsChanged: {
                    startLabel.text = Qt.formatDateTime(
                                controller.timeForStep(0),
                                fullExtentLabelFormat);
                }
            }
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.margins: 5
        }

        Button {
            icon.source: "images/step_back.png"
            enabled: !startTimePinned || !endTimePinned
            palette: timeSlider.palette
            onClicked: timeSlider.incrementFrame(-1);
            Layout.alignment: Qt.AlignLeft
            Layout.margins: 5
        }

        Button {
            icon.source: checked ? "images/pause.png"
                                 : "images/play.png"
            enabled: !startTimePinned || !endTimePinned
            checkable: true
            palette: timeSlider.palette
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 5
            Timer {
                running: parent.checked
                repeat: true
                interval: 500
                onTriggered: play();
            }
        }

        Button {
            icon.source: "images/step.png"
            enabled: !startTimePinned || !endTimePinned
            palette: timeSlider.palette
            onClicked: timeSlider.incrementFrame(1);
            Layout.alignment: Qt.AlignRight
            Layout.margins: 5
        }

        Label {
            text: Qt.formatDateTime(
                      controller.timeForStep(controller.numberOfSteps),
                      fullExtentLabelFormat);
            horizontalAlignment: Qt.AlignRight
            palette: timeSlider.palette
            Layout.alignment: Qt.AlignRight  | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.margins: 5
        }

        RangeSlider {
            id: slider
            stepSize: 1.0
            palette: timeSlider.palette
            snapMode: RangeSlider.SnapAlways
            from: 0
            to: controller.numberOfSteps
            first {
                handle: Rectangle {
                    x: slider.leftPadding + slider.first.visualPosition * (slider.availableWidth) - width /2
                    y: slider.topPadding - width/2
                    implicitWidth: enabled ? 26 : 4
                    implicitHeight: 26
                    radius: enabled ? 13 : 1
                    color: slider.first.pressed && enabled ? slider.palette.midlight
                                                           : slider.palette.base
                    border.color: slider.palette.mid
                    enabled: !startTimePinned
                }
                onValueChanged: {
                    if (slider.first.pressed) {
                        if (slider.first.handle.enabled)
                            controller.setSteps(first.value, controller.endStep);
                        else // Reset
                            slider.first.value = controller.startStep;
                    }
                }
            }
            second {
                handle: Rectangle {
                    x: slider.leftPadding + slider.second.visualPosition * (slider.availableWidth) - width/2
                    y: slider.topPadding - width/2
                    implicitWidth: enabled ? 26 : 4
                    implicitHeight: 26
                    radius: enabled ? 13 : 1
                    color: slider.second.pressed && enabled ? slider.palette.midlight
                                                            : slider.palette.base
                    border.color: slider.palette.mid
                    enabled: !endTimePinned
                }
                onValueChanged: {
                    if (slider.second.pressed) {
                        if (slider.second.handle.enabled)
                            controller.setSteps(controller.startStep, second.value);
                        else // Reset
                            slider.second.value = controller.endStep;
                    }
                }
            }
            background:  Item {
                id: sliderBackground
                anchors {
                    left: parent.left;
                    right: parent.right
                }
                height: childrenRect.height
                y: slider.topPadding
                Rectangle {
                    id: sliderBar
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    implicitHeight: 4
                    height: implicitHeight
                    radius: 2
                    color: slider.palette.midlight
                    Rectangle {
                        x: slider.first.visualPosition * parent.width
                        width: slider.second.visualPosition * parent.width - x
                        height: parent.height
                        color: slider.palette.shadow
                        radius: 2
                    }
                }
                Repeater {
                    id: repeater
                    property int marks: slider.to - slider.from
                    property var firstHandleLabel: null;
                    property var secondHandleLabel: null;
                    model: marks > 0 ? marks + 1 : 0
                    Item {
                        id: tickHold
                        anchors.top: sliderBar.bottom
                        x: (slider.availableWidth  - width)
                           * (index / repeater.marks) + slider.leftPadding
                        width: tickMark.width
                        Rectangle  {
                            id: tickMark
                            anchors.top: parent.top
                            width: 2
                            height: index % labelSliderTickInterval === 0 ? 20 
                                                                          : 10
                            color: slider.palette.midlight
                        }
                        Label {
                            id: tickLabel
                            anchors {
                                top: tickMark.bottom
                                topMargin: index % labelSliderTickInterval === 0 ? 0 : 10
                                bottom: parent.bottom
                            }

                            property string defaultLabelText:
                                Qt.formatDateTime(
                                    controller.timeForStep(index),
                                    timeStepIntervalLabelFormat);

                            property string combinedLabelText: `${
                                Qt.formatDateTime(
                                    controller.timeForStep(index),
                                    timeStepIntervalLabelFormat)} - ${
                                Qt.formatDateTime(
                                    controller.timeForStep(index + 1),
                                    timeStepIntervalLabelFormat)}`;

                            property real defaultLabelWidth: 
                                fontMetric.boundingRect(defaultLabelText).width;

                            property real defaultLabelX: {
                                const minX = -tickHold.x;
                                const maxX = -tickHold.x + sliderBackground.width - width;
                                return Math.min(maxX, Math.max(-defaultLabelWidth/2, minX));
                            }

                            x: defaultLabelX

                            text: defaultLabelText;

                            palette: slider.palette

                            visible: index > 0 &&
                                     index < repeater.marks &&
                                     index % labelSliderTickInterval === 0 &&
                                     labelMode === TimeSlider.LabelMode.Ticks 

                            states: [
                                State {
                                    name: "singleVisible"
                                    PropertyChanges {
                                        target: tickLabel
                                        visible: index > 0 && 
                                                 index < repeater.marks
                                    }
                                },
                                State {
                                    name: "combinedVisible"
                                    PropertyChanges {
                                        target: tickLabel
                                        text: tickLabel.combinedLabelText
                                        visible: index > 0 && 
                                                 index < repeater.marks
                                    }
                                }
                            ]

                            FontMetrics {
                                id: fontMetric
                                font: tickLabel.font
                            }

                            Connections {
                                target: slider.first
                                onValueChanged: {
                                    if (index === slider.first.value &&
                                        labelMode === TimeSlider.LabelMode.Thumbs) {
                                        if (index > 0 && index < repeater.marks) {
                                            repeater.firstHandleLabel = tickLabel;
                                        } else {
                                            repeater.firstHandleLabel = null;
                                        }
                                    }
                                }
                            }
                            Connections {
                                target: slider.second
                                onValueChanged: {
                                    if (index === slider.second.value &&
                                        labelMode === TimeSlider.LabelMode.Thumbs) {
                                        if (index > 0 && index < repeater.marks) {
                                            repeater.secondHandleLabel = tickLabel;
                                        } else {
                                            repeater.secondHandleLabel = null;
                                        }
                                    }
                                }
                            }
                            Connections {
                                target: repeater
                                onFirstHandleLabelChanged: {
                                    if (tickLabel !== repeater.firstHandleLabel &&
                                        tickLabel !== repeater.secondHandleLabel) {
                                        tickLabel.state = "";
                                    }
                                }
                                onSecondHandleLabelChanged: {
                                    if (tickLabel !== repeater.firstHandleLabel &&
                                        tickLabel !== repeater.secondHandleLabel) {
                                        tickLabel.state = "";
                                    }
                                }
                            }
                        }
                    }
                    onFirstHandleLabelChanged: handlesChanged()
                    onSecondHandleLabelChanged: handlesChanged()
                    function handlesChanged() {
                        if (firstHandleLabel &&
                            firstHandleLabel == secondHandleLabel) {
                            firstHandleLabel.state = "singleVisible";
                        } else if (firstHandleLabel && secondHandleLabel && 
                            horizontalOverlaps(firstHandleLabel, secondHandleLabel)) {
                            firstHandleLabel.state = "combinedVisible";
                            secondHandleLabel.state = "";
                        } else {
                            if (firstHandleLabel)
                                firstHandleLabel.state = "singleVisible";

                            if (secondHandleLabel)
                                secondHandleLabel.state = "singleVisible";
                        }
                    }
                    function horizontalOverlaps(item1, item2) {
                        const r1 = item1.mapToItem(
                            this, item1.defaultLabelX, item1.y,
                            item1.defaultLabelWidth, item1.height);
                        const r2 = item2.mapToItem(
                            this, item2.defaultLabelX, item2.y,
                            item2.defaultLabelWidth, item2.height);

                        if (r1.right < r2.left) {
                            return false;
                        }
                        else if (r2.right < r1.left) {
                            return false;
                        }
                        return true;
                    }
                }
            }
            Connections {
                target: controller
                onStepsChanged: slider.setValues(controller.startStep,
                                                 controller.endStep);
            }
            Layout.columnSpan: 5
            Layout.fillWidth: true
            Layout.margins: 5
            Layout.minimumHeight: sliderBackground.height
        }
    }

    Binding {
        target: controller
        property: "geoView"
        value: timeSlider.geoView
    }

    function incrementFrame(count) {
        const s = startTimePinned ? controller.startStep
                                  : controller.startStep + count;

        const e = endTimePinned ? controller.endStep
                                : controller.endStep + count;

        if (e <= controller.numberOfSteps && s >= 0 && s <= e) {
            controller.setSteps(s, e);
            return true;
        } else {
            return false;
        }
    }

    function play() {
        const success = incrementFrame(playbackReverse ? -1 : 1);
        const loops = playbackLoop && !(startTimePinned || endTimePinned);
        if (loops && !success) {
            let range = controller.endStep - controller.startStep;
            if (playbackReverse) {
                controller.setSteps(controller.numberOfSteps - range,
                                    controller.numberOfSteps);
            } else {
                controller.setSteps(0, range);
            }
        }
    }
}