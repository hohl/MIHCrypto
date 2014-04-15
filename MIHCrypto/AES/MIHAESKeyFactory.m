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