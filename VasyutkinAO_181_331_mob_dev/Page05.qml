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

Page{  //СТРАНИЦА ДЛЯ ПЯТОЙ ЛАБОРАТОРНОЙ - АУТЕНТИФИКАЦИЯ OAUTH2
    id: page05
    header: ToolBar {
        id: headerOAuth2
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "OAuth2"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    WebView {
        id: browserlab5
        anchors.fill: parent
        
        onLoadingChanged: {
            console.info(browserlab5.url + " current url")
            var token = httpController.auth(browserlab5.url)
            var tokenbool = httpController.authbool(browserlab5.url)
            
            browserlab5.visible = token === " " ? true : false;
            btngettoken.visible = token === " " ? false : true;
            labelfortoken.text = token
            token1 = token
            labelfortoken.color = tokenbool === true ? "black" : "#FF0000"
            labelsucsesslab5.visible = tokenbool === true ? true : false
            //console.info(token + " token    " + tokenbool)
            var gfdfgdfgf = httpController.requestReceivingAPI(token)
            //labelfortoken.text = gfdfgdfgf
        }
    }
    
    Label {
        id: labelfortoken
        anchors.bottom: btngettoken.top
        anchors.bottomMargin: 170
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "SF UI Display"
        font.pixelSize: 16
    }
    
    Label {
        id: labelsucsesslab5
        anchors.bottom: btngettoken.top
        anchors.bottomMargin: 250
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "SF UI Display"
        font.pixelSize: 21
        text: "Успешно! Ваш токен:"
        color: "#77BD8B"
    }
    
    Label {
        id: labelnosucsesslab5
        visible: true
        anchors.bottom: btngettoken.top
        anchors.bottomMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "SF UI Display"
        font.pixelSize: 21
        text: "Чтобы получить доступ \nк вашм фото на Яндекс Диске, \nвойдите в аккаунт."
    }
    
    Button {
        id:btngettoken
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Получить токен"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 130
        font.family: "SF UI Display Light"
        font.pixelSize: 21

        
        onClicked: {
            browserlab5.url = "https://oauth.yandex.ru/authorize?response_type=token"
                    +"&client_id=b90874f5afbc41c5a675b31f708dc772"
                    +"&device_id=123456546546"
                    +"&device_name=phone"
                    +"&redirect_uri=https://oauth.yandex.ru/verification_code"
                    +"&force_confirm=yes"
                    +"&state=get_token"
                    +"&display=popup",
            labelnosucsesslab5.visible = false
        }
    }
}
