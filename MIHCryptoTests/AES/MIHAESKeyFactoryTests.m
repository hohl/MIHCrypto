//
// Created by Michael Hohl on 25.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHSymmetricKey.h"
#import "MIHAESKeyFactory.h"
#import "MIHAESKey.h"

@interface MIHAESKeyFactoryTests : XCTestCase
@property (strong) MIHAESKeyFactory *aesKeyFactory;
@end

@implementation MIHAESKeyFactoryTests

- (void)setUp
{
    self.aesKeyFactory = [[MIHAESKeyFactory alloc] init];
    self.aesKeyFactory.preferedKeySize = MIHAESKey128;
}

- (void)testGeneratedKeyLength
{
    MIHAESKey *aesKey = [self.aesKeyFactory generateKey];
    XCTAssertEqual(MIHAESKey128, aesKey.key.length);
}

- (void)testRandomKeyGeneration
{
    id<MIHSymmetricKey> key1 = [self.aesKeyFactory generateKey];
    XCTAssertNotNil(key1);
    id<MIHSymmetricKey> key2 = [self.aesKeyFactory generateKey];
    XCTAssertNotNil(key2);
    XCTAssertNotEqualObjects(key1, key2);
}

@end