#include "qhttpcontroller.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>
#include <QEventLoop>
#include <QBitArray>
#include <string>
#include <iostream>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <string.h>


QHTTPController::QHTTPController(QObject *parent) : QObject(parent)
{
    nam = new QNetworkAccessManager();
}

void QHTTPController::GetNetworkValue()
{
    QNetworkRequest request;
    request.setUrl(QUrl("https://www.rbc.ru/crypto/currency/btcusd"));
    QNetworkReply * reply;
    QEventLoop eventloop;
    connect(nam, &QNetworkAccessManager::finished, &eventloop, &QEventLoop::quit);
    reply = nam -> get(request);
    //обработка reply
    eventloop.exec(); //запуск цикла ожидания. Приложение обрабатывает остальные сигналы, пока не поступит сигнал QEventLoop::quit
    QByteArray replyString = reply -> readAll();
    emit signalSendToQML(QString(replyString), slotPageInfo(replyString), currentratecost(replyString), currentratestate(replyString), boolforcolorlab_4(replyString), currentratedate(replyString));
    qDebug() << reply -> url()
             << reply -> rawHeaderList()
             << reply -> readAll();
}

void QHTTPController::GetNetworkValue_2()
{
    QNetworkRequest request;
    request.setUrl(QUrl("https://api.coinbase.com/v2/prices/spot?currency=RUB"));
    QNetworkReply * reply;
    QEventLoop eventloop;
    connect(nam, &QNetworkAccessManager::finished, &eventloop, &QEventLoop::quit);
    reply = nam -> get(request);
    eventloop.exec();
    QByteArray replyString = reply -> readAll();
    emit signalSendToQML_2(currentratecostrub(replyString));
    qDebug() << reply -> url()
             << reply -> rawHeaderList()
             << reply -> readAll();
}

QString QHTTPController::slotPageInfo(QString replyString)
{
    int a = replyString.indexOf("<div class=\"chart__subtitle js-chart-value\">");
    int b = replyString.indexOf("<span class=\"chart__change");
    int c = b - a;
    int d = replyString.indexOf("<span class=\"chart__change");
    int e = replyString.indexOf("<div class=\"chart__description\">");
    int f = e - d;
    QString currentrateall = replyString.mid(a, c) + " USD" + replyString.mid(d, f);
    qDebug() << a << b << c << d << e << f << currentrateall;
    return currentrateall;
}

QString QHTTPController::currentratecost(QString replyString)
{
    int a = replyString.indexOf("<div class=\"chart__subtitle js-chart-value\">");
    int b = replyString.indexOf("<span class=\"chart__change");
    int c = b - a;
    QString currentratecost = replyString.mid(a, c) + " $";
    return currentratecost;
}

bool QHTTPController::boolforcolorlab_4(QString replyString)
{
    int a = replyString.indexOf("<span class=\"chart__change");
    int b = replyString.indexOf("<div class=\"chart__description\">");
    int c = b - a;
    QString currentratestate = replyString.mid(a, c);
    std::string strforcolor = currentratestate.toLocal8Bit().constData();

    char char_array[155];
    strcpy_s(char_array, strforcolor.c_str());
    qDebug( )  <<char_array[60];

    bool boolforcolor = 1;
    if (char_array[60] == '-')
        boolforcolor = 0;
    else if (char_array[60] == '+')
        boolforcolor = 1;

    return boolforcolor;
}

QString QHTTPController::currentratestate(QString replyString)
{
    int a = replyString.indexOf("<span class=\"chart__change");
    int b = replyString.indexOf("<div class=\"chart__description\">");
    int c = b - a;
    QString currentratestate = replyString.mid(a, c);
    return currentratestate;
}

QString QHTTPController::currentratedate(QString replyString)
{
    int a = replyString.indexOf("<span class=\"js-chart-date\">") + 28;
    int b = replyString.indexOf("</span>\n            </div>\n            </div>\n    <div class=\"chart__peroids\">");
    int c = b - a;
    QString date = replyString.mid(a, c);
    return date;
}

QString QHTTPController::currentratecostrub(QByteArray replyString)
{
    QJsonDocument jsonfromcoingate = QJsonDocument::fromJson(replyString);
    QString amountrateforruble = jsonfromcoingate.object().value("data").toObject().value("amount").toString();

    amountrateforruble.insert(3, QString(" ")).remove(7,1).insert(7, QString(",")).remove(10, 4).insert(10, QString(" ₽"));

    qDebug ()<< "В рублях" << jsonfromcoingate << amountrateforruble;
    return amountrateforruble;
}
