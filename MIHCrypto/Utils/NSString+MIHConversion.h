//
// Created by Michael Hohl on 24.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MIHConversion)

/**
 * @return NSData which represents the octet information provided by the hex string.
 */
@property(readonly) NSData *MIH_dataFromHexadecimal;

@end