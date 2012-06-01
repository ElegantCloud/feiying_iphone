//
//  feiyingMovieSearchToolBar.m
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoSearchToolBar.h"

#import "../appViews/videoSearchViewController.h"

#import "../util/NSString+util.h"

#import "../openSource/Toast/iToast.h"

@implementation videoSearchToolBar

@synthesize videoSearchDelegate = _videoSearchDelegate;

// private methods
-(UIButton*) getSearchButton{
    UIButton *_ret = nil;
    
    // get search button
    for(id _subview in self.subviews){
        if([_subview isKindOfClass:[UIButton class]]){
            _ret = (UIButton *)_subview;
            break;
        }
    }
    
    return _ret;
}

// self init
-(id) init{
    self = [super init];
    if (self) {
        // Custom initialization
        // search bar setting
        self.barStyle = UIBarStyleBlackTranslucent;
        self.autoresizesSubviews = YES;
        self.placeholder = @"搜索";
        self.delegate = self;
    }
    return self;
}

// UISearchBarDelegate methods implemetation
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self resignFirstResponder];
    
    // search video
    [self videoSearchAction];
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // show search button
    self.showsCancelButton = YES;
    
    // update search button title and set target
    UIButton *_searchButton = [self getSearchButton];
    [_searchButton setTitle:@"取消" forState:UIControlStateNormal];
    [_searchButton setTintColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0]];
    // add target
    [_searchButton addTarget:self action:@selector(videoSearchCancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    // video search begin
    [_videoSearchDelegate videoSearchBegin];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // hide search button
    self.showsCancelButton = NO;
    
    // video search end
    [_videoSearchDelegate videoSearchEnd];
}

// methods implemetation
-(void) videoSearchAction{
    NSLog(@"videoSearchToolBar - toolBarMovieSearch - searchInputText: %@", self.text);
    
    [self resignFirstResponder];
    
    // call delegate method to search with keyword
    if(self.text && ![[self.text trimWhitespaceAndNewlineCharacter] isEqualToString:@""]){
        [_videoSearchDelegate videoSearch:self.text];
    }
    // call delegate method to back to hotKeywods view
    else{
        // the keyword is whitespace
        if([[self.text trimWhitespaceAndNewlineCharacter] isEqualToString:@""] && ![self.text isEqualToString:@""]){
            iToast *_toast = [iToast makeText:@"请不要搜索空关键词."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
}

-(void) videoSearchCancelAction{
    [self resignFirstResponder];
}

@end
