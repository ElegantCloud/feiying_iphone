//
//  videoIndicateBarButtonItem.h
//  feiying
//
//  Created by  on 12-4-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class customView;

@protocol customViewDelegate <NSObject>

@required

-(void) touchedDown;

@end




@interface customView : UIView{
    // customView delegate
    id<customViewDelegate> _customViewDelegate;
}

@property (nonatomic, retain) id<customViewDelegate> customViewDelegate;

@end




@interface videoIndicateBarButtonItem : UIBarButtonItem<customViewDelegate>{
    // message receiver
    id _mReceiver;
    // action
    SEL _mAction;
    
    // video indicate bar button item title
    UILabel *_mBarButtonItemTitleLabel;
}

// init with title, image, target and action
-(id) initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

@end
