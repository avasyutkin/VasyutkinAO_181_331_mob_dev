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
#include <curl/curl.h>


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
    token.prepend("OAuth ");
    QByteArray token_bytearray = token.toUtf8();


    QNetworkRequest request;
    QNetworkRequest request1;
    request.setUrl(QUrl("https://cloud-api.yandex.net:443/v1/"));
    request.setRawHeader("Accept-Language: ", "ru" );
    request.setRawHeader("Content-Type: ", "application/json");
    request.setRawHeader(QByteArray("Authorization: "), QByteArray(token_bytearray));
    request1.setUrl(QUrl("https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));

    //QByteArray body;
    //body.append()

    QNetworkReply * reply;
    QNetworkReply * reply1;
    QEventLoop eventloop;
    connect(nam, &QNetworkAccessManager::finished, &eventloop, &QEventLoop::quit);
    reply = nam -> post(request, "/");
    reply1 = nam -> get(request1);
    eventloop.exec();
    QByteArray replyString = reply -> readAll();
    QByteArray replyString1 = reply1 -> readAll();
    qDebug() << token_bytearray << "токен для api" << replyString1;

    //QNetworkAccessManager *manager = new QNetworkAccessManager(this);

    //QByteArray token_bytearray = token.toUtf8();
    //token.prepend("OAuth ");
    //QNetworkRequest request(QUrl("https://cloud-api.yandex.net/v1/disk/resources/files?fields=items.path&media_type=compressed"));
    // request.setRawHeader("Authorization: ", token_bytearray);
    //QHttpMultiPart *mpart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    //return "a";
    //QHttpPart part;
    //part.setHeader(QNetworkRequest::ContentDispositionHeader, )

    /*QNetworkReply *reply = manager -> post(request, mpart);
    mpart->setParent(reply);

    QNetworkRequest request1(QUrl("https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));
    reply = manager -> get (request1);
    QByteArray bytes = reply->readAll();
    qDebug() << bytes << "byyyyyyyyyyyyyyyyyyyyyyyytes";

    return bytes;*/



    /*CURL *curl;
    curl = curl_easy_init();
    struct curl_slist * chunk = NULL;
    chunk = curl_slist_append (chunk, "Accept:" );
    chunk = curl_slist_append (chunk, "https://cloud-api.yandex.net/v1/" );
    chunk = curl_slist_append(chunk, "Content-Type: application/json");
    chunk = curl_slist_append(chunk, "Accept-Language: ru");
    curl_easy_setopt(curl, CURLOPT_HEADER, "Authorization: ", *token_bytearray);
    chunk = curl_slist_append(chunk, "Authorization:  token_bytearray");
    curl_easy_setopt (curl, CURLOPT_HTTPHEADER , chunk);
    curl_easy_setopt(curl, CURLOPT_URL, "https://cloud-api.yandex.net/v1/");
    curl_easy_setopt(curl, CURLOPT_HEADER, 1);
    curl_easy_setopt(curl, CURLOPT_POST, 1);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "Content-Type: application/json","Accept-Language: ru",  "Authorization: ", *token_bytearray);

    std::u16string response_string;
    std::string header_string;
    CURLcode curlResult;
    if(curl)
    {
        curl_easy_setopt(curl, CURLOPT_URL, "https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "Content-Type: application/json", "Authorization: "+*token_bytearray);


        curl_easy_setopt( curl, CURLOPT_WRITEDATA, &response_string );
        curl_easy_setopt( curl, CURLOPT_HEADERDATA, &header_string );

        curlResult = curl_easy_perform(curl);
    }

    curl_easy_cleanup(curl);

    qDebug() << curl << curlResult << response_string << &header_string;


    /*QNetworkRequest request;
    request.setUrl(QUrl("https://cloud-api.yandex.net:443/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));
    QNetworkReply * reply;
    QEventLoop eventloop;
    connect(nam, &QNetworkAccessManager::finished, &eventloop, &QEventLoop::quit);
    reply = nam -> get(request);
    eventloop.exec();
    QByteArray repst = reply->readAll();
    qDebug() << QString(repst);*/


   /* QCURL cur;
    RequestData rd;
    QByteArray RequestResult;

    rd.Method = CURL::POST;
    rd.url = "http://www.s92640jz.bget.ru/register.php";
    //----- формирование пост параметров -------
    rd.PostData.insert("login","login");
    rd.PostData.insert("pass","pass");
    rd.PostData.insert("open_key","open_key");
    rd.PostData.insert("key_size","key_size");
    //---- и отправка файла --------------------
    //rd.PostFiles.insert("upload_data","c:\\users\\foto.zip");
    RequestResult = cur.SendRequest(rd);
    qDebug() << RequestResult;*/




    return "a";

}







