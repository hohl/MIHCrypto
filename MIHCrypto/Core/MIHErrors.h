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

/**
 * Domain used by all OpenSSL errors which are wrapped by MIHCrypto to an NSError instance.
 */
extern NSString *const MIHOpenSSLErrorDomain;

/**
 * Domain used by all error which are issued by MIHCrypto.
 */
extern NSString *const MIHCryptoErrorDomain;

typedef NS_ENUM(NSUInteger, MIHCryptoErrorCode) {
    /**
     * MIHCryptoInvalidKeySize is used in errors indicating that the passed key size can't get used with this approach.
     */
    MIHCryptoInvalidKeySize,
    
    /**
     * MIHCryptoInvalidMode is used in errors indicating that the passed mode is not usable with this approach.
     */
    MIHCryptoInvalidMode
};

/**
 * Name of all exceptions which may get thrown by MIHCrypto library.
 */
extern NSString *const MIHCryptoException;

/**
 *  Called when trying to use pseudo-random number generator and there is no PRNG implementation/device available.
 *  (This exception shouldn't never occur, since iOS and OS X implement `/dev/urandom` per default. But maybe this code
 *  get ever ported anywhere or somebody is using an corrupt setup.)
 */
extern NSString *const MIHNotSeededException;