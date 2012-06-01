//
//  UserManager.m
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"

#import "../util/NSString+util.h"

static UserManager *shareUserManager = nil;

@implementation UserManager

@synthesize userBean = _mUserBean;

+(UserManager *) shareSingleton{
    @synchronized(self){
        if(nil == shareUserManager){
            //[[self alloc] init];
            shareUserManager = [super alloc];
        }
    }
    
    return shareUserManager;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if(nil == shareUserManager){
            shareUserManager = [super allocWithZone:zone];
            return shareUserManager;
        }
    }
    
    return shareUserManager;
}

-(id) copyWithZone:(NSZone *)zone{
    return self;
}

// add an user and remove one
-(UserBean *) setUser:(NSString *)pName andPwd:(NSString *)pPwd{
    if(nil == _mUserBean){
        _mUserBean = [[UserBean alloc] init];
    }
    
    // generator user digit key 
    NSMutableString *_str = [[NSMutableString alloc] initWithString:pName];
    [_str appendString:pPwd];
    NSString *_digit = [_str md5];
    
    // set user bean
    _mUserBean.name = pName;
    _mUserBean.pwdMD5 = pPwd;
    _mUserBean.userKey = _digit;
    
    return _mUserBean;
}

-(UserBean *) setUser:(NSString *)pName andUserKey:(NSString *)pUserKey{
    if(nil == _mUserBean){
        _mUserBean = [[UserBean alloc] init];
    }
    
    // set user bean
    _mUserBean.name = pName;
    _mUserBean.userKey = pUserKey;
    
    return _mUserBean;
}

-(UserBean *) setUser:(NSString *)pName andUserKey:(NSString *)pUserKey andBusinessOpened:(feiyingBusinessState)pBusinessState{
    if(nil == _mUserBean){
        _mUserBean = [[UserBean alloc] init];
    }
    
    // set user bean
    _mUserBean.name = pName;
    _mUserBean.userKey = pUserKey;
    _mUserBean.businessState = pBusinessState;
    
    return _mUserBean;
}

-(void) removeUser{
    _mUserBean = nil;
}

@end
