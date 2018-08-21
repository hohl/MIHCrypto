//
//  MIHECSignature.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECSignature.h"
#import "MIHNSDataExtension.h"
@interface MIHECSignature ()
@property (assign, nonatomic, readwrite) ECDSA_SIG *signature;
@end

@implementation MIHECSignature
- (instancetype)initWithSignature:(ECDSA_SIG *)signature {
    if (signature == NULL) {
        return nil;
    }
    
    if (self = [super init]) {
        self.signature = signature;
    }
    
    return self;
}

- (void)dealloc {
    if (self.signature) {
        ECDSA_SIG_free(self.signature);
    }
}
@end

@implementation MIHECSignature (Conversion)
+ (ECDSA_SIG *)signatureFromData:(NSData *)data {
    __auto_type dataBytesCount = data.length;
    const unsigned char *bytes = [MIHNSDataExtension bytesFromData:data];
    if (bytes == NULL) {
        return NO;
    }
    
    ECDSA_SIG *signature = NULL;
    d2i_ECDSA_SIG(&signature, &bytes, dataBytesCount);
    // check for NULL
    return signature;
}
+ (NSData *)dataFromSignature:(ECDSA_SIG *)signature {
    __auto_type bytesCount = i2d_ECDSA_SIG(signature, NULL);
    unsigned char *bytes = calloc(bytesCount, sizeof(unsigned char));
    
    i2d_ECDSA_SIG(signature, &bytes);
    if (bytes == nil) {
        return nil;
    }
    
    return [NSData dataWithBytes:bytes length:bytesCount];
}

- (ECDSA_SIG *)signatureFromData:(NSData *)data { return [self.class signatureFromData:data]; }
- (NSData *)dataFromSignature:(ECDSA_SIG *)signature { return [self.class dataFromSignature:signature]; }
@end

@implementation MIHECSignature (MIHCoding)

- (NSData *)dataValue {
    if (self.signature == NULL) {
        return nil;
    }
    
    return [self dataFromSignature:self.signature];
}

- (instancetype)initWithData:(NSData *)dataValue {
    __auto_type signature = [self.class signatureFromData:dataValue];
    return [self initWithSignature:signature];
}

@end
