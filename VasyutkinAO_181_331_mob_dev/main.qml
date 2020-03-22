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

ApplicationWindow {

    signal signalMakeRequestHTTP()

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
        function onSignalSendToQML(pString){
            textAreaforHTTP.append(pString)
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

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

        Page{  //СТРАНИЦА ДЛЯ ВТОРОЙ ЛАБОРАТОРНОЙ - СЪЕМКА И ВОСПРОИЗВЕДЕНИЕ ВИДЕО
            id: page02
            header: ToolBar {
                anchors.leftMargin: 10
                anchors.left: parent.left;
                layer.enabled: true
                Material.background: "white"

                Text {
                    font.family: "SF UI Display Bold"
                    text: "Камера. Фото и видео"
                    font.pointSize: 23
                    color: "black"
                    anchors.bottom: parent.bottom
                }
            }

            RowLayout{
                id: rowforradio
                spacing: 50
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                RadioButton{
                    id: radio1
                    text: "Камера"
                    checked: true
                    onClicked: {
                        page1.visible = true
                        page2.visible = false
                    }
                }

                RadioButton{
                    id: radio2
                    text: "Фотопоток"
                    onClicked: {
                        page1.visible = false
                        page2.visible = true
                    }
                }
            }

            Item{  //СТРАНИЦА С КАМЕРОЙ
                id: page1
                width: 375
                height: 470
                anchors.horizontalCenter: parent.horizontalCenter

                Camera{
                    id: camera
                    imageCapture{
                        onImageCaptured: {
                            photoPreview.source = preview
                        }
                    }
                }

                VideoOutput{
                    id: photocam
                    source: camera  //показывает на экране во время записи
                    anchors.bottom: rowforbnt.top
                    anchors.bottomMargin: 50
                    width: 375
                    height: 200

                    Image {
                        id: photoPreview
                        height: 40
                        width: 75
                        anchors.right: parent.right

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: photoPreview.width = 375, photoPreview.height = 200
                            onDoubleClicked: photoPreview.width = 75, photoPreview.height = 40
                        }
                        }
                        }
                            RowLayout{
                                id: rowforbnt
                                spacing: 20
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.bottom

                                RoundButton{
                                    id: capturebutton
                                    Material.background: "grey"
                                    text: "C"
                                    onClicked: camera.imageCapture.capture()
                                }

                                RoundButton {
                                    id: videobutton
                                    Material.background: "red"
                                    text: "R"
                                    onClicked:
                                        if(camera.videoRecorder.StoppedState)
                                            camera.videoRecorder.record()
                                        else
                                            camera.videoRecorder.stop()
                                }
                            }
                        }

                        Item{  //страница с просмотром видео
                            id: page2
                            visible: false
                            width: 375
                            height: 667
                            anchors.horizontalCenter: parent.horizontalCenter

                            Button {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: rectangleforvideo.top
                                anchors.bottomMargin: 40
                                flat: true
                                text: "Открыть видео"
                                onClicked: fileDialog.open()

                                FileDialog {
                                    id: fileDialog
                                    folder: shortcuts.home
                                    nameFilters: [ "Music files (*.mp4 *.avi *.mkv *.mov)"]

                                }
                            }

                            Rectangle{
                                id: rectangleforvideo
                                width: 320
                                height: 240
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                MediaPlayer {
                                    id: player
                                    source: fileDialog.fileUrl
                                    autoPlay: true
                                    volume: 0
                                    loops: 5
                                }

                                VideoOutput {
                                    id: videoOutput
                                    source: player
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Slider{
                                    id:sliderforvideo
                                    anchors.topMargin: 10
                                    visible: false
                                    value: player.position
                                    to: player.duration
                                    anchors.left: parent.left
                                    anchors.top: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onPressedChanged: {
                                        player.seek(sliderforvideo.value)
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked:
                                        bntplayorstop.visible = true, sliderforvideo.visible = true, timerforguivideo.start()

                                    Button {
                                        id: bntplayorstop
                                        flat: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        icon.color: "white"
                                        icon.height: 55
                                        visible: false
                                        icon.width: 55
                                        icon.source:
                                            player.playbackState == MediaPlayer.PlayingState ? "/image/iconfinder_205_CircledPause_183322.png" : "/image/iconfinder_ic_play_circle_filled_white_48px_3669295.png"
                                        onClicked:
                                            player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play(), timerforguivideo.restart()
                                    }
                                    }

                                        Timer {
                                            id: timerforguivideo
                                            interval: 5000; running: true; repeat: true
                                            onTriggered: bntplayorstop.visible = false, sliderforvideo.visible = false
                                        }
                                        }
                                        }
                                        }

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
                                                    source: "/image/p4ZBKSVeTFY.jpg"
                                                    width: 340
                                                    height: 338
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.top: parent.top
                                                    anchors.topMargin: 35
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
                                                    from: 1
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
                                                    text: qsTr("saturation  " + sliderforradiusglow.value.toFixed(1))
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
                                                    text: qsTr("saturation  " + sliderforspread.value.toFixed(1))
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

                                                                    Button{
                                                                        id: buttonforHTTP
                                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                                        anchors.bottom: parent.bottom
                                                                        anchors.bottomMargin: 50
                                                                        onClicked: {
                                                                            signalMakeRequestHTTP()
                                                                        }
                                                                    }

                                                                    /*TextArea {
                                                //id: textAreaforHTTP
                                                width: 375
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.left:parent.left
                                                textFormat: Text.RichText
                                                //TextArea.flickable: textAreaforHTTP
                                                //wrapMode: textAreaforHTTP.Wrap
                                            }*/











                                                                    Pane {
                                                                        height: 500
                                                                        width: parent.width

                                                                        ScrollView {
                                                                            height: 500
                                                                            width: parent.width

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
                                                                                    height: 500
                                                                                    width: parent.width
                                                                                    id: textAreaforHTTP
                                                                                    Layout.fillWidth: true
                                                                                    focus: true
                                                                                    persistentSelection: true
                                                                                    selectByMouse: true
                                                                                    textMargin: 10
                                                                                    textFormat: Text.RichText
                                                                                    wrapMode: textAreaforHTTP.WrapAtWordBoundaryOrAnywhere
                                                                                }
                                                                            }
                                                                        }
                                                                    }











                                                                    TextField{
                                                                        readOnly: true
                                                                        text: "плак"
                                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                                        anchors.bottom: parent.bottom
                                                                    }
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
                                                                }
                                                            }

                                                            /* footer: TabBar {
                    id: tabBar
                    currentIndex: swipeView.currentIndex
                    font.family: "SF UI Display Light"
                    TabButton {
                        text: qsTr("Lab_1")
                    }
                    TabButton {
                        text: qsTr("Lab_2")
                    }
                    TabButton {
                        text: qsTr("Page 3")
                    }
                }*/
                                                        }
