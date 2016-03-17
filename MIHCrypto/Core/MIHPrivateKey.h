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

#import "MIHCoding.h"

/**
 * Protocol for classes which represent a private key. Private keys can get used to decrypt cipher data and to sign
 * messages.
 * 
 * @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@protocol MIHPrivateKey <NSObject, NSCopying, NSCoding, MIHCoding>

/**
 *  Encrypts the passed message with this private key.
 *
 *  @param message The message to get encrypted.
 *  @param error   Will be set if an error occurs.
 *
 *  @return The encrypted cipher data or nil if an error occured.
 */
- (NSData *)encrypt:(NSData *)message error:(NSError **)error;

/**
 *  Decrypts the passed cipher data with this private key.
 *
 *  @param cipher The cipher data to decrypt.
 *  @param error  Will get set if an error occurs while decrypting the cipher.
 *
 *  @return The encrypted message or nil if an error occured.
 */
- (NSData *)decrypt:(NSData *)cipher error:(NSError **)error;

/**
 * Signs the passed data. SHA128 is used to create the hash of the message.
 *
 * @param message The message to sign.
 * @param error   Reference used to return an error if there something went wrong.
 *
 * @return The created signature or nil if any error occurred.
 */
- (NSData *)signWithSHA128:(NSData *)message error:(NSError **)error;

/**
 * Signs the passed data. SHA256 is used to create the hash of the message.
 *
 * @param message The message to sign.
 * @param error   Reference used to return an error if there something went wrong.
 *
 * @return The created signature or nil if any error occurred.
 */
- (NSData *)signWithSHA256:(NSData *)message error:(NSError **)error;


/**
 * Signs the passed data. MD5 is used to create the hash of the message.
 *
 * @param message The message to sign.
 * @param error   Reference used to return an error if there something went wrong.
 *
 * @return The created signature or nil if any error occurred.
 */
- (NSData *)signWithMD5:(NSData *)message error:(NSError **)error;

@end