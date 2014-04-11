//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

@protocol MIHPrivateKey;
@protocol MIHPublicKey;
@protocol MIHSymmetricKey;
@class MIHKeyPair;

/**
 * Protocol for classes which are used to create new keys.
 *
 * Classes which implement this protocol should implement either -generateKeyPair or -generateKey
 */
@protocol MIHKeyFactory <NSObject>

@optional

- (MIHKeyPair *)generateKeyPair;

- (id <MIHSymmetricKey>)generateKey;

@end