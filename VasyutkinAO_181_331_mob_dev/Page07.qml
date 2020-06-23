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

Page{  //СТРАНИЦА ДЛЯ СЕДЬМОЙ ЛАБОРАТОРНОЙ - ШИФРОВАНИЕ
    id: page07
    header: ToolBar {
        
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "Шифрование"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    Label{
        text: "Введите ключ шифрования (32 символа)"
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "SF UI Display Light"
        font.pixelSize: 19
        anchors.bottom: textforkey.top
        anchors.bottomMargin: 60
    }
    
    TextField{
        id: textforkey
        placeholderText: qsTr("Вставьте ключ сюда")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: chipheronlab7.top
        horizontalAlignment: TextInput.AlignHCenter
        width: 330
        font.family: "SF UI Display Light"
        font.pixelSize: 17
        anchors.bottomMargin: 40
        maximumLength: 32
    }
    
    Button{
        id: chipheronlab7
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Шифровать данные"
        font.family: "SF UI Display Light"
        font.pixelSize: 22
        anchors.bottomMargin: 120
        flat: true
        visible: if(fileDialoglab7.fileUrl == 0) false; else true
        onClicked: cryptoController.do_crypt(textforkey.text, 1)
    }
    
    Button{
        id: chipherofflab7
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: chipheronlab7.bottom
        anchors.topMargin: 30
        text: "Получить доступ"
        font.family: "SF UI Display Light"
        font.pixelSize: 15
        flat: true
        visible: if(fileDialoglab7.fileUrl == 0) false; else true
        onClicked: cryptoController.do_crypt(textforkey.text, 0);
    }
    
    Button {
        id: btnfordialoglab7
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 15
        anchors.bottom: textforkey.top
        anchors.bottomMargin: 100
        anchors.leftMargin: 10
        flat: true
        text: "Выбрать файл"
        onClicked: fileDialoglab7.open()
        
        FileDialog {
            id: fileDialoglab7
            folder: shortcuts.home
            onAccepted: cryptoController.get_name_file(fileDialoglab7.fileUrls);
        }
    }
}
