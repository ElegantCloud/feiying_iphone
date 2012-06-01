//
//  episodeListView.m
//  feiying
//
//  Created by  on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "episodeListView.h"
#import "mtvDetailTableViewCell.h"
#import "customButton.h"

#import "../common/UserManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation episodeListView

// private methods
-(void) seriesPlay:(customButton*) pButton{
    // update other grouped button background color
    for(customButton *_button in self.subviews){
        if (![_button isEqual:pButton]) {
            _button.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    // get series episode
    NSDictionary *_episodeInfo = [_mDataSource objectAtIndex:pButton.tag];
    // get series episode url
    NSString *_episodeUrl = nil;
    if([[[UserManager shareSingleton] userBean] name]){
        _episodeUrl = [_episodeInfo objectForKey:@"video_url"];
    }
    else{
        _episodeUrl = [_episodeInfo objectForKey:@"video_url"];
    }
    NSLog(@"episode info =%@ and url = %@", _episodeInfo, _episodeUrl);
    
    // play the series episode
    [(movieTVDetailTableViewCell*)(self.superview.superview) playSeriesEpisodeAction:_episodeUrl];
}

// 2.0-|56.8|-3.0-|56.8|-3.0-|56.8|-3.0-|56.8|-3.0-|56.8|-2.0
// each row five buttons, height is 30.0, 2.0-|30.0|-3.0-|30.0|-...-3.0-|30.0|-2.0
-(void) buttonSetFrame:(customButton*) pButton andIndex:(NSInteger) pIndex{
    NSInteger _row = pIndex/5+1;
    NSInteger _col = pIndex%5+1;
    //NSLog(@"button index = %d, view row = %d and column = %d", pIndex, _row, _col);
    
    // set frame
    pButton.frame = CGRectMake(2.0+(3.0+56.8)*(_col-1), 2.0+(3.0+30.0)*(_row-1), 56.8, 30.0);
}

-(id) initWithEpisodeList:(NSArray*) pEpisodeList{
    self = [super init];
    if(self){
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        // set data source
        _mDataSource = pEpisodeList;
        
        // init button array
        for(NSInteger index = 0; index < [pEpisodeList count]; index++){
            // init custom button
            customButton *_button = [[customButton alloc] init];
            // set button grouped
            [_button setGrouped:YES];
            // set frame
            [self buttonSetFrame:_button andIndex:index];
            // set title
            NSString *_buttonTitle = (index+1<10) ? [NSString stringWithFormat:@"0%d", index+1] : [NSString stringWithFormat:@"%d", index+1];
            _button.labelText.text = _buttonTitle;
            // set tag
            [_button setTag:index];
            // add target
            [_button addTarget:self action:@selector(seriesPlay:) forControlEvents:UIControlEventTouchUpInside];
            // add button to view
            [self addSubview:_button];
        }
        
        // set frame
        NSInteger _buttonRows = ([pEpisodeList count]%5 == 0) ? [pEpisodeList count]/5 : [pEpisodeList count]/5+1;
        self.frame = CGRectMake(0.0, 0.0, 300.0, 2.0*2+_buttonRows*(30.0+3.0)-3.0);
    }
    return self;
}

@end
