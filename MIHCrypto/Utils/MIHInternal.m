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