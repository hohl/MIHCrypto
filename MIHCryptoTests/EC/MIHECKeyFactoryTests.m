//
//  MIHECKeyFactoryTests.m
//  MIHCryptoTests
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHECCurveGroup.h"
#import "MIHECKeyFactory.h"
#import "MIHKeyPair.h"

@interface MIHECKeyFactoryTests : XCTestCase

@end

@implementation MIHECKeyFactoryTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGenerateKeyPair {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // By curve.
    __auto_type curves = [MIHECCurves curves];
    XCTAssertNotNil(curves);
    __auto_type curve = [[MIHECCurves new] curveBySize:MIHECCurvesSizes.size256];
    XCTAssertNotNil(curve);
    __auto_type keyPair = [[MIHECKeyFactory new] generateKeyPairWithCurve:curve];
    XCTAssertNotNil(keyPair.public);
    XCTAssertNotNil(keyPair.private);
}

@end
