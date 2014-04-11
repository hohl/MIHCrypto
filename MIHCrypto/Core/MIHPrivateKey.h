//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

@protocol MIHPrivateKey <NSObject, NSCoding, NSCopying>

- (NSData *)decrypt:(NSData *)cipher error:(NSError **)error;

- (NSData *)dataValue;

/**
 * Signs the passed data. SHA256 is used to create the hash of the message.
 *
 * @param message The message to sign.
 * @param error Reference used to return an error if there something went wrong.
 * @return The created signature or nil if any error occurred.
 */
- (NSData *)signWithSHA256:(NSData *)message error:(NSError **)error;

@end