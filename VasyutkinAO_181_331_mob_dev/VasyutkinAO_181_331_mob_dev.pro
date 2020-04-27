QT += quick network   #список подключенных разделов библиотеки QT

CONFIG += c++11   #настройки компиляции

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS   #объявление переменных и флагов окружения

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \   #раздел файлов исходного кода на С++ (здесь прописаны все файлы из дерева файлов)
        crypto_controller.cpp \
        main.cpp \
        qhttpcontroller.cpp


#HEADERS - раздел файлов заголовков С++

RESOURCES += qml.qrc   #список файлов, включаемых в раздел ресурсов получаемого исполняемого модуля (exe, apk)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =


#синтаксис "название платформы:" - последующие комады сборки будут работать только на обозначенной платформе
# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += \
            C:\Qt\Tools\OpenSSL\Win_x64\include\openssl

LIBS += \
         C:\Qt\Tools\OpenSSL\Win_x64\lib\libcrypto.lib

DISTFILES += \
    ../../films/Kriminal'noe.mkv \
    ../../films/Kriminal'noe.mkv

HEADERS += \
    crypto_controller.h \
    qhttpcontroller.h

QMAKE_EXTRA_TARGETS += before_build makefilehook

makefilehook.target = $(MAKEFILE)
makefilehook.depends = .beforebuild

PRE_TARGETDEPS += .beforebuild

before_build.target = .beforebuild
before_build.depends = FORCE
before_build.commands = chcp 1251
