//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#include <openssl/rsa.h>
#import "MIHPublicKey.h"

@interface MIHRSAPublicKey : NSObject <MIHPublicKey>
{
@protected
    RSA *_rsa;
}

/**
 * Initializes a new public RSA key.
 *
 * @param data Must be the output of dataValue or at least the same format.
 * @return The initialized instance.
 */
- (instancetype)initWithData:(NSData *)dataValue;

@end