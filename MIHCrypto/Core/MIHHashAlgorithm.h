//
// Created by Michael Hohl on 09.04.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIHHashAlgorithm <NSObject>

/**
 * Creates the hash value of the passed binary data.
 *
 * @param data The data to create the hash sum from.
 * @return Created hash sum.
 */
- (NSData *)hashValueOfData:(NSData *)data;

@end