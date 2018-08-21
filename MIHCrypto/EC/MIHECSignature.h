//
//  MIHECSignature.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHEC.h"
#import "MIHCoding.h"

@interface MIHECSignature : MIHECObject
@property (assign, nonatomic, readonly) ECDSA_SIG *signature;
- (instancetype)initWithSignature:(ECDSA_SIG *)signature;
@end

@interface MIHECSignature (MIHCoding) <MIHCoding> @end

@interface MIHECSignature (Conversion)
+ (ECDSA_SIG *)signatureFromData:(NSData *)data;
+ (NSData *)dataFromSignature:(ECDSA_SIG *)signature;
@end
