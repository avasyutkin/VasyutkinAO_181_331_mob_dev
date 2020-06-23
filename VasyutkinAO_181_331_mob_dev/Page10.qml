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

Page{  //СТРАНИЦА ДЛЯ ДЕCЯТОЙ ЛАБОРАТОРНОЙ - ПРОСТЕЙШИЙ ЧАТ НА WEBSOCKET
    id: page10
    header: ToolBar {
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "Чат бот"
            anchors.leftMargin: 10
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    ListModel{
        id: modellab10
    }
    
    Rectangle{
        color: "#D4DADE"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: rectanlesend.top
        width: parent.width
        height: parent.height*0.85
        
        ListView{
            anchors.fill: parent
            anchors.bottomMargin: 70
            anchors.topMargin: 10
            spacing: 4
            model: modellab10
            delegate:
                
                Item{
                width: parent.width
                height: borderimagelab10.height
                
                BorderImage {
                    id: borderimagelab10
                    source: outmessage ? "image/mymessage.png" : "image/servermessage.png"
                    width: parent.width *0.8
                    height: textmessage.contentHeight + 25
                    anchors.left: outmessage ? undefined : parent.left
                    anchors.right: outmessage ? parent.right : undefined
                    
                    Text {
                        id: textmessage
                        color: "white"
                        text: message
                        width: borderimagelab10.width*0.8
                        font.pointSize: 12
                        font.family: "SF UI Display"
                        anchors.top: borderimagelab10.top
                        anchors.left: borderimagelab10.left
                        anchors.leftMargin: 6
                        anchors.topMargin: 6
                        wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                    }
                    
                    Text {
                        id: textfortimelab10
                        color: "#D1D3D4"
                        text: Qt.formatDateTime(new Date(), "hh:mm — dd.MM.yyyy")
                        font.family: "SF UI Display"
                        font.pointSize: 8
                        anchors.bottom: borderimagelab10.bottom
                        anchors.right: borderimagelab10.right
                        anchors.rightMargin: outmessage ? 6:6
                        anchors.bottomMargin: 5
                    }
                }
            }
        }
    }
    
    Rectangle{
        id: rectanlesend
        color: "#cbd0d3"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height*0.1
        
        RowLayout {
            anchors.bottom: parent.bottom
            width: parent.width
            
            Rectangle {
                anchors.fill: parent
                color: "#cbd0d3"
            }
            
            TextArea {
                id: areawritelab10
                Layout.fillWidth: true
                Layout.margins: 5
                font.family: "SF UI Display"
                font.pointSize: 12
                color: "#333333"
                placeholderTextColor: "#999999"
                placeholderText: "Сообщение"
                wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                background:

                    Item {
                    width: parent.width
                    height: parent.height

                    Rectangle {
                        color: "#4a76a8"
                        height: 1
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }
                }
            }
            
            RoundButton {
                Material.background: "#0351C1"
                text: "🡅"
                onClicked: {
                    if(areawritelab10.text!=""){
                        modellab10.append({
                                              "outmessage": true,
                                              "message": areawritelab10.text,
                                              "date" : new Date().toLocaleString(Qt.locale("ru_RU"))
                                          });
                        websocket.sendTextMessage(areawritelab10.text);
                        areawritelab10.clear();
                    }
                }
            }
        }
    }
    
    WebSocket{
        id: websocket
        active: true
        url: "ws://localhost:8765"
        onTextMessageReceived: {
            console.log("message: ", message);
            modellab10.append(
                        {
                            "outmessage" : false,
                            "message" : message,
                            "date" : new Date().toLocaleString(Qt.locale("ru_RU"))
                        });
        }
        onStatusChanged: {
            switch(status)
            {
            case WebSocket.Connecting:
                console.log("Socket is connecting");
                break;
            case WebSocket.Open:
                console.log("Socket is open");
                break;
            case WebSocket.Closing:
                console.log("Socket is closing");
                break;
            case WebSocket.Closed:
                console.log("Socket is closed");
                break;
            case WebSocket.Error:
                console.log("Socket is error");
                console.log("Error = ", errorString);
                break;
            }
        }
    }
}
