//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHSymmetricKey.h"

/**
 * MIHPrivateKey and MIHPublicKey implementation which is based on AES.
 * @discussion This implementation is based on the OpenSSL library.
 */
@interface MIHAESKey : NSObject <MIHSymmetricKey>

/**
 * The raw bytes (as NSData instance) of the AES symmetric key.
 */
@property(strong, readonly) NSData *key;

/**
 * The initialisation vector used by the AES symmetric key.
 */
@property(strong, readonly) NSData *iv;

/**
 * Binary represation of this symmetric key.
 */
@property (readonly) NSData *dataValue;

/**
 * Same as dataValue but will return a string which contains iv and key as HEX encoded data.
 */
@property(readonly) NSString *stringValue;

/**
 * Generates a new AES key with random key and init vector.
 *
 * @discussion Random bytes are taken from OpenSSL secure random method and may take some time!
 * @return The initialized instance.
 */
- (id)init;

/**
 * Initializes a new AES key.
 *
 * @param data Must be the output of dataValue or at least the same format.
 * @return The initialized instance.
 */
- (id)initWithData:(NSData *)data;

/**
 * Initializes a new AES key.
 *
 * @param key NSData which contains the bytes used as key. Must be of length 16, 24 or 32 bytes!
 * @param iv NSData which contains the bytes used as initialization vector. Must be of length 32!
 * @return The initialized instance.
 */
- (instancetype)initWithKey:(NSData *)key iv:(NSData *)iv;

/**
 * Compares this key against the passed aes key one.
 *
 * @param key The key to compare this key against.
 * @return YES if both keys are equavilent.
 */
- (BOOL)isEqualToKey:(MIHAESKey *)key;

@end