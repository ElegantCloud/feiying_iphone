//
//  userAccountSettingViewController.h
//  feiying
//
//  Created by  on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "baseTabViewController.h"

#import "../openSource/MBProgressHUD/MBProgressHUD.h"

@interface userAccountSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ASIHTTPRequestDelegate>{
    // user name
    UITextField *_mUserNameInput;
    // validate code
    UITextField *_mValidateCodeInput;
    
    // user register and login table view
    UITableView *_mUserRegLoginTableView;
    
    // register and login progressHud
    MBProgressHUD *_mHud;
    
    // register and login step index
    NSInteger _mRegLoginStep;
    // register and login step dictionary
    NSMutableDictionary *_mRegLoginStepDic;
    // components dictionary
    NSMutableDictionary *_mComponentsDic;
    
    // app started loading flag
    BOOL _isAppStartedLoading;
    
    // user login delegate
    id<userLoginDelegate> _userRegLoginDelegate;
}

@property (nonatomic, retain) id<userLoginDelegate> userRegLoginDelegate;

@property (nonatomic, retain) UITextField *userNameInput;

// init with app started
-(id) initWithAppStarted;

// user account setting cancel
-(void) userAccountSettingCancel;

// get user register and login validate code
-(void) getRegLoginValidateCode;
// user register and login checking
-(void) userRegLoginChecking;

// open feiying business
-(void) openFeiyingBusiness;
// abort open feiying business
-(void) abortOpenFeiyingBusiness;

@end
