//
//  MIHECDigest.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECDigest.h"
#import <OpenSSL/OpenSSL.h>

@implementation MIHECDigest__Constants
+ (NSNumber *)sha1 { return @(SHA_DIGEST_LENGTH); }
+ (NSNumber *)sha224 { return @(SHA224_DIGEST_LENGTH); }
+ (NSNumber *)sha256 { return @(SHA256_DIGEST_LENGTH); }
+ (NSNumber *)sha384 { return @(SHA384_DIGEST_LENGTH); }
+ (NSNumber *)sha512 { return @(SHA512_DIGEST_LENGTH); }
@end

@interface MIHECDigest ()
@property (copy, nonatomic, readwrite) NSNumber *length;
@end

@implementation MIHECDigest
- (instancetype)initWithLength:(NSNumber *)length {
    if (length == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        //
        self.length = length;
    }
    return self;
}

- (NSData *)applyToString:(NSString *)string {
    return [self apply:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSDictionary <NSNumber *, NSData *(^)(NSData *)>*)lengthsAndSHA {
    return @{
             @(SHA_DIGEST_LENGTH): ^(NSData *message){
                 NSUInteger length = SHA_DIGEST_LENGTH;
                 SHA_CTX ctx;
                 unsigned char messageDigest[SHA_DIGEST_LENGTH];
                 if (!SHA1_Init(&ctx)) {
                     return (NSData *)nil;
                 }
                 if (!SHA1_Update(&ctx, message.bytes, message.length)) {
                     return (NSData *)nil;
                 }
                 if (!SHA1_Final(messageDigest, &ctx)) {
                     return (NSData *)nil;
                 }
                 return [[NSData alloc] initWithBytes:&messageDigest length:length];
             },
             @(SHA224_DIGEST_LENGTH): ^(NSData *message){
                 NSUInteger length = SHA224_DIGEST_LENGTH;
                 SHA256_CTX ctx;
                 unsigned char messageDigest[SHA224_DIGEST_LENGTH];
                 if (!SHA224_Init(&ctx)) {
                     return (NSData *)nil;
                 }
                 if (!SHA224_Update(&ctx, message.bytes, message.length)) {
                     return (NSData *)nil;
                 }
                 if (!SHA224_Final(messageDigest, &ctx)) {
                     return (NSData *)nil;
                 }
                 return [[NSData alloc] initWithBytes:&messageDigest length:length];
             },
             @(SHA256_DIGEST_LENGTH): ^(NSData *message){
                 NSUInteger length = SHA256_DIGEST_LENGTH;
                 SHA256_CTX ctx;
                 unsigned char messageDigest[SHA256_DIGEST_LENGTH];
                 if (!SHA256_Init(&ctx)) {
                     return (NSData *)nil;
                 }
                 if (!SHA256_Update(&ctx, message.bytes, message.length)) {
                     return (NSData *)nil;
                 }
                 if (!SHA256_Final(messageDigest, &ctx)) {
                     return (NSData *)nil;
                 }
                 return [[NSData alloc] initWithBytes:&messageDigest length:length];
             },
             @(SHA384_DIGEST_LENGTH): ^(NSData *message){
                 NSUInteger length = SHA384_DIGEST_LENGTH;
                 SHA512_CTX ctx;
                 unsigned char messageDigest[SHA384_DIGEST_LENGTH];
                 if (!SHA384_Init(&ctx)) {
                     return (NSData *)nil;
                 }
                 if (!SHA384_Update(&ctx, message.bytes, message.length)) {
                     return (NSData *)nil;
                 }
                 if (!SHA384_Final(messageDigest, &ctx)) {
                     return (NSData *)nil;
                 }
                 return [[NSData alloc] initWithBytes:&messageDigest length:length];
             },
             @(SHA512_DIGEST_LENGTH): ^(NSData *message){
                 NSUInteger length = SHA512_DIGEST_LENGTH;
                 SHA512_CTX ctx;
                 unsigned char messageDigest[SHA512_DIGEST_LENGTH];
                 if (!SHA512_Init(&ctx)) {
                     return (NSData *)nil;
                 }
                 if (!SHA512_Update(&ctx, message.bytes, message.length)) {
                     return (NSData *)nil;
                 }
                 if (!SHA512_Final(messageDigest, &ctx)) {
                     return (NSData *)nil;
                 }
                 return [[NSData alloc] initWithBytes:&messageDigest length:length];
             }
             };
}

- (NSData *)apply:(NSData *)data length:(NSNumber *)length {
    __auto_type block = [self lengthsAndSHA][length];
    if (block) {
        return block(data);
    }
    return nil;
}

- (NSData *)apply:(NSData *)data {
    return [self apply:data length:self.length];
}
@end
