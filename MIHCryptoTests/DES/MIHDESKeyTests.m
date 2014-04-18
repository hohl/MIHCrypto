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

#import "MIHDESKey.h"
#import <XCTest/XCTest.h>

@interface MIHDESKeyTests : XCTestCase

@property (strong, nonatomic) MIHDESKey *desKey1;
@property (strong, nonatomic) MIHDESKey *tripleDesKey1;
@property (strong, nonatomic) NSData *messageData;
@property (strong, nonatomic) NSData *cipherData;
@property (strong, nonatomic) NSData *tripleCipherData;
@property (strong, nonatomic) NSString *key1StringValue;
@property (strong, nonatomic) NSData *key1DataValue;
@property (strong, nonatomic) NSString *tripleDESKey1StringValue;
@property (strong, nonatomic) NSData *tripleDESKey1DataValue;
@property (strong, nonatomic) NSData *key1;
@property (strong, nonatomic) NSData *tripleKey1;
@property (strong, nonatomic) NSData *iv1;

@end

@implementation MIHDESKeyTests

- (void)setUp {
    const unsigned char kMessageBytes[] = {
        0x00, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x4D, 0x72, 0x2E, 0x20, 0x48, 0x6F, 0x68, 0x6C, 0x21, 0x0A
    };
    // Test data create via OpenSSL command line tool:
    // $ openssl enc -d -des-cbc -K e7eea56886400300 -iv 0400ae77400a3333 -in message.txt -out cipher.des
    const unsigned char kChiperBytes[] = {
        0x6c, 0x1d, 0x08, 0xe5, 0xdb, 0x46, 0xfc, 0xce, 0x61, 0x30, 0x19, 0x44, 0xe3, 0xdf, 0x87, 0x2f,
        0x85, 0xf2, 0xd7, 0xbd, 0xba, 0xf9, 0xef, 0x62
    };
    // Test data create via OpenSSL command line tool:
    // $ openssl enc -d -des-ede-cbc -K e7eea568864003aabeef13371337ab00 -iv 0400ae77400a3333 -in message.txt -out cipher.des3
    const unsigned char kTripleChiperBytes[] = {
        0x15, 0xa7, 0x4f, 0x29, 0x34, 0xc5, 0xde, 0x03, 0x68, 0x19, 0x46, 0xff, 0xc5, 0xc4, 0x05, 0x37,
        0x89, 0x38, 0x6e, 0xcd, 0x4f, 0xcd, 0xce, 0x6f
    };
    const unsigned char kKey1Bytes[] = {
        0xE7, 0xEE, 0xA5, 0x68, 0x86, 0x40, 0x03, 0x00
    };
    const unsigned char kTripleDESKey1Bytes[] = {
        0xE7, 0xEE, 0xA5, 0x68, 0x86, 0x40, 0x03, 0xAA, 0xBE, 0xEF, 0x13, 0x37, 0x13, 0x37, 0xAB, 0x00
    };
    const unsigned char kIv1Bytes[] = {
        0x04, 0x00, 0xAE, 0x77, 0x40, 0x0A, 0x33, 0x33
    };
    
    self.messageData = [NSData dataWithBytes:kMessageBytes length:16];
    self.cipherData = [NSData dataWithBytes:kChiperBytes length:24];
    self.tripleCipherData = [NSData dataWithBytes:kTripleChiperBytes length:24];
    self.key1StringValue = @"key=e7eea56886400300,iv=0400ae77400a3333,mode=des-cbc";
    self.tripleDESKey1StringValue = @"key=e7eea568864003aabeef13371337ab00,iv=0400ae77400a3333,mode=des-ede-cbc";
    self.key1DataValue = [self.key1StringValue dataUsingEncoding:NSUTF8StringEncoding];
    self.tripleDESKey1DataValue = [self.tripleDESKey1StringValue dataUsingEncoding:NSUTF8StringEncoding];
    self.key1 = [NSData dataWithBytes:kKey1Bytes length:8];
    self.tripleKey1 = [NSData dataWithBytes:kTripleDESKey1Bytes length:16];
    self.iv1 = [NSData dataWithBytes:kIv1Bytes length:8];
    self.desKey1 = [[MIHDESKey alloc] initWithKey:self.key1 iv:self.iv1 mode:MIHDESModeCBC];
    self.tripleDesKey1 = [[MIHDESKey alloc] initWithKey:self.tripleKey1 iv:self.iv1 mode:MIHDESModeTriple2CBC];
}

- (void)testEncryption
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [self.desKey1 encrypt:self.messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    XCTAssertEqualObjects(self.cipherData, encryptedData);
}

- (void)testDecryption
{
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.desKey1 decrypt:self.cipherData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(self.messageData, decryptedData);
}

- (void)testTripleEncryption
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [self.tripleDesKey1 encrypt:self.messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    XCTAssertEqualObjects(self.tripleCipherData, encryptedData);
}

- (void)testTripleDecryption
{
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.tripleDesKey1 decrypt:self.tripleCipherData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(self.messageData, decryptedData);
}

- (void)testLoadingKeyData {
    MIHDESKey *desKey = [[MIHDESKey alloc] initWithData:self.key1DataValue];
    XCTAssertEqualObjects(self.key1, desKey.key);
    XCTAssertEqualObjects(self.iv1, desKey.iv);
}

- (void)testDataString {
    XCTAssertEqualObjects(self.key1StringValue, self.desKey1.stringValue);
}

- (void)testDataValue {
    XCTAssertEqualObjects(self.key1DataValue, self.desKey1.dataValue);
}

- (void)testPreventInit {
    XCTAssertThrows([[MIHDESKey alloc] init], "[[MIHDESKey alloc] init] is not intentend for use and should throw an exception!");
}

- (void)testEquality {
    MIHDESKey *keyA = [[MIHDESKey alloc] initWithKey:self.key1 iv:self.iv1 mode:MIHDESModeCBC];
    MIHDESKey *keyB = [[MIHDESKey alloc] initWithKey:self.key1 iv:self.iv1 mode:MIHDESModeCBC];
    XCTAssertEqualObjects(keyA, keyB);
    MIHDESKey *keyC = [[MIHDESKey alloc] initWithKey:self.iv1 iv:self.iv1 mode:MIHDESModeCBC];
    XCTAssertNotEqualObjects(keyA, keyC);
    XCTAssertNotEqualObjects(keyB, keyC);
}

- (void)testCopy {
    MIHDESKey *copy = [self.desKey1 copy];
    XCTAssertNotEqual(self.desKey1, copy);
    XCTAssertEqualObjects(self.desKey1, copy);
}

@end
