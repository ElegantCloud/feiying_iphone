//
//  UserBean.h
//  feiying
//
//  Created by  on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    unopened,
    opened,
    processing
} feiyingBusinessState;




@interface UserBean : NSObject{
    // user name
    NSString *_mName;
    // user md5 password
    NSString *_mPasswordMD5;
    // user key
    NSString *_mUserKey;
    // feiying business state
    feiyingBusinessState _mFeiyingBusinessState;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *pwdMD5;
@property (nonatomic, retain) NSString *userKey;
@property (nonatomic, readwrite) feiyingBusinessState businessState;

@end
