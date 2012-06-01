//
//  customButton.m
//  feiying
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "customButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation customButton

@synthesize labelText = _mLabel;

@synthesize buttonPressedBgColor = _mPressedBgColor;

@synthesize isPressed = _mButtonPressed;

// private methods
// change uicontrol touch down background color
-(void) changeTouchdownBGColor{
    //NSLog(@"customButton - touchdown.");
    
    // set button pressed
    _mButtonPressed = YES;
    
    // set background color
    if(!_mPressedBgColor){
        _mPressedBgColor = [UIColor grayColor];
    }
    self.backgroundColor = _mPressedBgColor;
}

// change uicontrol touch up background color
-(void) changeTouchupBGColor{ 
    //NSLog(@"customButton - touchup, normal background color = %@.", _mNormalBgColor);
    
    // set button pressed
    _mButtonPressed = NO;
    
    // not grouped button recover background color 
    self.backgroundColor = _mNormalBgColor;
}

// self init
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        // Custom initialization
        // save normal background color and set background color
        _mNormalBgColor = [UIColor colorWithRed:106.0/255.0 green:203.0/255.0 blue:221.0/255.0 alpha:1.0];
        self.backgroundColor = _mNormalBgColor;
        
        // set view layer
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        // label setting
        _mLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x+3.0, self.bounds.origin.y+(self.frame.size.height-20.0)/2, self.frame.size.width-2*3.0, 20.0)];
        // set background color
        _mLabel.backgroundColor = [UIColor clearColor];
        // font
        _mLabel.font = [UIFont systemFontOfSize:14.0];
        _mLabel.textAlignment = UITextAlignmentCenter;
        
        // change background color
        [self addTarget:self action:@selector(changeTouchdownBGColor) forControlEvents:UIControlEventTouchDown];
        if(!_mIsGrouped){
            [self addTarget:self action:@selector(changeTouchupBGColor) forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(changeTouchupBGColor) forControlEvents:UIControlEventTouchUpOutside];
        }
        
        // add to view
        [self addSubview:_mLabel];
    }
    return self;
}

// overwrite method:(void) setFrame:
-(void) setFrame:(CGRect)frame{
    // set button frame
    super.frame = frame;
    
    // set view layer
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // update button label frame
    _mLabel.frame = CGRectMake(3.0, (frame.size.height-20.0)/2, frame.size.width-2*3.0, 20.0);
}

// methods implemetation
-(void) setGrouped:(BOOL)pGrouped{
    // if grouped
    if (pGrouped) {
        [self removeTarget:self action:@selector(changeTouchupBGColor) forControlEvents:UIControlEventTouchUpInside];
        [self removeTarget:self action:@selector(changeTouchupBGColor) forControlEvents:UIControlEventTouchUpOutside];
    }
}

-(void) setNormalBgColor:(UIColor *)pColor{
    // save normal background color
    _mNormalBgColor = pColor;
    
    // set background color
    [super setBackgroundColor:pColor];
}

-(void) recoverButton{
    // set button predded
    _mButtonPressed = NO;
    
    // recover background color
    self.backgroundColor = _mNormalBgColor;
}

-(void) layerNoCornerRadius{
    // set view layer
    self.layer.cornerRadius = 1;
    self.layer.masksToBounds = NO;
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0] CGColor];
}

@end
