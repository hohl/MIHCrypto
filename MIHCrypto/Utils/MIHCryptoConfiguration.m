//
//  MIHCryptoConfig.m
//  MIHCrypto
//
//  Created by Michael Hohl on 18.04.14.
//  Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHCryptoConfiguration.h"
#import "MIHErrors.h"
#include <openssl/conf.h>
#include <openssl/err.h>
#include <openssl/evp.h>

@implementation MIHCryptoConfiguration

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        ERR_load_crypto_strings();
        OpenSSL_add_all_algorithms();
    }
    return self;
}

- (void)dealloc
{
    EVP_cleanup();
    ERR_free_strings();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHCryptoConfiguration
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (instancetype)defaultConfig
{
    static MIHCryptoConfiguration *DefaultConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefaultConfig = [[MIHCryptoConfiguration alloc] init];
    });
    return DefaultConfig;
}

- (void)load:(NSString *)configFilePath
{
    if (!configFilePath) {
        OPENSSL_no_config();
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]) {
        NSString *reason = [NSString stringWithFormat:@"OpenSSL configuration file %@ not found!", configFilePath];
        @throw [NSException exceptionWithName:MIHCryptoException reason:reason userInfo:nil];
    }
    
    OPENSSL_config([configFilePath cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
