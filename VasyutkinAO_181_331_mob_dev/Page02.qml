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
        height: 40
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
    
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowforradio.bottom
        anchors.bottom: parent.bottom
        anchors.verticalCenter: parent.verticalCenter
        border.color: "#2E3F7F"
        border.width: 3
        radius: 7
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#094A6F" }
            GradientStop { position: 0.6; color: "#64C8BD" }
        }
        
        Item{  //СТРАНИЦА С КАМЕРОЙ
            id: page1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rowforradio.bottom
            anchors.bottom: parent.bottom
            anchors.verticalCenter: parent.verticalCenter
            
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
                anchors.left: page1.left
                anchors.right: page1.right
                anchors.top: rowforradio.bottom
                anchors.bottom: page1.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                
                Image {
                    id: photoPreview
                    height: 40
                    width: 75
                    anchors.right: parent.right
                    
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: photoPreview.width = 355, photoPreview.height = 190
                        onDoubleClicked: photoPreview.width = 75, photoPreview.height = 40
                    }
                    }
                    }
                        RowLayout{
                            id: rowforbnt
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: photocam.bottom
                            anchors.bottomMargin: 50
                            
                            RoundButton{
                                id: capturebutton
                                Material.background: "grey"
                                text: "C"
                                onClicked: camera.imageCapture.captureToLocation("C:\Intel")
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
                }
                
                Item{  //страница с просмотром видео
                    id: page2
                    visible: false
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: rowforradio.bottom
                    anchors.bottom: parent.bottom
                    
                    Button {
                        id: btnfordialoglab2
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 15
                        anchors.top: page2.top
                        anchors.topMargin: 20
                        anchors.leftMargin: 10
                        Material.foreground: "white"
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
                        anchors.left: page2.left
                        anchors.right: page2.right
                        anchors.top: btnfordialoglab2.bottom
                        anchors.bottom: page2.bottom
                        anchors.leftMargin: 3
                        anchors.rightMargin: 3
                        radius: 7
                        gradient: Gradient {
                            GradientStop { position: 1.0; color: "#094A6F" }
                            GradientStop { position: 0.6; color: "#64C8BD" }
                        }
                        
                        MediaPlayer {
                            id: player
                            source: if (fileDialog.fileUrl == 0) "/video/sample (1).avi"; else fileDialog.fileUrl
                            autoPlay: true
                            volume: 0
                            loops: 5
                        }
                        
                        VideoOutput {
                            id: videoOutput
                            source: player
                            anchors.left: rectangleforvideo.left
                            anchors.right: rectangleforvideo.right
                            anchors.top: btnfordialoglab2.bottom
                            anchors.bottom: sliderforvideo.bottom
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            anchors.bottomMargin: 45
                            anchors.verticalCenter: rectangleforvideo.verticalCenter
                        }
                        
                        Slider{
                            id:sliderforvideo
                            visible: false
                            value: player.position
                            to: player.duration
                            anchors.left: videoOutput.left
                            anchors.bottom: rectangleforvideo.bottom
                            anchors.bottomMargin: 20
                            anchors.horizontalCenter: videoOutput.horizontalCenter
                            onPressedChanged: {
                                player.seek(sliderforvideo.value)
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: videoOutput
                            id: areaforvideolab2
                            onClicked:
                                bntplayorstop.visible = true, sliderforvideo.visible = true, timerforguivideo.start()
                            
                            Button {
                                id: bntplayorstop
                                flat: true
                                anchors.horizontalCenter: areaforvideolab2.horizontalCenter
                                anchors.verticalCenter: areaforvideolab2.verticalCenter
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
                                    