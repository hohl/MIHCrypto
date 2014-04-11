//
// Created by Michael Hohl on 24.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import "NSData+MIHConversion.h"


@implementation NSData (MIHConversion)

- (NSString *)MIH_hexadecimalString
{
    const unsigned char *dataBuffer = (const unsigned char *) [self bytes];

    if (!dataBuffer) {
        return [NSString string];
    }

    NSUInteger dataLength = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long) dataBuffer[i]]];
    }

    return [NSString stringWithString:hexString];
}

@end