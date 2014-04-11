//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

@protocol MIHPublicKey <NSObject, NSCoding, NSCopying>

- (NSData *)encrypt:(NSData *)message error:(NSError **)error;

- (NSData *)dataValue;

/**
 * Verifies the signature of the passed message. SHA256 is used to create the hash of the message.
 *
 * @param signature The signature bytes to verify.
 * @param message The message to verify.
 * @return YES if the signature is valid.
 */
- (BOOL)verifySignatureWithSHA256:(NSData *)signature message:(NSData *)message;

@end