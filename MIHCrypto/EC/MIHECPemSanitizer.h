//
//  MIHECPemSanitizer.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"

@interface MIHECPemSanitizer__EntryType : NSObject
@property (copy, nonatomic, readonly, class) NSString *Certificate;
@property (copy, nonatomic, readonly, class) NSString *PrivateKey;
@property (copy, nonatomic, readonly, class) NSString *PublicKey;
@end

@interface MIHECPemSanitizer : MIHECObject
// apply pem ( or add it )
- (NSString *)apply:(NSString *)string type:(NSString *)type;
// unapply pem ( or remove it )
- (NSString *)unapply:(NSString *)string;
@end
