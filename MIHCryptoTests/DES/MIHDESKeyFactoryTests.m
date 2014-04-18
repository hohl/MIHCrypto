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

#import "MIHDESKeyFactory.h"
#import "MIHDESKey.h"
#import <XCTest/XCTest.h>

@interface MIHDESKeyFactoryTests : XCTestCase
@property (strong) MIHDESKeyFactory *desKeyFactory;
@end

@implementation MIHDESKeyFactoryTests

- (void)setUp
{
    self.desKeyFactory = [[MIHDESKeyFactory alloc] init];
}

- (void)testCBCGeneratedKeyLength
{
    const NSUInteger kExpectedKeyLength = 8;
    self.desKeyFactory.preferedMode = MIHDESModeCBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(kExpectedKeyLength, desKey.key.length);
}

- (void)testtCBCGeneratedKeyMode
{
    self.desKeyFactory.preferedMode = MIHDESModeCBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(MIHDESModeCBC, desKey.mode);
}

- (void)testECBGeneratedKeyLength
{
    const NSUInteger kExpectedKeyLength = 8;
    self.desKeyFactory.preferedMode = MIHDESModeECB;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(kExpectedKeyLength, desKey.key.length);
}

- (void)testtECBGeneratedKeyMode
{
    self.desKeyFactory.preferedMode = MIHDESModeECB;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(MIHDESModeECB, desKey.mode);
}

- (void)testTriple2CBCGeneratedKeyLength
{
    const NSUInteger kExpectedKeyLength = 16;
    self.desKeyFactory.preferedMode = MIHDESModeTriple2CBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(kExpectedKeyLength, desKey.key.length);
}

- (void)testtTriple2CBCGeneratedKeyMode
{
    self.desKeyFactory.preferedMode = MIHDESModeTriple2CBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(MIHDESModeTriple2CBC, desKey.mode);
}

- (void)testTriple3CBCGeneratedKeyLength
{
    const NSUInteger kExpectedKeyLength = 24;
    self.desKeyFactory.preferedMode = MIHDESModeTriple3CBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(kExpectedKeyLength, desKey.key.length);
}

- (void)testtTriple3CBCGeneratedKeyMode
{
    self.desKeyFactory.preferedMode = MIHDESModeTriple3CBC;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(MIHDESModeTriple3CBC, desKey.mode);
}

- (void)testTriple3ECBGeneratedKeyLength
{
    const NSUInteger kExpectedKeyLength = 24;
    self.desKeyFactory.preferedMode = MIHDESModeTriple3ECB;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(kExpectedKeyLength, desKey.key.length);
}

- (void)testtTriple3ECBGeneratedKeyMode
{
    self.desKeyFactory.preferedMode = MIHDESModeTriple3ECB;
    MIHDESKey *desKey = [self.desKeyFactory generateKey];
    XCTAssertEqual(MIHDESModeTriple3ECB, desKey.mode);
}

- (void)testRandomKeyGeneration
{
    id<MIHSymmetricKey> key1 = [self.desKeyFactory generateKey];
    XCTAssertNotNil(key1);
    id<MIHSymmetricKey> key2 = [self.desKeyFactory generateKey];
    XCTAssertNotNil(key2);
    XCTAssertNotEqualObjects(key1, key2);
}

@end
