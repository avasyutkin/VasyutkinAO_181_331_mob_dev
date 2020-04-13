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







QString QHTTPController::auth()
{





    /*

    QNetworkReply * reply = nam -> get(QNetworkRequest(
                                           QUrl("https://oauth.yandex.ru/authorize?response_type=token"
                                                "&client_id=b90874f5afbc41c5a675b31f708dc772"
                                                "&device_id=123456546546"
                                                "&device_name=phone"
                                                "&redirect_uri=https://oauth.yandex.ru/verification_code"
                                                "&login_hint=alexandervasyutkin"
                                        //"&scope={\"is_yandex\": false, \"localized_scope\": [\"\u0418\u0441\u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u043d\u0438\u0435 API \u042f\u043d\u0434\u0435\u043a\u0441.\u0414\u043e\u0441\u0442\u0430\u0432\u043a\u0438 \u0434\u043b\u044f \u043f\u0430\u0440\u0442\u043d\u0435\u0440\u043e\u0432", "\u0427\u0442\u0435\u043d\u0438\u0435 \u0432\u0441\u0435\u0433\u043e \u0414\u0438\u0441\u043a\u0430\", \"\u0414\u043e\u0441\u0442\u0443\u043f \u043d\u0430 \u0447\u0442\u0435\u043d\u0438\u0435 \u043f\u0438\u0441\u0435\u043c \u0432 \u043f\u043e\u0447\u0442\u043e\u0432\u043e\u043c \u044f\u0449\u0438\u043a\u0435\", \"\u0410\u0443\u0442\u0435\u043d\u0442\u0438\u0444\u0438\u043a\u0430\u0446\u0438\u044f \u0432 \u041e\u0431\u043b\u0430\u043a\u0435\"], \"ctime\": 1586680495, \"mtime\": 1586680495, \"id\": \"b90874f5afbc41c5a675b31f708dc772\", \"description\": \"\", \"name\": \"MobDev_vasyutkin\", \"localized_names\": {\"ru\": \"MobDev_vasyutkin\", \"en\": \"MobDev_vasyutkin\", \"tr\": \"MobDev_vasyutkin\", \"uk\": \"MobDev_vasyutkin\"}, \"callback\": \"https://oauth.yandex.ru/verification_code\", \"scope\": [\"delivery:partner-api\", \"cloud_api:disk.read\", \"mail:imap_ro\", \"cloud:auth\"], \"icon\": null, \"homepage\": \"\"}"
                                        //"&optional_scope=<запрашиваемые опциональные права>"
                                                "&force_confirm=yes"
                                                "&state=ну че как жизнб"
                                                "&display=popup")

                                           ));
    QEventLoop eventloop;
    connect(nam, SIGNAL(QNetworkAccessManager::fininshed(QNetworkReply*)), &eventloop, SLOT(quit()));
    //обработка reply
    eventloop.exec(); //запуск цикла ожидания. Приложение обрабатывает остальные сигналы, пока не поступит сигнал QEventLoop::quit
    QByteArray replyString = reply -> readAll();
    emit signalSendToQML(QString(replyString), slotPageInfo(replyString), currentratecost(replyString), currentratestate(replyString), boolforcolorlab_4(replyString), currentratedate(replyString));
    qDebug() << reply -> url()
             << reply -> rawHeaderList()
             << reply -> readAll()
             << "authauthauth";











    QNetworkReply * reply;
    reply = nam->get(QNetworkRequest(
                         QUrl("https://oauth.yandex.ru/authorize?response_type=token"
                              "&client_id=b90874f5afbc41c5a675b31f708dc772"
                              "&device_id=123456546546"
                              "&device_name=phone"
                              "&redirect_uri=https://oauth.yandex.ru/verification_code"
                              "&login_hint=alexandervasyutkin"
                              //"&scope={\"is_yandex\": false, \"localized_scope\": [\"\u0418\u0441\u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u043d\u0438\u0435 API \u042f\u043d\u0434\u0435\u043a\u0441.\u0414\u043e\u0441\u0442\u0430\u0432\u043a\u0438 \u0434\u043b\u044f \u043f\u0430\u0440\u0442\u043d\u0435\u0440\u043e\u0432", "\u0427\u0442\u0435\u043d\u0438\u0435 \u0432\u0441\u0435\u0433\u043e \u0414\u0438\u0441\u043a\u0430\", \"\u0414\u043e\u0441\u0442\u0443\u043f \u043d\u0430 \u0447\u0442\u0435\u043d\u0438\u0435 \u043f\u0438\u0441\u0435\u043c \u0432 \u043f\u043e\u0447\u0442\u043e\u0432\u043e\u043c \u044f\u0449\u0438\u043a\u0435\", \"\u0410\u0443\u0442\u0435\u043d\u0442\u0438\u0444\u0438\u043a\u0430\u0446\u0438\u044f \u0432 \u041e\u0431\u043b\u0430\u043a\u0435\"], \"ctime\": 1586680495, \"mtime\": 1586680495, \"id\": \"b90874f5afbc41c5a675b31f708dc772\", \"description\": \"\", \"name\": \"MobDev_vasyutkin\", \"localized_names\": {\"ru\": \"MobDev_vasyutkin\", \"en\": \"MobDev_vasyutkin\", \"tr\": \"MobDev_vasyutkin\", \"uk\": \"MobDev_vasyutkin\"}, \"callback\": \"https://oauth.yandex.ru/verification_code\", \"scope\": [\"delivery:partner-api\", \"cloud_api:disk.read\", \"mail:imap_ro\", \"cloud:auth\"], \"icon\": null, \"homepage\": \"\"}"
                              //"&optional_scope=<запрашиваемые опциональные права>"
                              "&force_confirm=yes"
                              "&state=ну че как жизнб"
                              "&display=popup")));
    // после 2 запроса должно прийти что-то вроде https://oauth.vk.com/authorize?client_id=6455770&redirect_uri=https%3A%2F%2Foauth.vk.com%2Fblank.html&response_type=token&scope=2&v=5.37&state=123456&display=mobile&__q_hash=28f5e4f93012a7b3ae36130f6880e60c
    qDebug() <<  "*** РЕЗУЛЬТАТ 2 ЗАПРОСА HEADER " <<  reply->header(QNetworkRequest::LocationHeader).toString();
    qDebug() <<  "*** РЕЗУЛЬТАТ 2 ЗАПРОСА BODY " <<  reply->readAll();

    // Получаем редирект с успешной авторизацией
    reply = nam->get(
                QNetworkRequest(QUrl(reply->header(QNetworkRequest::LocationHeader).toString())));
    QEventLoop eventloop;
    eventloop.exec();
    qDebug() <<  "*** РЕЗУЛЬТАТ 3 ЗАПРОСА HEADER " <<  reply->header(QNetworkRequest::LocationHeader).toString();
    // здесь должно быть выведено что-то вроде https://login.vk.com/?act=grant_access&client_id=6455770&settings=2&redirect_uri=https%3A%2F%2Foauth.vk.com%2Fblank.html&response_type=token&group_ids=&token_type=0&v=5.37&state=123456&display=mobile&ip_h=ef8b1396e37a94a790&hash=1555330570_4d65b2c53f975e8ae9&https=1
    qDebug() <<  "*** РЕЗУЛЬТАТ 3 ЗАПРОСА BODY " <<  reply->readAll();
    // Получаем редирект на токен, наш милый и любимый
    reply = nam->get(QNetworkRequest(QUrl(reply->header(QNetworkRequest::LocationHeader).toString())));
    eventloop.exec();

    QString str = reply->header(QNetworkRequest::LocationHeader).toString();
    qDebug() <<  "*** РЕЗУЛЬТАТ 4 ЗАПРОСА HEADER " << str;
    // вот здесь только получен access_token в URI вида https://oauth.vk.com/blank.html#access_token=6bb58aed5a329922889fad15201e71046493539c5bebfbc6cafa43080a14822518bdd3c5bacde32432f9c&expires_in=86400&user_id=27520159&state=123456
    qDebug() <<  "*** РЕЗУЛЬТАТ 4 ЗАПРОСА BODY " << reply->readAll();

    if (str.indexOf("access_token") != -1)
    {
        QString m_accessToken = str.split("access_token=")[1].split("&")[0];
        //emit authorized();
        //emit authSuccess();
        qDebug() <<  "*** m_accessToken" << m_accessToken.mid(2,20);
    }
    else
        qDebug() << "Failed!";



*/

    return "gg";
}
