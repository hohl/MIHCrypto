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
 *  Protocol which should get included by all classes which represent a numeric value.
 *
 *  @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@protocol MIHNumber <MIHCoding, NSCopying>

/**
 *  Adds this MIHNumber instance to the other and returns the sum.
 *
 *  @param summand The other MIHNumber instance to add.
 *
 *  @return An MIHNumber instance which represents the sum.
 */
- (id<MIHNumber>)add:(id<MIHNumber>)summand;

/**
 *  Adds this MIHNumber instance to the other and returns the sum.
 *  (Hint: `returnValue=this+summand % modulo`)
 *
 *  @param summand The other MIHNumber instance to add.
 *  @param modulus The modulus of the calculation.
 *
 *  @return An MIHNumber instance which represents the sum modulo the modulus.
 */
- (id<MIHNumber>)add:(id<MIHNumber>)summand modulo:(id<MIHNumber>)modulus;

/**
 *  Subtracts the other MIHNumber instance from this one.
 *
 *  (Hint: `returnValue = this - other`)
 *
 *  @param subtrahend The other instance to subtract from this instance.
 *
 *  @return An MIHNumber instance which represents the result of the subtraction.
 */
- (id<MIHNumber>)subtract:(id<MIHNumber>)subtrahend;

/**
 *  Multiplies the other MIHNumber with this one.
 *
 *  @param factor The other MIHNumber instance to multiply.
 *
 *  @return An MIHNumber instance which represents the product of the multiplication.
 */
- (id<MIHNumber>)multiply:(id<MIHNumber>)factor;

/**
 *  Multiplies the other MIHNumber with this one.
 *
 *  @param factor  The other MIHNumber instance to multiply.
 *  @param modulus The modulus of the calculation.
 *
 *  @return An MIHNumber instance which represents the product of the multiplication modulo the modulus.
 */
- (id<MIHNumber>)multiply:(id<MIHNumber>)factor modulo:(id<MIHNumber>)modulus;

/**
 *  Divides the other MIHNumber from this one.
 *
 *  @param divisor The other MIHNumber to divide from this instance.
 *
 *  @return An MIHNumber instance which represents the quotient of the division.
 */
- (id<MIHNumber>)divide:(id<MIHNumber>)divisor;

/**
 *  Calculates the modulo value of the division between this MIHNumber and the other MIHNumber instance used as a 
 *  divisor. (Hint: `returnValue = this % divisor`)
 *
 *  @param divisor The other MIHNumber to divide from this instance.
 *
 *  @return An MIHNumber instance which represents the modulo value of the division.
 */
- (id<MIHNumber>)modulo:(id<MIHNumber>)divisor;

/**
 *  Calculates this MIHNumber instance to the power of another MIHNumber instance.
 *
 *  @param exponent The exponent of the calculation.
 *
 *  @return The value of this MIHNumber instance to the power of the passed MIHNumber instance.
 */
- (id<MIHNumber>)power:(id<MIHNumber>)exponent;

/**
 *  Calculates this MIHNumber instance to the power of another MIHNumber instance, limiting to the passed divisor.
 *  (Hint: `returnValue=this^exponent % modulo`)
 *
 *  @param exponent The exponent of the calculation.
 *  @param modulus  The modulus of the calculation.
 *
 *  @return The value of this MIHNumber instance to the power of the passed MIHNumber instance modulo the modulus.
 */
- (id<MIHNumber>)power:(id<MIHNumber>)exponent modulo:(id<MIHNumber>)modulus;

/**
 *  Calculate the square of this MIHNumber instance.
 *  (Hint: `returnValue=this*this` or `returnValue=this^2`)
 *
 *  @return The saure of this MIHNumber instance.
 */
- (id<MIHNumber>)square;

/**
 *  Creates a NSString of this decimal value of this MIHNumber instance.
 *
 *  @return NSString which represents the MIHNumber.
 */
- (NSString *)decimalStringValue;

/**
 *  Compares this MIHNumber instance with one.
 *
 *  @return `YES` if this MIHNumber instance is one.
 */
- (BOOL)isOne;

/**
 *  Compares this MIHNumber instance with zero.
 *
 *  @return `YES` if this MIHNumber instance is zero.
 */
- (BOOL)isZero;

/**
 *  Checks if the MIHNumber instance is odd.
 *
 *  @return `YES` if this MIHNumber instance is odd.
 */
- (BOOL)isOdd;

/**
 *  Checks the sign of this MIHNumber instance.
 *
 *  @return `YES` if the MIHNumber instance is smaller then zero.
 */
- (BOOL)isNegative;

/**
 *  Compares this MIHNumber instance with another one.
 *
 *  @param other The MIHNumber instance to compare with.
 *
 *  @return `YES` if the represented values are equal.
 */
- (BOOL)isEqualToNumber:(id<MIHNumber>)other;

/**
 *  Compares this MIHNumber instance with another one.
 *
 *  @param other The MIHNumber instance to compare with.
 *
 *  @return `YES` is the passed instance is less.
 */
- (BOOL)isGreaterThanNumber:(id<MIHNumber>)other;

/**
 *  Compares this MIHNumber instance with another one.
 *
 *  @param other The MIHNumber instance to compare with.
 *
 *  @return `YES` is the passed instance is greater.
 */
- (BOOL)isLessThanNumber:(id<MIHNumber>)other;

@end
