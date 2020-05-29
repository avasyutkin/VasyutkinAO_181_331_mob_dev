#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "qhttpcontroller.h"
#include "cryptocontroller.h"
#include <QQmlContext>
#include "modelfromyandexdisk.h"

int main(int argc, char *argv[])
{
    //вызов независимой функции в составе класса QCoreApplication
    //без создания экземпляра класса (объекта)
    //просто настройка масштабирования экрана
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);   //отвечает за базовые свойства объектов (просто консолька)

    QGuiApplication app(argc, argv);   //добавляет графические функции к приложению и позволяет работать с графикой (базовое приложение с графической областью)

    QHTTPController httpController;
    httpController.GetNetworkValue();
    httpController.GetNetworkValue_2();

    ModelfromYandexDisk filemodel;

    CryptoController cryptoController;

    QQmlApplicationEngine engine;   //создание браузерного движка

    QQmlContext * context = engine.rootContext();  //дерево объектов в QML движке
    context -> setContextProperty("httpController", &httpController); //приводим в соответствие имя сишному объекту - поместить С++ объект в область видимости QML
    context -> setContextProperty("cryptoController", &cryptoController);
    context -> setContextProperty("fileModel", &httpController.fileModel);

    const QUrl url(QStringLiteral("qrc:/main.qml"));   //преобразование пути стартовой страницы из char в QURL
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,   //подключение слота, срабатывающего по сигналу objectCreated
                     &app, [url](QObject *obj, const QUrl &objUrl) {   //заголовок лямбда-выражения вместо отдельного слота, далее идет тело
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);   //загрузка стартовой страницы с адресом URL

    QObject * mainWindow = engine.rootObjects().first();
    QObject::connect(mainWindow, SIGNAL(signalMakeRequestHTTP()), &httpController, SLOT(GetNetworkValue()));
    QObject::connect(mainWindow, SIGNAL(signalMakeRequestHTTP()), &httpController, SLOT(GetNetworkValue_2()));

    return app.exec();   //запуск бесконечного цикла обработки сообщений и слотов/сигналов
    setlocale(LC_ALL, "ru");
}
