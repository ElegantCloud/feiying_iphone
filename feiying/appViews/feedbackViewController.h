//
//  feedbackViewController.h
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../openSource/ASIHTTPRequest/ASIHTTPRequestDelegate.h"
#import "../openSource/MBProgressHUD/MBProgressHUD.h"

#import "../customComponents/customButton.h"
#import "../customComponents/customPickerView.h"

@interface feedbackViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, customPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, ASIHTTPRequestDelegate>{
    // feedback info type picker selector
    customButton *_mFbInfoTypePickerSelector;
    // feedback info
    UITextView *_mFeedbakInfo;
    // feedback user info
    UITextField *_mUserInfo;
    
    // picker view
    customPickerView * _mPickerView;
    
    // feedback type dictionary
    NSDictionary *_mFeedbackTypeDic;
    
    // feedback submit progressHud
    MBProgressHUD *_mHud;
}

// feedback submit confirm
-(void) feedbackSubmitConfirm;

@end
