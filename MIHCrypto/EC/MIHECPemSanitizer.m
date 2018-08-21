//
//  MIHECPemSanitizer.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 21.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECPemSanitizer.h"

// we need to write parser?
@interface MIHECPemSanitizer__EntryType (Headers)
- (NSString *)beginHeaderOfType:(NSString *)type;
- (NSString *)endHeaderOfType:(NSString *)type;
@end
@implementation MIHECPemSanitizer__EntryType (Headers)

- (NSString *)headerWithLabel:(NSString *)label type:(NSString *)type {
    return [[[[@"-----" stringByAppendingString:label] stringByAppendingString:@" "] stringByAppendingString:type] stringByAppendingString:@"-----"];
}

- (NSString *)beginHeaderOfType:(NSString *)type {
    return [self headerWithLabel:@"BEGIN" type:type];
}

- (NSString *)endHeaderOfType:(NSString *)type {
    return [self headerWithLabel:@"END" type:type];
}

@end
@implementation MIHECPemSanitizer__EntryType
+ (NSString *)Certificate {
    return @"CERTIFICATE";
}
+ (NSString *)PrivateKey {
    return @"PRIVATE KEY";
}
+ (NSString *)PublicKey {
    return @"PUBLIC KEY";
}
@end

@interface MIHECPemSanitizer (Extraction)
- (NSRegularExpression *)pemEntryRegularExpression;
@end

@implementation MIHECPemSanitizer (Extraction)

- (NSRegularExpression *)pemEntryRegularExpression {
    __auto_type expression = [[NSRegularExpression alloc] initWithPattern:@"-----BEGIN(?<Begin>[\\w\\s]+)-----(?<Content>.+?)-----END(?<End>[\\w\\s]+)-----" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    return expression;
}

@end

#import "NSData+MIHConversion.h"
@implementation MIHECPemSanitizer

- (BOOL)isValidPemString:(NSString *)string {
    __auto_type expression = [self pemEntryRegularExpression];
    __auto_type range = NSMakeRange(0, string.length);
    return [expression numberOfMatchesInString:string options:0 range:range] > 0;
}

- (NSString *)apply:(NSString *)string type:(NSString *)type {
    if ([self isValidPemString:string]) {
        return string;
    }
    
    // else we need to add pem headers?
    
    __auto_type entry = [MIHECPemSanitizer__EntryType new];
    __auto_type beginHeader = [entry beginHeaderOfType:type];
    __auto_type endHeader = [entry endHeaderOfType:type];
    
    if (string != nil) {
        __auto_type formattedString = [[string dataUsingEncoding:NSUTF8StringEncoding] MIH_base64EncodedStringWithWrapWidth:64];
        __auto_type result = @[beginHeader, formattedString, endHeader];
        return [result componentsJoinedByString:@"\n"];
    }
    
    return nil;
}
- (NSString *)unapply:(NSString *)string {
    if ([self isValidPemString:string]) {
        __auto_type range = NSMakeRange(0, string.length);
        __auto_type match = [[self pemEntryRegularExpression] firstMatchInString:string options:0 range:range];
        
        __auto_type validMatch = (BOOL)match.numberOfRanges > 2;
        if (!validMatch) {
            return nil;
        }
        __auto_type contentRange = [match rangeAtIndex:2];
        __auto_type content = [string substringWithRange:contentRange];
        __auto_type cleanContent = [content stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        return cleanContent;
    }
    return string;
}
@end
