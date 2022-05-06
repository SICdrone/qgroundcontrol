/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         1.2
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
// import QGroundControl.Vehicle       1.0
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

    property var    _searchResults      ///< List of parameter names from search results
    property var    _appSettings:       QGroundControl.settingsManager.appSettings
    // property bool   _searchFilter:      searchText.text.trim() != "" || controller.showModifiedOnly  ///< true: showing results of search
    //property bool   _showRCToParam:     _activeVehicle.px4Firmware


    Rectangle {
        // id:     sicRectangle
        // color: "#19d4d4d4"
        color:             qgcPal.windowShadeDark
        height:            ScreenTools.defaultFontPixelWidth * 55      
        width:             ScreenTools.defaultFontPixelHeight * 25
        // width:             ScreenTools.defaultFontPixelHeight * 50
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
            id: titleRow
            anchors.horizontalCenter:   parent.horizontalCenter
            height:                     50
            QGCLabel{
                id:   titleSIC
                text:       "SICVIEW"
                color:                  qgcPal.text
                font.bold:              true
            }
        }
        Row {
            id:         sicView
            anchors.top:     titleRow.bottom

            Column {
                id:                speedView  
                height:            ScreenTools.defaultFontPixelWidth * 40
                Layout.margins:       _toolsMargin
                width:             ScreenTools.defaultFontPixelHeight * 10
                spacing:           10

                // color:             qgcPal.windowShadeDark
                // border {
                //     color:          "#34c6eb"
                //     width:          4
                // }
                QGCLabel {
                    id:                     speedometerTitle
                    text:                   "AIR SPEED (mph)"
                    Layout.fillWidth:       true
                    // Layout.alignment:       Qt.AlignHCenter
                    color:                  qgcPal.text
                    font.pointSize:         ScreenTools.mediumFontPointSize 
                    font.bold:              true
                    y:                      50
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                QGCLabel {
                    id:                     speedStat
                    font.pointSize:         ScreenTools.mediumFontPointSize
                    text:                   speedGauge.value.toFixed(2) + ""
                    Layout.fillWidth:   true
                    color:                  qgcPal.text
                    // font.pointSize:         ScreenTools.smallFontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                CircularGauge {
                    id:                     speedGauge
                    Layout.fillWidth:       true
                    anchors.horizontalCenter: parent.horizontalCenter
                    
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
            }
            Column {
                Repeater {
                    model: _activeVehicle ? _activeVehicle.batteries : 0

                    Loader {
                        sourceComponent:    tiltComponent


                    }
                }
                id:                 tiltView
                // spacing:            10

                height:            ScreenTools.defaultFontPixelWidth * 40        
                // width:             ScreenTools.defaultFontPixelHeight * 6.4  
                Layout.margins:       _toolsMargin
                Component {
                    id: tiltComponent
                    ColumnLayout{
                        FactPanelController {
                            id:          controller
                            // factPanel : panel
                        }
                        QGCLabel {
                            id:                     _tiltLabel
                            Layout.fillWidth:       true
                            text:                   "TILT VIEW"                    
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.mediumFontPointSize 
                            font.bold:              true

                        }
                        QGCLabel {
                            id:                     leftTiltTitle
                            text:                   "AUTO TILT ENABLED"
                            Layout.fillWidth:       true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.mediumFontPointSize / 2
                            font.bold:              true
                        }

                        FactTextField{
                            //The -1 signals default component id

                            // fact : controller.getParameterFact("SIC_PARLEL_MODE")

                            fact:   controller.getParameterFact(-1, "SIC_AUTO_TILT_EN" )
                            // indexModel: false
                            Layout.fillWidth:   true
                        }             
                        QGCLabel {
                            id:                     rightTiltTitle
                            text:                   "TILT MODE"
                            Layout.fillWidth:       true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.mediumFontPointSize / 2
                            font.bold:              true
                        
                        }
                        // QGCButton {
                        //     id:   _tiltModeButton
                        //     text: qsTr("Disabled")
                        //     onClicked: {
                        //         if(ScreenTools.isMobile) {
                        //             Qt.inputMethod.hide();
                        //         }
                        //         if(_tiltEnabledButton.text == "Enabled") {
                        //             _tiltEnabledButton.text = "Enabled"
                        //         }
                        //         else {
                        //             _tiltEnabledButton.text = "Disabled"
                        //         }
                        //     }
                        //     // anchors.verticalCenter: parent.verticalCenter
                        // } 
                        // ComboBox {
                        //     id:                     _tiltModeDropdown
                        //     model:                  ["Parallel","PTF"]             
                        // } 
                        FactTextField {
                            //The -1 signals default component id. 

                            fact : controller.getParameterFact(-1, "SIC_PARLEL_MODE")
                            Layout.fillWidth:   true
                            // indexModel: false
                        }
                        QGCLabel {
                            id:                     _tiltChannelTitle
                            text:                   "TILT MODE CHANNEL"
                            Layout.fillWidth:       true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.mediumFontPointSize / 2
                            font.bold:              true
                        
                        }
                        FactTextField {
                            //The -1 signals default component id. 

                            // width: 100
                            fact : controller.getParameterFact(-1, "TILT_MODE_CHAN")
                            Layout.fillWidth:   true
                            // indexModel: false
                        }
                        // ComboBox {
                        //     id:                     _tiltChannelDropdown
                        //     model:                  ["-1","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]             
                        // }    
                        QGCLabel {
                            id:                     rightTiltStat
                            // text:                   rpmGauge.value.toFixed(2) + ""
                            Layout.fillWidth:   true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.smallFontPointSize
                        }
                        QGCButton {
                            text:           qsTr("Reboot Vehicle")
                            onClicked:    mainWindow.showComponentDialog(rebootVehicleConfirmComponent, qsTr("Reboot Vehicle"), mainWindow.showDialogDefaultWidth, StandardButton.Cancel | StandardButton.Ok)
                        }
                        Component {
                            id: rebootVehicleConfirmComponent

                            QGCViewDialog {
                                function accept() {
                                    hideDialog()
                                    _activeVehicle.rebootVehicle()
                                }

                                QGCLabel {
                                    width:              parent.width
                                    wrapMode:           Text.WordWrap
                                    text:               qsTr("Select Ok to reboot vehicle.")
                                }
                            }
                        }
                    }
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
                spacing:           20
         
            
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
                        spacing:           20
                        QGCLabel {
                            id:                     batteryTitle
                            text:                   "BATTERY LEVEL"
                            anchors.top:            parent.top
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.mediumFontPointSize 
                            font.bold:              true
                        }
                        QGCLabel {
                            id:                     batterytime
                            // text:                   battery._timeRemainingFact
                            text:                   "Time Remaining: " + battery.timeRemaining.valueString
                            Layout.fillWidth:   true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.smallFontPointSize
                            Layout.topMargin:   20
                            // Layout.AlignHCenter:    Qt.AlignHCenter
                        } 
                        QGCLabel {
                            id:                     batteryVoltage
                            // text:                   battery._timeRemainingFact
                            text:                   "Voltage: " + battery.voltage.valueString
                            Layout.fillWidth:   true
                            color:                  qgcPal.text
                            font.pointSize:         ScreenTools.smallFontPointSize
                            Layout.topMargin:   20
                            // Layout.AlignHCenter:    Qt.AlignHCenter
                        } 
                        QGCLabel {
                            id:                     batteryStat
                            text:                   "Battery Left: " + getBatteryPercentageText()
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
                            height:             ScreenTools.defaultFontPixelHeight * 10          
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