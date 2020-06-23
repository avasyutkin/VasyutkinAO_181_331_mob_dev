import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.14 //для камеры
import QtQuick 2.0
import QtQuick 2.14
import QtMultimedia 5.4
import QtGraphicalEffects 1.14
import QtQuick.Window 2.12
import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQml 2.14
import QtWebView 1.14
import QtCharts 2.0
import QtWebSockets 1.1

Page{  //СТРАНИЦА ДЛЯ ТРЕТЬЕЙ ЛАБОРАТОРНОЙ - ГРАФИЧЕСКИЕ ЭФФЕКТЫ - IT IS MY PHOTOSHOP
    id: page03
    header: ToolBar {
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        Text {
            font.family: "SF UI Display Bold"
            text: "Графические эффекты"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    Image {
        id: imageforchange
        source: if (fileDialoglab3.fileUrl == 0) "/image/p4ZBKSVeTFY.jpg"; else fileDialoglab3.fileUrl
        width: 340
        height: 338
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.bottom: sliderforsaturation.top
        anchors.bottomMargin: 15
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            FileDialog {
                id: fileDialoglab3
                folder: shortcuts.home
                nameFilters: [ "Image files (*.jpg *.png)"]
                
            }
            onPressAndHold: fileDialoglab3.open()
            onDoubleClicked: sliderforradius.value = 0, sliderforloops.value = 0,
            sliderforhue.value = 0, sliderforlightness.value = 0, sliderforsaturation.value = 0,
            sliderforradiusglow.value = 0, sliderforspread.value = 0
        }
        }
            
            RecursiveBlur {
                id: recursiveblur
                anchors.fill: imageforchange
                source: imageforchange
                radius: sliderforradius.value
                loops: sliderforloops.value
            }
            
            Slider {
                id: sliderforradius
                from: 0
                to: 15
                anchors.bottom: sliderforloops.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
                
            }
            
            Text {
                font.family: "SF UI Display"
                font.pointSize: 10
                id: textsliderforradius
                text: qsTr("radius  " + sliderforradius.value.toFixed(1))
                anchors.bottom: sliderforradius.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.bottomMargin: -10
                
            }
            
            Slider {
                id: sliderforloops
                from: 0
                to: 80
                anchors.bottom: barforlab3.top
                anchors.bottomMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
                enabled: if(sliderforradius.value == 0)
                             false
                         else
                             true
                value: if(sliderforradius.value == 0)
                           0
            }
            
            Text {
                id: textsliderforloops
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("loops  " + sliderforloops.value.toFixed(1))
                anchors.bottom: sliderforloops.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
                
            }
            
            HueSaturation {
                id: huesaturation
                anchors.fill: recursiveblur
                source: recursiveblur
                hue: sliderforhue.value
                saturation: sliderforsaturation.value
                lightness: sliderforlightness.value
            }
            
            Slider{
                visible: false
                id: sliderforhue
                from: -1
                to: 1
                anchors.bottom: barforlab3.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
                
            }
            
            Text {
                visible: false
                id: sliderforhuetext
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("hue  " + sliderforhue.value.toFixed(1))
                anchors.bottom: sliderforhue.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            
            Slider{
                visible: false
                id: sliderforlightness
                from: -1
                to: 1
                anchors.bottom: sliderforhue.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
            }
            
            Text {
                visible: false
                id: sliderforlightnesstexxt
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("lightness  " + sliderforlightness.value.toFixed(1))
                anchors.bottom: sliderforlightness.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            
            Slider{
                visible: false
                id: sliderforsaturation
                from: -1
                to: 1
                anchors.bottom: sliderforlightness.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
                
            }
            
            Text {
                visible: false
                id: sliderforsaturationtext
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("saturation  " + sliderforsaturation.value.toFixed(1))
                anchors.bottom: sliderforsaturation.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            
            Glow {
                anchors.fill: huesaturation
                radius: sliderforradiusglow.value
                spread: sliderforspread.value
                color: "red"
                source: huesaturation
            }
            
            Slider{
                visible: false
                id: sliderforradiusglow
                from: 0
                to: 10
                anchors.bottom: barforlab3.top
                anchors.bottomMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
            }
            
            Text {
                visible: false
                id: sliderforradiusglowtext
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("radius  " + sliderforradiusglow.value.toFixed(1))
                anchors.bottom: sliderforradiusglow.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            
            Slider{
                visible: false
                id: sliderforspread
                from: 0
                to: 1
                anchors.bottom: sliderforradiusglow.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left:parent.left
                anchors.leftMargin: 20
                
            }
            
            Text {
                visible: false
                id: sliderforspreadtext
                font.family: "SF UI Display"
                font.pointSize: 10
                text: qsTr("spread  " + sliderforspread.value.toFixed(1))
                anchors.bottom: sliderforspread.top
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            
            TabBar {
                id: barforlab3
                width: parent.width
                anchors.bottom: parent.bottom
                font.family: "SF UI Display Light"
                TabButton {
                    text: qsTr("RecursiveBlur")
                    onClicked: sliderforradius.visible = true,
                    textsliderforradius.visible = true,
                    sliderforloops.visible = true,
                    textsliderforloops.visible = true,
                    
                    sliderforhue.visible = false,
                    sliderforhuetext.visible = false,
                    sliderforlightness.visible = false,
                    sliderforlightnesstexxt.visible = false,
                    sliderforsaturation.visible = false,
                    sliderforsaturationtext.visible = false,
                    
                    sliderforradiusglow.visible = false,
                    sliderforradiusglowtext.visible = false,
                    sliderforspread.visible = false,
                    sliderforspreadtext.visible = false
                }
                    
                    TabButton {
                        text: qsTr("HueSaturation")
                        onClicked: sliderforradius.visible  = false,
                        textsliderforradius.visible  = false,
                        sliderforloops.visible = false,
                        textsliderforloops.visible = false,
                        
                        sliderforhue.visible = true,
                        sliderforhuetext.visible = true,
                        sliderforlightness.visible = true,
                        sliderforlightnesstexxt.visible = true,
                        sliderforsaturation.visible = true,
                        sliderforsaturationtext.visible = true,
                        
                        sliderforradiusglow.visible = false,
                        sliderforradiusglowtext.visible = false,
                        sliderforspread.visible = false,
                        sliderforspreadtext.visible = false
                        
                    }
                        TabButton {
                            text: qsTr("Glow")
                            onClicked:sliderforradius.visible  = false,
                            textsliderforradius.visible  = false,
                            sliderforloops.visible = false,
                            textsliderforloops.visible = false,
                            
                            sliderforhue.visible = false,
                            sliderforhuetext.visible = false,
                            sliderforlightness.visible = false,
                            sliderforlightnesstexxt.visible = false,
                            sliderforsaturation.visible = false,
                            sliderforsaturationtext.visible = false,
                            
                            sliderforradiusglow.visible = true,
                            sliderforradiusglowtext.visible = true,
                            sliderforspread.visible = true,
                            sliderforspreadtext.visible = true
                        }
                        }
                        }
                            