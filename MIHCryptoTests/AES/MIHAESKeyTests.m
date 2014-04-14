//
// Created by Michael Hohl on 23.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHAESKey.h"

@interface MIHAESKeyTests : XCTestCase
@end

const unsigned char kMessageBytes[] = {
        0x48, 0x69, 0x20, 0x75, 0x73, 0x65, 0x72, 0x20, 0x67, 0x6F, 0x20, 0x68, 0x6F, 0x6D, 0x65, 0x0A,
        0x48, 0x69, 0x20, 0x75, 0x73, 0x65, 0x72, 0x20, 0x67, 0x6F, 0x20, 0x68, 0x6F, 0x6D, 0x65, 0x0A
};
const unsigned char kChiperBytes[] = {
        0x05, 0xe6, 0xc2, 0xdc, 0x85, 0xdb, 0x41, 0x03, 0x4e, 0xaf, 0xe2, 0xd6, 0x6b, 0x02, 0xaa, 0x74,
        0xd1, 0x41, 0x7b, 0x49, 0x8c, 0xdd, 0x4b, 0xc9, 0x34, 0x55, 0x70, 0x81, 0xb2, 0x02, 0x78, 0x87,
        0xe3, 0x40, 0x30, 0x93, 0x08, 0x0b, 0xd6, 0x37, 0x92, 0x03, 0x94, 0x72, 0x99, 0x23, 0xd1, 0xbb
};
const unsigned char kKey1Bytes[] = {
        0xF5, 0xEE, 0xA5, 0x68, 0x86, 0x40, 0x03, 0x37, 0xF5, 0xEE, 0xA5, 0x68, 0x86, 0x40, 0xEE, 0xEE
};
const unsigned char kIv1Bytes[] = {
        0x04, 0x00, 0xAE, 0x77, 0x40, 0x0A, 0x33, 0x33, 0x33, 0x33, 0xAE, 0x77, 0x40, 0x0A, 0x33, 0x33
};

@implementation MIHAESKeyTests {
    MIHAESKey *_aesKey1;
    NSData *_messageData;
    NSData *_cipherData;
    NSString *_key1StringValue;
    NSData *_key1DataValue;
    NSData *_key1;
    NSData *_iv1;
}

- (void)setUp {
    _messageData = [NSData dataWithBytes:kMessageBytes length:32];
    _cipherData = [NSData dataWithBytes:kChiperBytes length:48];
    _key1StringValue = @"key=f5eea56886400337f5eea5688640eeee,iv=0400ae77400a33333333ae77400a3333";
    _key1DataValue = [_key1StringValue dataUsingEncoding:NSUTF8StringEncoding];
    _key1 = [NSData dataWithBytes:kKey1Bytes length:16];
    _iv1 = [NSData dataWithBytes:kIv1Bytes length:16];
    _aesKey1 = [[MIHAESKey alloc] initWithKey:_key1 iv:_iv1];
}

- (void)testEncryption
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [_aesKey1 encrypt:_messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    XCTAssertEqualObjects(_cipherData, encryptedData);
}

- (void)testDecryption
{
    NSError *decryptionError = nil;
    NSData *decryptedData = [_aesKey1 decrypt:_cipherData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(_messageData, decryptedData);
}

- (void)testLoadingKeyData {
    MIHAESKey *aesKey = [[MIHAESKey alloc] initWithData:_key1DataValue];
    XCTAssertEqualObjects(_key1, aesKey.key);
    XCTAssertEqualObjects(_iv1, aesKey.iv);
}

- (void)testDataString {
    XCTAssertEqualObjects(_key1StringValue, _aesKey1.stringValue);
}

- (void)testDataValue {
    XCTAssertEqualObjects(_key1DataValue, _aesKey1.dataValue);
}

- (void)testPreventInit {
    @try {
        MIHAESKey *unusedKey = [[MIHAESKey alloc] init];
        [unusedKey description]; // Just do something to prevent the unused warning.
        XCTAssert(false, "Exception should get thrown when using [[MIHAESKey alloc] init]!");
    }
    @catch (NSException *e) {
        // expected!
    }
}

- (void)testEquality {
    MIHAESKey *keyA = _aesKey1 = [[MIHAESKey alloc] initWithKey:_key1 iv:_iv1];
    MIHAESKey *keyB = _aesKey1 = [[MIHAESKey alloc] initWithKey:_key1 iv:_iv1];
    XCTAssertEqualObjects(keyA, keyB);
    MIHAESKey *keyC = _aesKey1 = [[MIHAESKey alloc] initWithKey:_iv1 iv:_iv1];
    XCTAssertNotEqualObjects(keyA, keyC);
    XCTAssertNotEqualObjects(keyB, keyC);
}

- (void)testCopy {
    MIHAESKey *copy = [_aesKey1 copy];
    XCTAssertNotEqual(_aesKey1, copy);
    XCTAssertEqualObjects(_aesKey1, copy);
}

@end