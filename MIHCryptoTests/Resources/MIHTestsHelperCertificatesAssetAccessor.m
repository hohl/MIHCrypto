//
//  MIHTestsHelperCertificatesAssetAccessor.m
//  MIHCryptoTests
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

@import AppKit;
#import "MIHTestsHelperCertificatesAssetAccessor.h"

@implementation MIHTestsHelperCertificatesAssetAccessor__AlgorithmNames
+ (NSString *)es256 { return NSStringFromSelector(_cmd); }
+ (NSString *)es384 { return NSStringFromSelector(_cmd); }
+ (NSString *)es512 { return NSStringFromSelector(_cmd); }
@end

@implementation MIHTestsHelperCertificatesAssetAccessor (FolderAccess)
- (NSString *)stringFromFileWithName:(NSString *)name {
    __auto_type data = [self dataFromFileWithName:name];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)dataFromFileWithName:(NSString *)name {
    __auto_type path = [self.folder stringByAppendingPathComponent:name];
    if (@available(macOS 10.11, *)) {
        __auto_type asset = [[NSDataAsset alloc] initWithName:path bundle:[NSBundle bundleForClass:self.class]];
        __auto_type data = asset.data;
        return data;
    } else {
        return nil;
    }
}
@end

@implementation MIHTestsHelperCertificatesAssetAccessor (Getters)
- (NSString *)privateKeyBase64 {
    return [self stringFromFileWithName:@"private.pem"];
}
- (NSString *)publicKeyBase64 {
    return [self stringFromFileWithName:@"public.pem"];
}
- (NSString *)certificateBase64 {
    return [self stringFromFileWithName:@"certificate.cer"];
}
- (NSData *)p12Data {
    return [self dataFromFileWithName:@"private.p12"];
}
- (NSString *)p12Password {
    return [self stringFromFileWithName:@"p12_password.txt"];
}
@end

@implementation MIHTestsHelperCertificatesAssetAccessor
- (instancetype)initWithFolder:(NSString *)folder {
    if (self = [super init]) {
        self.folder = folder;
        // check that data exists!
        if (!self.check) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithAlgorithmType:(NSString *)type shaSize:(NSNumber *)size {
    return [self initWithFolder:[type stringByAppendingPathComponent:size.description]];
}

+ (NSArray *)typeAndSizeFromAlgorithmName:(NSString *)name {
    if (name.length < 3) {
        return nil;
    }
    __auto_type type = [name substringToIndex:2];
    __auto_type size = [name substringFromIndex:2];
    if (type == nil || size == nil) {
        return nil;
    }
    return @[type, size];
}

- (instancetype)initWithAlgorithName:(NSString *)name {
    return [self initWithFolder:name.lowercaseString];
}
@end

@implementation MIHTestsHelperCertificatesAssetAccessor (Validation)
- (instancetype)checked {
    return self.check ? self : nil;
}
- (BOOL)check {
    return self.privateKeyBase64 != nil;
}
@end
