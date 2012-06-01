//
//  videoIndicateBarButtonItem.m
//  feiying
//
//  Created by  on 12-4-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoIndicateBarButtonItem.h"

#import <QuartzCore/QuartzCore.h>

#include <objc/message.h>

@implementation customView

@synthesize customViewDelegate = _customViewDelegate;

// overwrite method:(void) touchesBegan: withEvent:
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // set background color
    self.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:0.6];
    // set layer
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    
    // call customView delegate method
    //[_customViewDelegate touchedDown];
}

// overwrite method:(void) touchesEnded: withEvent:
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // recover background color
    self.backgroundColor = [UIColor clearColor];
    // recover layer
    self.layer.cornerRadius = 0.0;
    self.layer.masksToBounds = NO;
    
    // call customView delegate method
    [_customViewDelegate touchedDown];
}

@end




@implementation videoIndicateBarButtonItem

// init with title, image, target and action
-(id) initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action{
    // save target and action
    _mReceiver = target;
    _mAction = action;
    
    // super init 
    self = [super init];
    if (self) {
        // Initialization code
        // init videoIndicateBarButtonItem customView
        self.customView = [[customView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
        // set customView delegate
        ((customView*)self.customView).customViewDelegate = self;
        
        // init bar button item image
        UIImageView *_itemImgView = [[UIImageView alloc] initWithImage:image];
        // set frame
        _itemImgView.frame = CGRectMake(0.0, (self.customView.frame.size.height-24.0)/2, 24.0, 24.0);
        // add to customView
        [self.customView addSubview:_itemImgView];
        
        // init bar button item title
        _mBarButtonItemTitleLabel = [[UILabel alloc] init];
        // set background color
        _mBarButtonItemTitleLabel.backgroundColor = [UIColor clearColor];
        // set frame
        _mBarButtonItemTitleLabel.frame = CGRectMake(_itemImgView.frame.origin.x+_itemImgView.frame.size.width, 5.0, 40.0, 30.0);
        // set text and font
        _mBarButtonItemTitleLabel.text = title;
        _mBarButtonItemTitleLabel.textColor = [UIColor whiteColor];
        _mBarButtonItemTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        // add to customView
        [self.customView addSubview:_mBarButtonItemTitleLabel];
    }
    return self;
}

// overwrite method:(void) setTitle:
-(void) setTitle:(NSString *)title{
    // judge title lenth
    if ([title length] > 2) {
        // get new bar button item title label width
        CGFloat _width = 40.0*(([title length]%2) ? [title length]/2 : [title length]/2+1);
        
        // update customeView frame and barButtonItemTitleLabel frame
        self.customView.frame = CGRectMake(self.customView.frame.origin.x, self.customView.frame.origin.y, self.customView.frame.size.width-_mBarButtonItemTitleLabel.frame.size.width+_width, self.customView.frame.size.height);
        _mBarButtonItemTitleLabel.frame = CGRectMake(_mBarButtonItemTitleLabel.frame.origin.x, _mBarButtonItemTitleLabel.frame.origin.y, _width, _mBarButtonItemTitleLabel.frame.size.height);
    }
    // update bar button item title
    _mBarButtonItemTitleLabel.text = title;
}

// overwrite mehtod:(void) setAction:
-(void) setAction:(SEL)action{
    // update action
    _mAction = action;
}

// customViewDelegate methods implemetation
-(void) touchedDown{
    if ([_mReceiver respondsToSelector:_mAction]) {
        // send message
        objc_msgSend(_mReceiver, _mAction);
    }
}

@end
