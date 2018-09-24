//
//  MIHNSDataExtension.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHNSDataExtension.h"

@interface MIHNSDataExtension (InstanceMethods)
- (unsigned char *)bytesFromData:(NSData *)data;
- (NSData *)dataFromBytes:(unsigned char *)bytes length:(NSUInteger)length;
@end

@implementation MIHNSDataExtension

+ (unsigned char *)bytesFromData:(NSData *)data {
    return [[self new] bytesFromData:data];
}

+ (NSData *)dataFromBytes:(unsigned char *)bytes length:(NSUInteger)length {
    return [[self new] dataFromBytes:bytes length:length];
}

- (unsigned char *)bytesFromData:(NSData *)data {
    __auto_type bytesCount = data.length;
    if (bytesCount == 0) {
        return NULL;
    }
    
    __auto_type buffer = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    [data getBytes:buffer length:bytesCount];
    return buffer;
}

- (NSData *)dataFromBytes:(unsigned char *)bytes length:(NSUInteger)length {
    if (bytes == NULL) {
        return nil;
    }
    
    return [[NSData alloc] initWithBytes:bytes length:length];
}

@end
