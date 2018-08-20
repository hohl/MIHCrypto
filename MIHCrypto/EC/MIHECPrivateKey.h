//
//  MIHECPrivateKey.h
//  MIHCrypto
//
//  Created by Dmitry Lobanov on 14.08.2018.
//  Copyright © 2018 Michael Hohl. All rights reserved.
//

#import "MIHECObject.h"
#import "MIHECBaseKey.h"
#import "MIHPrivateKey.h"

@interface MIHECPrivateKey : MIHECBaseKey @end

@interface MIHECPrivateKey (MIHPrivateKey) <MIHPrivateKey> @end
