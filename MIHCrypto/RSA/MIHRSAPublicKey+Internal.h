//
// Created by Michael Hohl on 26.03.14.
// Copyright (c) 2014 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIHRSAPublicKey.h"

/**
 * These category on MIHRSAPublicKey contains an initializer which should only get used by MIHRSAKeyFactory.
 * @discussion Don't use these category yourself!
 */
@interface MIHRSAPublicKey (Internal)

- (instancetype)initWithRSA:(RSA *)rsa;

@end