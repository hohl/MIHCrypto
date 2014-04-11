//
// Created by Michael Hohl on 25.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHAESKeyFactory.h"
#import "MIHAESKey.h"
#import <openssl/aes.h>
#import <openssl/rand.h>

@implementation MIHAESKeyFactory

- (id)init
{
    self = [super init];
    if (self) {
        self.preferedKeySize = MIHAESKey256;
    }
    return self;
}

- (MIHAESKey <MIHSymmetricKey> *)generateKey
{
    if (self.preferedKeySize != MIHAESKey128
            && self.preferedKeySize != MIHAESKey192
            && self.preferedKeySize != MIHAESKey256) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Key size must be either MIHAESKey128, MIHAESKey192 or MIHAESKey256."
                                     userInfo:nil];
    }

    unsigned char *keyBytes = (unsigned char *) malloc(sizeof(unsigned char) * self.preferedKeySize);
    RAND_bytes(keyBytes, self.preferedKeySize);
    NSData *key = [NSData dataWithBytesNoCopy:keyBytes length:(NSUInteger) self.preferedKeySize];
    unsigned char *initVectorBytes = (unsigned char *) malloc(sizeof(unsigned char) * AES_BLOCK_SIZE);
    RAND_bytes(initVectorBytes, AES_BLOCK_SIZE);
    NSData *iv = [NSData dataWithBytesNoCopy:initVectorBytes length:AES_BLOCK_SIZE];

    return [[MIHAESKey alloc] initWithKey:key iv:iv];
}

@end