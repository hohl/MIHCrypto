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

#import "MIHBigInteger.h"

/**
 *  These category on MIHBigInteger contains adds the ability to load MIHBigInteger from an OpenSSL BIGNUM.
 *
 *  @internal
 *  @discussion These methods are designed for internal use only. Don't use these category yourself!
 *  @author <a href="http://www.michaelhohl.net">Michael Hohl</a>
 */
@interface MIHBigInteger (Internal)

/**
 *  Initialises a MIHBigInteger by **copying** the passed BIGNUM to the internal representation BIGNUM.
 *
 *  @param aBn OpenSSL BIGNUM struct which should get represented by this MIHBigInteger.
 *
 *  @internal
 *  @return The newly-created instance.
 */
- (id)initWithBIGNUM:(BIGNUM*)aBn;

/**
 *  Initialises a MIHBigInteger by **assign** the passed BIGNUM as the internal representation BIGNUM.
 *
 *  @param aBn OpenSSL BIGNUM struct which should get represented by this MIHBigInteger.
 *
 *  @internal
 *  @return The newly-created instance.
 */
- (id)initWithBIGNUMNoCopy:(BIGNUM*)aBn;

/**
 *  If the passed aNumber is already MIHBigInteger it will just get returned.
 *  Otherwise a new MIHBigInteger is created on the decimal value returned by the number.
 *
 *  @param aNumber The number to convert to an MIHBigInteger.
 *
 *  @internal
 *  @return Always any kind of MIHBigInteger which represents the value of the passed aNumber.
 */
+ (MIHBigInteger *)bigIntegerFromNumber:(id<MIHNumber>)aNumber;

/**
 *  The BIGNUM which is wrapped by this object.
 *
 *  @internal
 */
@property (assign, readonly) BIGNUM *representedBn;

@end
