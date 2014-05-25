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
@class MIHBigIntegerRange;

/**
 *  Category on MIHBigInteger which cotains static factory methods to create MIHBigIntegers.
 *
 *  @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@interface MIHBigInteger (Factory)

/**
 *  Always returns an `MIHBigInteger` which represents **zero**.
 *
 *  @discussion Since `MIHBigInteger`s are immutable this methods may return an singleton instance for the
 *              representation of this value.
 *
 *  @return MIHBigInteger which represents zero.
 */
+ (MIHBigInteger *)zero;

/**
 *  Always returns an `MIHBigInteger` which represents **one**.
 *
 *  @discussion Since `MIHBigInteger`s are immutable this methods may return an singleton instance for the 
 *              representation of this value.
 *
 *  @return MIHBigInteger which represents one.
 */
+ (MIHBigInteger *)one;

/**
 *  Generates a random `MIHBigInteger` within the passed range.
 *
 *  @param range `MIHBigInteger` to limit the maximum and minium value of the generated random integer.
 *
 *  @return `MIHBigInteger` which represents the generated random integer.
 */
+ (MIHBigInteger *)randomInRange:(MIHBigIntegerRange *)range;

/**
 *  Generates a cryptographically strong pseudo-random `MIHBigInteger` of bits in length of passed value.
 *
 *  (Hint: If you would like to generate a number between `0` and `65535` you need to pass `16`.)
 *
 *  @param sizeInBits Maximum numbers of bits which may be required to store the generated random integer.
 *
 *  @return `MIHBigInteger` which represents the generated random integer.
 */
+ (MIHBigInteger *)randomWithBitsCount:(int)sizeInBits;

/**
 *  Generates a  cryptographically strong pseudo-random **prime** `MIHBigInteger` of bits in length of passed value.
 *
 *  @param sizeInBits Maximum numbers of bits which may be required to store the generated random prime.
 *
 *  @return `MIHBigInteger` which represents the generated random prime.
 */
+ (MIHBigInteger *)randomPrimeWithBitsCount:(int)sizeInBits;

@end
