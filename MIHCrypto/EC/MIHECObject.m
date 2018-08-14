//
//  MIHECObject.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"

@implementation MIHECObject
- (NSDictionary *)debugInformation {
    return @{};
}
- (NSString *)debugDescription {
    return [[super debugDescription] stringByAppendingString:([self debugInformation] ?: @{}).debugDescription];
}
@end
