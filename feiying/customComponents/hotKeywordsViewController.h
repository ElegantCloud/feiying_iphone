//
//  hotKeywordsViewController.h
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "baseTabViewController.h"

@interface hotKeywordsViewController : baseTabViewController{
    // parent video search view controller
    UIViewController *_mParentVideoSearchViewController;
}

@property (nonatomic, retain) UIViewController *parentVideoSearchViewController;

@end
