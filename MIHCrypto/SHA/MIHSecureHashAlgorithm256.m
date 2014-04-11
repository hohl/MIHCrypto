//
// Created by Michael Hohl on 09.04.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHSecureHashAlgorithm256.h"
#import "MIHInternal.h"
#import <openssl/sha.h>


@implementation MIHSecureHashAlgorithm256

- (NSData *)hashValueOfData:(NSData *)data
{
    SHA256_CTX sha256Ctx;
    unsigned char hashValue[SHA256_DIGEST_LENGTH];
    if(!SHA256_Init(&sha256Ctx)) {
        @throw [NSException openSSLException];
    }
    if (!SHA256_Update(&sha256Ctx, data.bytes, data.length)) {
        @throw [NSException openSSLException];
    }
    if (!SHA256_Final(hashValue, &sha256Ctx)) {
        @throw [NSException openSSLException];
    }
    return [NSData dataWithBytes:hashValue length:SHA256_DIGEST_LENGTH];
}

@end