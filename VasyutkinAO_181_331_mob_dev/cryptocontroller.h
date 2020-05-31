#ifndef CRYPTOCONTROLLER_H
#define CRYPTOCONTROLLER_H

#include <QObject>

class CryptoController : public QObject
{
    Q_OBJECT
public:
    explicit CryptoController(QObject *parent = nullptr);

public slots:
    int do_crypt(unsigned char *sourcetext, unsigned char *ciphertext, int do_encrypt, unsigned char *keysource);
    void readfile (QString name, int do_encrypt, QString keysource);

signals:

};

#endif // CRYPTOCONTROLLER_H
