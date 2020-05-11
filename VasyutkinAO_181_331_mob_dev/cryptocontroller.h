#ifndef CRYPTOCONTROLLER_H
#define CRYPTOCONTROLLER_H

#include <QObject>

class CryptoController : public QObject
{
    Q_OBJECT
public:
    explicit CryptoController(QObject *parent = nullptr);

signals:
    int do_crypt(unsigned char *sourcetext, unsigned char *ciphertext, int do_encrypt);

};

#endif // CRYPTOCONTROLLER_H
