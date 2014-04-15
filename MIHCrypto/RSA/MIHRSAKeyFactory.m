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