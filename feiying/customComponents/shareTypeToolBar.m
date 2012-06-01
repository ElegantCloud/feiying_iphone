//
//  shareTypeToolBar.m
//  feiying
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "shareTypeToolBar.h"

#import "../customComponents/customButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation shareTypeToolBar

@synthesize selectedItemIndex = _mSelectedItemIndex;

@synthesize shareTypeToolBarDelegate = _shareTypeToolBarDelegate;

// overwrite method:(id) initWithFrame:
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        // Custom initialization
        // set toolbar style
        self.barStyle = UIBarStyleBlackOpaque;
    }
    return self;
}

// methods implemetation
-(void) setBarButtonItems:(NSArray *)pItems{
    //NSLog(@"setBarButtonItems - pItems = %@", pItems);
    
    // judge items
    if (pItems == nil) {
        return;
    }
    
    /*
    // container view
    UIView *_containerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 0.0, 80*2-1.0, 44.0)];
    // set view layer
    _containerView.layer.cornerRadius = 3;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.borderWidth = 1.0;
    _containerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    */
     
    // set each barButtonItem
    for (int _index = 0; _index < [pItems count]; _index++) {
        // create and init barButton
        customButton *_barButton = [[customButton alloc] init];
        // set grouped
        [_barButton setGrouped:YES];
        // set tag
        _barButton.tag = _index;
        // set frame
        _barButton.frame = CGRectMake((320.0-2*80.0)/2+(_index)*(80.0-1.0), (44.0-30.0)/2, 80.0, 30.0);
        // set normal background color
        [_barButton setNormalBgColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.4]];
        // set pressed background color
        _barButton.buttonPressedBgColor = [UIColor colorWithRed:165.0/255.0 green:507.5/255.0 blue:552.5/255.0 alpha:0.6];
        // set title and its font
        _barButton.labelText.text = [pItems objectAtIndex:_index];
        _barButton.labelText.textColor = [UIColor grayColor];
        _barButton.labelText.font = [UIFont boldSystemFontOfSize:14.0];
        // set layer no cornerRadius
        [_barButton layerNoCornerRadius];
        // add target
        [_barButton addTarget:self action:@selector(barButtonItemBeenSelected:) forControlEvents:UIControlEventTouchDown];
        
        // add bar button to cantainer
        //[_containerView addSubview:_barButton];
        
        // add to subViews
        [self addSubview:_barButton];
        
        // set default selected item index
        if(_index == _mSelectedItemIndex){
            _barButton.backgroundColor = _barButton.buttonPressedBgColor;
            
            _barButton.labelText.textColor = [UIColor whiteColor];
        }
    }
    
    // add container view to subViews
    //[self addSubview:_containerView];
}

-(void) barButtonItemBeenSelected:(UIButton *)pBarButton{
    NSLog(@"barButtonItemBeenSelected - barButton = %@", ((customButton*)pBarButton).labelText.text);
    
    // set selected bar button item text color
    ((customButton*)pBarButton).labelText.textColor = [UIColor whiteColor];
    
    // judge each bar button in bar subViews
    for (UIButton *_button in self.subviews) {
        if (![_button isEqual:pBarButton]) {
            if([_button respondsToSelector:@selector(recoverButton)]){
                [(customButton*)_button recoverButton];
                
                ((customButton*)_button).labelText.textColor = [UIColor grayColor];
            }
            else{
                NSLog(@"BarButton is normal button, can't recover normal background color.");
            }
        }
    }
    
    // call shareTypeToolBar delegate method to process
    [_shareTypeToolBarDelegate barItemChanged:pBarButton];
}

@end
