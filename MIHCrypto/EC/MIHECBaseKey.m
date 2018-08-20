//
//  MIHECBaseKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECBaseKey.h"
#import "MIHECKey.h"

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

@interface MIHECBaseKey ()
@property (strong, nonatomic, readwrite) MIHECKey *key;
@end

@implementation MIHECBaseKey (NSCopying)

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class alloc] initWithKey:[self.key copy]];
}

@end

@implementation MIHECBaseKey
- (instancetype)initWithKey:(MIHECKey *)key {
    if (key == NULL) {
        return nil;
    }
    
    if (self = [super init]) {
        self.key = key;
    }
    return self;
}
@end

@implementation MIHECBaseKey (KeyConversion)
- (NSData *)dataFromKey:(MIHECKey *)key {
    return nil;
}
- (MIHECKey *)keyFromData:(NSData *)data {
    return nil;
}
@end

@interface MIHECBaseKey__Keys : NSObject
@property (copy, nonatomic, readonly, class) NSString *Key;
@end

@implementation MIHECBaseKey__Keys
+ (NSString *)Key { return NSStringFromSelector(_cmd); }
@end

@implementation MIHECBaseKey (NSCoding)
- (void)encodeWithCoder:(NSCoder *)aCoder {
    __auto_type value = [self dataFromKey:self.key];
    if (value == nil) {
        return;
    }
    [aCoder setValue:value forKey:MIHECBaseKey__Keys.Key];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    __auto_type value = (NSData *)[aDecoder valueForKey:MIHECBaseKey__Keys.Key];
    __auto_type key = [self keyFromData:value];
    return [self initWithKey:key];
}
@end

@implementation MIHECBaseKey (MIHCoding)
- (NSData *)dataValue {
    return [self dataFromKey:self.key];
}

- (id)initWithData:(NSData *)dataValue {
    return [self initWithKey:[self keyFromData:dataValue]];
}

@end
