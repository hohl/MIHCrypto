//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MIHRSAPrivateKey.h"
#import "MIHInternal.h"
#include <openssl/pem.h>
#include <openssl/md5.h>
@implementation MIHRSAPrivateKey

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, NSCoding and NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithData:(NSData *)dataValue
{
    NSParameterAssert([dataValue isKindOfClass:[NSData class]]);
    self = [super init];
    if (self) {
        BIO *privateBIO = BIO_new_mem_buf((void *) dataValue.bytes, (int)dataValue.length);
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

- (int)rsaPadding
{
    if (_rsaPadding == 0)
        _rsaPadding = RSA_PKCS1_PADDING;

    return _rsaPadding;
}

- (NSData *)dataValue
{
    EVP_PKEY *pkey = EVP_PKEY_new();
    char *privateBytes;
    int privateBytesLength;
    @try {
        EVP_PKEY_set1_RSA(pkey, _rsa);
        BIO *privateBIO = BIO_new(BIO_s_mem());
        PEM_write_bio_PKCS8PrivateKey(privateBIO, pkey, NULL, NULL, 0, 0, NULL);
        privateBytesLength =  BIO_pending(privateBIO);
        privateBytes = malloc((size_t)privateBytesLength);
        BIO_read(privateBIO, privateBytes, privateBytesLength);
    }
    @finally {
        EVP_PKEY_free(pkey);
    }

    return [NSData dataWithBytesNoCopy:privateBytes length:privateBytesLength];
}

- (NSData *)encrypt:(NSData *)messageData error:(NSError **)error
{
    NSMutableData *cipherData = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    int cipherBytesLength = RSA_private_encrypt((int)messageData.length, messageData.bytes, cipherData.mutableBytes, _rsa, self.rsaPadding);
    if (cipherBytesLength < 0) {
        if (error) *error = [NSError errorFromOpenSSL];
    }
    [cipherData setLength:(NSUInteger) cipherBytesLength];

    return cipherData;
}

- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error
{
    NSUInteger rsaSize = (NSUInteger) RSA_size(_rsa);
    NSMutableData *messageData = [NSMutableData dataWithLength:rsaSize];
    int messageBytesLength = RSA_private_decrypt((int)cipherData.length, cipherData.bytes, messageData.mutableBytes, _rsa, self.rsaPadding);
    if (messageBytesLength < 0) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [messageData setLength:(NSUInteger) messageBytesLength];

    return messageData;
}

- (NSData *)signWithSHA128:(NSData *)message error:(NSError **)error
{
    SHA_CTX shaCtx;
    unsigned char messageDigest[SHA_DIGEST_LENGTH];
    if (!SHA1_Init(&shaCtx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA1_Update(&shaCtx, message.bytes, message.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA1_Final(messageDigest, &shaCtx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }

    NSMutableData *signature = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    unsigned int signatureLength = 0;
    if (RSA_sign(NID_sha1, messageDigest, SHA_DIGEST_LENGTH, signature.mutableBytes, &signatureLength, _rsa) == 0) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [signature setLength:(NSUInteger) signatureLength];

    return signature;
}

- (NSData *)signWithSHA256:(NSData *)message error:(NSError **)error
{
    SHA256_CTX sha256Ctx;
    unsigned char messageDigest[SHA256_DIGEST_LENGTH];
    if (!SHA256_Init(&sha256Ctx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA256_Update(&sha256Ctx, message.bytes, message.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!SHA256_Final(messageDigest, &sha256Ctx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }

    NSMutableData *signature = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    unsigned int signatureLength = 0;
    if (RSA_sign(NID_sha256, messageDigest, SHA256_DIGEST_LENGTH, signature.mutableBytes, &signatureLength, _rsa) == 0) {
        if (error)
            *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [signature setLength:(NSUInteger) signatureLength];

    return signature;
}

- (NSData *)signWithMD5:(NSData *)message error:(NSError **)error{
    MD5_CTX md5Ctx;
    unsigned char messageDigest[MD5_DIGEST_LENGTH];
    if (!MD5_Init(&md5Ctx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!MD5_Update(&md5Ctx, message.bytes, message.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    if (!MD5_Final(messageDigest, &md5Ctx)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    
    NSMutableData *signature = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    unsigned int signatureLength = 0;
    if (RSA_sign(NID_md5, messageDigest, MD5_DIGEST_LENGTH, signature.mutableBytes, &signatureLength, _rsa) == 0) {
        if (error)
            *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [signature setLength:(NSUInteger) signatureLength];
    
    return signature;
}

@end