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



Page{  //СТРАНИЦА ДЛЯ ДЕВЯТОЙ ЛАБОРАТОРНОЙ - ГРАФИКИ

function update_plot(sizeLess1, sizeLess2, sizeLess3, sizeLess4, sizeLess5, sizeOver5){
    statless1.value = sizeLess1
    statless2.value = sizeLess2
    statless3.value = sizeLess3
    statless4.value = sizeLess4
    statless5.value = sizeLess5
    statover5.value = sizeOver5
}

    id: page09
    header: ToolBar {
        anchors.leftMargin: 10
        anchors.left: parent.left;
        layer.enabled: true
        Material.background: "white"
        
        Text {
            font.family: "SF UI Display Bold"
            text: "Графики"
            font.pointSize: 23
            color: "black"
            anchors.bottom: parent.bottom
        }
    }
    
    ChartView {
        id: chart
        title: "Статистика размера ваших фото"
        titleFont: Qt.font({pointSize: 13})
        anchors.fill: parent
        legend.alignment: Qt.AlignBottom
        antialiasing: true
        visible: if (labelfortoken.text != 0) true; else false
        
        PieSeries {
            id: statfileschart
            PieSlice { id:statless1; label: "1МБ" }
            PieSlice { id:statless2; label: "2МБ" }
            PieSlice { id:statless3; label: "3МБ" }
            PieSlice { id:statless4; label: "4МБ" }
            PieSlice { id:statless5; label: "5МБ" }
            PieSlice { id:statover5; label: ">5МБ" }
        }
    }
    
    Label{
        id: noaccesslab9
        font.pixelSize: 17
        font.family: "SF UI Display"
        anchors.centerIn: parent
        lineHeight: 1.5
        text: "Пожалуйста, разрешите приложению \nправа на чтение Яндекс Диска, \nчтобы мы могли вывести \nстатистику по вашим изображениям."
        visible: if (token1 != 0) false; else true
    }
}
