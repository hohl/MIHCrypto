//
//  MIHECPublicKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPublicKey.h"
#import "MIHECKey.h"

@interface MIHECPublicKey () @end
@implementation MIHECPublicKey @end

@implementation MIHECPublicKey (KeyConversion)
- (NSData *)dataFromKey:(MIHECKey *)key {
    if (key == nil) {
        return nil;
    }
    
    __auto_type bytesCount = i2d_ECParameters(key.key, NULL);
    if (bytesCount == 0) {
        return nil;
    }
    
    __auto_type bytes = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    i2o_ECPublicKey(key.key, &bytes);
    if (bytes == NULL) {
        return nil;
    }
    
    __auto_type data = [[NSData alloc] initWithBytes:bytes length:bytesCount];
    return data;
}

- (MIHECKey *)keyFromData:(NSData *)data {
    __auto_type bytesCount = data.length;
    
    if (bytesCount == 0) {
        return nil;
    }
    
    __auto_type bytes = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    [data getBytes:bytes length:bytesCount];
    
    if (bytes == NULL) {
        return nil;
    }
    
    EC_KEY *key = NULL;
    o2i_ECPublicKey(&key, &bytes, bytesCount);
    
    return [[MIHECKey alloc] initWithKey:key];
}
@end

#import "MIHNSDataExtension.h"
#import "MIHECSignature.h"
@implementation MIHECPublicKey (MIHPublicKey)
- (NSData *)encrypt:(NSData *)message error:(NSError *__autoreleasing *)error { return nil; }
- (NSData *)decrypt:(NSData *)cipher error:(NSError *__autoreleasing *)error { return nil; }

- (BOOL)verifySignature:(NSData *)signature message:(NSData *)message {
    const unsigned char *digest = [MIHNSDataExtension bytesFromData:message];
    __auto_type digestLength = message.length;
    if (digest == NULL) {
        return NO;
    }

    __auto_type theSignature = [[MIHECSignature alloc] initWithData:signature];
    if (theSignature == nil) {
        return NO;
    }
    
    __auto_type status = ECDSA_do_verify(digest, digestLength, theSignature.signature, self.key.key);
    switch (status) {
        case 1: return YES;
        case 0: return NO;
        case -1: return NO; // error, special handling
        default: return NO;
    }
}

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
