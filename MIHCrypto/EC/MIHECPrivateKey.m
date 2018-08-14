//
//  MIHECPrivateKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPrivateKey.h"

@implementation MIHECPrivateKey

@end

@implementation MIHECPrivateKey (MIHPrivateKey)

- (NSData *)encrypt:(NSData *)message error:(NSError *__autoreleasing *)error { return nil; }
- (NSData *)decrypt:(NSData *)cipher error:(NSError *__autoreleasing *)error { return nil; }

- (NSData *)signWithMD5:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

- (NSData *)signWithSHA128:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

- (NSData *)signWithSHA256:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

@end
