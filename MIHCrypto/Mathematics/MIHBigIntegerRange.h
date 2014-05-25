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
 *  Stores range utilising MIHBigInteger. Similar to NSRange, but without any limitation in the size of integers.
 *
 *  @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@interface MIHBigIntegerRange : NSObject<NSCopying, NSCoding>

/**
 *  The start index (0 is the first, as in C arrays).
 */
@property (strong) MIHBigInteger *location;

/**
 *  The number of items in the range (can be 0).
 */
@property (strong) MIHBigInteger *range;

/**
 *  Compares this `MIHBigIntegerRange with the passed `MIHBigIntegerRange`.
 *
 *  @param other `MIHBigIntegerRange` to compare with.
 *
 *  @return `YES` if the other `MIHBigIntegerRange` is equal to this one.
 */
- (BOOL)isEqualToRange:(MIHBigIntegerRange *)range;

@end

/**
 *  Category on `MIHBigInteger` which adds the ability to validate if it is inside a range.  
 *
 *  @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@interface MIHBigInteger (MIHBigIntegerRange)

/**
 *  Checks if this instance is inside the passed range.
 *
 *  @param bigIntegerRange Range to validate.
 *
 *  @return `YES` if this instance is inside the passed range.
 */
- (BOOL)isInRange:(MIHBigIntegerRange *)bigIntegerRange;

@end