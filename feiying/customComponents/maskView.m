//
//  maskView.m
//  feiying
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "maskView.h"

@implementation maskView

@synthesize maskViewDelegate = _maskViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesBegan, touches = %@ and event = %@", touches, event);
    
    // call maskViewDelegate delegate method
    if(_maskViewDelegate){
        [_maskViewDelegate touchInside:self];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesEnded, touches = %@ and event = %@", touches, event);
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesCancelled, touches = %@ and event = %@", touches, event);
}

@end
