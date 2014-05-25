//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MIHBigInteger+Factory.h"
#import "MIHBigInteger+Internal.h"
#import "MIHBigIntegerRange.h"
#import "MIHInternal.h"
#include <openssl/bn.h>
#include <openssl/rand.h>

static dispatch_block_t sMIHInitRANDOnce = ^() {
    RAND_poll();
    
};

@implementation MIHBigInteger (Factory)

+ (MIHBigInteger *)zero
{
    static dispatch_once_t onceToken;
    static MIHBigInteger *zeroInstance;
    dispatch_once(&onceToken, ^{
        BIGNUM *zeroBIGNUM = BN_new();
        BN_zero(zeroBIGNUM);
        zeroInstance = [[MIHBigInteger alloc] initWithBIGNUMNoCopy:zeroBIGNUM];
    });
    
    return zeroInstance;
}

+ (MIHBigInteger *)one
{
    static dispatch_once_t onceToken;
    static MIHBigInteger *oneInstance;
    dispatch_once(&onceToken, ^{
        BIGNUM *oneBIGNUM = BN_new();
    BN_one(oneBIGNUM);
        oneInstance = [[MIHBigInteger alloc] initWithBIGNUMNoCopy:oneBIGNUM];
    });
    
    return oneInstance;
}

+ (MIHBigInteger *)randomInRange:(MIHBigIntegerRange *)bigIntegerRange
{
    NSAssert(bigIntegerRange.location, @"`location` of MIHBigInteger must be set when calling `randomInRange:`!");
    NSAssert(bigIntegerRange.range, @"`range` of MIHBigInteger must be set when calling `randomInRange:`!");
    MIHSeedPseudeRandomNumberGenerator();
    
    BIGNUM *randomBn = BN_new();
    if (!BN_rand_range(randomBn, bigIntegerRange.range.representedBn)) {
        @throw [NSException openSSLException];
    }
    if (!BN_add(randomBn, randomBn, bigIntegerRange.location.representedBn)) {
        @throw [NSException openSSLException];
    }
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:randomBn];
}

+ (MIHBigInteger *)randomWithBitsCount:(int)sizeInBits
{
    MIHSeedPseudeRandomNumberGenerator();
    
    BIGNUM *randomBn = BN_new();
    if (!BN_rand(randomBn, sizeInBits, 0, false)) {
        @throw [NSException openSSLException];
    }
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:randomBn];
}

+ (MIHBigInteger *)randomPrimeWithBitsCount:(int)sizeInBits
{
    MIHSeedPseudeRandomNumberGenerator();
    
    BIGNUM *randomPrimeBn = BN_new();
    if (!BN_generate_prime_ex(randomPrimeBn, sizeInBits, false, NULL, NULL, NULL)) {
        @throw [NSException openSSLException];
    }
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:randomPrimeBn];
}

@end
