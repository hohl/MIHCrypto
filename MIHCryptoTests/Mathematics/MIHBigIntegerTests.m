//
//  MIHBigIntegerTests.m
//  MIHCrypto
//
//  Created by Michael Hohl on 08.05.14.
//  Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "MIHBigInteger.h"
#import <XCTest/XCTest.h>

@interface MIHBigIntegerTests : XCTestCase
@end

@implementation MIHBigIntegerTests

- (void)testZero
{
    MIHBigInteger *zeroBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:0ul];
    XCTAssert([zeroBigInteger isZero]);
    XCTAssert(![zeroBigInteger isOne]);
    XCTAssert(![zeroBigInteger isOdd]);
}

- (void)testOne
{
    MIHBigInteger *oneBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:1ul];
    XCTAssert(![oneBigInteger isZero]);
    XCTAssert([oneBigInteger isOne]);
    XCTAssert([oneBigInteger isOdd]);
}

- (void)testDecimalStringValue
{
    MIHBigInteger *bigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:12345ul];
    XCTAssertEqualObjects(bigInteger.decimalStringValue, @"12345");
}

- (void)testHexStringValue
{
    MIHBigInteger *bigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:12345ul];
    XCTAssertEqualObjects(bigInteger.hexStringValue, @"3039");
}

- (void)testAdd
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:1234567ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:11ul];
    id<MIHNumber> result = [someBigInteger add:anotherBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"1234578"]);
}

- (void)testAddModulo
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:7ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:12ul];
    MIHBigInteger *modulusBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:13ul];
    id<MIHNumber> result = [someBigInteger add:anotherBigInteger modulo:modulusBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"6"]);
}

- (void)testSubtract
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:1000000001ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:999999994ul];
    id<MIHNumber> result = [someBigInteger subtract:anotherBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"7"]);
}

- (void)testMultiply
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456789ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456ul];
    MIHBigInteger *expectedResultBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"15241481342784"];
    id<MIHNumber> result = [someBigInteger multiply:anotherBigInteger];
    XCTAssert([result isEqualToNumber:expectedResultBigInteger]);
}

- (void)testMultiplyModulo
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456789ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456ul];
    MIHBigInteger *modulusBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:13ul];
    id<MIHNumber> result = [someBigInteger multiply:anotherBigInteger modulo:modulusBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"8"]);
}

- (void)testDivide
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456789ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456ul];
    id<MIHNumber> result = [someBigInteger divide:anotherBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"1000"]);
}

- (void)testModulo
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456789ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:123456ul];
    id<MIHNumber> result = [someBigInteger modulo:anotherBigInteger];
    XCTAssert([result.decimalStringValue isEqualToString:@"789"]);
}

- (void)testPower
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:2ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:10ul];
    MIHBigInteger *expectedResultBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:1024ul];
    id<MIHNumber> result = [someBigInteger power:anotherBigInteger];
    XCTAssert([result isEqualToNumber:expectedResultBigInteger]);
}

- (void)testPowerModulo
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:2ul];
    MIHBigInteger *anotherBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:10ul];
    MIHBigInteger *modulusBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:9ul];
    MIHBigInteger *expectedResultBigInteger = [[MIHBigInteger alloc] initWithUnsignedInteger:7ul];
    id<MIHNumber> result = [someBigInteger power:anotherBigInteger modulo:modulusBigInteger];
    XCTAssert([result isEqualToNumber:expectedResultBigInteger]);
}

- (void)testSquareroot
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"123456"];
    id<MIHNumber> result = [someBigInteger square];
    XCTAssert([result.decimalStringValue isEqualToString:@"15241383936"]);
}

- (void)testMIHCoding
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"123456"];
    MIHBigInteger *sameBigInteger = [[MIHBigInteger alloc] initWithData:someBigInteger.dataValue];
    XCTAssertEqualObjects(someBigInteger, sameBigInteger);
}

- (void)testNSCoding
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"11111111"];
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:someBigInteger];
    MIHBigInteger *sameBigInteger = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    XCTAssertEqualObjects(someBigInteger, sameBigInteger);
}

- (void)testGreaterThan
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"345"];
    MIHBigInteger *sameBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"345"];
    MIHBigInteger *lessBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"340"];
    MIHBigInteger *greaterBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"350"];
    XCTAssert(![someBigInteger isGreaterThanNumber:sameBigInteger]);
    XCTAssert([someBigInteger isGreaterThanNumber:lessBigInteger]);
    XCTAssert(![someBigInteger isGreaterThanNumber:greaterBigInteger]);
}

- (void)testLessThan
{
    MIHBigInteger *someBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"12345678"];
    MIHBigInteger *sameBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"12345678"];
    MIHBigInteger *lessBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"1234567"];
    MIHBigInteger *greaterBigInteger = [[MIHBigInteger alloc] initWithDecimalStringValue:@"123456789"];
    XCTAssert(![someBigInteger isLessThanNumber:sameBigInteger]);
    XCTAssert(![someBigInteger isLessThanNumber:lessBigInteger]);
    XCTAssert([someBigInteger isLessThanNumber:greaterBigInteger]);
}

@end
