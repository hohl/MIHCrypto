//
// Created by Michael Hohl on 25.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIHSymmetricKey <NSObject>

- (NSData *)decrypt:(NSData *)cipher error:(NSError **)error;

- (NSData *)encrypt:(NSData *)message error:(NSError **)error;

- (NSData *)dataValue;

@end