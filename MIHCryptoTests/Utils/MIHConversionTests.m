//
// Created by Michael Hohl on 25.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+MIHConversion.h"
#import "NSData+MIHConversion.h"

@interface MIHConversionTests : XCTestCase
@end

@implementation MIHConversionTests

- (void)testLowerCaseHexString {
    NSString *hexString = @"e45564af";
    char expectedBytes[] = {0xE4, 0x55, 0x64, 0xAF};
    NSData *expectedHexData = [[NSData alloc] initWithBytes:(const void *)expectedBytes length:4];

    NSData *outputData = [hexString MIH_dataFromHexadecimal];

    XCTAssertEqualObjects(expectedHexData, outputData);
}

- (void)testUpperCaseHexString {
    NSString *hexString = @"13BEEF37";
    char expectedBytes[] = {0x13, 0xBE, 0xEF, 0x37};
    NSData *expectedHexData = [[NSData alloc] initWithBytes:(const void *)expectedBytes length:4];

    NSData *outputData = [hexString MIH_dataFromHexadecimal];

    XCTAssertEqualObjects(expectedHexData, outputData);
}

- (void)testZeroHexString {
    NSString *hexString = @"000000";
    char expectedBytes[] = {0x00, 0x00, 0x00};
    NSData *expectedHexData = [[NSData alloc] initWithBytes:(const void *)expectedBytes length:3];

    NSData *outputData = [hexString MIH_dataFromHexadecimal];

    XCTAssertEqualObjects(expectedHexData, outputData);
}

- (void)testAnyData {
    char anyBytes[] = {0xF8, 0x00, 0x00, 0x37};
    NSData *anyData = [[NSData alloc] initWithBytes:(const void *)anyBytes length:4];
    NSString *expectedHexString = @"f8000037";

    NSString *hexString = [anyData MIH_hexadecimalString];

    XCTAssertEqualObjects(expectedHexString, [hexString lowercaseString]);
}

@end