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

- (void)dealloc {
    if (self.key != NULL) {
        EC_KEY_free(self.key);
    }
}

@end

@implementation MIHECKey (NSCopying)
- (id)copyWithZone:(NSZone *)zone {
    if (self.key) {
        __auto_type key = EC_KEY_dup(self.key);
        __auto_type result = (typeof(self))[[self.class alloc] initWithKey:key];
        return result;
    }
    else {
        return nil;
    }
}
@end
