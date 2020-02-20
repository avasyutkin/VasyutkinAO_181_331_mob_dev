import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id:mainWindow   //если к объекту не планиуется обращаться, то id можно не задавать, название должно начинаться с маленькой буквы
    visible: true
    width: 480
    height: 640
    title: qsTr("MainWindow")   //qsTr - функция для перключения языка строки

    header: ToolBar {

        ToolButton{
            text: "PLHFCN"
        }

        Material.background: "WHITE"
        font.pointSize: 20
    }


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        /*Page {
            Button {
                id: button1
                text: "Button"
                font.family: ""
                font.bold: true
                font.pixelSize: 30
                font.italic: true

            }

            Button {   //страница демонстрации anchor
                text: "Button"
                anchors.right: parent.right
                anchors.left: button1.right
                anchors.margins: 10
                anchors.top: button1.bottom
                font.pixelSize: 30
            }

            Button {
                text: "Button"
                width: 100
                height: 100
                anchors.centerIn: parent
                font.pixelSize: 30
            }

        }

        Page {   //страница демонстрации layout

            GridLayout {
            anchors.fill: parent   //привязываем по всем фронтам
            columns: 3

            Button {
                id: button2
                text: "Button"
                font.family: ""
                font.bold: true
                font.pixelSize: 30
                font.italic: true

            }

            Button {
                text: "Button"
                anchors.right: parent.right
                anchors.left: button1.right
                anchors.margins: 10
                anchors.top: button1.bottom
                font.pixelSize: 30
            }

            Button {
                text: "Button"
                width: 100
                height: 100
                font.pixelSize: 30
                Layout.row: 2   //напрямую объявляем для кнопки строку
                Layout.column: 2   //напрямую объявляем для кнопки столбец
                Layout.preferredHeight: 200   //настраиваем предпочтительную высоту
                Layout.preferredWidth: 200   //настраиваем предпочтительную ширину
            }

            }
            //anchors запрещены
        }*/
        Page{
            Button {
                id: button1
                text: "Button"
                font.family: "SF"
                font.pixelSize: 15
            }
        }

        Page{

        }

        Page{


        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Page 1")

        }
        TabButton {
            text: qsTr("Page 2")
        }
        TabButton {
            text: qsTr("Page 3")
        }
    }
}
