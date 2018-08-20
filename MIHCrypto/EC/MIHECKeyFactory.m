//
//  MIHECKeyFactory.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECKeyFactory.h"

#import "MIHEC.h"
#import "MIHKeyPair.h"
#import "MIHECCurves.h"
#import "MIHECCurveGroup.h"
#import "MIHECKey.h"
#import "MIHECPrivateKey.h"
#import "MIHECPublicKey.h"

@implementation MIHECKeyFactory

- (MIHKeyPair *)pairWithECKey:(EC_KEY *)key {
    if (key == NULL) {
        return nil;
    }
    __auto_type the_key = [[MIHECKey alloc] initWithKey:key];
    __auto_type privateKey = [[MIHECPrivateKey alloc] initWithKey:the_key];
    __auto_type publicKey = [[MIHECPublicKey alloc] initWithKey:the_key];
    __auto_type pair = [[MIHKeyPair alloc] init];
    pair.private = privateKey;
    pair.public = publicKey;
    return pair;
}

- (MIHKeyPair *)generateKeyPair {
    __auto_type group = self.group;
    __auto_type curve = self.curve;
    
    if (curve != nil) {
        return [self generateKeyPairWithCurve:curve];
    }
    else if (group != nil) {
        return [self generateKeyPairWithGroup:group];
    }
    return nil;
}

- (MIHKeyPair *)generateKeyPairWithCurve:(MIHECCurve *)curve {
    __auto_type identifier = curve.identifier;
    __auto_type ec_key = EC_KEY_new_by_curve_name(identifier.unsignedShortValue);
    return [self pairWithECKey:ec_key];
}
- (MIHKeyPair *)generateKeyPairWithGroup:(MIHECCurveGroup *)group {
    __auto_type ec_group = group.group;
    __auto_type ec_key = EC_KEY_new();
    EC_KEY_set_group(ec_key, ec_group);
    EC_KEY_generate_key(ec_key);
    return [self pairWithECKey:ec_key];
}

@end
