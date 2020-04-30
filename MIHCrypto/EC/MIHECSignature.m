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

#import <openssl/err.h>
@implementation MIHECSignature (Conversion)
+ (ECDSA_SIG *)signatureFromData:(NSData *)data {
    __auto_type dataBytesCount = data.length;
    const unsigned char *bytes = [MIHNSDataExtension bytesFromData:data];
    if (bytes == NULL) {
        return NULL;
    }
    
    ECDSA_SIG *signature = NULL;
    signature = d2i_ECDSA_SIG(&signature, &bytes, dataBytesCount);
    
    return signature;
}
+ (NSData *)trimmingZeros:(unsigned char *)bytes length:(NSUInteger)length {
    __auto_type start = bytes;
    __auto_type finish = bytes + length;
    while (*start == 0 && start != finish) {
        start++;
    }
    while (*finish == 0 && start != finish) {
        finish++;
    }
    
    __auto_type begin = start;
    __auto_type newLength = 0;
    while (start != finish) {
        newLength++;
        start++;
    }
    __auto_type result = [[NSData alloc] initWithBytes:begin length:newLength];
    return result;
}
+ (NSData *)dataFromSignature:(ECDSA_SIG *)signature {
    __auto_type bytesCount = i2d_ECDSA_SIG(signature, NULL);
    unsigned char *bytes = calloc(bytesCount, sizeof(unsigned char));
    
    i2d_ECDSA_SIG(signature, &bytes);
    if (bytes == nil) {
        return nil;
    }
    
    __auto_type result = [NSData dataWithBytes:bytes length:bytesCount];
    return result;
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
