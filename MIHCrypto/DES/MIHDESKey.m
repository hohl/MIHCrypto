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
#import "MIHDESKey+Internal.h"
#import "NSData+MIHConversion.h"
#import "NSString+MIHConversion.h"
#import "MIHErrors.h"
#import "MIHInternal.h"
#import <openssl/evp.h>

@implementation MIHDESKey
{
    EVP_CIPHER_CTX encryptCtx;
    EVP_CIPHER_CTX decryptCtx;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, NSCoding and NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class MIHAESKey"
                                 userInfo:nil];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _key = [coder decodeObjectForKey:@"_key"];
        _iv = [coder decodeObjectForKey:@"_iv"];
        _mode = [coder decodeIntegerForKey:@"_mode"];
    }
    
    return self;
}

- (id)initWithKey:(NSData *)key iv:(NSData *)iv mode:(MIHDESMode)mode
{
    self = [super init];
    if (self) {
        _key = key;
        _iv = iv;
        _mode = mode;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.key forKey:@"_key"];
    [coder encodeObject:self.iv forKey:@"_iv"];
    [coder encodeInteger:self.mode forKey:@"_mode"];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [(MIHDESKey *)[[self class] allocWithZone:zone] initWithKey:_key iv:_iv mode:_mode];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *components = [dataString componentsSeparatedByString:@","];
        [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger index, BOOL *stop)
         {
             if ([component hasPrefix:@"key="]) {
                 NSString *hexEncodedKey = [component substringFromIndex:4];
                 _key = hexEncodedKey.MIH_dataFromHexadecimal;
             } else if ([component hasPrefix:@"iv="]) {
                 NSString *hexEncodedIv = [component substringFromIndex:3];
                 _iv = hexEncodedIv.MIH_dataFromHexadecimal;
             } else if ([component hasPrefix:@"mode="]) {
                 NSString *modeName = [component substringFromIndex:3];
                 _mode = [MIHDESKey modeFromModeName:modeName];
             }
         }];
    }
    
    return self;
}

- (NSData *)dataValue
{
    return [self.stringValue dataUsingEncoding:NSUTF8StringEncoding];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHSymmetricKey
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSData *)decrypt:(NSData *)cipherData error:(NSError **)error
{
    size_t messageBytesLength = 0;
    size_t blockLength = 0;
    
    unsigned char *messageBytes = (unsigned char *) malloc(cipherData.length);
    if (messageBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }
    
    const EVP_CIPHER *evpCipher = [MIHDESKey cipherForMode:self.mode error:error];
    if (*error) {
        free(messageBytes);
        return nil;
    }
    
    if (!EVP_DecryptInit(&decryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        free(messageBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    
    if (!EVP_DecryptUpdate(&decryptCtx, messageBytes, (int *) &blockLength, cipherData.bytes, (int) cipherData.length)) {
        free(messageBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    messageBytesLength += blockLength;
    
    if (!EVP_DecryptFinal(&decryptCtx, messageBytes + messageBytesLength, (int *) &blockLength)) {
        free(messageBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    messageBytesLength += blockLength;
    
    return [NSData dataWithBytesNoCopy:messageBytes length:messageBytesLength];
}

- (NSData *)encrypt:(NSData *)messageData error:(NSError **)error
{
    size_t blockLength = 0;
    size_t cipherBytesLength = 0;
    
    const EVP_CIPHER *evpCipher = [MIHDESKey cipherForMode:self.mode error:error];
    if (*error) {
        return nil;
    }
    
    int blockSize = EVP_CIPHER_block_size(evpCipher);
    
    unsigned char *cipherBytes = (unsigned char *) malloc(messageData.length + blockSize);
    memset(cipherBytes, 0, messageData.length + blockSize);
    if (cipherBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }
    
    if (!EVP_EncryptInit(&encryptCtx, evpCipher, self.key.bytes, self.iv.bytes)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    
    if (!EVP_EncryptUpdate(&encryptCtx, cipherBytes, (int *) &blockLength, messageData.bytes, (int)messageData.length)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;
    
    if (!EVP_EncryptFinal(&encryptCtx, cipherBytes + cipherBytesLength, (int *) &blockLength)) {
        free(cipherBytes);
        if (error) *error = [NSError errorFromOpenSSL];
        return nil;
    }
    cipherBytesLength += blockLength;
    
    return [NSData dataWithBytesNoCopy:cipherBytes length:cipherBytesLength];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHDESKey
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"key=%@,iv=%@,mode=%@", self.key.MIH_hexadecimalString,
            self.iv.MIH_hexadecimalString, [MIHDESKey modeNameForMode:self.mode]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    
    return [self isEqualToKey:other];
}

- (BOOL)isEqualToKey:(MIHDESKey *)key
{
    NSParameterAssert([key isKindOfClass:[MIHDESKey class]]);
    if (self == key)
        return YES;
    if (key == nil)
        return NO;
    if (self.key != key.key && ![self.key isEqualToData:key.key])
        return NO;
    if (self.iv != key.iv && ![self.iv isEqualToData:key.iv])
        return NO;
    if (self.mode != key.mode)
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.key hash];
    hash = hash * 31u + [self.iv hash];
    hash = hash * 16u + self.mode;
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<MIHDESKey %@>", self.stringValue];
}

@end
