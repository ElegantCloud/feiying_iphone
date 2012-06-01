//
//  videoDetailViewController.h
//  feiying
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

#import "commonTableViewController.h"
#import "videoChannelViewController.h"
#import "../delegate/videoIndicatorDelegate.h"

#import "../openSource/MediaPlayer/feiyingVideoPlayerViewController.h"
#import "../openSource/ASIHTTPRequest/ASIHTTPRequestDelegate.h"
#import "../openSource/MBProgressHUD/MBProgressHUD.h"

@interface videoDetailViewController : baseTabViewController <videoIndicatorDelegate, MFMessageComposeViewControllerDelegate, MBProgressHUDDelegate>{
    // video url
    NSString *_mVideoUrl;
    
    // video user indicator progress
    MBProgressHUD *_mHud;
    
    // add or delete fav video flag
    BOOL _mIsDeleteFavVideo;
    
    // add or delete share video flag
    BOOL _mIsDeleteShareVideo;
    // video shared type
    ShareListViewType _mVideoSharedType;
    // video shared id
    NSString *_mVideoSharedId;
    // video share time
    NSString *_mVideoShareTime;
    // video share persons
    NSString *_mVideoSharePersons;
    
    // parent table view: video channel view or share list view or search result view
    commonTableViewController *_mParentTableViewController;
    // indexPath in parent table view: video channel view or share list view or search result view
    NSIndexPath *_mParentTableViewIndexPath;
    
    // toolbar button items
    UIBarButtonItem *_mFavBarButtonItem;
    UIBarButtonItem *_mShareBarButtonItem;
}

@property (nonatomic, readwrite) BOOL isDeleteFavVideoFlag;

@property (nonatomic, readwrite) BOOL isDeleteShareVideoFlag;
@property (nonatomic, readwrite) ShareListViewType videoSharedType;
@property (nonatomic, retain) NSString *videoSharedId;
@property (nonatomic, retain) NSString *videoSharedTime;
@property (nonatomic, retain) NSString *videoSharedPersons;

@property (nonatomic, retain) commonTableViewController *parentTableViewController;
@property (nonatomic, retain) NSIndexPath *parentTableViewIndexPath;

// init with video detail infomation for first page
-(id) initWithDetailInfo:(NSDictionary*) pDetailInfo;
// init video detail infomation with source id and video channel id
-(id) initWithSourceID:(NSString*) pSourceId andVideoChannelId:(NSNumber*) pVideoChannelId;

// add fav video
-(void) videoAddFav;
// delete fav video
-(void) videoDeleteFav;
// share the video to persons
-(void) videoShare;

// get video shared info dictionary
-(NSDictionary*) getVideoSharedInfo;

@end
