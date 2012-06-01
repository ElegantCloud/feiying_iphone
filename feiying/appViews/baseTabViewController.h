//
//  baseTabViewController.h
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../openSource/ASIHTTPRequest/ASIHTTPRequestDelegate.h"
#import "../openSource/EGOTableViewPullRefresh/EGORefreshTableHeaderView.h"

#import "../delegate/userLoginDelegate.h"

#import "../customComponents/userLoginIndicatorView.h"

#import "../util/UIImage+util.h"

typedef enum {
    videoImage,
    mtvImage,
    ssImage
} videoImageType;

typedef enum {
    synchronous,
    asynchronous
} asiHTTPRequestType;

@interface baseTabViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, userLoginDelegate>{
    UITableView *_mTableView;
    UITabBarItem *_mTabBarItem;
    
    NSMutableArray *_mTableDataSource;
    
    NSMutableDictionary *_mPagerInfo;
    
    // table data refresh header view
    EGORefreshTableHeaderView *_mRefreshHeaderView;
    // reload dataSource flag
    BOOL _reloading;
    
    // append more data to dataSource flag
    BOOL _appending;
    
    NSString *_mRootUrl;
    
    // view loading activityIndicator view
    UIActivityIndicatorView *_mViewLoadingIndicatorView;
    // user login indicator view
    userLoginIndicatorView *_mUserLoginIndicatorView;
    
    // table view reload flag
    BOOL _mTableViewReload;
}

@property (nonatomic, retain) NSString *rootUrl;
@property (nonatomic, readwrite) BOOL isTableViewReload;

@property (nonatomic, retain) NSMutableArray *tableDataSource;
@property (nonatomic, retain) UITableView *tableView;

// send normal http request
-(void) sendNormalRequestWithUrl:(NSString*) pUrl andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType;

// send request with url
-(void) sendRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType;

// send sig request with url
-(void) sendSigRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType;

// send authenticate request with finished and failed response method
-(void) sendAuthenticateRequest:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType;

// popup fav and share tab navigation viewController and update rootViewController
-(void) popupFavShareTabNavAndUpdateRoot;

// show alertView with title and message
-(UIAlertView*) showUserInfoSettingAlertViewWithTitle:(NSString*) pTitle andMsg:(NSString*) pMsg;

// init table dataSource
-(void) initTableDataSource:(NSString*) pRequestUrl;

// video search navigation button response method
-(void) videoSearchNavigation;

// set video init image and type
-(UIImage*) setVideoInitImageInRow:(NSInteger) pRow andImageType:(videoImageType) pImageType;

// video infomation
// video image
-(UIImage*) getVideoImageInRow:(NSInteger) pRow;
// video title
-(NSString*) getVideoTitleInRow:(NSInteger) pRow;
// video total time
-(NSString*) getVideoTotalTimeInRow:(NSInteger) pRow;
// video episode count
-(NSString*) getVideoEpisodeCountInRow:(NSInteger) pRow;
// video episode state
-(NSString*) getVideoEpisodeStateInRow:(NSInteger) pRow;
// video size
-(NSString*) getVideoSizeInRow:(NSInteger) pRow;
// video play count
-(NSString*) getVideoPlaycountInRow:(NSInteger) pRow;
// video share count
-(NSString*) getVideoSharecountInRow:(NSInteger) pRow;
// video fav count
-(NSString*) getVideoFavcountInRow:(NSInteger) pRow;
// video actors
-(NSString*) getVideoActorsInRow:(NSInteger) pRow;
// video release date
-(NSString*) getVideoReleaseDateInRow:(NSInteger) pRow;
// video origin locate
-(NSString*) getVideoOriginLocateInRow:(NSInteger) pRow;
// video director
-(NSString*) getVideoDirectorInRow:(NSInteger) pRow;
// video description
-(NSString*) getVideoDescriptionInRow:(NSInteger) pRow;
// video episode list
-(NSArray*) getVideoEpisodeListInRow:(NSInteger)pRow;
// video channel id
-(NSNumber*) getVideoChannelIdInRow:(NSInteger) pRow;
// video source id
-(NSString*) getVideoSourceIdInRow:(NSInteger) pRow;
// video url
-(NSString*) getVideoUrlInRow:(NSInteger) pRow;
// video share time
-(NSString*) getVideoShareTimeInRow:(NSInteger) pRow;
// video share id
-(NSString*) getVideoShareIdInRow:(NSInteger) pRow;
// share video sent to
-(NSString*) getShareVideoSendToInRow:(NSInteger) pRow;
// share video receive from
-(NSString*) getShareVideoReceiveFromInRow:(NSInteger) pRow;

// channel information
// channel image
-(UIImage*) getChannelImageInRow:(NSInteger) pRow;
// channel title
-(NSString*) getChannelTitleInRow:(NSInteger) pRow;
// channel id
-(NSNumber*) getChannelIdInRow:(NSInteger) pRow;
// channel fav video count
-(NSString*) getChannelFavVideoCountInRow:(NSInteger)pRow;

@end
