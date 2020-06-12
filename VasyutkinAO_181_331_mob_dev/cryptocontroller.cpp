#include "cryptocontroller.h"
#include <openssl/evp.h>
#include <QFile>
#include <QByteArray>
#include <QDebug>
#include <QIODevice>
#include <QObject>
#include <QTemporaryFile>
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/aes.h>

CryptoController::CryptoController(QObject *parent)
{

}

bool CryptoController::do_crypt(QString key, bool mode)
{
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();

    if (mode == 1)
    {
        if(!EVP_EncryptInit_ex(ctx, EVP_aes_256_ofb(), NULL, reinterpret_cast<unsigned char *>(key.toLatin1().data()), iv))
            return false;
    }

    else if (mode == 0)
        if(!EVP_DecryptInit_ex(ctx, EVP_aes_256_ofb(), NULL, reinterpret_cast<unsigned char *>(key.toLatin1().data()), iv))
            return false;

    QFile source_file(sourcefile);
    source_file.open(QIODevice::ReadOnly);

    int position;
    position = sourcefile.lastIndexOf(".");
    QString file_extension = sourcefile.mid(position);
    QString sourcefile_for_if;

    if (mode == 1)
    {
        position = sourcefile.lastIndexOf(".");
        sourcefile_for_if = sourcefile.left(position) + "_encrypt" + file_extension;
    }

    else if (mode == 0)
    {
        position = sourcefile.lastIndexOf("_encrypt");
        sourcefile_for_if = sourcefile.left(position) + "_decrypt" + file_extension;
    }

    QFile file_modified(sourcefile_for_if);
    file_modified.open(QIODevice::ReadWrite | QIODevice::Truncate);

    unsigned char ciphertext[256];
    unsigned char plaintext[256];
    int plaintext_len = source_file.read((char *)plaintext, 256);
    int len;

    while (plaintext_len > 0)
    {
        if (mode == 1)
        {
            if(!EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
                return false;
        }

        else if (mode == 0)
            if(!EVP_DecryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
                return false;

        file_modified.write((char*)ciphertext, len);
        plaintext_len = source_file.read((char*)plaintext, 256);
    }

    if (mode == 1)
    {
        if(!EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
            return false;
    }

    else if (mode == 0)
        if(!EVP_DecryptFinal_ex(ctx, ciphertext + len, &len))
            return false;

    file_modified.write((char*)ciphertext, len);

    EVP_CIPHER_CTX_free(ctx);

    source_file.close();
    file_modified.close();
}

void CryptoController::get_name_file(QString name){
    sourcefile = name.mid(8);
}
