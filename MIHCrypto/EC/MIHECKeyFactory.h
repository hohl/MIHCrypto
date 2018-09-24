//
//  MIHECKeyFactory.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"

@class MIHKeyPair;
@class MIHECCurve;
@class MIHECCurveGroup;
@interface MIHECKeyFactory : MIHECObject

// one of them will be used.
@property (strong, nonatomic, readwrite) MIHECCurveGroup *group;
@property (strong, nonatomic, readwrite) MIHECCurve *curve;

- (MIHKeyPair *)generateKeyPair;
- (MIHKeyPair *)generateKeyPairWithCurve:(MIHECCurve *)curve;
- (MIHKeyPair *)generateKeyPairWithGroup:(MIHECCurveGroup *)group;

@end
