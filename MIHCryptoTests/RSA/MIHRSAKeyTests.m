//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIHRSAPublicKey.h"
#import "MIHKeyPair.h"
#import "MIHPrivateKey.h"
#import "MIHRSAPrivateKey.h"

@interface MIHRSAKeyTests : XCTestCase
@property(strong) NSData *messageData;
@property(strong) MIHRSAPublicKey *publicKey;
@property(strong) MIHRSAPrivateKey *privateKey;
@property(strong) NSData *pub;
@property(strong) NSData *pem;
@end

@implementation MIHRSAKeyTests

- (void)setUp
{
    NSString *pubString = @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJma7iWHjLCpeiHHhkwf/IGVtJvrHVW/"
            "F+te83hB85YiCuAOqvaG7Isy4dYbwBZKkuIq9x+FVZ+6SrsaRQuaFSkCAwEAAQ==";
    self.pub = [[NSData alloc] initWithBase64Encoding:pubString];
    NSString *pemString = @"-----BEGIN PRIVATE KEY-----\n"
            "MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAmZruJYeMsKl6IceG\n"
            "TB/8gZW0m+sdVb8X617zeEHzliIK4A6q9obsizLh1hvAFkqS4ir3H4VVn7pKuxpF\n"
            "C5oVKQIDAQABAkApWzJVPmqdwfOVFrBM3KvSg+kNtb6/MGUTRQxOS4t21ybGi2Rn\n"
            "eXU8bucIhUjETTnwgdkRr56/e/C3Mn7BOnq1AiEAyKg/sFruB0be/VW8x4dAuM/V\n"
            "YlOk6TGRXuE2cm4uAysCIQDD+H3ZU9r8P+3+XRxucfa9p1Lf02zuQ5yBqZaq/yHu\n"
            "+wIgeUdP70yWT6mjP6Vhi4uRL+LWSy7ZHuUJwzoGCZXUk68CIQCzo1ZhYG/NaSDV\n"
            "WS7VwxvmD7p1OE6TPmD5rqZRSxwk/wIhAKaDoovCCJuBlVWQlAypZ+PriMqsUHVP\n"
            "Zg54vniNK3Yv\n"
            "-----END PRIVATE KEY-----\n";
    self.pem = [pemString dataUsingEncoding:NSUTF8StringEncoding];

    self.messageData = [@"Good morning Mr. Hohl!" dataUsingEncoding:NSUTF8StringEncoding];
    self.publicKey = [[MIHRSAPublicKey alloc] initWithData:self.pub];
    self.privateKey = [[MIHRSAPrivateKey alloc] initWithData:self.pem];
}

- (void)testEncryptionAndDecryption
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [self.publicKey encrypt:self.messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.privateKey decrypt:encryptedData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(self.messageData, decryptedData);
}

- (void)testSignAndVerify
{
    NSError *signingError = nil;
    NSData *signatureData = [self.privateKey signWithSHA256:self.messageData error:&signingError];
    XCTAssertNil(signingError);
    BOOL isVerified = [self.publicKey verifySignatureWithSHA256:signatureData message:self.messageData];
    XCTAssertEqual(YES, isVerified);
}

- (void)testInvalidSignature
{
    BOOL isVerified = [self.publicKey verifySignatureWithSHA256:self.messageData message:self.messageData];
    XCTAssertEqual(NO, isVerified);
}

- (void)testDataValue
{
    XCTAssertEqualObjects(self.pub, self.publicKey.dataValue);
    XCTAssertEqualObjects(self.pem, self.privateKey.dataValue);
}

@end