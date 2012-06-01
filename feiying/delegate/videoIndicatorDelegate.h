//
//  videoIndicatorDelegate.h
//  feiying
//
//  Created by  on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../appViews/shareListViewController.h"

@protocol videoIndicatorDelegate <NSObject>

// play the video with url
-(void) videoPlay:(NSString*) pVideoUrl;

// delete the shared video record with type
-(void) deleteSharedVideo;

@end
