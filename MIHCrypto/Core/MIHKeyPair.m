//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
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