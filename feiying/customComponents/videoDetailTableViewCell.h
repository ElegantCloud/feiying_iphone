//
//  videoDetailTableViewCell.h
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"
#import "../appViews/shareListViewController.h"

#import "../delegate/videoIndicatorDelegate.h"

#import "../customComponents/customButton.h"

@interface videoDetailTableViewCell : baseTableViewCell{
    id<videoIndicatorDelegate> _videoIndicatorDelegate;
}

@property (nonatomic, retain) id<videoIndicatorDelegate> videoIndicatorDelegate;

// init with video image, title, total time, size, play count, share count, fav count, category, source id and video url
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage andTotalTime:(NSString*) pTotalTime andSize:(NSString*) pSize andPlaycount:(NSString*) pPlaycount andSharecount:(NSString*) pSharecount andFavcount:(NSString*) pFavcount andDeleteFavFlag:(BOOL) pDeleteFav andDeleteShareFlag:(BOOL) pDeleteShare andShareInfo:(NSDictionary*) pShareInfo;

// play the video action
-(void) playVideoAction;
// delete the share video record action
-(void) deleteShareVideoRecordAction;

// set share info view
-(NSInteger) setShareInfoView:(NSDictionary*) pShareInfo andIsShared:(BOOL) pIsShared;

@end
