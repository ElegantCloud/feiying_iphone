//
//  userLoginViewController.h
//  feiying
//
//  Created by  on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../openSource/ASIHTTPRequest/ASIHTTPRequestDelegate.h"
#import "../openSource/MBProgressHUD/MBProgressHUD.h"

#import "../delegate/userLoginDelegate.h"

#import "../customComponents/customButton.h"

@interface userLoginViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate, ASIHTTPRequestDelegate>{
    // user name
    UITextField *_mUserNameInput;
    // password
    UITextField *_mPasswordInput;
    // user auto login
    UISwitch *_mAutoLoginSwitch;
    // remember user input password
    UISwitch *_mRememberPasswordSwitch;
    // login confirm button
    customButton *_mLoginButton;
    
    id<userLoginDelegate> _userLoginDelegate;
    
    // login progressHud
    MBProgressHUD *_mHud;
}

@property (nonatomic, retain) id<userLoginDelegate> userLoginDelegate;

@property (nonatomic, retain) UITextField *userNameInput;
@property (nonatomic, retain) UITextField *passwordInput;

// user register navigate action
-(void) userRegisterNavigation;
// user login action
-(void) userLoginAction;
// user login cancel
-(void) userLoginCancel;

@end

@interface controlTableViewCell : UITableViewCell

// init with label tip and control
-(id) initWithLabelTip:(NSString*) pString andControl:(UIControl*) pControl;

// init with controls array
-(id) initWithControls:(NSArray*) pControls;

@end
