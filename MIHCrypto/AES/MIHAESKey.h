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

#import "MIHSymmetricKey.h"

/**
 * MIHPrivateKey and MIHPublicKey implementation which is based on AES in CBC mode.
 *
 * @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface MIHAESKey : NSObject <MIHSymmetricKey>

/**
 * The raw bytes (as NSData instance) of the AES symmetric key.
 */
@property(strong, readonly) NSData *key;

/**
 * The initialisation vector used by the AES symmetric key.
 */
@property(strong, readonly) NSData *iv;

/**
 * Binary represation of this symmetric key.
 */
@property (readonly) NSData *dataValue;

/**
 * Same as dataValue but will return a string which contains iv and key as HEX encoded data.
 */
@property(readonly) NSString *stringValue;

/**
 * Generates a new AES key with random key and init vector.
 *
 * @warning Random bytes are taken from OpenSSL secure random method and may take some time!
 *
 * @return The initialized instance.
 */
- (id)init;

/**
 * Initializes a new AES key.
 *
 * @param data Must be the output of dataValue or at least the same format.
 *
 * @return The initialized instance.
 */
- (id)initWithData:(NSData *)data;

/**
 * Initializes a new AES key.
 *
 * @param key NSData which contains the bytes used as key. Must be of length 16, 24 or 32 bytes!
 * @param iv NSData which contains the bytes used as initialization vector. Must be of length 32!
 *
 * @return The initialized instance.
 */
- (instancetype)initWithKey:(NSData *)key iv:(NSData *)iv;

/**
 * Compares this key against the passed aes key one.
 *
 * @param key The key to compare this key against.
 *
 * @return YES if both keys are equavilent.
 */
- (BOOL)isEqualToKey:(MIHAESKey *)key;

@end