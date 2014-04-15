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
#import "MIHMessageDigest5.h"
#import "NSData+MIHConversion.h"

@interface MIHMessageDigest5Tests : XCTestCase
@property (strong) MIHMessageDigest5 *hashAlgorithm;
@end

@implementation MIHMessageDigest5Tests

- (void)setUp
{
    self.hashAlgorithm = [[MIHMessageDigest5 alloc] init];
}

- (void)testHashShortMessage
{
    NSString *input = @"Hello World!";
    NSString *expectedOutput = @"ed076287532e86365e841e92bfc50d8c";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashLongText
{
    NSString *input = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    NSString *expectedOutput = @"901736df3fbc807121c46f9eaed8ff28";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashNil
{
    NSString *expectedOutputForNil = @"d41d8cd98f00b204e9800998ecf8427e";
    
    NSData *outputDataForNil = [self.hashAlgorithm hashValueOfData:nil];
    NSString *outputForNil = [outputDataForNil MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutputForNil, outputForNil);
}

@end