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
#include <QNetworkAccessManager>
#include <string.h>
#include <QHttpMultiPart>


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

    amountrateforruble.insert(3, QString(" ")).remove(7,1).insert(7, QString(",")).remove(10, 10).insert(10, QString(" ₽"));

    qDebug ()<< "В рублях" << jsonfromcoingate << amountrateforruble;
    return amountrateforruble;
}

QString QHTTPController::auth(QString urlforauth)
{
    qDebug() << urlforauth << "выполнено oauth";
    if (urlforauth.contains("token_type=bearer&expires_in=") == true)
    {
        int a = urlforauth.indexOf("access_token=") + 13;
        int b = urlforauth.indexOf("&token_type");
        int c = b - a;
        urlforauth = urlforauth.mid(a, c);



        //requestReceivingAPI(urlforauth);



        return urlforauth;
    }

    else if (urlforauth.contains("&error=access_denied&") == true)
    {
        return "Не удалось получить токен";
    }

    QString text = " ";
    return text;
}

bool QHTTPController::authbool(QString urlforauth)
{
    qDebug() << urlforauth << "выполнено oauth";
    if (urlforauth.contains("token_type=bearer&expires_in=") == true)
    {
        int a = urlforauth.indexOf("access_token=") + 13;
        int b = urlforauth.indexOf("&token_type");
        int c = b - a;
        urlforauth = urlforauth.mid(a, c);
        return 1;
    }

    else if (urlforauth.contains("&error=access_denied&") == true)
    {
        return 0;
    }

    return 0;
}

QByteArray QHTTPController::requestReceivingAPI(QString token)
{
    QByteArray token_bytearray = token.toUtf8();

    QNetworkRequest request;
    QNetworkRequest request1;
    request.setUrl(QUrl("https://cloud-api.yandex.net/v1/disk/resources/files?fields=items.path&media_type=compressed"));
    request.setRawHeader("Accept-Language", "ru" );
    request.setRawHeader("Content-Type", "application/json");
    request.setRawHeader(QByteArray("Authorization"), QByteArray("OAuth AQAAAAAMsMHEAADLW6bnl0Kw7UJjotzztWNVaxM"));
    request1.setUrl(QUrl("https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));

    QByteArray body;
    //body.append()

    QNetworkAccessManager *pManager = new QNetworkAccessManager();

    QNetworkReply * reply;
    QNetworkReply * reply1;
    reply = pManager -> post(request, "/");
    reply1 = pManager -> get(request1);
    QByteArray replyString = reply -> readAll();
    QByteArray replyString1 = reply1 -> readAll();
    QJsonDocument jsonfromcoingate = QJsonDocument::fromJson(replyString1);
    qDebug() << replyString << "токен для api" << jsonfromcoingate << "пенис" ;
    return replyString;
    /*QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    QByteArray token_bytearray = token.toUtf8();
    token.prepend("OAuth ");
    QNetworkRequest request(QUrl("https://cloud-api.yandex.net/v1/disk/resources/files?fields=items.path&media_type=compressed"));
    request.setRawHeader("Authorization: ", token_bytearray);
    QHttpMultiPart *mpart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    /*QHttpPart part;
    part.setHeader(QNetworkRequest::ContentDispositionHeader, )*/

    /*QNetworkReply *reply = manager -> post(request, mpart);
    mpart->setParent(reply);

    QNetworkRequest request1(QUrl("https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));
    reply = manager -> get (request1);
    QByteArray bytes = reply->readAll();
    qDebug() << bytes << "byyyyyyyyyyyyyyyyyyyyyyyytes";

    return bytes;*/
}







