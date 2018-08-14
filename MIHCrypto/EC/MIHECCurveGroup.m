//
//  MIHECCurveGroup.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECCurveGroup.h"
#import "MIHEC.h"
@implementation MIHECCurveGroupFieldTypes
+ (NSString *)primeField { return NSStringFromSelector(_cmd); }
+ (NSString *)binaryField { return NSStringFromSelector(_cmd); }
@end

@interface MIHECCurveGroupFieldParameters (BigNumConversion)
- (BIGNUM *)bigNumForNumber:(NSNumber *)number;
@property(assign, nonatomic, readonly) BIGNUM *bigNum_a;
@property(assign, nonatomic, readonly) BIGNUM *bigNum_b;
@property(assign, nonatomic, readonly) BIGNUM *bigNum_p;
@end

@implementation MIHECCurveGroupFieldParameters (BigNumConversion)
- (BIGNUM *)bigNumForNumber:(NSNumber *)number {
    __auto_type bigNum = BN_new();
    __auto_type word = number ? number.unsignedShortValue : 65537;
    BN_set_word(bigNum, word);
    return bigNum;
}

- (BIGNUM *)bigNum_a { return [self bigNumForNumber:self.a]; }
- (BIGNUM *)bigNum_b { return [self bigNumForNumber:self.b]; }
- (BIGNUM *)bigNum_p { return [self bigNumForNumber:self.p]; }
@end

@interface MIHECCurveGroupFieldParameters ()
@property (copy, nonatomic, readwrite) NSString *fieldType;
@end

@implementation MIHECCurveGroupFieldParameters
- (instancetype)configuredByFieldType:(NSString *)type {
    self.fieldType = type;
    return self;
}
@end

@interface MIHECCurveGroup ()
@property (strong, nonatomic, readwrite) MIHECCurve *curve;
@property (strong, nonatomic, readwrite) MIHECCurveGroupFieldParameters *parameters;
@end

@implementation MIHECCurveGroup @end

@implementation MIHECCurveGroup (Parameters)
- (EC_GROUP *)group {
    if ([self.parameters.fieldType isEqualToString:MIHECCurveGroupFieldTypes.primeField]) {
        __auto_type a = [self.parameters bigNum_a];
        __auto_type b = [self.parameters bigNum_b];
        __auto_type p = [self.parameters bigNum_p];
        __auto_type ctx = BN_CTX_new();
        __auto_type group = EC_GROUP_new_curve_GFp(p, a, b, ctx);
        if (a != NULL) {
            BN_free(a);
        }
        if (b != NULL) {
            BN_free(b);
        }
        if (p != NULL) {
            BN_free(p);
        }
        if (ctx != NULL) {
            BN_CTX_free(ctx);
        }
        return group;
    }
    
    if (self.curve) {
        __auto_type group = EC_GROUP_new_by_curve_name(self.curve.identifier.unsignedShortValue);
        return group;
    }
    
    return nil;
}

- (instancetype)initWithFieldParameters:(MIHECCurveGroupFieldParameters *)parameters {
    if (parameters == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        self.parameters = parameters;
    }
    return self;
}

- (instancetype)initWithCurveName:(MIHECCurve *)curve {
    if (curve == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        self.curve = curve;
    }
    
    return self;
}
@end
