//
//  shareTabViewController.h
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTabViewController.h"
#import "shareListViewController.h"

#import "../customComponents/shareTypeToolBar.h"

@interface shareTabViewController : baseTabViewController<shareTypeToolBarDelegate>{
    // share list segmented control
    //UISegmentedControl *_mListSegmentedControl;
    
    // share list header shareTypeToolBar
    shareTypeToolBar *_mShareTabHearderToolbar;
    
    // feilai segment table view controller
    shareListViewController *_mFeilaiSeg;
    // feilqu segment table view controller
    shareListViewController *_mFeiquSeg;
}

@property (nonatomic, retain) shareListViewController *feiquShareList;

// segment item changed
-(void) segItemChanged:(UISegmentedControl*) pSeg;

@end
