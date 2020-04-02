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
signals:
    void signalSendToQML(QString pReply, QString replayrete);

};

#endif // QHTTPCONTROLLER_H
