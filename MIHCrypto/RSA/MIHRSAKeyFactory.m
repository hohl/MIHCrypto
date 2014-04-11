//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHInternal.h"
#import "MIHKeyPair.h"
#import "MIHRSAPrivateKey+Internal.h"
#import "MIHRSAPublicKey.h"
#import "MIHRSAPublicKey+Internal.h"
#import "MIHRSAKeyFactory.h"

@implementation MIHRSAKeyFactory

- (id)init
{
    self = [super init];
    if (self) {
        self.preferedKeySize = MIHRSAKey2048;
    }

    return self;
}

- (MIHKeyPair *)generateKeyPair
{
    BIGNUM *exponent = BN_new();
    BN_set_word(exponent, 65537);
    @try {
        RSA *rsa = RSA_new();
        if (!RSA_generate_key_ex(rsa, self.preferedKeySize * 8, exponent, NULL)) {
            @throw [NSException openSSLException];
        }

        MIHKeyPair *keyPair = [[MIHKeyPair alloc] init];
        keyPair.private = [[MIHRSAPrivateKey alloc] initWithRSA:rsa];
        keyPair.public = [[MIHRSAPublicKey alloc] initWithRSA:rsa];

        RSA_free(rsa);

        return keyPair;
    }
    @finally {
        BN_free(exponent);
    }
}

@end