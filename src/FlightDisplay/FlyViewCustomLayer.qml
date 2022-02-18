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
    // Rectangle {
    //     id:                 fuelLevel
    //     anchors.margins:    _toolsMargin
    //     anchors.top:        parent.top
    //     width:              ScreenTools.defaultFontPixelWidth * 45
        
    //     height:             ScreenTools.defaultFontPixelHeight * 5
    //     color:                      qgcPal.windowShadeDark
    //     anchors.topMargin:          _toolsMargin
    //     anchors.horizontalCenter:   parent.horizontalCenter
    //     border {
    //         color:          "#34c6eb"
    //         width:          4

    //     }
        
    //     Row {
    //         Layout.fillWidth:   true
    //         id: title
    //         spacing: ScreenTools.defaultFontPixelWidth
    //         anchors.margins:    _toolsMargin
    //         anchors{
    //             horizontalCenter: parent.horizontalCenter
    //         }

    //         QGCLabel {
    //             Layout.fillWidth:   true
    //             text:                   "FUEL VIEW"
                
    //             anchors.verticalCenter: parent.verticalCenter
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.mediumFontPointSize / 1.5
    //             font.bold:              true
    //         }
    //     } //title row
    //     Row {
    //         id: labelNames
    //         Layout.fillWidth:   true
    //         spacing: ScreenTools.defaultFontPixelWidth
    //         anchors.margins:    _toolsMargin
    //         anchors{
    //             horizontalCenter: parent.horizontalCenter
    //             top:              title.bottom
    //         }

            
    //         QGCLabel {
    //             id:                     startingFuelLabel
    //             text:                   "STARTING AMOUNT"
    //             Layout.fillWidth:   true
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.mediumFontPointSize / 2
    //             font.bold:              true
    //             anchors.left:       fuelLevel.left
                
    //         }
    //         QGCLabel {
    //             text:                   "CURRENT AMOUNT"
    //             Layout.fillWidth:   true
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.mediumFontPointSize / 2
    //             font.bold:              true
    //             anchors.horizontalCenter: fuelLevel.horizontalCenter
                
    //         }
    //         QGCLabel {
    //             text:                   "FUEL PERCENTAGE"
    //             Layout.fillWidth:   true
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.mediumFontPointSize / 2
    //             font.bold:              true
    //             anchors.right:          fuelLevel.right
    //         }
    //     } //label row
    //     Row {
    //         id: labelStats
    //         spacing: ScreenTools.defaultFontPixelWidth * 7
    //         anchors{
    //             horizontalCenter: parent.horizontalCenter
    //             top:              labelNames.bottom
    //         }
    //         y: 55
    //         x: ScreenTools.defaultFontPixelWidth + 4
    //         QGCLabel {
    //             id:                     startingFuelStat
    //             text:                   QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_startingFuelLevel).toFixed(1)
    //                                     + " mL" 
    //             Layout.fillWidth:   true
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.smallFontPointSize
    //             anchors.left:       fuelLevel.left
    //             anchors.top:        startingFuelLabel.bottom     
    //         }    
    //         QGCLabel {
                
    //             text:                   
    //                                     QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_currentFuelLevel).toFixed(1)
    //                                     + " mL" 
    //             Layout.fillWidth:       true
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.smallFontPointSize
    //             anchors.horizontalCenter: fuelLevel.horizontalCenter
    //             anchors.verticalCenter:     fuelLevel.verticalCenter
    //         }  
    //         QGCLabel {
    //             id:                     percentageFuel
    //             Layout.fillWidth:   true
    //             function gasLeft(){
    //                 percentageFuel.text = (QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_currentFuelLevel).toFixed(1) / QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_startingFuelLevel).toFixed(1))*100 + "%" 
    //             }
    //             text:                   gasLeft()        
    //             color:                  qgcPal.text
    //             font.pointSize:         ScreenTools.smallFontPointSize
    //             anchors.right:          fuelLevel.right
    //         } 
    //     } //stats row
    //     MavlinkConsoleController {
    //         id: conController
    //     }
    //     Row{
    //         id:             buttonRow
    //         Layout.fillWidth:   true
    //         spacing: ScreenTools.defaultFontPixelWidth
    //         anchors{
    //             horizontalCenter: parent.horizontalCenter
    //             top:              labelStats.bottom
    //         }         
    //         TextField {
                
    //             id: fuelfield
    //             Layout.fillWidth:   true
    //             placeholderText:               qsTr("in mL")
    //             font.family:        "Helvetica"
    //             font.pointSize:      10
    //             font.bold:              true
    //             validator: DoubleValidator {
    //                 bottom: -1e8
    //                 top: 1e8
    //                 decimals: 1
    //             }
    //             horizontalAlignment:Text.AlignHCenter
    //             verticalAlignment:  Text.AlignVCenter

    //             width:                  150
    //             function sendCommand() {
    //                 conController.sendCommand("fs2012 fuel " + fuelfield.text)
    //                 fuelfield.text = ""
    //             }
    //             function listenerCommand() {
    //                 return conController.sendCommand("listener fuel_status")
    //             }                
    //             onAccepted:  {
                    
    //                 _startingFuelLevel += parseFloat(fuelfield.text)
    //                 sendCommand()
                    
    //                 fuelfield.placeholderText = "Enter Fuel"
    //                 fuelfield.text=listenerCommand()
                    
    //                 percentageFuel.text = "                  " + (QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_currentFuelLevel).toFixed(1) / QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_startingFuelLevel).toFixed(1))*100 + "%" 
    //                 _currentFuelLevel = _activeVehicle.fuelStatus.startingFuelLevel.rawValue
    //                 _startingFuelLevel = _activeVehicle.fuelStatus.currentFuelLevel.rawValue
                    
    //             }
    //         } // add fuel text box (sends mavlink command)

    //         QGCButton {
                
    //             contentItem: Text {
    //                 text:               qsTr("ADD FUEL")
    //                 font.family:        "Helvetica"
    //                 font.pointSize:      12
    //                 opacity:            enabled ? 1.0 : 0.3
    //                 horizontalAlignment:Text.AlignHCenter
    //                 verticalAlignment:  Text.AlignVCenter
    //                 elide:              Text.ElideRight
    //             }   
    //             Layout.fillWidth:   true          
    //             backRadius:             4
    //             showBorder:             true
    //             heightFactor:           0.1
    //             height:                 50
    //             onClicked: {
    //                 //need function here to trigger change in fuel status 
    //                 // dostuff("fs2012 add " + str(input)) 
    //                 if (fuelfield.text != "" && fuelfield.text != " " && isNaN(parseInt(fuelfield.text)) == false) {
    //                     _startingFuelLevel += parseInt(fuelfield.text)
    //                     fuelfield.text=""
    //                     fuelfield.sendCommand()
    //                     _currentFuelLevel = _activeVehicle.fuelStatus.startingFuelLevel.rawValue
    //                     _startingFuelLevel = _activeVehicle.fuelStatus.currentFuelLevel.rawValue
    //                     fuelfield.placeholderText = ""
    //                     percentageFuel.text = "                  " + (QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_currentFuelLevel).toFixed(1) / QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_startingFuelLevel).toFixed(1))*100 + "%" 
    //                 }
    //             }    
    //         } // add fuel button
    //     }
    //     Image {
    //         source: "/res/SICLogoFull"
    //         width:                  40
    //         height:                 40
    //         anchors.bottom:         parent.bottom
    //         anchors.right:          parent.right
    //         anchors.margins:        _toolsMargin

    //     }
    // } //the fuel view widget
    Rectangle {
        id:                speedView  
        anchors {
            right:              parent.right           
            margins:            _toolsMargin
            verticalCenter:     _root.verticalCenter            
        }
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
        anchors {
            right:              parent.right          
            margins:            _toolsMargin
            bottom:             _root.bottom       
        }
        height:            ScreenTools.defaultFontPixelWidth * 15
        
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
        anchors {
            left:              parent.left         
            margins:            _toolsMargin
            bottom:             _root.bottom       
        }
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
                    anchors.top:            parent.bottom 
                    anchors.horizontalCenter: parent.horizontalCenter
                }   
                Gauge {
                    id:                     gauge
                    anchors.margins:       _toolsMargin
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:              ScreenTools.defaultFontPixelWidth * 11
                    height:             ScreenTools.defaultFontPixelHeight * 7           
                    maximumValue: 100
                    minorTickmarkCount: 1
                    anchors.top:        batteryStat.bottom

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
