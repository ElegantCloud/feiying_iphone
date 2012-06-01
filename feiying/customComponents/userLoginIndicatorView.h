//
//  userLoginIndicatorView.h
//  feiying
//
//  Created by  on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../delegate/userLoginDelegate.h"

@interface userLoginIndicatorView : UIView{
    // indicator tip
    UILabel *_mUserLoginIndicatorTip;
    
    // set user login info delegate
    id<userLoginDelegate> _setUserLoginInfoDelegate;
}

@property (nonatomic, retain) id<userLoginDelegate> setUserLoginInfoDelegate;

// set user login indicator tip string
-(void) setUserLoginIndicatorTipString:(NSString*) pTipString;

@end
