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
signals:
    void signalSendToQML(QString pReply);

};

#endif // QHTTPCONTROLLER_H
