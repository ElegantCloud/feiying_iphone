//
//  tableFooterView.m
//  feiying
//
//  Created by  on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "tableFooterView.h"

// table foot spinner view
@implementation tableFootSpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        // create indicator text label
        UILabel *_indicatorText = [[UILabel alloc] init];
        // set frame
        _indicatorText.frame = CGRectMake(140.0-64.0, 11.0, 103.0, 23.0);
        // set text and text font
        _indicatorText.text = @"获取更多视频...";
        _indicatorText.font = [UIFont systemFontOfSize:14.0];
        _indicatorText.textColor = [UIColor grayColor];
        _indicatorText.textAlignment = UITextAlignmentCenter;
        
        // create and init activityView
        UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        // set frame
		_activityView.frame = CGRectMake(140.0+64.0+2.0, 11.0, 23.0, 23.0);
        
        // add indicatorText and activityView to view
        [self addSubview:_indicatorText];
		[self addSubview:_activityView];
        
        // start animating
        [_activityView startAnimating];
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

@end




// table foot no more data view
@implementation tableFootNoMoreDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create indicator text label
        UILabel *_indicatorText = [[UILabel alloc] init];
        // set frame
        _indicatorText.frame = CGRectMake((320.0-120.0)/2, 11.0, 120.0, 23.0);
        // set text and text font
        _indicatorText.text = @"没有更多数据";
        _indicatorText.font = [UIFont boldSystemFontOfSize:16.0];
        _indicatorText.textColor = [UIColor blackColor];
        _indicatorText.textAlignment = UITextAlignmentCenter;
        
        // add indicatorText and activityView to view
        [self addSubview:_indicatorText];
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

@end
