//
//  customButton.h
//  feiying
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customButton : UIControl{
    // button title label
    UILabel *_mLabel;
    
    // normal background color
    UIColor *_mNormalBgColor;
    // pressed background color
    UIColor *_mPressedBgColor;
    
    // customButton grouped
    BOOL _mIsGrouped;
    
    // button pressed
    BOOL _mButtonPressed;
}

@property (nonatomic, retain) UILabel *labelText;

@property (nonatomic, retain) UIColor *buttonPressedBgColor;

@property (nonatomic, readonly) BOOL isPressed;

// set custom button is grouped
-(void) setGrouped:(BOOL) pGrouped;

// set normal background color
-(void) setNormalBgColor:(UIColor*) pColor;

// recover button
-(void) recoverButton;

// layer no cornerRadius
-(void) layerNoCornerRadius;

@end
