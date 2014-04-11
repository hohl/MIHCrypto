//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

/*
 * Some helpers which make code more readable which should only get used MIHCrypto internally.
 */

/** Name of all exceptions which may get thrown by MIHCrypto library. */
extern NSString *const MIHCryptoException;

@interface NSError (MIHCrypt)
+ (instancetype)errorFromOpenSSL;
@end

@interface NSException (MIHCrypto)
+ (instancetype)openSSLException;
+ (instancetype)outOfMemoryException;
@end