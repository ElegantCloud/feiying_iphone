//
//  userLoginIndicatorView.m
//  feiying
//
//  Created by  on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "userLoginIndicatorView.h"

@implementation userLoginIndicatorView

@synthesize setUserLoginInfoDelegate = _setUserLoginInfoDelegate;

// private methods
// set user login info
-(void) setUserLoginInfoAction{
    // call delegate setUserLoginInfo methods
    if(_setUserLoginInfoDelegate){
        [_setUserLoginInfoDelegate setUserLoginInfo];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set user login indicator view background color
        self.backgroundColor = [UIColor whiteColor];
        
        // user login indicator tip
        _mUserLoginIndicatorTip = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+5.0, frame.size.height/2-30.0-40.0-10.0, frame.size.width-2*5.0, 40.0)];
        _mUserLoginIndicatorTip.numberOfLines = 2;
        // set text
        _mUserLoginIndicatorTip.text = @"您还没有设置账户信息,暂时无法使用此功能.";
        _mUserLoginIndicatorTip.textAlignment = UITextAlignmentCenter;
        _mUserLoginIndicatorTip.textColor = [UIColor lightGrayColor];
        _mUserLoginIndicatorTip.font = [UIFont systemFontOfSize:14.0];
        // add user login indicator tip to indicator view
        [self addSubview:_mUserLoginIndicatorTip];
        
        // set user info image button
        UIButton *_userLoginIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set button image
        [_userLoginIndicatorButton setImage:[UIImage imageNamed:@"loginIndicatorImg.png"] forState:UIControlStateNormal];
        [_userLoginIndicatorButton setImage:[UIImage imageNamed:@"loginIndicatorImg.png"] forState:UIControlStateHighlighted];
        // set image button frame
        _userLoginIndicatorButton.frame = CGRectMake(frame.origin.x, frame.size.height/2-40.0, frame.size.width, 120.0);
        // add image button target
        [_userLoginIndicatorButton addTarget:self action:@selector(setUserLoginInfoAction) forControlEvents:UIControlEventTouchUpInside];
        // add user login indicator image button to indicator view
        [self addSubview:_userLoginIndicatorButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// method implemetation
-(void) setUserLoginIndicatorTipString:(NSString *)pTipString{
    _mUserLoginIndicatorTip.text = pTipString;
}

@end
