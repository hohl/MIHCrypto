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

#import "MIHRSAPublicKey.h"
#import "MIHInternal.h"
#import "NSData+MIHConversion.h"
#include <openssl/pem.h>
#include <openssl/md5.h>

@implementation MIHRSAPublicKey

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, NSCoding and NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithData:(NSData *)dataValue
{
    NSParameterAssert([dataValue isKindOfClass:[NSData class]]);
    self = [super init];
    if (self) {
        // --- BEGIN OPENSSL HACK ---
        NSString *base64DataString = [dataValue MIH_base64EncodedStringWithWrapWidth:64];
        base64DataString = [@"-----BEGIN PUBLIC KEY-----\n" stringByAppendingString:base64DataString];
        base64DataString = [base64DataString stringByAppendingString:@"\n-----END PUBLIC KEY-----"];
        NSData *base64Data = [base64DataString dataUsingEncoding:NSUTF8StringEncoding];
        // --- END OPENSSL HACK ---

        BIO *publicBIO = BIO_new_mem_buf((void *) base64Data.bytes, (int)base64Data.length);
        EVP_PKEY *pkey = EVP_PKEY_new();
        @try {
            if (!PEM_read_bio_PUBKEY(publicBIO, &pkey, NULL, NULL)) {
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
    MIHRSAPublicKey *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        CRYPTO_add(&_rsa->references, 1, CRYPTO_LOCK_RSA);
        copy->_rsa = _rsa;
    }

    return copy;
}

- (void)dealloc
{
    RSA_free(_rsa);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHPublicKey
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (int)rsaPadding
{
    if (_rsaPadding == 0)
        _rsaPadding = RSA_PKCS1_PADDING;

    return _rsaPadding;
}

- (NSData *)dataValue
{
    // OpenSSL PEM Writer requires the key in EVP_PKEY format:
    EVP_PKEY *pkey = EVP_PKEY_new();
    char *publicBytes;
    size_t publicBytesLength;
    @try {
        EVP_PKEY_set1_RSA(pkey, _rsa);

        BIO *publicBIO = BIO_new(BIO_s_mem());
        PEM_write_bio_PUBKEY(publicBIO, pkey);
        publicBytesLength = (size_t) BIO_pending(publicBIO);
        publicBytes = malloc(publicBytesLength);
        BIO_read(publicBIO, publicBytes, (int)publicBytesLength);
    }
    @finally {
        EVP_PKEY_free(pkey);
    }

    // --- BEGIN OPENSSL HACK ---
    NSData *rawDataValue = [NSData dataWithBytesNoCopy:publicBytes length:publicBytesLength];
    NSMutableString *dataString = [[NSMutableString alloc] initWithData:rawDataValue encoding:NSUTF8StringEncoding];
    // Remove: '-----BEGIN RSA PUBLIC KEY-----' or '-----END RSA PUBLIC KEY-----'
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(-{5,}BEGIN (RSA )?PUBLIC KEY-{5,})|(-{5,}END (RSA )?PUBLIC KEY-{5,})|\n"
                                                                           options:0
                                                                             error:nil];
    [regex replaceMatchesInString:dataString
                          options:0
                            range:NSMakeRange(0, dataString.length)
                     withTemplate:@""];
    // --- END OPENSSL HACK ---
    
    return [NSData MIH_dataByBase64DecodingString:dataString];
}

- (NSData *)encrypt:(NSData *)messageData error:(NSError **)error
{
    NSMutableData *cipherData = [NSMutableData dataWithLength:(NSUInteger) RSA_size(_rsa)];
    int cipherBytesLength = RSA_public_encrypt((int)messageData.length, messageData.bytes, cipherData.mutableBytes, _rsa, self.rsaPadding);
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
    int messageBytesLength = RSA_public_decrypt((int)cipherData.length, cipherData.bytes, messageData.mutableBytes, _rsa, self.rsaPadding);
    if (messageBytesLength < 0) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    [messageData setLength:(NSUInteger) messageBytesLength];

    return messageData;
}

- (BOOL)verifySignatureWithSHA128:(NSData *)signature message:(NSData *)message
{
    SHA_CTX shaCtx;
    unsigned char messageDigest[SHA_DIGEST_LENGTH];
    if(!SHA1_Init(&shaCtx)) {
        return NO;
    }
    if (!SHA1_Update(&shaCtx, message.bytes, message.length)) {
        return NO;
    }
    if (!SHA1_Final(messageDigest, &shaCtx)) {
        return NO;
    }
    if (RSA_verify(NID_sha1, messageDigest, SHA_DIGEST_LENGTH, signature.bytes, (int)signature.length, _rsa) == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)verifySignatureWithSHA256:(NSData *)signature message:(NSData *)message
{
    SHA256_CTX sha256Ctx;
    unsigned char messageDigest[SHA256_DIGEST_LENGTH];
    if(!SHA256_Init(&sha256Ctx)) {
        return NO;
    }
    if (!SHA256_Update(&sha256Ctx, message.bytes, message.length)) {
        return NO;
    }
    if (!SHA256_Final(messageDigest, &sha256Ctx)) {
        return NO;
    }
    if (RSA_verify(NID_sha256, messageDigest, SHA256_DIGEST_LENGTH, signature.bytes, (int)signature.length, _rsa) == 0) {
        return NO;
    }
    return YES;
}


- (BOOL)verifySignatureWithMD5:(NSData *)signature message:(NSData *)message
{
    
    MD5_CTX md5Ctx;
    unsigned char messageDigest[MD5_DIGEST_LENGTH];
    if(!MD5_Init(&md5Ctx)) {
        return NO;
    }
    if (!MD5_Update(&md5Ctx, message.bytes, message.length)) {
        return NO;
    }
    if (!MD5_Final(messageDigest, &md5Ctx)) {
        return NO;
    }
    if (RSA_verify(NID_md5, messageDigest, MD5_DIGEST_LENGTH, signature.bytes, (int)signature.length, _rsa) == 0) {
        return NO;
    }
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)description
{
    return [[self dataValue] MIH_base64EncodedString];
}

@end