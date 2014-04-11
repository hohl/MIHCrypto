//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

/** Domain used by all error which are issued by MIHCrypto.*/
extern NSString *const MIHCryptoErrorDomain;

typedef NS_ENUM(NSUInteger, MIHCryptoErrorCode) {
    MIHCryptoOpenSSLErrorCode,
    MIHCryptoInvalidKeySize
};
