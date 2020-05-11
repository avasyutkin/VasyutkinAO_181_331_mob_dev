#include "cryptocontroller.h"
#include <openssl/evp.h>

CryptoController::CryptoController(QObject *parent) : QObject(parent)
{

}

int do_crypt(unsigned char *sourcetext, unsigned char *ciphertext, int do_encrypt)
{
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();

    int sourcetext_len = strlen((char *)sourcetext),
            len,
            ciphertext_len;

    unsigned char *key = (unsigned char *)"0123456789abcdeF0123456789abcdeF",
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
