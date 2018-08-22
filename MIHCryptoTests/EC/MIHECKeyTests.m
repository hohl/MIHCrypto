//
//  MIHECKeyTests.m
//  MIHCryptoTests
//
//  Created by Dmitry Lobanov on 22.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHECCurveGroup.h"
#import "MIHECKeyFactory.h"
#import "MIHKeyPair.h"
#import "MIHECPrivateKey.h"
#import "MIHECPublicKey.h"
#import "MIHECDigest.h"

@interface MIHECKeyTests : XCTestCase

@end

@implementation MIHECKeyTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSigningAndVerificationFromCurve {
    __auto_type curve = [[MIHECCurves new] curveBySize:MIHECCurvesSizes.size256];
    XCTAssertNotNil(curve);
    __auto_type keyPair = [[MIHECKeyFactory new] generateKeyPairWithCurve:curve];
    XCTAssertNotNil(keyPair.public);
    XCTAssertNotNil(keyPair.private);
    
    __auto_type message = @"very long message that we want to sign later we want to verify it.";
    
    // digest
    __auto_type hashData = [[[MIHECDigest alloc] initWithLength:MIHECDigest__Constants.sha256] applyToString:message];
    XCTAssertNotNil(hashData);
    
    // sign
    __auto_type private = (MIHECPrivateKey *)keyPair.private;
    __auto_type signature = [private theSignMessage:hashData error:NULL];
    XCTAssertNotNil(signature);
    
    // verify
    __auto_type public = (MIHECPublicKey *)keyPair.public;
    __auto_type verified = [public verifyTheSignature:signature message:hashData];
    XCTAssertTrue(verified);
}

- (void)testVerification {
    
}

//- (void)testDescription {
//
//}
//- (void)testDataValue {
//    XCTAssertEqualObjects(self.pub, self.publicKey.dataValue);
//    XCTAssertEqualObjects(self.pem, self.privateKey.dataValue);
//}

@end
