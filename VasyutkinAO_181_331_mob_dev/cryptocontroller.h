#ifndef CRYPTOCONTROLLER_H
#define CRYPTOCONTROLLER_H

#include <QObject>
#include <QFile>

class CryptoController : public QObject
{
    Q_OBJECT
public:
    explicit CryptoController(QObject *parent = nullptr);

    QString sourcefile;

public slots:
    void get_name_file(QString name);
    bool do_crypt(QString key, bool mode);

private:
    unsigned char * iv = (unsigned char *)("01234567898765432101236547898765");


signals:

};

#endif // CRYPTOCONTROLLER_H
