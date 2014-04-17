//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/**
 * Extension to NSData used by MIHCrypto internally to create HEX and BASE64 strings.
 * 
 * @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
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