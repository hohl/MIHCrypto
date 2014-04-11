//
// Created by Michael Hohl on 09.04.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHSecureHashAlgorithm256.h"
#import "NSData+MIHConversion.h"

@interface MIHSecureHashAlgorithm256Tests : XCTestCase
@property (strong) MIHSecureHashAlgorithm256 *hashAlgorithm;
@end

@implementation MIHSecureHashAlgorithm256Tests

- (void)setUp
{
    self.hashAlgorithm = [[MIHSecureHashAlgorithm256 alloc] init];
}

- (void)testHashShortMessage
{
    NSString *input = @"Hello World!";
    NSString *expectedOutput = @"7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069";

    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];

    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashLongText
{
    NSString *input = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    NSString *expectedOutput = @"ff4ef4245da5b09786e3d3de8b430292fa081984db272d2b13ed404b45353d28";

    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];

    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashNil
{
    NSString *expectedOutputForNil = @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";

    NSData *outputDataForNil = [self.hashAlgorithm hashValueOfData:nil];
    NSString *outputForNil = [outputDataForNil MIH_hexadecimalString];

    XCTAssertEqualObjects(expectedOutputForNil, outputForNil);
}

@end