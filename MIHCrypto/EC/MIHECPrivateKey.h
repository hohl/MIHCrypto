//
//  MIHECPrivateKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHECBaseKey.h"
#import "MIHPrivateKey.h"

@interface MIHECPrivateKey : MIHECBaseKey @end

@class MIHECSignature;
@interface MIHECPrivateKey (MIHPrivateKey) <MIHPrivateKey>
- (NSData *)signMessage:(NSData *)message error:(NSError *__autoreleasing *)error;
- (MIHECSignature *)theSignMessage:(NSData *)message error:(NSError *__autoreleasing *)error;
@end
