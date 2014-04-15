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
#import "MIHSecureHashAlgorithm512.h"
#import "NSData+MIHConversion.h"

@interface MIHSecureHashAlgorithm512Tests : XCTestCase
@property (strong) MIHSecureHashAlgorithm512 *hashAlgorithm;
@end

@implementation MIHSecureHashAlgorithm512Tests

- (void)setUp
{
    self.hashAlgorithm = [[MIHSecureHashAlgorithm512 alloc] init];
}

- (void)testHashShortMessage
{
    NSString *input = @"Hello World!";
    NSString *expectedOutput = @"861844d6704e8573fec34d967e20bcfef3d424cf48be04e6dc08f2bd58c729743371015ead891cc3cf1c9d34b49264b510751b1ff9e537937bc46b5d6ff4ecc8";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashLongText
{
    NSString *input = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    NSString *expectedOutput = @"9b75ddb74674b45ab738f84f73ef25c833d7d33d7c72d2556f13274d753259187386bf91dadf8e6a735e6111d703d3ffbabf64d827aaec64d5c6c33259260ce9";
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [self.hashAlgorithm hashValueOfData:inputData];
    NSString *output = [outputData MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutput, output);
}

- (void)testHashNil
{
    NSString *expectedOutputForNil = @"cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e";
    
    NSData *outputDataForNil = [self.hashAlgorithm hashValueOfData:nil];
    NSString *outputForNil = [outputDataForNil MIH_hexadecimalString];
    
    XCTAssertEqualObjects(expectedOutputForNil, outputForNil);
}

@end