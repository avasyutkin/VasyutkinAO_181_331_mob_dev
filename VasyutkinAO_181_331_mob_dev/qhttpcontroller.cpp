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
#include <QUrlQuery>
#include <QUrl>
#include <QSqlDatabase>
#include <QtWidgets/QTableView>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlTableModel>
#include <QtSql/QSqlError>

QHTTPController::QHTTPController(QObject *parent) : QObject(parent)
{
    nam = new QNetworkAccessManager();
    database_read();
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
    QNetworkReply * reply;
    QEventLoop eventloop;
    connect(nam, &QNetworkAccessManager::finished, &eventloop, &QEventLoop::quit);
    QNetworkRequest request;
    request.setUrl(QUrl("https://cloud-api.yandex.net/v1/disk/resources/files?fields=name%2C%20created%2C%20size%2C%20preview&media_type=image&offset=0&preview_crop=true&preview_size=40"));
    request.setRawHeader(QByteArray("Authorization"), QByteArray(token_bytearray));
    reply = nam->get(request);
    eventloop.exec();
    QByteArray replyString = reply -> readAll();
    qDebug() << replyString << request.url().toString() <<
                request.header(QNetworkRequest::ContentTypeHeader);


    //parseJSON(replyString);
    database_write(replyString);

    return "a";

}

/*void QHTTPController::parseJSON(QByteArray source)
{
    QJsonDocument jsonDoc = QJsonDocument::fromJson(source);  //распарсить json

    QJsonObject rootObject = jsonDoc.object();  //получние ссылки на корневой объект

    int size;
    QString name;
    QString created;
    QString preview;

    if (rootObject.contains("items") && rootObject["items"].isArray()) {
        QJsonValue items = rootObject.value("items");
        QJsonArray items_array = items.toArray();

        foreach (const QJsonValue & item, items_array) {
            QJsonObject itemobj = item.toObject();

            if (itemobj.contains("size")){
                QJsonValue size_value = itemobj.value("size");
                size = size_value.toInt();
            }

            if (itemobj.contains("name")){
                QJsonValue name_value = itemobj.value("name");
                name = name_value.toString();
            }

            if (itemobj.contains("created")){
                QJsonValue created_value = itemobj.value("created");
                created = created_value.toString().remove(9, 15);
            }

            if (itemobj.contains("file")){
                QJsonValue preview_value = itemobj.value("file");
                preview = preview_value.toString();
            }

            fileModel.addItem(FileObject(size, name, created, preview));
        }
    }

    qDebug() << size << name << created << preview;
}
*/

void QHTTPController::database_read()
{
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");  //добавляет базу данных в список соединений с базой данных
    database.setHostName("files");
    database.setDatabaseName("D:/QT Labs/files.db");
    database.open();

    int sizeLess1 = 0;
    int sizeLess2 = 0;
    int sizeLess3 = 0;
    int sizeLess4 = 0;
    int sizeLess5 = 0;
    int sizeOver5 = 0;

    if(database.isOpen())
    {
        if (fileModel.rowCount() > 0)
        {
            fileModel.clear();
        }

        QSqlQuery query;
        if (query.exec("SELECT * FROM files"))
        {
            query.exec("SELECT * FROM files");

            while (query.next())
            {
                QString name = query.value("File_name").toString();
                QString size = query.value("File_size").toString();
                QString created = query.value("File_created").toString();
                QString preview = query.value("File_preview").toString();

                if (size.toInt() < 1048576)
                    sizeLess1++;
                else if (size.toInt() > 1048576 && size.toInt() < 2097152)
                    sizeLess2++;
                else if (size.toInt() > 2097152 && size.toInt() < 3145728)
                    sizeLess3++;
                else if (size.toInt() > 3145728 && size.toInt() < 4194304)
                    sizeLess4++;
                else if (size.toInt() > 4194304 && size.toInt() < 5242880)
                    sizeLess5++;
                else if (size.toInt() > 5242880)
                    sizeOver5++;

                fileModel.addItem(FileObject(size.toInt(), name, created, preview));
            }

            QSqlDatabase::removeDatabase("QSQLITE");
            database.close();
        }
    }

    emit signalSendToQML_3(sizeLess1, sizeLess2, sizeLess3, sizeLess4, sizeLess5, sizeOver5);
}

void QHTTPController::database_write(QByteArray source)
{
    int size;
    QString name;
    QString created;
    QString preview;

    QJsonDocument jsonDoc = QJsonDocument::fromJson(source);  //распарсить json
    QJsonObject rootObject = jsonDoc.object();  //получние ссылки на корневой объект

    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setHostName("files");
    database.setDatabaseName("D:/QT Labs/files.db");
    database.open();
    QSqlQuery query;
    query.exec("DROP TABLE files");
    query.exec("CREATE TABLE files("
               "File_name varchar(255),"
               "File_size varchar(255),"
               "File_created varchar(255),"
               "File_preview varchar(255))");

    if (rootObject.contains("items") && rootObject["items"].isArray())
    {
        QJsonValue items = rootObject.value("items");
        QJsonArray items_array = items.toArray();

        foreach (const QJsonValue & item, items_array)
        {
            QJsonObject itemobj = item.toObject();

            if (itemobj.contains("size"))
            {
                QJsonValue size_value = itemobj.value("size");
                size = size_value.toInt();
            }

            if (itemobj.contains("name"))
            {
                QJsonValue name_value = itemobj.value("name");
                name = name_value.toString();
            }

            if (itemobj.contains("created"))
            {
                QJsonValue created_value = itemobj.value("created");
                created = created_value.toString().remove(9, 15);
            }

            if (itemobj.contains("file"))
            {
                QJsonValue preview_value = itemobj.value("file");
                preview = preview_value.toString();
            }

            query.prepare("INSERT INTO files(File_name, File_size, File_created, File_preview)"
                          "VALUES (:File_name, :File_size, :File_created, :File_preview)");
            query.bindValue(":File_name", name);
            query.bindValue(":File_size", size);
            query.bindValue(":File_created", created);
            query.bindValue(":File_preview", preview);
            query.exec();
        }
    }

    QSqlDatabase::removeDatabase("QSQLITE");  //удаляет соединение с БД
    database.close();
    database_read();
}



