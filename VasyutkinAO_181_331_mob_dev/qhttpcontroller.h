#ifndef QHTTPCONTROLLER_H
#define QHTTPCONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>

class QHTTPController : public QObject
{
    Q_OBJECT
public:
    explicit QHTTPController(QObject *parent = nullptr);
    QNetworkAccessManager * nam;

public slots:
    void GetNetworkValue();  //выполняет запрос к серверу
    void GetNetworkValue_2();
    QString slotPageInfo (QString pReply);
    QString currentratecost(QString replyString);
    QString currentratestate(QString replyString);
    bool boolforcolorlab_4(QString replyString);
    QString currentratedate(QString replyString);
    QString currentratecostrub(QByteArray replyString);
    QString auth();
signals:
    void signalSendToQML(QString pReply, QString replayrete, QString currentratecost, QString currentratestate, bool boolforcolorlab_4, QString currentratedate);
    void signalSendToQML_2(QString currentratecostrub);
};

#endif // QHTTPCONTROLLER_H
