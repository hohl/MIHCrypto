//
//  MIHEC.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHEC.h"
#import "MIHInternal.h"
#import <openssl/err.h>
@implementation MIHEC
+ (void)loadErrors:(BOOL)load {
    // TODO: no need for that!
}
+ (NSError *)getError {
    // TODO: Re-write that that entire class as it does not behave as the rest of the library!
    return [NSError errorFromOpenSSL];
}
@end
