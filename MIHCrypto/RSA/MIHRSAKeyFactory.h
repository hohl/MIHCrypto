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