//
//  userLoginDelegate.h
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol userLoginDelegate <NSObject>

@optional

// user login succeed
-(void) userLoginSucceed;

// set user login info
-(void) setUserLoginInfo;

@end
