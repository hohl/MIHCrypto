//
//  MIHECPublicKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHECBaseKey.h"
#import "MIHPublicKey.h"

@interface MIHECPublicKey : MIHECBaseKey

@end
@class MIHECSignature;
@interface MIHECPublicKey (MIHPublicKey) <MIHPublicKey>
- (BOOL)verifySignature:(NSData *)signature message:(NSData *)message;
- (BOOL)verifyTheSignature:(MIHECSignature *)signature message:(NSData *)message;
@end
