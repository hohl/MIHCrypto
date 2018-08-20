//
//  MIHECPrivateKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPrivateKey.h"
#import "MIHECKey.h"

@interface MIHECPrivateKey () @end
@implementation MIHECPrivateKey @end

@implementation MIHECPrivateKey (KeyConversion)
- (NSData *)dataFromKey:(MIHECKey *)key {
    if (key == nil) {
        return nil;
    }
    
    __auto_type bytesCount = i2d_ECPrivateKey(key.key, NULL);
    if (bytesCount == 0) {
        return nil;
    }
    
    __auto_type bytes = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    i2d_ECPrivateKey(key.key, &bytes);
    if (bytes == NULL) {
        return nil;
    }
    
    __auto_type data = [[NSData alloc] initWithBytes:bytes length:bytesCount];
    return data;
}

- (MIHECKey *)keyFromData:(NSData *)data {
    __auto_type bytesCount = data.length;
    
    if (bytesCount == 0) {
        return nil;
    }
    
    __auto_type bytes = (unsigned char *)calloc(bytesCount, sizeof(unsigned char));
    [data getBytes:bytes length:bytesCount];
    
    if (bytes == NULL) {
        return nil;
    }
    
    EC_KEY *key = NULL;
    d2i_ECPrivateKey(&key, &bytes, bytesCount);
    
    return [[MIHECKey alloc] initWithKey:key];
}
@end

@implementation MIHECPrivateKey (MIHPrivateKey)

- (NSData *)encrypt:(NSData *)message error:(NSError *__autoreleasing *)error { return nil; }
- (NSData *)decrypt:(NSData *)cipher error:(NSError *__autoreleasing *)error { return nil; }

#pragma mark - OpenSSL Definition
/** Computes ECDSA signature of a given hash value using the supplied
 *  private key (note: sig must point to ECDSA_size(eckey) bytes of memory).
 *  \param  type     this parameter is ignored
 *  \param  dgst     pointer to the hash value to sign
 *  \param  dgstlen  length of the hash value
 *  \param  sig      memory for the DER encoded created signature
 *  \param  siglen   pointer to the length of the returned signature
 *  \param  eckey    EC_KEY object containing a private EC key
 *  \return 1 on success and 0 otherwise
 /
int ECDSA_sign(int type, const unsigned char *dgst, int dgstlen,
               unsigned char *sig, unsigned int *siglen, EC_KEY *eckey);
*/
- (NSData *)signMessage:(NSData *)message error:(NSError *__autoreleasing *)error {
    const unsigned char *digest = [MIHNSDataExtension bytesFromData:message];
    __auto_type digestLength = message.length;
    if (digest == NULL) {
        return nil;
    }
    
    // convert signature to data
    // maybe use another class for this.
    // yes, we need signature object.
    __auto_type signature = ECDSA_do_sign(digest, digestLength, self.key.key);
    if (signature == NULL) {
        return nil;
    }
    
    __auto_type bytesCount = i2d_ECDSA_SIG(signature, NULL);
    unsigned char *bytes = calloc(bytesCount, sizeof(unsigned char));
    
    i2d_ECDSA_SIG(signature, &bytes);
    if (bytes == nil) {
        return nil;
    }
    
    __auto_type result = [NSData dataWithBytes:bytes length:bytesCount];
    return result;
}

#pragma mark -

- (NSData *)signWithMD5:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

- (NSData *)signWithSHA128:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

- (NSData *)signWithSHA256:(NSData *)message error:(NSError *__autoreleasing *)error {
    return nil;
}

@end
