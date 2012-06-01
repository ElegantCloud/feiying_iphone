//
//  searchResultViewController.h
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonTableViewController.h"

@interface searchResultViewController : commonTableViewController{
    // search view controller
    UIViewController *_mSearchViewController;
    
    // search result label string
    NSString* _mSearchResultLabelString;
}

@property (nonatomic, retain) UIViewController *searchViewController;

// begin to search with search title
-(void) beginToSearch:(NSString*) pSearchTitle;

@end
