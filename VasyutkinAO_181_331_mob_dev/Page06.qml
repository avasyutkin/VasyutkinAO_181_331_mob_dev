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

Page{  //СТРАНИЦА ДЛЯ ШЕСТОЙ ЛАБОРАТОРНОЙ - REST API
    id: page06
    header: ToolBar {
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "REST API"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    


    /*ListView{
        model: fileModel
        id: listrest
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: rowforrest.top
        anchors.bottomMargin: 50
        spacing: 10
        anchors.topMargin: 25
        
        delegate: Rectangle{
            height: Screen.pixelDensity * 20
            width: listrest.width
            
            GridLayout{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: rowforrest.top
                
                Image {
                    id: imageforrest
                    source: preview
                    sourceSize.width: 100
                    sourceSize.height: 100
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                
                Label{
                    id: nameforrest
                    text: name
                    font.pixelSize: 20
                    anchors.top: imageforrest.top
                    anchors.left: imageforrest.right
                    anchors.leftMargin: 10
                    font.family: "SF UI Display Bold"
                    font.pointSize: 18
                }
                
                Label{
                    id: sizeforrest
                    text: size + " бит"
                    font.pixelSize: 13
                    font.family: "SF UI Display"
                    anchors.left: imageforrest.right
                    anchors.leftMargin: 10
                    anchors.top: nameforrest.bottom
                    anchors.topMargin: 5
                }
                
                Label{
                    id: createdforrest
                    text: "Дата зарузки: " + created
                    font.pixelSize: 13
                    font.family: "SF UI Display"
                    anchors.left: sizeforrest.right
                    anchors.leftMargin: 10
                    anchors.top: nameforrest.bottom
                    anchors.topMargin: 5
                }
            }
        }
    }*/
    
    GridView{
        model: fileModel
        id: gridrest
        visible: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: rowforrest.top
        anchors.bottomMargin: 120
        anchors.topMargin: 30
        anchors.leftMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: 180
        cellHeight: 180
        
        delegate: Column {
            Image {
                source: preview
                sourceSize.width: 150
                sourceSize.height: 150
            }
            
            Label{
                text: name
                font.pixelSize: 17
            }
            
            Label{
                text: size + " байт"
                font.pixelSize: 13
                font.family: "SF UI Display"
            }
            
            Label{
                text: "Дата зарузки: " + created
                font.pixelSize: 13
                font.family: "SF UI Display"
            }
        }
    }
    
    Label{
        id: noaccesslab6
        font.pixelSize: 17
        font.family: "SF UI Display"
        anchors.centerIn: parent
        lineHeight: 1.5
        text: "Пожалуйста, разрешите приложению \nправа на чтение Яндекс Диска, \nчтобы мы могли вывести \nактуальный список фото."
        visible: if (fileModel.rowCount() > 0) false; else true
    }
    
    RowLayout{
        id: rowforrest
        spacing: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        height: 40
        Material.background: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        
        Button {
            id: btnforspisok
            flat: true
            text: "Cписок"
            height: 150
            width: 150
            onClicked: if (fileModel.rowCount() > 0) gridrest.visible = false, listrest.visible = true, noaccesslab6.visible = false; else noaccesslab6.visible = true
        }
            
            Button {
                id: btnforplitki
                flat: true
                text: "Плитки"
                height: 150
                width: 150
                onClicked: if (fileModel.rowCount() > 0) gridrest.visible = true, listrest.visible = false, noaccesslab6.visible = false; else noaccesslab6.visible = true
            }
                
                Button {
                    id: btnforreload
                    flat: true
                    text: "Обновить"
                    height: 150
                    width: 150
                    onClicked: if (token1 != 0) listrest.visible = true, gridrest.visible = false, noaccesslab6.visible = false, httpController.requestReceivingAPI(token1); else noaccesslab6.visible = true, listrest.visible = false, gridrest.visible = false
                }
                }
                }
                    
