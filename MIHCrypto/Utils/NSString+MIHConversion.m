//
// Created by Michael Hohl on 24.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "NSString+MIHConversion.h"

@implementation NSString (MIHConversion)

- (NSData *)MIH_dataFromHexadecimal
{
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx + 2 <= self.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [self substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end