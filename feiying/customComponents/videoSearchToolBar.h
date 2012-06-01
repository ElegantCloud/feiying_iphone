//
//  videoSearchToolBar.h
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../delegate/videoSearchDelegate.h"

@interface videoSearchToolBar : UISearchBar <UISearchBarDelegate>{
    // video search delegate
    id<videoSearchDelegate> _videoSearchDelegate;
}

@property (nonatomic, retain) id<videoSearchDelegate> videoSearchDelegate;

// videoSearchToolBar videoSearch button action
-(void) videoSearchAction;

// videoSearchToolBar videoSearchCancel button action
-(void) videoSearchCancelAction;

@end
