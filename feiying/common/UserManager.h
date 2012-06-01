//
//  UserManager.h
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserBean.h"

@interface UserManager : NSObject{
    // user information
    UserBean *_mUserBean;
}

@property (nonatomic, retain) UserBean *userBean;

// Singleton
+(UserManager *) shareSingleton;

// add an user and remove one
-(UserBean *) setUser:(NSString *)pName andPwd:(NSString *)pPwd;
-(UserBean *) setUser:(NSString *)pName andUserKey:(NSString *)pUserKey;
-(UserBean *) setUser:(NSString *)pName andUserKey:(NSString *)pUserKey andBusinessOpened:(feiyingBusinessState) pBusinessState;
-(void) removeUser;

@end
