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