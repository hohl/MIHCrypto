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

#import "MIHBigInteger.h"
#import "MIHBigInteger+Internal.h"
#import "MIHInternal.h"

@implementation MIHBigInteger

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init, MIHCoding and NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithUnsignedInteger:(BN_ULONG)value
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        BN_set_word(_representedBn, value);
    }
    
    return self;
}

- (id)initWithSignedInteger:(BN_LONG)value
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        BN_set_word(_representedBn, ABS(value));
        if (value < 0) {
            BN_set_negative(_representedBn, 1);
        }
    }

    return self;
}

- (id)initWithDecimalStringValue:(NSString *)decimalString
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        if (!BN_dec2bn(&_representedBn, decimalString.UTF8String)) {
            @throw [NSException openSSLException];
        }
    }
    
    return self;
}

- (id)initWithHexStringValue:(NSString *)hexString
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        if (!BN_hex2bn(&_representedBn, hexString.UTF8String)) {
            @throw [NSException openSSLException];
        }
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        NSString *hexString = [aDecoder decodeObjectForKey:@"hexString"];
        if (!BN_hex2bn(&_representedBn, hexString.UTF8String)) {
            @throw [NSException openSSLException];
        }
    }
    
    return self;
}

- (id)initWithData:(NSData *)dataValue
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        if (!BN_bin2bn(dataValue.bytes, (int)dataValue.length, _representedBn)) {
            @throw [NSException openSSLException];
        }
    }

    return self;
}

- (id)initWithMpiData:(NSData *)mpiDataValue
{
    self = [super init];
    if (self) {
        _representedBn = BN_new();
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
        if (!BN_mpi2bn(mpiDataValue.bytes, (int)mpiDataValue.length, _representedBn)) {
            @throw [NSException openSSLException];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.hexStringValue forKey:@"hexString"];
}

- (NSData *)dataValue
{
    NSMutableData *data = [[NSMutableData alloc] initWithLength:BN_num_bytes(_representedBn)];
    BN_bn2bin(_representedBn, data.mutableBytes);
    return data;
}

- (void)dealloc
{
    BN_clear_free(_representedBn);
    _representedBn = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCopying
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)copyWithZone:(NSZone *)zone
{
    return [[MIHBigInteger allocWithZone:zone] initWithBIGNUM:_representedBn];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHNumber
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id<MIHNumber>)add:(id<MIHNumber>)summand
{
    MIHBigInteger *summandInteger = [MIHBigInteger bigIntegerFromNumber:summand];
    
    BIGNUM *resultBn = BN_new();
    if (!BN_add(resultBn, _representedBn, summandInteger->_representedBn)) {
        @throw [NSException openSSLException];
    }
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)add:(id<MIHNumber>)summand modulo:(id<MIHNumber>)modulus
{
    MIHBigInteger *summandInteger = [MIHBigInteger bigIntegerFromNumber:summand];
    MIHBigInteger *modulusInteger = [MIHBigInteger bigIntegerFromNumber:modulus];
    
    BIGNUM *resultBn = BN_new();
    if (!BN_mod_add_quick(resultBn, _representedBn, summandInteger->_representedBn, modulusInteger->_representedBn)) {
        @throw [NSException openSSLException];
    }
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)subtract:(id<MIHNumber>)subtrahend
{
    MIHBigInteger *subtrahendInteger = [MIHBigInteger bigIntegerFromNumber:subtrahend];
    
    BIGNUM *resultBn = BN_new();
    if (!BN_sub(resultBn, _representedBn, subtrahendInteger->_representedBn)) {
        @throw [NSException openSSLException];
    }
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)multiply:(id<MIHNumber>)factor
{
    MIHBigInteger *factorInteger = [MIHBigInteger bigIntegerFromNumber:factor];
    
    BIGNUM *resultBn = BN_new();
    BN_CTX *mulCtx = BN_CTX_new();
    if (!mulCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_mul(resultBn, _representedBn, factorInteger->_representedBn, mulCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(mulCtx);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)multiply:(id<MIHNumber>)factor modulo:(id<MIHNumber>)modulus
{
    MIHBigInteger *factorInteger = [MIHBigInteger bigIntegerFromNumber:factor];
    MIHBigInteger *modulusInteger = [MIHBigInteger bigIntegerFromNumber:modulus];
    
    BIGNUM *resultBn = BN_new();
    BN_CTX *mulCtx = BN_CTX_new();
    if (!mulCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_mod_mul(resultBn, _representedBn, factorInteger->_representedBn, modulusInteger->_representedBn, mulCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(mulCtx);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)divide:(id<MIHNumber>)divisor
{
    MIHBigInteger *divisorInteger = [MIHBigInteger bigIntegerFromNumber:divisor];
    
    BIGNUM *dividendBn = BN_new();
    BIGNUM *reminderBn = BN_new();
    BN_CTX *divCtx = BN_CTX_new();
    if (!divCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_div(dividendBn, reminderBn, _representedBn, divisorInteger->_representedBn, divCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(divCtx);
    BN_clear_free(reminderBn);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:dividendBn];
}

- (id<MIHNumber>)modulo:(id<MIHNumber>)divisor
{
    MIHBigInteger *divisorInteger = [MIHBigInteger bigIntegerFromNumber:divisor];
    
    BIGNUM *dividenBn = BN_new();
    BIGNUM *reminderBn = BN_new();
    BN_CTX *divCtx = BN_CTX_new();
    if (!divCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_div(dividenBn, reminderBn, _representedBn, divisorInteger->_representedBn, divCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(divCtx);
    BN_clear_free(dividenBn);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:reminderBn];
}

- (id<MIHNumber>)power:(id<MIHNumber>)exponent
{
    MIHBigInteger *exponentInteger = [MIHBigInteger bigIntegerFromNumber:exponent];
    
    BIGNUM *resultBn = BN_new();
    BN_CTX *expCtx = BN_CTX_new();
    if (!expCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_exp(resultBn, _representedBn, exponentInteger->_representedBn, expCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(expCtx);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)power:(id<MIHNumber>)exponent modulo:(id<MIHNumber>)modulus
{
    MIHBigInteger *exponentInteger = [MIHBigInteger bigIntegerFromNumber:exponent];
    MIHBigInteger *modulusInteger = [MIHBigInteger bigIntegerFromNumber:modulus];
    
    BIGNUM *resultBn = BN_new();
    BN_CTX *ctx = BN_CTX_new();
    if (!ctx) {
        @throw [NSException openSSLException];
    }
    if (!BN_mod_exp(resultBn, _representedBn, exponentInteger->_representedBn, modulusInteger->_representedBn, ctx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(ctx);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (id<MIHNumber>)square
{
    BIGNUM *resultBn = BN_new();
    BN_CTX *sqrCtx = BN_CTX_new();
    if (!sqrCtx) {
        @throw [NSException openSSLException];
    }
    if (!BN_sqr(resultBn, _representedBn, sqrCtx)) {
        @throw [NSException openSSLException];
    }
    BN_CTX_free(sqrCtx);
    
    return [[MIHBigInteger alloc] initWithBIGNUMNoCopy:resultBn];
}

- (NSString *)decimalStringValue
{
    char *hexString = BN_bn2dec(_representedBn);
    if (!hexString) {
        return nil;
    }
    
    return [NSString stringWithUTF8String:hexString];
}

- (BOOL)isOne
{
    return BN_is_one(_representedBn);
}

- (BOOL)isOdd
{
    return BN_is_odd(_representedBn);
}

- (BOOL)isZero
{
    return BN_is_zero(_representedBn);
}

- (BOOL)isNegative
{
    return BN_is_zero(_representedBn);
}

- (BOOL)isEqualToNumber:(id<MIHNumber>)other
{
    MIHBigInteger *otherInteger = [MIHBigInteger bigIntegerFromNumber:other];
    return [self isEqualToBigInteger:otherInteger];
}

- (BOOL)isGreaterThanNumber:(id<MIHNumber>)other
{
    MIHBigInteger *otherInteger = [MIHBigInteger bigIntegerFromNumber:other];
    return [self isGreaterThanBigInteger:otherInteger];
}

- (BOOL)isLessThanNumber:(id<MIHNumber>)other
{
    MIHBigInteger *otherInteger = [MIHBigInteger bigIntegerFromNumber:other];
    return [self isLessThanBigInteger:otherInteger];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MIHBigNum
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)hexStringValue
{
    char *hexString = BN_bn2hex(_representedBn);
    if (!hexString) {
        return nil;
    }
    
    return [NSString stringWithUTF8String:hexString];
}

- (NSData *)mpiDataValue
{
    int expectedLength = BN_bn2mpi(_representedBn, NULL);
    NSMutableData *data = [[NSMutableData alloc] initWithLength:expectedLength];
    BN_bn2mpi(_representedBn, data.mutableBytes);
    return data;
}

- (BOOL)isEqualToBigInteger:(MIHBigInteger *)other
{
    if (other == self)
        return YES;
    
    return BN_cmp(_representedBn, other->_representedBn) == 0;
}

- (BOOL)isGreaterThanBigInteger:(MIHBigInteger *)other
{
    if (other == self)
        return YES;
    
    return BN_cmp(_representedBn, other->_representedBn) > 0;
}

- (BOOL)isLessThanBigInteger:(MIHBigInteger *)other
{
    if (other == self)
        return YES;
    
    return BN_cmp(_representedBn, other->_representedBn) < 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (other == nil)
        return NO;
    if (![other conformsToProtocol:@protocol(MIHNumber)])
        return NO;

    return [self isEqualToNumber:(id<MIHNumber>)other];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), self.decimalStringValue];
}

@end
