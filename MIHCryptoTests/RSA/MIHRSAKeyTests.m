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
#import "MIHRSAPublicKey.h"
#import "MIHKeyPair.h"
#import "MIHPrivateKey.h"
#import "MIHRSAPrivateKey.h"
#import "NSData+MIHConversion.h"

@interface MIHRSAKeyTests : XCTestCase
@property(strong) NSData *messageData;
@property(strong) NSData *inalidEncryptedData;
@property(strong) NSString *publicKeyString;
@property(strong) MIHRSAPublicKey *publicKey;
@property(strong) MIHRSAPrivateKey *privateKey;
@property(strong) NSData *pub;
@property(strong) NSData *pem;
@end

@implementation MIHRSAKeyTests

- (void)setUp
{
    self.publicKeyString = @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJma7iWHjLCpeiHHhkwf/IGVtJvrHVW/"
                           "F+te83hB85YiCuAOqvaG7Isy4dYbwBZKkuIq9x+FVZ+6SrsaRQuaFSkCAwEAAQ==";
    self.pub = [NSData MIH_dataByBase64DecodingString:self.publicKeyString];
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
    
    self.inalidEncryptedData = [NSData MIH_dataByBase64DecodingString:@"BdhFH0sd7e9DExiCd50Yk"
                                "h4spm2BX126skjJ1o8HHjKsN+J7r9IoI9kbB9AAacEpJsAfyesiJsq5gDBhQ"
                                "tcNbB6l88aSgPrEoVwR9ilzuzVcv1q3J1dxs4uIEMuhzoWT+R8//dD2jDdXP"
                                "yFsdGWJc10CEizPFKpmy2jWhvU8CVs="];
    self.messageData = [@"Good morning Mr. Hohl!" dataUsingEncoding:NSUTF8StringEncoding];
    self.publicKey = [[MIHRSAPublicKey alloc] initWithData:self.pub];
    self.privateKey = [[MIHRSAPrivateKey alloc] initWithData:self.pem];
}

- (void)testEncryptionWithPublicKeyAndDecryptionWithPrivateKey
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [self.publicKey encrypt:self.messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.privateKey decrypt:encryptedData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(self.messageData, decryptedData);
}

- (void)testEncryptionWithPrivateKeyAndDecryptionWithPublicKey
{
    NSError *encryptionError = nil;
    NSData *encryptedData = [self.privateKey encrypt:self.messageData error:&encryptionError];
    XCTAssertNil(encryptionError);
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.publicKey decrypt:encryptedData error:&decryptionError];
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(self.messageData, decryptedData);
}

- (void)testRsaDefaultPadding
{
    XCTAssertEqual(self.privateKey.rsaPadding, RSA_PKCS1_PADDING);
    XCTAssertEqual(self.publicKey.rsaPadding, RSA_PKCS1_PADDING);
}

- (void)testRsaPaddingChange
{
    self.privateKey.rsaPadding = RSA_PKCS1_OAEP_PADDING;
    XCTAssertEqual(self.privateKey.rsaPadding, RSA_PKCS1_OAEP_PADDING);

    self.publicKey.rsaPadding = RSA_PKCS1_OAEP_PADDING;
    XCTAssertEqual(self.publicKey.rsaPadding, RSA_PKCS1_OAEP_PADDING);

    [self testEncryptionWithPublicKeyAndDecryptionWithPrivateKey];
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

- (void)testSignAndVerifyUsingSHA1
{
    NSError *signingError = nil;
    NSData *signatureData = [self.privateKey signWithSHA128:self.messageData error:&signingError];
    XCTAssertNil(signingError);
    BOOL isVerified = [self.publicKey verifySignatureWithSHA128:signatureData message:self.messageData];
    XCTAssertEqual(YES, isVerified);
}

- (void)testInvalidSignatureUsingSHA1
{
    BOOL isVerified = [self.publicKey verifySignatureWithSHA128:self.messageData message:self.messageData];
    XCTAssertEqual(NO, isVerified);
}

- (void)testDataValue
{
    XCTAssertEqualObjects(self.pub, self.publicKey.dataValue);
    XCTAssertEqualObjects(self.pem, self.privateKey.dataValue);
}

- (void)testDataExceedsModLen
{
    NSError *decryptionError = nil;
    NSData *decryptedData = [self.privateKey decrypt:self.inalidEncryptedData error:&decryptionError];
    XCTAssertNotNil(decryptionError);
    XCTAssertNil(decryptedData);
}

- (void)testDescription
{
    XCTAssertEqualObjects(self.publicKeyString, [self.publicKey description]);
}

- (void)testSignAndVerifyUsingMD5
{
    NSError *signingError = nil;
    NSData *signatureData = [self.privateKey signWithMD5:self.messageData error:&signingError];
    XCTAssertNil(signingError);
    BOOL isVerified = [self.publicKey verifySignatureWithMD5:signatureData message:self.messageData];
    XCTAssertEqual(YES, isVerified);
}

@end