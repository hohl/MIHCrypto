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

#import "MIHAESKey.h"
#import "MIHAESKeyFactory.h"
#import "MIHErrors.h"
#import "MIHInternal.h"
#import "NSData+MIHConversion.h"
#import "NSString+MIHConversion.h"
#include <openssl/evp.h>
#include <openssl/aes.h>

@implementation MIHAESKey
{
    EVP_CIPHER_CTX encryptCtx;
    EVP_CIPHER_CTX decryptCtx;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, NSCoding and NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class MIHAESKey"
                                 userInfo:nil];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _key = [coder decodeObjectForKey:@"_key"];
        _iv = [coder decodeObjectForKey:@"_iv"];
    }

    return self;
}

- (id)initWithKey:(NSData *)key iv:(NSData *)iv
{
    self = [super init];
    if (self) {
        _key = key;
        _iv = iv;
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.key forKey:@"_key"];
    [coder encodeObject:self.iv forKey:@"_iv"];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithKey:_key iv:_iv];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *components = [dataString componentsSeparatedByString:@","];
        [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger index, BOOL *stop)
         {
             if ([component hasPrefix:@"key="]) {
                 NSString *hexEncodedKey = [component substringFromIndex:4];
                 _key = hexEncodedKey.MIH_dataFromHexadecimal;
             } else if ([component hasPrefix:@"iv="]) {
                 NSString *hexEncodedIv = [component substringFromIndex:3];
                 _iv = hexEncodedIv.MIH_dataFromHexadecimal;
             }
         }];
    }
    
    return self;
}

- (NSData *)dataValue
{
    return [self.stringValue dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"key=%@,iv=%@", self.key.MIH_hexadecimalString, self.iv.MIH_hexadecimalString];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHSymmetricKey
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error
{
    size_t messageBytesLength = 0;
    size_t blockLength = 0;

    unsigned char *messageBytes = (unsigned char *) malloc(cipherData.length);
    if (messageBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }

    const EVP_CIPHER *evpCipher;
    switch (self.key.length) {
        case MIHAESKey256:
            evpCipher = EVP_aes_256_cbc();
            break;
        case MIHAESKey192:
            evpCipher = EVP_aes_192_cbc();
            break;
        case MIHAESKey128:
            evpCipher = EVP_aes_128_cbc();
            break;
        default:
            if (error)
                *error = [NSError errorWithDomain:MIHCryptoErrorDomain
                                             code:MIHCryptoInvalidKeySize
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%lu is not a valid AES key size!", (unsigned long) self.key.length]}];
            free(messageBytes);
            return nil;
    }

    if (!EVP_DecryptInit(&decryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        if (error) *error = [NSError errorFromOpenSSL];
        free(messageBytes);
        return nil;
    }

    if (!EVP_DecryptUpdate(&decryptCtx, messageBytes, (int *) &blockLength, cipherData.bytes, (int) cipherData.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        free(messageBytes);
        return nil;
    }
    messageBytesLength += blockLength;

    if (!EVP_DecryptFinal(&decryptCtx, messageBytes + messageBytesLength, (int *) &blockLength)) {
        if (error) *error = [NSError errorFromOpenSSL];
        free(messageBytes);
        return nil;
    }
    messageBytesLength += blockLength;

    return [NSData dataWithBytesNoCopy:messageBytes length:messageBytesLength];
}

- (NSData *)encrypt:(NSData *)messageData error:(NSError **)error
{
    size_t blockLength = 0;
    size_t cipherBytesLength = 0;

    const EVP_CIPHER *evpCipher;
    switch (self.key.length) {
        case MIHAESKey256:
            evpCipher = EVP_aes_256_cbc();
            break;
        case MIHAESKey192:
            evpCipher = EVP_aes_192_cbc();
            break;
        case MIHAESKey128:
            evpCipher = EVP_aes_128_cbc();
            break;
        default:
            if (error)
                *error = [NSError errorWithDomain:MIHCryptoErrorDomain
                                             code:MIHCryptoInvalidKeySize
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%lu is not a valid AES key size!", (unsigned long)self.key.length]}];
            return nil;
    }

    unsigned char *cipherBytes = (unsigned char *) malloc(messageData.length + AES_BLOCK_SIZE);
    memset(cipherBytes, 0, messageData.length + AES_BLOCK_SIZE);
    if (cipherBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }

    if (!EVP_EncryptInit(&encryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }

    if (!EVP_EncryptUpdate(&encryptCtx, cipherBytes, (int *) &blockLength, messageData.bytes, (int)messageData.length)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;

    if (!EVP_EncryptFinal(&encryptCtx, cipherBytes + cipherBytesLength, (int *) &blockLength)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;

    return [NSData dataWithBytesNoCopy:cipherBytes length:cipherBytesLength];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToKey:other];
}

- (BOOL)isEqualToKey:(MIHAESKey *)key
{
    NSParameterAssert([key isKindOfClass:[MIHAESKey class]]);
    if (self == key)
        return YES;
    if (key == nil)
        return NO;
    if (self.key != key.key && ![self.key isEqualToData:key.key])
        return NO;
    if (self.iv != key.iv && ![self.iv isEqualToData:key.iv])
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.key hash];
    hash = hash * 31u + [self.iv hash];
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<MIHAESKey %@>", self.stringValue];
}

@end