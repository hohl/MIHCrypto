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

#import "MIHCertificateName.h"
#import "MIHCoding.h"
#import "MIHHashAlgorithm.h"
#import "MIHPublicKey.h"

/**
 * Protocol for classes which implement a certifcate which holds a public key.
 *
 * @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@protocol MIHCertificate <NSObject, MIHCoding>

/**
 * @return Subject of this certificate.
 */
- (id<MIHCertificateName>)subject;

/**
 * @return Issuer of this certificate.
 *
 * @discussion If you want to create a root certificate, set issuer to the same value as subject. These kind of
 *             ceritifcates are called "root" certificate.
 */
- (id<MIHCertificateName>)issuer;

/**
 * @return MIHPublicKey which represents the hold public key.
 */
- (id<MIHPublicKey>)publicKey;

/**
 * @return `NSDate` defining end of validity of this certificate.
 */
- (NSDate *)notValidAfterDate;

/**
 * @return `NSDate` defining begin of validity of this certificate.
 */
- (NSDate *)notValidBeforeDate;

/**
 * @return Hash algorithm used to create the signature of this certificate.
 */
- (id<MIHHashAlgorithm>)signatureAlgorithm;

/**
 * @return Raw data of the signature.
 */
- (NSData *)signatureData;

@end
