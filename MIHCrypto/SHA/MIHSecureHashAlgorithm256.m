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