//
//  MIHECBaseKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHCoding.h"

@interface MIHECBaseKey : MIHECObject @end

@interface MIHECBaseKey (NSCopying) <NSCopying> @end
@interface MIHECBaseKey (NSCoding) <NSCoding> @end
@interface MIHECBaseKey (MIHCoding) <MIHCoding> @end
