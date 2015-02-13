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
#include <openssl/rand.h>

static dispatch_once_t loadErrorsOnce = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSError (MIHCrypto)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSError (MIHCrypto)

+ (instancetype)errorFromOpenSSL
{
    dispatch_once(&loadErrorsOnce, ^
    {
        ERR_load_crypto_strings();
    });

    
    unsigned long errorCode = ERR_get_error();
    
    NSString *errorDescription;
    if (errorCode == 67522668) {
        errorDescription = @"Size of data to encrypt must not exceed size of RSA key. If you want to securly encrypt "
                            "large blocks of data combine RSA with AES. (See "
                            "https://github.com/hohl/MIHCrypto/issues/24 for more details about that topic.)";
    } else {
        char *errorMessage = malloc(130);
        if (errorMessage == NULL) {
            @throw [NSException outOfMemoryException];
        }
        ERR_error_string(errorCode, errorMessage);
        errorDescription = [NSString stringWithFormat:@"OpenSSL internal error! (Code=%lu,Description=%s)", errorCode, errorMessage];
        free(errorMessage);
    }
    
    return [NSError errorWithDomain:MIHOpenSSLErrorDomain
                               code:(NSUInteger)errorCode
                           userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSException (MIHCrypto)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    NSString *errorDescription = [NSString stringWithFormat:@"OpenSLL internal error! (Code=%lu,Description=%s)",
                                  errorCode, errorMessage];
    
    NSException *instance =[NSException exceptionWithName:MIHCryptoException
                                                   reason:[NSString stringWithFormat:@"[OpenSSL] ERROR: %s", errorMessage]
                                                 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    free(errorMessage);
    return instance;
}

+ (instancetype)outOfMemoryException
{
    return [NSException exceptionWithName:MIHCryptoException reason:@"Not enough memory to decrypt." userInfo:nil];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHSeedPseudeRandomNumberGenerator
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void MIHSeedPseudeRandomNumberGenerator(void)
{
    if (!RAND_status()) {
        // This should never occur, but just for the case that there would be some situation where the operating system,
        // doesn't provide a /dev/urandom.
        [NSException exceptionWithName:MIHNotSeededException
                                reason:@"You can't use pseudo-random number generators without seeding them first. (This is job of the operating system thought.)"
                              userInfo:nil];
    }
}