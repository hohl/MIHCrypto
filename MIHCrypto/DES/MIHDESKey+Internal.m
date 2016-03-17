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

#import "MIHDESKey+Internal.h"
#import "MIHErrors.h"

@implementation MIHDESKey (Internal)

+ (const EVP_CIPHER*)cipherForMode:(MIHDESMode)mode error:(NSError *__autoreleasing *)error
{
    switch (mode) {
        case MIHDESModeCBC:
            return EVP_des_cbc();
        case MIHDESModeECB:
            return EVP_des_ecb();
        case MIHDESModeCFB:
            return EVP_des_cfb();
        case MIHDESModeOFB:
            return EVP_des_ofb();
        case MIHDESModeTriple2CBC:
            return EVP_des_ede_cbc();
        case MIHDESModeTriple2ECB:
            return EVP_des_ede_ecb();
        case MIHDESModeTriple2CFB:
            return EVP_des_ede_cfb();
        case MIHDESModeTriple2OFB:
            return EVP_des_ede_ofb();
        case MIHDESModeTriple3CBC:
            return EVP_des_ede3_cbc();
        case MIHDESModeTriple3ECB:
            return EVP_des_ede3_ecb();
        case MIHDESModeTriple3CFB:
            return EVP_des_ede3_cfb();
        case MIHDESModeTriple3OFB:
            return EVP_des_ede3_ofb();
        case MIHDESModeXCBC:
            return EVP_desx_cbc();
        default:
            if (error)
                *error = [NSError errorWithDomain:MIHCryptoErrorDomain
                                             code:MIHCryptoInvalidMode
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%lu is not a valid DES mode!", (unsigned long) mode]}];
            return nil;
    }
}

+ (MIHDESMode)modeFromModeName:(NSString *)modeName
{
    static NSDictionary *kModes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kModes = @{
                   @"des-cbc": [NSNumber numberWithInteger:MIHDESModeCBC],
                   @"des-ecb": [NSNumber numberWithInteger:MIHDESModeECB],
                   @"des-cfb": [NSNumber numberWithInteger:MIHDESModeCFB],
                   @"des-ofb": [NSNumber numberWithInteger:MIHDESModeOFB],
                   @"des-ede-cbc": [NSNumber numberWithInteger:MIHDESModeTriple2CBC],
                   @"des-ede-ecb": [NSNumber numberWithInteger:MIHDESModeTriple2ECB],
                   @"des-ede-cfb": [NSNumber numberWithInteger:MIHDESModeTriple2CFB],
                   @"des-ede-ofb": [NSNumber numberWithInteger:MIHDESModeTriple2OFB],
                   @"des-ede3-cbc": [NSNumber numberWithInteger:MIHDESModeTriple3CBC],
                   @"des-ede3-ecb": [NSNumber numberWithInteger:MIHDESModeTriple3ECB],
                   @"des-ede3-cfb": [NSNumber numberWithInteger:MIHDESModeTriple3CFB],
                   @"des-ede3-ofb": [NSNumber numberWithInteger:MIHDESModeTriple3OFB]
                   };
    });
    return [[kModes objectForKey:modeName] integerValue];
}

+ (NSString *)modeNameForMode:(MIHDESMode)mode
{
    static NSDictionary *kModeNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kModeNames = @{
                       [NSNumber numberWithInteger:MIHDESModeCBC]: @"des-cbc",
                       [NSNumber numberWithInteger:MIHDESModeECB]: @"des-ecb",
                       [NSNumber numberWithInteger:MIHDESModeCFB]: @"des-cfb",
                       [NSNumber numberWithInteger:MIHDESModeOFB]: @"des-ofb",
                       [NSNumber numberWithInteger:MIHDESModeTriple2CBC]: @"des-ede-cbc",
                       [NSNumber numberWithInteger:MIHDESModeTriple2ECB]: @"des-ede-ecb",
                       [NSNumber numberWithInteger:MIHDESModeTriple2CFB]: @"des-ede-cfb",
                       [NSNumber numberWithInteger:MIHDESModeTriple2OFB]: @"des-ede-ofb",
                       [NSNumber numberWithInteger:MIHDESModeTriple3CBC]: @"des-ede3-cbc",
                       [NSNumber numberWithInteger:MIHDESModeTriple3ECB]: @"des-ede3-ecb",
                       [NSNumber numberWithInteger:MIHDESModeTriple3CFB]: @"des-ede3-cfb",
                       [NSNumber numberWithInteger:MIHDESModeTriple3OFB]: @"des-ede3-ofb"
                       };
    });
    return [kModeNames objectForKey:[NSNumber numberWithInteger:mode]];
}

@end
