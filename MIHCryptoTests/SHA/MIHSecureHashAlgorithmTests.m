//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>
#import "MIHSecureHashAlgorithm.h"
#import "NSData+MIHConversion.h"

@interface MIHSecureHashAlgorithmTests : XCTestCase
@property (strong) MIHSecureHashAlgorithm *hashAlgorithm;
@end

@implementation MIHSecureHashAlgorithmTests

- (void)setUp
{
    self.hashAlgorithm = [[MIHSecureHashAlgorithm alloc] init];
}

- (void)testHashShortMessage
{
    NSString *input = @"Hello World!";
    NSString *expectedOutput = @"2ef7bde608ce5404e97d5f042f95f89f1c232871";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashLongText
{
    NSString *input = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    NSString *expectedOutput = @"5bad3910a14b84999677b58528bd3d96500f1f94";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashNil
{
    NSString *expectedOutputForNil = @"da39a3ee5e6b4b0d3255bfef95601890afd80709";
    
    NSData *outputDataForNil = [self.hashAlgorithm hashValueOfData:nil];
    NSString *outputForNil = [outputDataForNil MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutputForNil, outputForNil);
}

@end