//
//  videoSearchViewController.h
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../delegate/videoSearchDelegate.h"

#import "searchResultViewController.h"
#import "../customComponents/maskView.h"
#import "../customComponents/videoSearchToolBar.h"
#import "../customComponents/hotKeywordsViewController.h"

@interface videoSearchViewController : UIViewController <videoSearchDelegate, maskViewDelegate>{
    // video search toolBar
    videoSearchToolBar *_mvsToolBar;
    
    // hot keywords view controller
    hotKeywordsViewController *_mHotKeywordsViewController;
    
    // view search result table view
    searchResultViewController *_mSRTableViewController;
    
    // mask view
    maskView *_mMaskView;
}

@property (nonatomic, retain) videoSearchToolBar *videoSearchToolbar;

// video search back
-(void) videoSearchBack;

@end
