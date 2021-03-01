//
//  MIHECPrivateKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPrivateKey.h"
#import "MIHECKey.h"

@interface MIHECPrivateKey () @end
@implementation MIHECPrivateKey @end

@implementation MIHECPrivateKey (KeyConversion)
- (NSData *)dataFromKey:(MIHECKey *)key {
    if (key == nil) {
        return nil;
    }
    
    __auto_type bytesCount = i2d_ECPrivateKey(key.key, NULL);
    if (bytesCount == 0) {
        return nil;
    }
    
    __auto_type bytes = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    i2d_ECPrivateKey(key.key, &bytes);
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
    d2i_ECPrivateKey(&key, &bytes, bytesCount);
    
    return [[MIHECKey alloc] initWithKey:key];
}
@end

#import "MIHNSDataExtension.h"
#import "MIHECSignature.h"
#import <OpenSSL/OpenSSL.h>
@implementation MIHECPrivateKey (MIHPrivateKey)

- (NSData *)encrypt:(NSData *)message error:(NSError *__autoreleasing *)error { return nil; }
- (NSData *)decrypt:(NSData *)cipher error:(NSError *__autoreleasing *)error { return nil; }

#pragma mark - OpenSSL Definition
- (NSData *)signMessage:(NSData *)message error:(NSError *__autoreleasing *)error {
    const unsigned char *digest = [MIHNSDataExtension bytesFromData:message];
    __auto_type digestLength = message.length;
    if (digest == NULL) {
        return nil;
    }
    
    // note: sig must point to ECDSA_size(eckey) bytes of memory
    unsigned char *signature = malloc(ECDSA_size(self.key.key));
    unsigned int signatureSize = 0;
    
    if (ECDSA_sign(0, digest, digestLength, signature, &signatureSize, self.key.key) == 0) {
        return nil;
    }
    
//    __auto_type signatureBytes = realloc(signature, signatureSize);
    __auto_type result = [[NSData alloc] initWithBytes:signature length:signatureSize];
    return result;
//    // convert signature to data
//    // maybe use another class for this.
//    // yes, we need signature object.
//    __auto_type signature = ECDSA_do_sign(digest, digestLength, self.key.key);
//    if (signature == NULL) {
//        return nil;
//    }
//
//    __auto_type theSignature = [[MIHECSignature alloc] initWithSignature:signature];
//    __auto_type result = theSignature.dataValue;
//    return result;
}

- (MIHECSignature *)theSignMessage:(NSData *)message error:(NSError *__autoreleasing *)error {
    const unsigned char *digest = [MIHNSDataExtension bytesFromData:message];
    __auto_type digestLength = message.length;
    if (digest == NULL) {
        return nil;
    }
    
    // convert signature to data
    // maybe use another class for this.
    // yes, we need signature object.
    __auto_type signature = ECDSA_do_sign(digest, digestLength, self.key.key);
    if (signature == NULL) {
        return nil;
    }
    
    __auto_type theSignature = [[MIHECSignature alloc] initWithSignature:signature];
    return theSignature;
}

#pragma mark -

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
