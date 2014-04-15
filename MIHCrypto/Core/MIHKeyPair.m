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

#import "MIHKeyPair.h"
#import "MIHPublicKey.h"
#import "MIHPrivateKey.h"

@implementation MIHKeyPair

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.private = [coder decodeObjectForKey:@"self.private"];
        self.public = [coder decodeObjectForKey:@"self.public"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.private forKey:@"self.private"];
    [coder encodeObject:self.public forKey:@"self.public"];
}

- (id)copyWithZone:(NSZone *)zone
{
    MIHKeyPair *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.private = self.private;
        copy.public = self.public;
    }

    return copy;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToPair:other];
}

- (BOOL)isEqualToPair:(MIHKeyPair *)pair
{
    if (self == pair)
        return YES;
    if (pair == nil)
        return NO;
    if (self.private != pair.private && ![self.private isEqual:pair.private])
        return NO;
    if (self.public != pair.public && ![self.public isEqual:pair.public])
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.private hash];
    hash = hash * 31u + [self.public hash];
    return hash;
}


@end