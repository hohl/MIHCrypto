//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHKeyFactory.h"

@class MIHKeyPair;

typedef NS_ENUM(NSUInteger, MIHRSAKeySize) {
    MIHRSAKey512 = 64,
    MIHRSAKey1024 = 128,
    MIHRSAKey2048 = 256,
    MIHRSAKey4096 = 512
};

@interface MIHRSAKeyFactory : NSObject <MIHKeyFactory>

/**
 * The size which should get used for the key generation.
 */
@property (assign) MIHRSAKeySize preferedKeySize;

/**
 * Generates a pair of RSA keys and returns them as MIHKeyPair.
 */
- (MIHKeyPair *)generateKeyPair;

@end