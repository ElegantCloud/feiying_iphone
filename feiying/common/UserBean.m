//
//  UserBean.m
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserBean.h"

@implementation UserBean

@synthesize name = _mName;
@synthesize pwdMD5 = _mPasswordMD5;
@synthesize userKey = _mUserKey;
@synthesize businessState = _mFeiyingBusinessState;

// overwrite description
-(NSString *) description{
    NSMutableString *ret = [[NSMutableString alloc] init];
    
    [ret appendFormat:@"user name:%@ , ", _mName];
    [ret appendFormat:@"his password MD5:%@ , ", _mPasswordMD5];
    [ret appendFormat:@"and user key:%@ ,", _mUserKey];
    [ret appendFormat:@"and his feiying business state = %d", _mFeiyingBusinessState];
    
    return ret;
}

@end
