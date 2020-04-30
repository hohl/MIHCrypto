//
//  MIHTestsHelperCertificatesAssetAccessor.h
//  MIHCryptoTests
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIHTestsHelperCertificatesAssetAccessor__AlgorithmNames : NSObject
@property (copy, nonatomic, readonly, class) NSString *es256;
@property (copy, nonatomic, readonly, class) NSString *es384;
@property (copy, nonatomic, readonly, class) NSString *es512;
@end

@interface MIHTestsHelperCertificatesAssetAccessor : NSObject
@property (copy, nonatomic, readwrite) NSString *folder;
- (instancetype)initWithFolder:(NSString *)folder;
- (instancetype)initWithAlgorithmType:(NSString *)type shaSize:(NSNumber *)size;
- (instancetype)initWithAlgorithName:(NSString *)name;
@end

@interface MIHTestsHelperCertificatesAssetAccessor (Validation)
- (instancetype)checked;
- (BOOL)check;
@end

@interface MIHTestsHelperCertificatesAssetAccessor (FolderAccess)
- (NSString *)stringFromFileWithName:(NSString *)name;
- (NSData *)dataFromFileWithName:(NSString *)name;
@end

@interface MIHTestsHelperCertificatesAssetAccessor (Getters)
@property (copy, nonatomic, readonly) NSString *privateKeyBase64;
@property (copy, nonatomic, readonly) NSString *publicKeyBase64;
@property (copy, nonatomic, readonly) NSString *certificateBase64;
@property (copy, nonatomic, readonly) NSData *p12Data;
@property (copy, nonatomic, readonly) NSString *p12Password;
@end

NS_ASSUME_NONNULL_END
