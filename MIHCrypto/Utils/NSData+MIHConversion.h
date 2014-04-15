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

/**
 * @return BASE64 encoded NSString which represents this data.
 */
@property(readonly) NSString *MIH_base64EncodedString;

/**
 * Same as MIH_base64EncodedString but adds breaks.
 *
 * @param wrapWidth Number of characters before adding a line break.
 * @return The created BASE64 encoded NSString which represents this data.
 */
- (NSString *)MIH_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

/**
 * Creates NSData with the content of the passed BASE64 encoded NSString.
 * 
 * @param decode Base64 encoded string.
 * @return Created NSData.
 */
+ (NSData *)MIH_dataByBase64DecodingString:(NSString *)decode;

@end