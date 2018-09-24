//
//  MIHECKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHEC.h"

@interface MIHECKey : MIHECObject

@property (assign, nonatomic, readonly) EC_KEY *key;
- (instancetype)initWithKey:(EC_KEY *)key;

@end

@interface MIHECKey (NSCopying) <NSCopying> @end
