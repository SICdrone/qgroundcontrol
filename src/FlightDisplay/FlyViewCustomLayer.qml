/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12
import QtQuick.Controls.Styles  1.4
import QtQuick.Extras           1.4


import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0
import MAVLink                      1.0
// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl
    property int    _rowHeight:         ScreenTools.defaultFontPixelHeight * 2
    property int    _rowWidth:          10 // Dynamic adjusted at runtime    
    property Fact   _editorDialogFact: Fact { }
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real _groundSpeed:             _activeVehicle ? _activeVehicle.groundSpeed.rawValue : 0
    property var    _controller:        controller

    ParameterEditorController {
        id: controller
    }
    // QGCToolInsets {
    //     id:                         _toolInsets
    //     leftEdgeCenterInset:    0
    //     leftEdgeTopInset:           0
    //     leftEdgeBottomInset:        0
    //     rightEdgeCenterInset:   0
    //     rightEdgeTopInset:          0
    //     rightEdgeBottomInset:       0
    //     topEdgeCenterInset:       0
    //     topEdgeLeftInset:           0
    //     topEdgeRightInset:          0
    //     bottomEdgeCenterInset:    0
    //     bottomEdgeLeftInset:        0
    //     bottomEdgeRightInset:       0
    // }
    // QGCListView {
    //     id:                 paramsListView
    //     anchors.leftMargin: ScreenTools.defaultFontPixelWidth
    //     // anchors.left:       _searchFilter ? parent.left : groupScroll.right
    //     anchors.right:      _root.right
    //     // anchors.top:        header.bottom
    //     anchors.bottom:     _root.bottom
    //     orientation:        ListView.Vertical
    //     model:              controller.parameters
    //     cacheBuffer:        height > 0 ? height * 2 : 0
    //     clip:               true
    //     Rectangle {
    //         id: testangle
    //         height: 30
    //         width:    30
    //         color:  qgcPal.windowShadeDark
    //         QGCLabel {
    //             id:     nameLabel
    //             width:  ScreenTools.defaultFontPixelWidth  * 20
    //             text:   "poop"
    //             //clip:   true

    //         }
            
    //     }
        // delegate: Rectangle {
        //     height: _rowHeight
        //     width:  _rowWidth
        //     color:  qgcPal.windowShadeDark

        //     Row {
        //         id:     factRow
        //         spacing: Math.ceil(ScreenTools.defaultFontPixelWidth * 0.5)
        //         anchors.verticalCenter: parent.verticalCenter

        //         property Fact modelFact: object

        //         QGCLabel {
        //             id:     nameLabel
        //             width:  ScreenTools.defaultFontPixelWidth  * 20
        //             text:   factRow.modelFact.name
        //             clip:   true

        //         }
        //     }
        // }
    // }

    // Rectangle {
    //     id:                 buttonTest
    //     color:             qgcPal.windowShadeDark
    //     height:            ScreenTools.defaultFontPixelWidth * 40      
    //     width:             ScreenTools.defaultFontPixelHeight * 25
    //     anchors {
    //         right:       parent.right
    //         bottom:     parent.bottom
    //         margins:    _toolsMargin
    //     }
    //     QGCListView {
    //         id:                 editorListView
    //         anchors.leftMargin: ScreenTools.defaultFontPixelWidth
    //         anchors.left:       _searchFilter ? parent.left : groupScroll.right
    //         anchors.right:      parent.right
    //         anchors.top:        header.bottom
    //         anchors.bottom:     parent.bottom
    //         orientation:        ListView.Vertical
    //         model:              controller.parameters
    //         cacheBuffer:        height > 0 ? height * 2 : 0
    //         clip:               true

    //         delegate: Rectangle {
    //             height: _rowHeight
    //             width:  _rowWidth
    //             color:  qgcPal.windowShadeDark

    //             Row {
    //                 id:     factRow
    //                 spacing: Math.ceil(ScreenTools.defaultFontPixelWidth * 0.5)
    //                 anchors.verticalCenter: parent.verticalCenter

    //                 property Fact modelFact: object

    //                 QGCLabel {
    //                     id:     nameLabel
    //                     width:  ScreenTools.defaultFontPixelWidth  * 20
    //                     text:   factRow.modelFact.name
    //                     clip:   true

    //                 }
    //             }
    //         }
    //     }
    // }
    Rectangle {
        // id:     sicRectangle
        // color: "#19d4d4d4"
        color:             qgcPal.windowShadeDark
        height:            ScreenTools.defaultFontPixelWidth * 40      
        width:             ScreenTools.defaultFontPixelHeight * 25
        anchors {
            left:       parent.left
            bottom:     parent.bottom
            margins:    _toolsMargin
        }
        border {
            color:          "#34c6eb"
            width:          4
        }
        Row {
            id:         sicView
            anchors.bottom:     parent.bottom

            Column {
                id:                speedView  
                height:            ScreenTools.defaultFontPixelWidth * 40
                
                width:             ScreenTools.defaultFontPixelHeight * 10
                // color:             qgcPal.windowShadeDark
                // border {
                //     color:          "#34c6eb"
                //     width:          4
                // }
                QGCLabel {
                    id:                     speedometerTitle
                    text:                   "Air Speed (mph)"
                    Layout.fillWidth:       true
                    // Layout.alignment:       Qt.AlignHCenter
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 2
                    font.bold:              true
                    y:                      50
                }
                QGCLabel {
                    id:                     speedStat
                    text:                   speedGauge.value.toFixed(2) + ""
                    Layout.fillWidth:   true
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.smallFontPointSize
                }
                CircularGauge {
                    id:                     speedGauge
                    Layout.fillWidth:       true
                    
                    
                    maximumValue:           110
                    // anchors.horizontalCenter:           parent.horizontalCenter

                    
                    tickmarksVisible:   true
                    width:              ScreenTools.defaultFontPixelWidth * 20
                    height:             ScreenTools.defaultFontPixelHeight * 20
                    value:              _groundSpeed * 2.23694
                    Behavior on value {            
                        NumberAnimation {
                            duration:   250
                        }
                    }
                    style: CircularGaugeStyle {
                        

                        function degreesToRadians(degrees) {
                            return degrees * (Math.PI / 180);
                        }
                        background: Canvas {
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();

                                ctx.beginPath();
                                ctx.strokeStyle = "#e34c22";
                                ctx.lineWidth = outerRadius * 0.02;

                                ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                    degreesToRadians(378.5), degreesToRadians(415));
                                ctx.stroke();
                            }
                        }
                        // tickmarkStepSize:       1
                        // minorTickmarkCount:     2
                        needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.03
                            implicitHeight: outerRadius * 0.9
                            antialiasing: true
                            color: Qt.rgba(0.66, 0.3, 0, 1)
                        }
                    }
                } // engine rpm gauge     
                Image {
                    source: "/res/SICLogoFull"
                    width:                  40
                    height:                 40
                } 
            }
            Column {
                id:                 tiltView
                spacing:            10

                height:            ScreenTools.defaultFontPixelWidth * 40        
                width:             ScreenTools.defaultFontPixelHeight * 6.4  
                QGCLabel {
                    id:                     _tiltLabel
                    Layout.fillWidth:       true
                    text:                   "TILT VIEW"                    
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 1.5
                    font.bold:              true
                }
                QGCLabel {
                    id:                     leftTiltTitle
                    text:                   "TilT ENABLED"
                    Layout.fillWidth:       true
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 2
                    font.bold:              true
                }

                QGCButton {
                    id:   _tiltEnabledButton
                    text: qsTr("Disabled")
                    onClicked: {
                        if(ScreenTools.isMobile) {
                            Qt.inputMethod.hide();
                        }
                        if(_tiltEnabledButton.text == "Disabled") {
                            _tiltEnabledButton.text = "Enabled"
                        }
                        else {
                            _tiltEnabledButton.text = "Disabled"
                        }
                    }
                }                
                QGCLabel {
                    id:                     rightTiltTitle
                    text:                   "TILT MODE"
                    Layout.fillWidth:       true
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 2
                    font.bold:              true
                   
                }
                QGCButton {
                    id:   _tiltModeButton
                    text: qsTr("Disabled")
                    onClicked: {
                        if(ScreenTools.isMobile) {
                            Qt.inputMethod.hide();
                        }
                        if(_tiltEnabledButton.text == "Enabled") {
                            _tiltEnabledButton.text = "Enabled"
                        }
                        else {
                            _tiltEnabledButton.text = "Disabled"
                        }
                    }
                    // anchors.verticalCenter: parent.verticalCenter
                } 
                QGCLabel {
                    id:                     _tiltChannelTitle
                    text:                   "TILT CHANNEL"
                    Layout.fillWidth:       true
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 2
                    font.bold:              true
                   
                }
                ComboBox {
                    id:                     _tiltChannelDropdown
                    model:                  ["-1","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]             
                }    
                QGCLabel {
                    id:                     rightTiltStat
                    // text:                   rpmGauge.value.toFixed(2) + ""
                    Layout.fillWidth:   true
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.smallFontPointSize
                } 
            }
            Column {
                Repeater {
                    model: _activeVehicle ? _activeVehicle.batteries : 0

                    Loader {
                        sourceComponent:    batteryComponent

                        property var battery: object
                    }
                }
                id:                 batteryView

                height:            ScreenTools.defaultFontPixelWidth * 40        
                width:             ScreenTools.defaultFontPixelHeight * 6.4
                QGCLabel {
                    id:                     batteryTitle
                    text:                   "Battery Level"
                    anchors.top:            parent.top
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize / 1.5
                    font.bold:              true
                }
         
            
                Component {
                    id: batteryComponent
                    ColumnLayout{
                        id: batteryRectangle  
                        function getBatteryColor() {
                            switch (battery.chargeState.rawValue) {
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_OK:
                                return qgcPal.text
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_LOW:
                                return qgcPal.colorOrange
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_CRITICAL:
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_EMERGENCY:
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_FAILED:
                            case MAVLink.MAV_BATTERY_CHARGE_STATE_UNHEALTHY:
                                return qgcPal.colorRed
                            default:
                                return qgcPal.text
                            }
                        }

                        function getBatteryPercentageText() {
                            if (!isNaN(battery.percentRemaining.rawValue)) {
                                if (battery.percentRemaining.rawValue > 98.9) {
                                    return qsTr("100%")
                                } else {
                                    return battery.percentRemaining.valueString + battery.percentRemaining.units
                                }
                            } else if (!isNaN(battery.voltage.rawValue)) {
                                return battery.voltage.valueString + battery.voltage.units
                            } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                                return battery.chargeState.enumStringValue
                            }
                            return ""
                        }
                        QGCLabel {
                            id:                     batteryStat
                            text:                   getBatteryPercentageText()
                            Layout.fillWidth:   true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.smallFontPointSize
                            Layout.topMargin:   20
                            // Layout.AlignHCenter:    Qt.AlignHCenter
                        } 
                        Gauge {
                            id:                     gauge
                            Layout.margins:       _toolsMargin
                            Layout.topMargin:   35
                            width:              ScreenTools.defaultFontPixelWidth * 11
                            height:             ScreenTools.defaultFontPixelHeight * 11           
                            maximumValue: 100
                            minorTickmarkCount: 1


                            tickmarkStepSize:       50
                            
                            value: battery.percentRemaining.rawValue

                            Behavior on value {            
                                NumberAnimation {
                                    duration: 250
                                }
                            }
                            style: GaugeStyle {
                                valueBar: Rectangle {
                                    implicitWidth: 16
                                    color: Qt.rgba(1-gauge.value / gauge.maximumValue, gauge.value / gauge.maximumValue, 0, 1)
                                }
                            }

                        }    
                    } 
                }
            }
        }

        Image {
            source: "/res/SICLogoFull"
            width:                  40
            height:                 40
            anchors.bottom:         parent.bottom
            anchors.right:          parent.right
            anchors.margins:        _toolsMargin

        } 
    }
}
