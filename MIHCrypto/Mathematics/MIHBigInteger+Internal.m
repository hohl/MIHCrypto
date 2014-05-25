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

#import "MIHBigInteger+Internal.h"
#import "MIHInternal.h"

@implementation MIHBigInteger (Internal)

- (id)initWithBIGNUM:(BIGNUM *)aBn
{
    self = [super init];
    if (self) {
        _representedBn = BN_dup(aBn);
        if (!_representedBn) {
            @throw [NSException openSSLException];
        }
    }
    
    return self;
}

- (id)initWithBIGNUMNoCopy:(BIGNUM *)aBn
{
    self = [super init];
    if (self) {
        _representedBn = aBn;
    }
    
    return self;
}

+ (MIHBigInteger *)bigIntegerFromNumber:(id<MIHNumber>)aNumber
{
    if ([aNumber isKindOfClass:[MIHBigInteger class]]) {
        return (MIHBigInteger *)aNumber;
    }
    
    NSString *aNumberDecimalString = [aNumber decimalStringValue];
    return [[MIHBigInteger alloc] initWithDecimalStringValue:aNumberDecimalString];
}

- (BIGNUM *)representedBn
{
    return _representedBn;
}

@end
