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

- (void)testEncodeBase64 {
    NSData *decodedInputString = [@"Guten Tag, Herr Hohl!" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *outputString = [decodedInputString MIH_base64EncodedString];
    
    NSString *expectedEncodedString = @"R3V0ZW4gVGFnLCBIZXJyIEhvaGwh";
    XCTAssertEqualObjects(expectedEncodedString, outputString);
}

- (void)testEncodeBase64Wrapped {
    NSData *decodedInputString = [@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor "
                                  "invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam "
                                  "et justo duo dolores et ea rebum." dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *outputString = [decodedInputString MIH_base64EncodedStringWithWrapWidth:64];
    
    NSString *expectedEncodedString = @"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNldGV0dXIgc2FkaXBzY2lu\r\n"
                                       "ZyBlbGl0ciwgc2VkIGRpYW0gbm9udW15IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQg\r\n"
                                       "dXQgbGFib3JlIGV0IGRvbG9yZSBtYWduYSBhbGlxdXlhbSBlcmF0LCBzZWQgZGlh\r\n"
                                       "bSB2b2x1cHR1YS4gQXQgdmVybyBlb3MgZXQgYWNjdXNhbSBldCBqdXN0byBkdW8g\r\n"
                                       "ZG9sb3JlcyBldCBlYSByZWJ1bS4=";
    XCTAssertEqualObjects(expectedEncodedString, outputString);
}

- (void)testDecodeBase64 {
    NSString *encodedInputString = @"R3V0ZW4gVGFnLCBIZXJyIEhvaGwh";
    
    NSData *outputData = [NSData MIH_dataByBase64DecodingString:encodedInputString];
    
    NSData *expectedDecodedString = [@"Guten Tag, Herr Hohl!" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedDecodedString, outputData);
}

@end