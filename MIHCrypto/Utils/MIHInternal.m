//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHInternal.h"
#import "MIHErrors.h"
#include <openssl/err.h>

NSString *const MIHCryptoException = @"MIHCryptoException";
static dispatch_once_t loadErrorsOnce = 0;

@implementation NSError (MIHCrypto)

+ (instancetype)errorFromOpenSSL
{
    dispatch_once(&loadErrorsOnce, ^
    {
        ERR_load_crypto_strings();
    });

    char *errorMessage = malloc(130);
    if (errorMessage == NULL) {
        @throw [NSException outOfMemoryException];
    }
    unsigned long errorCode = ERR_get_error();
    ERR_error_string(errorCode, errorMessage);
    NSString *errorDescription = [NSString stringWithFormat:@"OpenSLL internal error! (Code=%lu,Description=%s)", errorCode, errorMessage];
    free(errorMessage);

    return [NSError errorWithDomain:MIHCryptoErrorDomain
                               code:MIHCryptoOpenSSLErrorCode
                           userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}

@end

@implementation NSException (MIHCrypto)

+ (instancetype)openSSLException
{
    dispatch_once(&loadErrorsOnce, ^
    {
        ERR_load_crypto_strings();
    });

    char *errorMessage = malloc(130);
    if (errorMessage == NULL) {
        @throw [NSException outOfMemoryException];
    }
    unsigned long errorCode = ERR_get_error();
    ERR_error_string(errorCode, errorMessage);
    NSString *errorDescription = [NSString stringWithFormat:@"OpenSLL internal error! (Code=%lu,Description=%s)", errorCode, errorMessage];
    free(errorMessage);

    return [NSException exceptionWithName:MIHCryptoException
                                   reason:[NSString stringWithFormat:@"[OpenSSL] ERROR: %s", errorMessage]
                                 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}

+ (instancetype)outOfMemoryException
{
    return [NSException exceptionWithName:MIHCryptoException reason:@"Not enough memory to decrypt." userInfo:nil];
}

@end