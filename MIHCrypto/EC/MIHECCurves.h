//
//  MIHECCurves.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIHECCurve : NSObject// <NSCopying>
@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@end

@interface MIHECCurvesSizes : NSObject
@property (assign, nonatomic, readonly, class) NSInteger size256;
@property (assign, nonatomic, readonly, class) NSInteger size384;
@property (assign, nonatomic, readonly, class) NSInteger size512;
@end

@interface MIHECCurves : NSObject
@property (copy, nonatomic, readonly) NSArray <MIHECCurve *>* curves;
@end

@interface MIHECCurves (Curves)
- (instancetype)requestedCurvesWithCount:(NSInteger)count;
@property (copy, nonatomic, readonly, class) NSArray <MIHECCurve *>* curves;
@end

@interface MIHECCurves (Sizes)
- (MIHECCurve *)curveByName:(NSString *)name;
- (MIHECCurve *)curveBySize:(NSInteger)size;
@end
