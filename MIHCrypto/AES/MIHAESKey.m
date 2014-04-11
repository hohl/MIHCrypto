//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
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
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%d is not a valid AES key size!", self.key.length]}];
            return nil;
    }

    if (!EVP_DecryptInit(&decryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }

    if (!EVP_DecryptUpdate(&decryptCtx, messageBytes, (int *) &blockLength, cipherData.bytes, (int) cipherData.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    messageBytesLength += blockLength;

    if (!EVP_DecryptFinal(&decryptCtx, messageBytes + messageBytesLength, (int *) &blockLength)) {
        if (error) *error = [NSError errorFromOpenSSL];
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
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%d is not a valid AES key size!", self.key.length]}];
            return nil;
    }

    unsigned char *cipherBytes = (unsigned char *) malloc(messageData.length + AES_BLOCK_SIZE);
    memset(cipherBytes, 0, messageData.length + AES_BLOCK_SIZE);
    if (cipherBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }

    if (!EVP_EncryptInit(&encryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }

    if (!EVP_EncryptUpdate(&encryptCtx, cipherBytes, (int *) &blockLength, messageData.bytes, messageData.length)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;

    if (!EVP_EncryptFinal(&encryptCtx, cipherBytes + cipherBytesLength, (int *) &blockLength)) {
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;

    return [NSData dataWithBytesNoCopy:cipherBytes length:cipherBytesLength];
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"key=%@,iv=%@", self.key.MIH_hexadecimalString, self.iv.MIH_hexadecimalString];
}

- (NSData *)dataValue
{
    return [self.stringValue dataUsingEncoding:NSUTF8StringEncoding];
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