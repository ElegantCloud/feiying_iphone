//
//  userRegisterViewController.h
//  feiying
//
//  Created by  on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../openSource/ASIHTTPRequest/ASIHTTPRequestDelegate.h"
#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/MBProgressHUD/MBProgressHUD.h"

@interface userRegisterViewController : UIViewController<UITableViewDataSource, UITextFieldDelegate, ASIHTTPRequestDelegate>{
    // user name
    UITextField *_mUserNameInput;
    // password
    UITextField *_mPasswordInput;
    // password confirm
    UITextField *_mPwdConfirmInput;
    // validate code
    UITextField *_mValidateCodeInput;
    
    // user register table view
    UITableView *_mUserRegTableView;
    
    // register progressHud
    MBProgressHUD *_mHud;
    
    // register step index
    NSInteger _mRegStep;
    // register step dictionary
    NSMutableDictionary *_mRegStepDic;
    // components dictionary
    NSMutableDictionary *_mComponentsDic;
    
}

// user register confirm
-(void) userRegisterConfirm;

// get user register validate code
-(void) getRegisterValidateCode;
// check user register validate code
-(void) checkRegisterValidateCode;

@end
