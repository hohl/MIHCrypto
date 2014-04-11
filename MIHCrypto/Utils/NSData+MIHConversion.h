//
// Created by Michael Hohl on 24.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MIHConversion)

/**
 * @return Hexadecimal NSString representation of the data.
 * @discussion An empty NSString is returned when there is no data.
 */
@property(readonly) NSString *MIH_hexadecimalString;

@end