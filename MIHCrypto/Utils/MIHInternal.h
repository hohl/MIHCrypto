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

/*
 * Some helpers which make code more readable which should only get used MIHCrypto internally.
 */

/**
 * Helper category used to construct NSErrors from OpenSSL errors.
 *
 * @internal
 * @discussion These methods are designed for internal use only. Don't use these category yourself!
 * @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface NSError (MIHCrypt)
+ (instancetype)errorFromOpenSSL;
@end

/**
 * Helper category used to construct NSException from OpenSSL errors and out of memory exceptions.
 *
 * @internal
 * @discussion These methods are designed for internal use only. Don't use these category yourself!
 * @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface NSException (MIHCrypto)
+ (instancetype)openSSLException;
+ (instancetype)outOfMemoryException;
@end

/**
 *  Seeds the generator for the pseudo-random number generator.
 */
void MIHSeedPseudeRandomNumberGenerator(void);