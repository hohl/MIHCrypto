//
//  MIHNSDataExtension.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIHNSDataExtension : NSObject
+ (unsigned char *)bytesFromData:(NSData *)data;
+ (NSData *)dataFromBytes:(unsigned char *)bytes length:(NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
