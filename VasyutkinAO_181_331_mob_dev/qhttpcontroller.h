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
    QString slotPageInfo (QString pReply);
    QString currentratecost(QString replyString);
    QString currentratestate(QString replyString);
    bool boolforcolorlab_4(QString replyString);
signals:
    void signalSendToQML(QString pReply, QString replayrete, QString currentratecost, QString currentratestate, bool boolforcolorlab_4);

};

#endif // QHTTPCONTROLLER_H
