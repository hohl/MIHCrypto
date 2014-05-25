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

#import "MIHDESKeyFactory.h"
#import "MIHDESKey.h"
#import "MIHDESKey+Internal.h"
#import "MIHInternal.h"
#import <openssl/dsa.h>
#import <openssl/evp.h>
#import <openssl/rand.h>

@implementation MIHDESKeyFactory

- (id)init
{
    self = [super init];
    if (self) {
        _preferedMode = MIHDESModeCBC;
    }
    return self;
}

- (MIHDESKey <MIHSymmetricKey> *)generateKey
{
    MIHSeedPseudeRandomNumberGenerator();
    
    MIHDESMode mode = self.preferedMode;
    NSError *cipherForModeError = nil;
    const EVP_CIPHER *evpCipher = [MIHDESKey cipherForMode:mode error:&cipherForModeError];
    if (cipherForModeError) {
        return nil;
    }
    
    int keyLength = EVP_CIPHER_key_length(evpCipher);
    int blockSize = EVP_CIPHER_block_size(evpCipher);
    
    unsigned char *keyBytes = (unsigned char *) malloc(sizeof(unsigned char) * keyLength);
    RAND_bytes(keyBytes, keyLength);
    NSData *key = [NSData dataWithBytesNoCopy:keyBytes length:(NSUInteger)keyLength];
    unsigned char *initVectorBytes = (unsigned char *) malloc(sizeof(unsigned char) * blockSize);
    RAND_bytes(initVectorBytes, blockSize);
    NSData *iv = [NSData dataWithBytesNoCopy:initVectorBytes length:(NSUInteger)blockSize];
    
    return [[MIHDESKey alloc] initWithKey:key iv:iv mode:mode];
}

@end
