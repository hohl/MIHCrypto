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

@class MIHAESKey;

typedef NS_ENUM(NSUInteger, MIHAESKeySize) {
    MIHAESKey256 = 32,
    MIHAESKey192 = 24,
    MIHAESKey128 = 16
};

/**
 * Factory used to create new MIHAESKeys.
 *
 * @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface MIHAESKeyFactory : NSObject <MIHKeyFactory>

/**
 * This key size is going to be used when a new key is created.
 */
@property(assign) MIHAESKeySize preferedKeySize;

/**
 * Generates a random AES key with the configured key size.
 *
 * @return The created symmetric AES key.
 * @see -preferedKeySize
 */
- (MIHAESKey<MIHSymmetricKey> *)generateKey;

@end