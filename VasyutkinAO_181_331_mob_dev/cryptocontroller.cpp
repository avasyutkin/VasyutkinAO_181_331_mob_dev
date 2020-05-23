#include "cryptocontroller.h"
#include <openssl/evp.h>
#include <QFile>
#include <QByteArray>
#include <QDebug>
#include <string.h>
#include <iostream>

CryptoController::CryptoController(QObject *parent) : QObject(parent)
{

}

int CryptoController::do_crypt(unsigned char *sourcetext, unsigned char *ciphertext, int do_encrypt, unsigned char *keysource)
{
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();


    int sourcetext_len = strlen((char *)sourcetext),
            len,
            ciphertext_len;


    unsigned char *key = keysource,
            *iv = (unsigned char *)"1234567887654321";

    if(!EVP_CipherInit_ex(ctx, EVP_aes_256_cbc(), NULL, NULL, NULL, do_encrypt))
    {
        EVP_CIPHER_CTX_free(ctx);
        return 0;
    }

    OPENSSL_assert(EVP_CIPHER_CTX_key_length(ctx) == 32);
    OPENSSL_assert(EVP_CIPHER_CTX_iv_length(ctx) == 16);

    if(!EVP_CipherInit_ex(ctx, NULL, NULL, key, iv, do_encrypt))
    {
        EVP_CIPHER_CTX_free(ctx);
        return 0;
    }

    if(!EVP_CipherUpdate(ctx, ciphertext, &len, sourcetext, sourcetext_len))
    {
        EVP_CIPHER_CTX_free(ctx);
        return 0;
    }
    ciphertext_len = len;

    if(!EVP_CipherFinal_ex(ctx, ciphertext + len, &len))
    {
        EVP_CIPHER_CTX_free(ctx);
        return 0;
    }
    ciphertext_len += len;


    EVP_CIPHER_CTX_free(ctx);
    ciphertext[ciphertext_len] = '\0';
    return ciphertext_len;
}

void CryptoController::readfile (QString name, int do_encrypt, char keysource){
    /*name.remove(0, 8);
    QFile file(name);

    unsigned char *vOut = (unsigned char*)strtol(&keysource, NULL, 10);

    QString a = "";
    int count = 0;
    if(file.open(QIODevice::ReadWrite))
    {
        while(!file.atEnd())
        {
            a=a+file.readLine();
            count = count + 1;
        }
    }
    file.close();
    qDebug() << "количество строк" << count << a << name;

    unsigned char *ciphertext;
    if ((file.exists())&&(file.open(QIODevice::ReadWrite)))
    {
        qDebug() << "работаем";
        QString str = "";
        QByteArray databuf;

        while(!file.atEnd())
        {
            qDebug() << "работаем2";
            str=str+file.readLine();
            QByteArray arr = str.toLocal8Bit();
            unsigned char *sourcetext = (unsigned char *)strdup(arr.constData());
            do_crypt(sourcetext, ciphertext, do_encrypt, vOut);
            databuf = QByteArray((char*)ciphertext, 128);
            file.write(databuf);
        }
        file.close();
    }*/


    std::string stringtext = "привет как дела";

        unsigned char *sourcetext = (unsigned char*)stringtext.c_str(),
                ciphertext[128],
                decryptedtext[128],
                key[32] = "1111111111111111111111111111111";

        std::cout << "Cipher text: хуй";
        do_crypt(sourcetext, ciphertext, 1, key);
        std::cout << "Cipher text: " << "\n" << ciphertext << "\n";

        do_crypt(ciphertext, decryptedtext, 0, key);
        std::cout << "Decrypted text: " << "\n" << decryptedtext << "\n";

}
