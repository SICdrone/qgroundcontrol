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

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real _groundSpeed:             _activeVehicle ? _activeVehicle.groundSpeed.rawValue : 0
    property real   _startingFuelLevel:         _activeVehicle ? _activeVehicle.fuelStatus.startingFuelLevel.rawValue : 0
    property real   _currentFuelLevel:          _activeVehicle ? _activeVehicle.fuelStatus.currentFuelLevel.rawValue : 0
    QGCToolInsets {
        id:                         _toolInsets
        leftEdgeCenterInset:    0
        leftEdgeTopInset:           0
        leftEdgeBottomInset:        0
        rightEdgeCenterInset:   0
        rightEdgeTopInset:          0
        rightEdgeBottomInset:       0
        topEdgeCenterInset:       0
        topEdgeLeftInset:           0
        topEdgeRightInset:          0
        bottomEdgeCenterInset:    0
        bottomEdgeLeftInset:        0
        bottomEdgeRightInset:       0
    }

    Row {
        id:         sicView
        anchors.bottom:     parent.bottom

        Rectangle {
            id:                speedView  
            // anchors {
            //     right:              parent.right           
            //     margins:            _toolsMargin
            //     verticalCenter:     _root.verticalCenter            
            // }
            height:            ScreenTools.defaultFontPixelWidth * 40
            
            width:             ScreenTools.defaultFontPixelHeight * 10
            color:             qgcPal.windowShadeDark
            border {
                color:          "#34c6eb"
                width:          4
            }
            QGCLabel {
                id:                     speedometerTitle
                text:                   "Air Speed (mph)"
                Layout.fillWidth:       true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.mediumFontPointSize / 2
                font.bold:              true
                y:                      50
                
                anchors.horizontalCenter:           speedView.horizontalCenter
            }
            QGCLabel {
                id:                     speedStat
                text:                   speedGauge.value.toFixed(2) + ""
                Layout.fillWidth:   true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.smallFontPointSize
                anchors.top:            speedometerTitle.bottom
                anchors.horizontalCenter: speedView.horizontalCenter
            }
            CircularGauge {
                id:                     speedGauge
                Layout.fillWidth:       true
                
                
                maximumValue:           110
                anchors.horizontalCenter:           speedView.horizontalCenter

                
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
                anchors.bottom:         parent.bottom
                anchors.right:          parent.right
                anchors.margins:        _toolsMargin

            } 
        }
        Rectangle {
            id:                 tiltView
            // anchors {
            //     right:              parent.right          
            //     margins:            _toolsMargin
            //     bottom:             _root.bottom       
            // }
            height:            ScreenTools.defaultFontPixelWidth * 40        
            width:             ScreenTools.defaultFontPixelHeight * 6.4
            color:             qgcPal.windowShadeDark
            border {
                color:          "#34c6eb"
                width:          4
            }     
            QGCLabel {
                Layout.fillWidth:   true
                text:                   "TILT VIEW"
                
                anchors.horizontalCenter: parent.horizontalCenter
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.mediumFontPointSize / 1.5
                font.bold:              true
            }
            QGCLabel {
                id:                     leftTiltTitle
                text:                   "LEFT TILT"
                Layout.fillWidth:       true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.mediumFontPointSize / 2
                font.bold:              true
                y:                      50
                
                anchors.horizontalCenter:           tiltView.horizontalCenter
            }
            QGCLabel {
                id:                     leftTiltStat
                text:                   rpmGauge.value.toFixed(2) + ""
                Layout.fillWidth:   true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.smallFontPointSize
                anchors.top:            leftTiltTitle.bottom
                anchors.horizontalCenter: tiltView.horizontalCenter
            } 
            QGCLabel {
                id:                     rightTiltTitle
                text:                   "RIGHT TILT"
                Layout.fillWidth:       true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.mediumFontPointSize / 2
                font.bold:              true
                anchors.top:            leftTiltStat.bottom 
                
                anchors.horizontalCenter:           tiltView.horizontalCenter
            }
            QGCLabel {
                id:                     rightTiltStat
                text:                   rpmGauge.value.toFixed(2) + ""
                Layout.fillWidth:   true
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.smallFontPointSize
                anchors.top:            rightTiltTitle.bottom
                anchors.horizontalCenter: tiltView.horizontalCenter
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
        Rectangle {
            Repeater {
                model: _activeVehicle ? _activeVehicle.batteries : 0

                Loader {
                    // anchors.top:        parent.top
                    // anchors.bottom:     parent.bottom
                    sourceComponent:    batteryComponent

                    property var battery: object
                }
            }
            id:                 batteryView
            // anchors {
            //     left:              parent.left         
            //     margins:            _toolsMargin
            //     bottom:             _root.bottom       
            // }
            height:            ScreenTools.defaultFontPixelWidth * 40        
            width:             ScreenTools.defaultFontPixelHeight * 6.4
            color:             qgcPal.windowShadeDark
            border {
                color:          "#34c6eb"
                width:          4
            } 
        
            QGCLabel {
                id:                     batteryTitle
                text:                   "Battery Level"
                anchors.horizontalCenter: batteryView.horizontalCenter
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.mediumFontPointSize / 1.5
                font.bold:              true
            }
    
            Image {
                source: "/res/SICLogoFull"
                width:                  40
                height:                 40
                anchors.bottom:         batteryView.bottom
                anchors.right:          batteryView.right
                anchors.margins:        _toolsMargin

            } 
            Component {
                id: batteryComponent
                Rectangle{
                    id: batteryRectangle
                    anchors {
                        horizontalCenter:   parent.horizontalCenter                    
                        margins:            _toolsMargin
                        bottom:             _root.bottom 
                        // left:               parent.left

                    }    
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
                        // anchors.top:            parent.bottom 
                        // anchors.horizontalCenter: batteryRectangle.horizontalCenter
                        // anchors.verticalCenter: batteryRectangle.verticalCenter
                        y:                      50
                        x:                      (ScreenTools.defaultFontPixelHeight * 6.4) / 2
                        //x:65
                        // anchors.horizontalCenter: batteryView.horizontalCenter


                    }   
                    Gauge {
                        id:                     gauge
                        // anchors.margins:       _toolsMargin
                        // anchors.horizontalCenter: parent.horizontalCenter
                        // anchors.verticalCenter:   batteryComponent.verticalCenter
                        y:                   100
                        x:                  (ScreenTools.defaultFontPixelHeight * 6.4) / 4
                        width:              ScreenTools.defaultFontPixelWidth * 11
                        height:             ScreenTools.defaultFontPixelHeight * 11           
                        maximumValue: 100
                        minorTickmarkCount: 1

                        // anchors.top:        batteryStat.bottom
                        // anchors.horizontalCenter: batteryRectangle.horizontalCenter
                        // anchors.verticalCenter: batteryRectangle.verticalCenter
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
                                color: Qt.rgba(gauge.value / gauge.maximumValue, 0, 1 - gauge.value / gauge.maximumValue, 1)
                            }
                        }

                    }   
                } 
            }
        }
    }
}
