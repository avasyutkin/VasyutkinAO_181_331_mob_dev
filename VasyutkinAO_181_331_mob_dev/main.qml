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

ApplicationWindow {

    signal signalMakeRequestHTTP()
    property string token1: ""

    id:mainWindow   //если к объекту не планиуется обращаться, то id можно не задавать, название должно начинаться с маленькой буквы
    visible: true
    width: 375
    height: 667
    title: qsTr("MainWindow")   //qsTr - функция для перключения языка строки
    Material.background: "white"
    font.capitalization: Font.MixedCase
    Material.accent: "#007DFA"

    Connections{
        target: httpController  //объект - источник сигнала, его нужно сделать видимым в QML
        function onSignalSendToQML(pString, rateString, currentratecost, currentratestate, boolforcolorlab_4, currentratedate){
            indicatorforlab4.visible = false
            linkrbk.visible = true
            linkcoinbase.visible = true
            textAreaforHTTP.append(pString)
            textfieldforrate.append(rateString)
            labelforratecostdesign.text = currentratecost
            labelforratestatedesign.text = currentratestate
            labelforboolcolorlab_4.text = boolforcolorlab_4
            labelforratedatedesign.text = currentratedate
        }

        function onSignalSendToQML_2(currentratecostrub){
            labelforratecostrubdesign.text = currentratecostrub
        }

        function onSignalSendToQML_3(sizeLess1, sizeLess2, sizeLess3, sizeLess4, sizeLess5, sizeOver5){
            page09.update_plot(sizeLess1, sizeLess2, sizeLess3, sizeLess4, sizeLess5, sizeOver5)

        }

    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page01 {
            id: page01
        }

        Page02 {
            id: page02
        }

        Page03 {
            id: page03
        }

        Page04 {
            id: page04
        }

        Page05 {
            id: page05
        }

        Page06 {
            id: page06
        }

        Page07 {
            id: page07
        }

        /*Page{  //СТРАНИЦА ДЛЯ ВОСЬМОЙ ЛАБОРАТОРНОЙ - БАЗЫ ДАННЫХ И SQL-ЗАПРОСЫ
                                                                                                id: page08
                                                                                                header: ToolBar {
                                                                                                    anchors.leftMargin: 10
                                                                                                    anchors.left: parent.left;
                                                                                                    layer.enabled: true
                                                                                                    Material.background: "white"

                                                                                                    Text {
                                                                                                        font.family: "SF UI Display Bold"
                                                                                                        text: "БД и SQL-запросы"
                                                                                                        font.pointSize: 23
                                                                                                        color: "black"
                                                                                                        anchors.bottom: parent.bottom
                                                                                                    }
                                                                                                }

                                                                                                Button {
                                                                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                                                                    anchors.top: chipheronlab7.bottom
                                                                                                    anchors.topMargin: 30
                                                                                                    text: "Получить доступ"
                                                                                                    font.family: "SF UI Display Light"
                                                                                                    font.pixelSize: 15
                                                                                                    flat: true
                                                                                                }
                                                                                            }*/

        Page09 {
            id: page09
        }

        Page10 {
            id: page10
        }
    }

    Drawer{
        id: drawer
        width: 0.80 * parent.width
        height: parent.height
        dragMargin: 10 * Screen.pixelDensity
        GridLayout{
            width: parent.width
            columns: 1
            Button{
                text: "Элементы GUI"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 0
                    drawer.close()
                }
            }

            Button{
                text: "Камера. Фото и видео"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 1
                    drawer.close()
                }
            }
            Button{
                text: "Графические эффекты"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 2
                    drawer.close()
                }
            }

            Button{
                text: "HTTP запросы"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 3
                    drawer.close()
                }
            }

            Button{
                text: "Аутентификация OAuth2"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 4
                    drawer.close()
                }
            }

            Button{
                text: "REST API"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 5
                    drawer.close()
                }
            }

            Button{
                text: "Шифрование"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 6
                    drawer.close()
                }
            }

            /*Button{
                                                                                                    text: "БД и SQL-запросы"
                                                                                                    flat: true
                                                                                                    onClicked: {
                                                                                                        swipeView.currentIndex = 7
                                                                                                        drawer.close()
                                                                                                    }
                                                                                                }*/

            Button{
                text: "Графики"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 7
                    drawer.close()
                }
            }

            Button{
                text: "Чат бот"
                flat: true
                onClicked: {
                    swipeView.currentIndex = 8
                    drawer.close()
                }
            }
        }
    }
}
