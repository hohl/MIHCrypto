//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHRSAPrivateKey.h"
#import "MIHInternal.h"
#include <openssl/pem.h>

@implementation MIHRSAPrivateKey

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, NSCoding and NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithData:(NSData *)dataValue
{
    NSParameterAssert([dataValue isKindOfClass:[NSData class]]);
    self = [super init];
    if (self) {
        BIO *privateBIO = BIO_new_mem_buf((void *) dataValue.bytes, dataValue.length);
        EVP_PKEY *pkey = EVP_PKEY_new();
        @try {
            if (!PEM_read_bio_PrivateKey(privateBIO, &pkey, 0, NULL)) {
                @throw [NSException openSSLException];
            }
            _rsa = EVP_PKEY_get1_RSA(pkey);
        }
        @finally {
            //EVP_PKEY_free(pkey);
        }
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    NSData *dataValue = [coder decodeObjectForKey:@"dataValue"];
    return [self initWithData:dataValue];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.dataValue forKey:@"dataValue"];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIHRSAPrivateKey *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        CRYPTO_add(&_rsa->references, 1, CRYPTO_LOCK_RSA);
        copy->_rsa = _rsa;
    }

    return copy;
}

- (void)dealloc
{
    if (_rsa)
        RSA_free(_rsa);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHPrivateKey
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSData *)dataValue
{
    EVP_PKEY *pkey = EVP_PKEY_new();
    char *privateBytes;
    size_t privateBytesLength;
    @try {
        EVP_PKEY_set1_RSA(pkey, _rsa);
        BIO *privateBIO = BIO_new(BIO_s_mem());
        PEM_write_bio_PKCS8PrivateKey(privateBIO, pkey, NULL, NULL, 0, 0, NULL);
        privateBytesLength = (size_t) BIO_pending(privateBIO);
        privateBytes = malloc(privateBytesLength);
        BIO_read(privateBIO, privateBytes, privateBytesLength);
    }
    @finally {
        EVP_PKEY_free(pkey);
    }

    return [NSData dataWithBytesNoCopy:privateBytes length:privateBytesLength];
}

- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error
{
    NSUInteger rsaSize = (NSUInteger) RSA_size(_rsa);
    NSMutableData *messageData = [NSMutableData dataWithLength:rsaSize];
    int messageBytesLength = RSA_private_decrypt(cipherData.length, cipherData.bytes, messageData.mutableBytes, _rsa, RSA_PKCS1_OAEP_PADDING);
    if (messageBytesLength < 0) {
        *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [messageData setLength:(NSUInteger) messageBytesLength];

    return messageData;
}

- (NSData *)signWithSHA256:(NSData *)message error:(NSError **)error
{
    SHA256_CTX sha256Ctx;
    unsigned char messageDigest[SHA256_DIGEST_LENGTH];
    if (!SHA256_Init(&sha256Ctx)) {
        *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA256_Update(&sha256Ctx, message.bytes, message.length)) {
        *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA256_Final(messageDigest, &sha256Ctx)) {
        *error = [NSError errorFromOpenSSL];
        return nil;
    }

    NSMutableData *signature = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    unsigned int signatureLength = 0;
    if (RSA_sign(NID_sha256, messageDigest, SHA256_DIGEST_LENGTH, signature.mutableBytes, &signatureLength, _rsa) == 0) {
        *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [signature setLength:(NSUInteger) signatureLength];

    return signature;
}

@end