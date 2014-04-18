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

#import "MIHDESKey.h"
#import "MIHDESKeyFactory.h"
#import <openssl/evp.h>

/**
 * These category on MIHDESKey contains an static helper which fetches the EVP_CIPHER for the passed MIHDESMode.
 *
 * @internal
 * @discussion These methods are designed for internal use only. Don't use these category yourself!
 * @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface MIHDESKey (Internal)

/**
 * Loads an EVP_CIPHER for the passed MIHDESMode.
 *
 * @internal
 *
 * @param mode  MIHDESMode to look up.
 * @param error Will be set if an error occurs during loading.
 *
 * @return The loaded cipher or nil if an error occured..
 */
+ (const EVP_CIPHER*)cipherForMode:(MIHDESMode)mode error:(NSError**)error;

/**
 * Fetches the name for the passed MIHDESMode.
 *
 * @internal
 * @see -modeFromModeName
 *
 * @param mode MIHDESMode to look up.
 *
 * @return NSString which contains the name or nil if the mode isn't a valid MIHDESMode.
 */
+ (NSString *)modeNameForMode:(MIHDESMode)mode;

/**
 * Fetches the MIHDESMode for the passed mode name.
 *
 * @internal
 * @see -modeFromModeName
 *
 * @param modeName NSString which contains the name.
 *
 * @return MIHDESMode or MIHDESModeCBC if the mode name wasn't a valid name.
 */
+ (MIHDESMode)modeFromModeName:(NSString *)modeName;

@end
