//
//  MIHECDigest.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIHECDigest__Constants : NSObject
@property (copy, nonatomic, readonly, class) NSNumber *sha1;
@property (copy, nonatomic, readonly, class) NSNumber *sha224;
@property (copy, nonatomic, readonly, class) NSNumber *sha256;
@property (copy, nonatomic, readonly, class) NSNumber *sha384;
@property (copy, nonatomic, readonly, class) NSNumber *sha512;
@end

@interface MIHECDigest : NSObject
- (instancetype)initWithLength:(NSNumber *)length;
- (NSData *)applyToString:(NSString *)string;
- (NSData *)apply:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
