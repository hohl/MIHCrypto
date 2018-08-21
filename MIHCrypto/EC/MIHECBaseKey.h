//
//  MIHECBaseKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHCoding.h"
@class MIHECKey;

@interface MIHECBaseKey : MIHECObject
@property (strong, nonatomic, readonly) MIHECKey *key;
- (instancetype)initWithKey:(MIHECKey *)key;
@end

@interface MIHECBaseKey (NSCopying) <NSCopying> @end

// Implement in subclasses
@interface MIHECBaseKey (KeyConversion)
- (NSData *)dataFromKey:(MIHECKey *)key;
- (MIHECKey *)keyFromData:(NSData *)data;
@end

@interface MIHECBaseKey (NSCoding) <NSCoding> @end
@interface MIHECBaseKey (MIHCoding) <MIHCoding> @end
