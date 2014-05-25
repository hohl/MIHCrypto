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

#import "MIHBigIntegerRange.h"

@implementation MIHBigIntegerRange

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _location = [aDecoder decodeObjectForKey:@"_location"];
        _range = [aDecoder decodeObjectForKey:@"_range"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_location forKey:@"_location"];
    [aCoder encodeObject:_range forKey:@"_range"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)copyWithZone:(NSZone *)zone
{
    MIHBigIntegerRange *copy = [[MIHBigIntegerRange allocWithZone:zone] init];
    copy.location = self.location;
    copy.range = self.range;
    return copy;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRange:other];
}

- (BOOL)isEqualToRange:(MIHBigIntegerRange *)range
{
    if (self == range)
        return YES;
    if (range == nil)
        return NO;
    if (self.location != range.location && ![self.location isEqualToBigInteger:range.location])
        return NO;
    return !(self.range != range.range && ![self.range isEqualToBigInteger:range.range]);
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.location hash];
    hash = hash * 31u + [self.range hash];
    return hash;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHBigInteger (MIHBigIntegerRange)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MIHBigInteger (MIHBigIntegerRange)

- (BOOL)isInRange:(MIHBigIntegerRange *)bigIntegerRange
{
    if ([self isLessThanBigInteger:bigIntegerRange.location])
        return NO;
    
    id<MIHNumber> limit = [bigIntegerRange.location add:bigIntegerRange.range];
    
    return [self isLessThanNumber:limit];
}

@end