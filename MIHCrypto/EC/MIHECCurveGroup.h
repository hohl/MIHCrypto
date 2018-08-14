//
//  MIHECCurveGroup.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Within the library there are two forms of elliptic curve that are of interest. The first form is those defined over the prime field Fp. The elements of Fp are the integers 0 to p-1, where p is a prime number. This gives us a revised elliptic curve equation as follows:
 
 y^2 mod p = x^3 +ax + b mod p
 
 The second form is those defined over a binary field F2^m where the elements of the field are integers of length at most m bits. For this form the elliptic curve equation is modified to:
 
 y^2 + xy = x^3 + ax^2 + b (where b != 0)
 */
#import "MIHEC.h"
#import "MIHECCurves.h"

@interface MIHECCurveGroupFieldTypes : NSObject
@property (copy, nonatomic, readonly, class) NSString *primeField;
@property (copy, nonatomic, readonly, class) NSString *binaryField;
@end
@interface MIHECCurveGroupFieldParameters : NSObject
// since they are bignum structures, we need to set their degrees only.
@property (copy, nonatomic, readonly) NSNumber *a;
@property (copy, nonatomic, readonly) NSNumber *b;
@property (copy, nonatomic, readonly) NSNumber *p;
- (instancetype)configuredByFieldType:(NSString *)type;
@end

@interface MIHECCurveGroup : NSObject
@property (assign, nonatomic, readonly) EC_GROUP *group;
@end

@interface MIHECCurveGroup (Parameters)
- (instancetype)initWithFieldParameters:(MIHECCurveGroupFieldParameters *)parameters;
@end

@interface MIHECCurveGroup (Name)
- (instancetype)initWithCurveName:(MIHECCurve *)curve;
@end
