//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

@protocol MIHPrivateKey;
@protocol MIHPublicKey;

/**
 * Container for storing a pair of public and private keys.
 */
@interface MIHKeyPair : NSObject <NSCoding, NSCopying>

@property(strong) id <MIHPrivateKey> private;
@property(strong) id <MIHPublicKey> public;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToPair:(MIHKeyPair *)pair;

- (NSUInteger)hash;

@end