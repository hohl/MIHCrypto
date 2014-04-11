//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHRSAKeyFactory.h"
#import "MIHKeyPair.h"

@interface MIHRSAKeyFactoryTests : XCTestCase
@property(strong) MIHRSAKeyFactory *rsaKeyFactory;
@end

@implementation MIHRSAKeyFactoryTests

- (void)setUp
{
    self.rsaKeyFactory = [[MIHRSAKeyFactory alloc] init];
}

- (void)testRandomKeyGeneration
{
    MIHKeyPair *keyPair1 = [self.rsaKeyFactory generateKeyPair];
    XCTAssertNotNil(keyPair1.private);
    XCTAssertNotNil(keyPair1.public);
    MIHKeyPair *keyPair2 = [self.rsaKeyFactory generateKeyPair];
    XCTAssertNotNil(keyPair2.private);
    XCTAssertNotNil(keyPair2.public);
    XCTAssertNotEqualObjects(keyPair1, keyPair2);

}

@end