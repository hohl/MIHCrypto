//
//  MIHECCurves.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECCurves.h"
#import "MIHEC.h"
#import <openssl/objects.h> // convert nid to sn.

@interface MIHECCurve ()
// maybe add flag that buildin_curve is ok?
// and set it in initializer.
@property (assign, nonatomic, readwrite) EC_builtin_curve curve;
@end

@interface MIHECCurve (Validation)
@property (assign, nonatomic, readonly) BOOL valid;
@end

@implementation MIHECCurve (Validation)
- (BOOL)valid {
    return self.curve.comment != NULL;
}
@end

@interface MIHECCurve (Initialization)
- (instancetype)initWithCurve:(EC_builtin_curve)curve;
- (instancetype)configuredWithCurve:(EC_builtin_curve)curve;
@end

@implementation MIHECCurve (Initialization)
- (instancetype)initWithCurve:(EC_builtin_curve)curve {
    if (self = [super init]) {
        [self configuredWithCurve:curve];
    }
    return self;
}
- (instancetype)configuredWithCurve:(EC_builtin_curve)curve {
    self.curve = curve;
    return self;
}
@end

@implementation MIHECCurve
- (NSNumber *)identifier {
    if (self.valid) {
        return @(self.curve.nid);
    }
    return nil;
}

- (NSString *)name {
    if (self.valid) {
        __auto_type sn = OBJ_nid2sn(self.curve.nid);
        if (sn == NULL) {
            return nil;
        }
        return [NSString stringWithCString:sn encoding:NSASCIIStringEncoding];
    }
    return nil;
}

- (NSString *)comment {
    if (self.valid) {
        return [NSString stringWithCString:self.curve.comment encoding:NSASCIIStringEncoding];
    }
    return nil;
}

- (NSDictionary *)debugInformation {
    return @{
             @"identifier": self.identifier ?: [NSNull null],
             @"name": self.name ?: [NSNull null],
             @"comment": self.comment ?: [NSNull null]
             };
}
@end

@implementation MIHECCurvesSizes
+ (NSInteger)size256 {
    return 256;
}
+ (NSInteger)size384 {
    return 384;
}
+ (NSInteger)size512 {
    return 512;
}
@end

@interface MIHECCurves ()
@property (copy, nonatomic, readwrite) NSArray <MIHECCurve *>* curves;
@end

@implementation MIHECCurves
- (NSDictionary *)debugInformation {
    return @{
             @"curves": [self.curves valueForKey:@"debugDescription"] ?: [NSNull null]
             };
}
@end

@implementation MIHECCurves (Curves)
- (instancetype)requestedCurvesWithCount:(NSInteger)count {
    self.curves = [self.class curvesWithCount:count];
    return self;
}
+ (size_t)defaultCountOfCurves {
    return EC_get_builtin_curves(NULL, 0);
}
+ (NSArray<MIHECCurve *> *)curvesWithCount:(NSInteger)count {
    // we need all curves?
    // doesn't matter?
    EC_builtin_curve *curves = calloc(count, sizeof(EC_builtin_curve));
    EC_get_builtin_curves(curves, count);
    // check that no items?
    
    // fill array
    NSArray *result = @[];
    for (size_t i = 0; i < count; ++i) {
        __auto_type object = curves[i];
        __auto_type curve = [[MIHECCurve alloc] initWithCurve:object];
        result = [result arrayByAddingObject:curve];
    }
    return result;
}
+ (NSArray<MIHECCurve *> *)curves {
    __auto_type count = self.defaultCountOfCurves;
    return [self curvesWithCount:count];
}
@end

@implementation MIHECCurves (Sizes)
- (NSDictionary <NSNumber *, NSString*>*)namesAndSizes {
    return @{
             @(MIHECCurvesSizes.size256) : @"prime256v1",
             @(MIHECCurvesSizes.size384) : @"secp384r1",
             @(MIHECCurvesSizes.size512) : @"secp521r1"
             };
}
- (NSString *)nameBySize:(NSInteger)size {
    return [self namesAndSizes][@(size)];
}
- (MIHECCurve *)curveByName:(NSString *)name {
    if (name == nil) {
        return nil;
    }
    
    __auto_type curves = [self requestedCurvesWithCount:self.class.defaultCountOfCurves].curves;
    __auto_type filtered = [curves filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MIHECCurve * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.name isEqualTo:name];
    }]];
    return filtered.firstObject;
}
- (MIHECCurve *)curveBySize:(NSInteger)size {
    return [self curveByName:[self nameBySize:size]];
}
@end
