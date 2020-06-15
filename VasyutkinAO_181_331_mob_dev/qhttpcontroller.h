#ifndef QHTTPCONTROLLER_H
#define QHTTPCONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonArray>
#include "modelfromyandexdisk.h"

class QHTTPController : public QObject
{
    Q_OBJECT
public:
    explicit QHTTPController(QObject *parent = nullptr);
    QNetworkAccessManager * nam;
    ModelfromYandexDisk fileModel;

public slots:
    void GetNetworkValue();  //выполняет запрос к серверу
    void GetNetworkValue_2();
    QString slotPageInfo (QString pReply);
    QString currentratecost(QString replyString);
    QString currentratestate(QString replyString);
    bool boolforcolorlab_4(QString replyString);
    QString currentratedate(QString replyString);
    QString currentratecostrub(QByteArray replyString);
    QString auth(QString urlforauth);
    bool authbool(QString urlforauth);
    QByteArray requestReceivingAPI(QString token);
    //void parseJSON(QByteArray source);

    void database_read();
    void database_write(QByteArray source);

signals:
    void signalSendToQML(QString pReply, QString replayrete, QString currentratecost, QString currentratestate, bool boolforcolorlab_4, QString currentratedate);
    void signalSendToQML_2(QString currentratecostrub);
    void signalSendToQML_3(int sizeLess1, int sizeLess2, int sizeLess3, int sizeLess4, int sizeLess5, int sizeOver5);
};

#endif // QHTTPCONTROLLER_H
