//
//  MIHEC.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHEC.h"
#import <openssl/err.h>
@implementation MIHEC
+ (void)loadErrors:(BOOL)load {
    if (load) {
        //    SSL_load_error_strings();
        ERR_load_crypto_strings();
    }
    else {
        ERR_free_strings();
    }
}
+ (NSError *)getError {
    __auto_type error = ERR_get_error();
    char *buffer[1024];
    __auto_type errorDescription = ERR_error_string(error, &buffer);
    return nil;
}
@end
