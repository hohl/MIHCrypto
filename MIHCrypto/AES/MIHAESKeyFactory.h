//
// Created by Michael Hohl on 25.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHKeyFactory.h"

@class MIHAESKey;

typedef NS_ENUM(NSUInteger, MIHAESKeySize) {
    MIHAESKey256 = 32,
    MIHAESKey192 = 24,
    MIHAESKey128 = 16
};

@interface MIHAESKeyFactory : NSObject <MIHKeyFactory>

/**
 * This key size is going to be used when a new key is created.
 */
@property(assign) MIHAESKeySize preferedKeySize;

/**
 * @return Generates a random AES key with the configured key size and returns it.
 */
- (MIHAESKey<MIHSymmetricKey> *)generateKey;

@end