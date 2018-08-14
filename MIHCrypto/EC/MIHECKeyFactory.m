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

@implementation MIHECKeyFactory

- (MIHKeyPair *)generateKeyPair {
    __auto_type group = self.group;
    __auto_type curve = self.curve;
    
    if (curve != nil) {
        __auto_type identifier = curve.identifier;
        __auto_type ec_key = EC_KEY_new_by_curve_name(identifier.unsignedShortValue);
        return nil;
    }
    if (group != nil) {
        __auto_type ec_group = group.group;
        __auto_type ec_key = EC_KEY_new();
        EC_KEY_set_group(ec_key, ec_group);
        return nil;
    }
    return nil;
}

@end
