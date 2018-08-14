//
//  MIHECPublicKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPublicKey.h"


@implementation MIHECPublicKey

@end

#import "MIHPublicKey.h"
@implementation MIHECPublicKey (MIHPublicKey)
- (NSData *)encrypt:(NSData *)message error:(NSError *__autoreleasing *)error { return nil; }
- (NSData *)decrypt:(NSData *)cipher error:(NSError *__autoreleasing *)error { return nil; }
- (BOOL)verifySignatureWithMD5:(NSData *)signature message:(NSData *)message {
    return NO;
}
- (BOOL)verifySignatureWithSHA128:(NSData *)signature message:(NSData *)message {
    return NO;
}
- (BOOL)verifySignatureWithSHA256:(NSData *)signature message:(NSData *)message {
    return NO;
}
@end
