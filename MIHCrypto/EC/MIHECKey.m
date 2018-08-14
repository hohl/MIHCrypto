//
//  MIHECKey.m
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECKey.h"

@interface MIHECKey ()
@property (assign, nonatomic, readwrite) EC_KEY *key;
@end

@implementation MIHECKey

- (instancetype)initWithKey:(EC_KEY *)key {
    if (key == NULL) {
        return nil;
    }
    
    if (self = [super init]) {
        self.key = key;
    }
    
    return self;
}

@end
