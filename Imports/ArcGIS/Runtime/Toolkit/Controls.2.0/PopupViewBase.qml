/*******************************************************************************
 * Copyright 2012-2016 Esri
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 ******************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Esri.ArcGISExtras 1.1

/*!
    internal
*/
Item {
    id: popupViewBase

    /* internal */
    property color backgroundColorInternal
    property color borderColorInternal
    property real borderWidthInternal
    property real radiusInternal
    property string titleTextInternal
    property real titleTextSizeInternal
    property color titleTextColorInternal
    property color attributeNameTextColorInternal
    property color attributeValueTextColorInternal
    property var popupManagerInternal: null
    property real scaleFactor: System.displayScaleFactor
    property var displayedFields: popupManagerInternal ? popupManagerInternal.displayedFields : null
    property var attachments: popupManagerInternal ? popupManagerInternal.attachmentMananger.attachmentsModel : null
    property bool showAttachments: popupManagerInternal ? popupManagerInternal.showAttachments : true
    signal attachmentThumbnailClickedInternal(var index)
    
    Rectangle {
        anchors.fill: parent
        color: backgroundColorInternal
        border {
            color: borderColorInternal
            width: borderWidthInternal
        }
        radius: radiusInternal
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: mouse.accepted = true;
            onWheel: wheel.accepted = true;
        }

        Column {
            id: heading
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 10 * scaleFactor
            }
            spacing: 10
            clip: true

            Text {
                width: parent.width
                text: titleTextInternal + ":"
                elide: Text.ElideRight
                color: titleTextColorInternal
                font {
                    family: "serif"
                    pixelSize: titleTextSizeInternal
                    bold: true
                }
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: 1 * scaleFactor
                color: borderColorInternal
            }
        }

        Flickable {
            anchors {
                left: parent.left
                right: parent.right
                top: heading.bottom
                bottom: parent.bottom
                margins: 10 * scaleFactor
            }
            contentHeight: popupColumn.height
            clip: true

            Column {
                id: popupColumn
                width: parent.width
                spacing: 10
                clip: true

                // display of attributes
                Column {
                    spacing: 5
                    width: parent.width
                    Repeater {
                        model: displayedFields

                        Row {
                            anchors.left: parent.left
                            clip: true
                            spacing: 5

                            Text {
                                width: popupColumn.width * 0.55
                                text: fieldName ? fieldName : ""
                                wrapMode: Text.WrapAnywhere
                                font.pixelSize: 14 * scaleFactor
                                color: attributeNameTextColorInternal
                            }

                            Text {
                                width: popupColumn.width * 0.4
                                text: formattedValue ? formattedValue : ""
                                //text: fieldValue ? fieldValue : ""
                                wrapMode: Text.WrapAnywhere
                                font.pixelSize: 14 * scaleFactor
                                color: attributeValueTextColorInternal
                            }
                        }
                    }
                }

                Text {
                    text: "Attachments:"
                    font {
                        family: "serif"
                        pixelSize: titleTextSizeInternal
                        bold: true
                    }
                    renderType: Text.NativeRendering
                    visible: showAttachments
                }

                // display of attachments
                Column {
                    spacing: 5
                    width: parent.width
                    visible: showAttachments

                    Repeater {
                        model: attachments

                        Row {
                            anchors.left: parent.left
                            clip: true
                            spacing: 5

                            Text {
                                width: popupColumn.width * 0.6
                                text: name
                                wrapMode: Text.WrapAnywhere
                                font.pixelSize: 14 * scaleFactor
                                color: attributeNameTextColor
                            }

                            Image {
                                source: thumbnailUrl
                                width: attachments.thumbnailWidth * 0.5
                                height: attachments.thumbnailHeight * 0.5

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: attachmentThumbnailClickedInternal(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}