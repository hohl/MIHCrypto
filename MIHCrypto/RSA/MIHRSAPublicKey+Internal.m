//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//


#import "MIHRSAPublicKey+Internal.h"
#import <OpenSSL-Universal/openssl/evp.h>

@implementation MIHRSAPublicKey (Internal)

- (instancetype)initWithRSA:(RSA *)rsa
{
    self = [super init];
    if (self) {
        CRYPTO_add(&rsa->references, 1, CRYPTO_LOCK_RSA);
        _rsa = rsa;
    }

    return self;
}

@end