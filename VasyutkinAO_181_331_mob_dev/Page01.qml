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

Page{  //СТРАНИЦА ДЛЯ ПЕРВОЙ ЛАБОРАТОРНОЙ - ЭЛЕМЕНТЫ GUI
    id: page01
    scale: 1
    header: ToolBar {
        id: toolbar
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        Text {
            font.family: "SF UI Display Bold"
            text: "Элементы GUI"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
            
            
        }
    }
    
    Rectangle{
        id: frameforyandex
        anchors.fill: parent
        border.color: "#f9cf47"
        border.width: 3
        radius: 7
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#f9cf47" }
            GradientStop { position: 0.6; color: "white" }
        }
        
        BusyIndicator {
            id: busyindicator
            scale: 0.5
            anchors.leftMargin: 10
            anchors.topMargin: 20
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            layer.enabled: true
            running: image.status === Image.Loading
            Material.accent: "#f9cf47"
        }
        
        Image{
            id: logoyandex
            source: "/image/1200px-Яндекс.svg.png"
            width: 105
            height: 58
            anchors.leftMargin: 10
            anchors.top: busyindicator.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Rectangle{
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.top: logoyandex.bottom
            anchors.left: parent.left
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: {
                if(textarea.activeFocus)
                    0
                else
                    2
            }
            
            border.color: "#f9cf47"
            width: 100
            height: 36
            radius: 1
            
            TextArea {
                id: textarea
                color: "#000"
                wrapMode: Text.WrapAnywhere
                placeholderText: qsTr("Найдется всё!")
                placeholderTextColor: "#99999b"
                font.family: "SF UI Text Regular"
                font.pointSize: 12
                Material.accent: "#f9cf47"
                anchors.leftMargin: 10
                anchors.left: parent.left
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        
        Dial {
            id: dial
            to: 100
            anchors.leftMargin: 10
            anchors.topMargin: 50
            anchors.top: slider.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn: parent
            value: slider.value
            Material.accent: "#f9cf47"
        }
        
        Slider {
            id:slider
            value: dial.value
            from: 1
            to: 100
            anchors.top: dial.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.left: parent.left
            Material.accent: "#f9cf47"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        ColumnLayout {
            anchors.leftMargin: 10
            anchors.topMargin: 50
            anchors.top: slider.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Material.accent: "#ff0000"
            
            Switch {
                text: qsTr("Включить VPN")
                Material.foreground: "#000"
                font.family: "SF UI Text Regular"
            }
        }
        
        Text {
            text: "© Moscow Polytech"
            font.family: "SF UI Text Regular"
            font.pointSize: 10
            color: "#000"
            anchors.leftMargin: 10
            anchors.bottomMargin: 20
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
