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

Page{  //СТРАНИЦА ДЛЯ ЧЕТВЕРТОЙ ЛАБОРАТОРНОЙ - HTTP-ЗАПРОСЫ
    id: page04
    header: ToolBar {
        id: headerforhttp
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "HTTP запросы"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    Item {
        id: itemforverygooddesignlab4
        anchors.fill: parent
        
        Image {
            anchors.fill: parent
            source: "/image/bg_lab4.JPG"
        }
        
        Label { id:labelamountlab_4; text: "Цена Bitcoin"; font.pixelSize: 33; color: "#222222"; font.family: "SF UI Display"; anchors.left: parent.left; anchors.leftMargin: 10; anchors.top: parent.top; anchors.topMargin: 35}
        
        GridLayout {
            id: gridforlab4
            anchors.top: labelamountlab_4.bottom
            columns: 2
            width: parent.width
            Label { id: labelforratecostrubdesign;  font.pixelSize: 45;  font.family: "SF UI Display Light"; color: "#222222"; anchors.left: parent.left; anchors.leftMargin: 10; anchors.top: parent.top; anchors.topMargin: 20 }
            Label { }
            Label { id: linkcoinbase; text: "coinbase.com"; visible: false; font.family: "SF UI Display Light"; color: "#9c9c9c"; anchors.top: labelforratecostrubdesign.bottom; anchors.topMargin: -3; anchors.left: parent.left; anchors.leftMargin: 10; }
            Label { }
            Label { id: labelforratecostdesign; font.pixelSize: 35;  font.family: "SF UI Display Bold"; color: "#222222"; anchors.left: parent.left; anchors.leftMargin: 10; anchors.top: linkcoinbase.bottom; anchors.topMargin: 20; }
            Label { id: labelforratestatedesign; font.pixelSize: 21; font.family: "SF UI Display"; color: if (labelforboolcolorlab_4.text == "true") "#20b984"; else "#ff4545"; anchors.top: linkcoinbase.bottom; anchors.topMargin: 33; anchors.left: labelforratecostdesign.right; anchors.leftMargin: 6 }
            Label { id: linkrbk; text: "rbc.ru"; visible: false; font.family: "SF UI Display Light"; color: "#9c9c9c"; anchors.top: labelforratecostdesign.bottom; anchors.topMargin: 0; anchors.left: parent.left; anchors.leftMargin: 10 }
            Label { }
            Label { id: labelforratedatedesign; color: "#888888"; font.family: "SF UI Display"; font.pixelSize: 15; anchors.left: parent.left; anchors.leftMargin: 10; anchors.top: linkrbk.bottom; anchors.topMargin: 15; }
            Label { id: labelforboolcolorlab_4; color: "white" }
        }
    }
    
    Button {
        id: buttonforHTTP
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Learn the rate of BTC"
        font.family: "SF UI Display Light"
        font.pixelSize: 20
        anchors.bottomMargin: 110
        flat: true
        onClicked: {
            labelforratecostdesign.text = " ", labelforratestatedesign.text = " ", labelforratecostrubdesign.text = " ", labelforratedatedesign.text = " ", linkrbk.visible = false, linkcoinbase.visible = false, indicatorforlab4.visible = true, signalMakeRequestHTTP(), itemforbaddesignlab4.visible = false, itemforverygooddesignlab4.visible = true
        }
    }
    
    DelayButton {
        id: delaybtntobaddesignlab4
        delay: 800
        background:
            Rectangle {
            width: parent.width
        }
        
        Material.foreground: "#9c9c9c"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "long click on me"
        font.family: "SF UI Display Light"
        font.pixelSize: 15
        anchors.bottomMargin: 60
        onActivated:
            itemforbaddesignlab4.visible = true, itemforverygooddesignlab4.visible = false, indicatorforlab4.visible = true, delaybtntobaddesignlab4.visible = false, buttonforHTTP.visible = false, labelforratecostdesign.text = " ", labelforratestatedesign.text = " ", labelforratecostrubdesign.text = " ", labelforratedatedesign.text = " ", textAreaforHTTP.text = " ", textfieldforrate.text = "", linkrbk.visible = false, linkcoinbase.visible = false, signalMakeRequestHTTP()
    }
        
        BusyIndicator {
            visible: false
            id: indicatorforlab4
            scale: 0.5
            anchors.leftMargin: 10
            anchors.topMargin: 200
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            layer.enabled: true
            running: image.status === Image.Loading
            Material.accent: "#1850f1"
        }
        
        Item {
            id: itemforbaddesignlab4
            visible: false
            anchors.fill: parent
            
            ScrollView {
                id: scrollforbaddesignlab4
                height: 500
                width: parent.width
                anchors.bottom: rectanglefortextandbntlab4.top
                anchors.bottomMargin: -1
                
                RowLayout {
                    spacing: 0
                    width: parent.parent.width
                    
                    ColumnLayout {
                        id: lineNumbers
                        
                        Repeater {
                            id: lineNumberRepeater
                            model: textAreaforHTTP.lineCount
                            Layout.fillHeight: true
                        }
                    }
                    
                    TextArea {
                        width: parent.width
                        height: 500
                        id: textAreaforHTTP
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        focus: true
                        persistentSelection: true
                        selectByMouse: true
                        textMargin: 10
                        textFormat: Text.PlainText
                        //wrapMode: textAreaforHTTP.WrapAtWordBoundaryOrAnywhere
                    }
                }
            }
            
            Rectangle {
                id: rectanglefortextandbntlab4
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 109
                anchors.bottom: parent.bottom
                color: "white"
                
                TextArea {
                    id: textfieldforrate
                    readOnly: true
                    placeholderText: qsTr("BTC")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    activeFocusOnPress: false
                    horizontalAlignment: TextInput.AlignHCenter
                    textFormat: Text.RichText
                    wrapMode: textfieldforrate.WrapAtWordBoundaryOrAnywhere
                }
                
                Button {
                    id: buttontovernutsatonormdesign
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    text: "Назад"
                    font.family: "SF UI Display Light"
                    font.pixelSize: 15
                    anchors.bottomMargin: 50
                    flat: true
                    onClicked: {
                        itemforbaddesignlab4.visible = false, itemforverygooddesignlab4.visible = true, indicatorforlab4.visible = true, delaybtntobaddesignlab4.visible = true, buttonforHTTP.visible = true, labelforratecostdesign.text = " ", labelforratestatedesign.text = " ", labelforratecostrubdesign.text = " ", labelforratedatedesign.text = " ", textAreaforHTTP.text = " ", textfieldforrate.text = "", linkrbk.visible = false, linkcoinbase.visible = false, signalMakeRequestHTTP()
                    }
                }
            }
        }
    }
    