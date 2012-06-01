//
//  videoDetailViewController.m
//  feiying
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoDetailViewController.h"

#import "videoShareViewController.h"
#import "../customComponents/videoDetailTableViewCell.h"
#import "shareTabViewController.h"
#import "../customComponents/videoIndicateBarButtonItem.h"

#import "../common/UserManager.h"
#import "../util/NSString+util.h"
#import "../util/NSArray+util.h"
#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/Toast/iToast.h"

#import "AppDelegate.h"

@implementation videoDetailViewController

@synthesize isDeleteFavVideoFlag = _mIsDeleteFavVideo;

@synthesize isDeleteShareVideoFlag = _mIsDeleteShareVideo;
@synthesize videoSharedType = _mVideoSharedType;
@synthesize videoSharedId = _mVideoSharedId;
@synthesize videoSharedTime = _mVideoShareTime;
@synthesize videoSharedPersons = _mVideoSharePersons;

@synthesize parentTableViewController = _mParentTableViewController;
@synthesize parentTableViewIndexPath = _mParentTableViewIndexPath;


// private methods
// send video play authenticate request
-(void) sendVideoPlayAuthenticateRequest{
    [self sendAuthenticateRequest:@selector(didFinishedRequestVideoPlayAuth:) andFailedRespMeth:@selector(didFailedRequestVideoPlayAuth:) andRequestType:synchronous];
}

// send video share authenticate request
-(void) sendVideoShareAuthenticateRequest{
    [self sendAuthenticateRequest:@selector(didFinishedRequestVideoShareAuth:) andFailedRespMeth:@selector(didFailedRequestVideoShareAuth:) andRequestType:synchronous];
}

// send add video play count request
-(void) sendAddPlayCountRequest{
    // get video sourceId and user name
    NSString *_sourceId = [self getVideoSourceIdInRow:0];
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    NSLog(@"sendAddVideoPlayCountRequest - request param - video source id = %@ and login user name = %@", _sourceId, _loginName);
    
    // init add video play count request param
    NSMutableDictionary *_addPlayCountParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _sourceId, @"sourceId", nil];
    
    [self sendSigRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant addVideoPlayCountUrl]] andPostBody:_addPlayCountParam andUserInfo:nil andFinishedRespMeth:nil andFailedRespMeth:nil andRequestType:synchronous];
}

// send add video fav request
-(void) sendVideoAddFavRequest{
    // get video sourceId, category and user name
    NSString *_sourceId = [self getVideoSourceIdInRow:0];
    NSNumber *_channelId = [self getVideoChannelIdInRow:0];
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    NSLog(@"sendVideoFavRequest - request param - video source id = %@, category = %@ and login user name = %@", _sourceId, _channelId, _loginName);
    
    // init add fav request param
    NSMutableDictionary *_addFavParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _sourceId, @"sourceId", _channelId, @"category", @"add", @"action", nil];
    
    [self sendSigRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant videoFavIndicatorUrl]] andPostBody:_addFavParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestAddFav:) andFailedRespMeth:@selector(didFailedRequestAddFav:) andRequestType:synchronous];
}

// send delete fav video request
-(void) sendVideoDeleteFavRequest{
    // get video sourceId, category and user name
    NSString *_sourceId = [self getVideoSourceIdInRow:0];
    NSNumber *_channelId = [self getVideoChannelIdInRow:0];
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    NSLog(@"sendVideoDeleteFavRequest - request param - video source id = %@, category = %@ and login user name = %@", _sourceId, _channelId, _loginName);
    
    // init delete fav request param
    NSMutableDictionary *_deleteFavParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _sourceId, @"sourceId", _channelId, @"category", @"del", @"action", nil];
    
    [self sendSigRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant videoFavIndicatorUrl]] andPostBody:_deleteFavParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestDeleteFav:) andFailedRespMeth:@selector(didFailedRequestDeleteFav:) andRequestType:synchronous];
}

// send share video request
-(void) sendShareVideoRequest:(NSString*) pPhoneStr andInfo:(NSString*) pInfo{
    // get video sourceId, category and user name
    NSString *_sourceId = [self getVideoSourceIdInRow:0];
    NSNumber *_channelId = [self getVideoChannelIdInRow:0];
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    NSLog(@"sendShareVideoRequest - request param - video source id = %@, category = %@, login user name = %@ and share people = %@ and share note = %@", _sourceId, _channelId, _loginName, pPhoneStr, pInfo);
    
    // init send share video request param
    NSMutableDictionary *_sendShareParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _sourceId, @"sourceId", _channelId, @"channel", pPhoneStr, @"phoneStr", nil];
    if(pInfo){
        [_sendShareParam setObject:pInfo forKey:@"info"];
    }
    
    [self sendSigRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant sendShareUrl]] andPostBody:_sendShareParam andUserInfo:nil  andFinishedRespMeth:@selector(didFinishedRequestSendShare:) andFailedRespMeth:@selector(didFailedRequestSendShare:) andRequestType:synchronous];
}

// send delete shared video request
-(void) sendDeleteSharedVideoRequest{
    // get user login name
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    // init delete the shared video record request url
    NSString *_deleteSVRUrl = nil;
    // delete received shared video
    if(_mVideoSharedType == Received){
        _deleteSVRUrl = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant deleteReceivedShareUrl]];
    }
    // delete sended shared video
    else if(_mVideoSharedType == Sended){
        _deleteSVRUrl = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant deleteSendedShareUrl]];
    }
    NSLog(@"sendDeleteSharedVideoRequest - request param - video share id = %@, shared type = %d and login user name = %@", _mVideoSharedId, _mVideoSharedType, _loginName);
    
    // init delete shared video request param
    NSMutableDictionary *_deleteSharedParam = _deleteSharedParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _mVideoSharedId, @"shareId", nil];
    
    [self sendSigRequestWithUrl:_deleteSVRUrl andPostBody:_deleteSharedParam andUserInfo:nil  andFinishedRespMeth:@selector(didFinishedRequestDeleteShared:) andFailedRespMeth:@selector(didFailedRequestDeleteShared:) andRequestType:synchronous];
}

// notify all fav tab views
-(void) notifyFavtabViews{
    // get fav tab navigation view controller
    UINavigationController *_retNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:1];
    // get fav tab all view controllers
    NSArray *_navViewControllers = [NSArray arrayWithArray:_retNav.viewControllers];
    
    // judge fav tab root view controller navigation view controller
    if(!_navViewControllers){
        NSLog(@"error, navigation view controller is nil.");
        
        return;
    }
    
    // update view
    for(baseTabViewController *_vc in _navViewControllers){
        //NSLog(@"the fab tab navigation each view controller title = %@", _vc.title);
        _vc.isTableViewReload = NO;
    }
}

// notify share tab feiqu share list view
-(void) notifySharetabFeiquShareListView{
    // get share tab navigation view controller
    UINavigationController *_retNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:0];
    
    // update feiqu share list
    ((shareTabViewController*)[_retNav.viewControllers objectAtIndex:0]).feiquShareList.isTableDSRefresh = YES;
}

// notify fab tab root view controller
-(void) notifyFavTabRootView{
    //NSLog(@"fav tab current visible view controller = %@", _mParentTableViewController.title);
    
    // get root view controller
    baseTabViewController *_rootViewController = [_mParentTableViewController.navigationController.viewControllers objectAtIndex:0];
    
    _rootViewController.isTableViewReload = NO;
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// init with video detail infomation
-(id) initWithDetailInfo:(NSDictionary *)pDetailInfo{
    self = [super init];
    if(self){
        // Custom initialization
        //NSLog(@"videoDetailViewController - initWithDetailInfo - video detail info: %@", pDetailInfo);
        
        // base setting
        // set title
        self.title = @"详情";
        
        // remove refreshHeaderView
        [_mRefreshHeaderView removeFromSuperview];
        
        // set navigationItem nil
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        // tabBar item setting
        self.tabBarItem = nil;
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        
        // create and init bottom toolbar
        UIToolbar *_bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(_mTableView.bounds.origin.x, _mTableView.bounds.origin.y+_mTableView.frame.size.height, _mTableView.frame.size.width, 49.0)];
        // set tint color and style
        _bottomToolbar.tintColor = [UIColor colorWithWhite:0.111 alpha:1.0];
        _bottomToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        // bar button items
        // "space" bar item
        UIBarItem *_space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _mFavBarButtonItem = [[videoIndicateBarButtonItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"favTab.png"] target:self action:@selector(videoAddFav)];
        _mShareBarButtonItem = [[videoIndicateBarButtonItem alloc] initWithTitle:@"分享" image:[UIImage imageNamed:@"shareTab.png"] target:self action:@selector(videoShare)];
        
        // set  button items
        _bottomToolbar.items = [NSArray arrayWithObjects:_mFavBarButtonItem, _space, _mShareBarButtonItem, nil];
        // add to view
        [self.view addSubview:_bottomToolbar];
        
        // create and init user indicator progress
        _mHud = [[MBProgressHUD alloc] initWithView:self.view];
        //_mHud.mode = MBProgressHUDModeDeterminate;
        // set label text
        _mHud.labelText = @"处理中...";
        // set delegate
        _mHud.delegate = self;
        // add subViews to self view
        [self.view addSubview:_mHud];
        
        // has video detail information
        if(pDetailInfo){
            // stop viewLoadingIndicatorView and show tableView
            [_mViewLoadingIndicatorView stopAnimating];
            _mTableView.hidden = NO;
            
            // set table dataSource
            _mTableDataSource = [NSMutableArray arrayWithObjects:pDetailInfo, nil];
        }
    }
    return self;
}

// init video detail infomation with source id and video channel id
-(id) initWithSourceID:(NSString *)pSourceId andVideoChannelId:(NSNumber *)pVideoChannelId{
    self = [self initWithDetailInfo:nil];
    if(self){
        // Custom initialization
        // set fetch video detail infomation url
        NSLog(@"videoDetailViewController - initWithSourceId - source id: %@ and category = %@", pSourceId, pVideoChannelId);
        NSString *_videoDetaiInfolUrl = [NSString stringWithFormat:@"%@%@/%d/%@", [systemConstant systemRootUrl], [urlConstant commonvVideoDetailInfoPageUrl], pVideoChannelId.integerValue, pSourceId];
        NSLog(@"video detail info url = %@", _videoDetaiInfolUrl);
        
        // init table dataSource
        [self initTableDataSource:_videoDetaiInfolUrl];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

// update fav and share barButtonItem title and target
-(void) viewWillAppear:(BOOL)animated{
    //NSLog(@"_mIsDeleteFavVideo = %d and _mIsDeleteShareVideo = %d", _mIsDeleteFavVideo, _mIsDeleteShareVideo);
    
    // delete fav video
    if(_mIsDeleteFavVideo){
        _mFavBarButtonItem.title = @"取消收藏";
        _mFavBarButtonItem.action = @selector(videoDeleteFav);
    }
    
    // delete shared video
    if(_mIsDeleteShareVideo){
        _mShareBarButtonItem.title = @"转发";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

// overwrite UIScrollViewDelegate method:(void)scrollViewDidEndDecelerating:
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //
}

// overwrite UIScrollViewDelegate method:(void) scrollViewDidScroll:
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //
}

// overwrite UIScrollViewDelegate method:(void) scrollViewDidEndDragging: willDecelerate:
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //
}

// overwrite method:(void) initTableDataSource:
-(void) initTableDataSource:(NSString *)pRequestUrl{
    // send get video detail information ASIHTTPRequest
    // judge user info had been setting
    if([[[UserManager shareSingleton] userBean] name]){
        // init get video detail info request param
        NSMutableDictionary *_videoDetailInfoParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", nil];
        
        [self sendSigRequestWithUrl:pRequestUrl andPostBody:_videoDetailInfoParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
    }
    else{
        [self sendNormalRequestWithUrl:pRequestUrl andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
    }
}

// overwrite UITableViewDataSource method:(UITableViewCell*) tableView: cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    videoDetailTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"videoDetailViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellVideoImage = [self getVideoImageInRow:[indexPath row]];
        NSString *_cellVideoTitle = [self getVideoTitleInRow:[indexPath row]];
        NSString *_cellVideoTotalTime = [self getVideoTotalTimeInRow:[indexPath row]];
        NSString *_cellVideoSize = [self getVideoSizeInRow:[indexPath row]];
        NSString *_cellVideoPlaycount = [self getVideoPlaycountInRow:[indexPath row]];
        NSString *_cellVideoSharecount = [self getVideoSharecountInRow:[indexPath row]];
        NSString *_cellVideoFavcount = [self getVideoFavcountInRow:[indexPath row]];
        //NSLog(@"cell %d - video image = %@, title: %@, total time: %@, size: %@, play count: %@, share count: %@ and fav count: %@.", [indexPath row], _cellVideoImage, _cellVideoTitle, _cellVideoTotalTime, _cellVideoSize, _cellVideoPlaycount, _cellVideoSharecount, _cellVideoFavcount);
        
        _cell = [[videoDetailTableViewCell alloc] initWithTitle:_cellVideoTitle andImage:_cellVideoImage andTotalTime:_cellVideoTotalTime andSize:_cellVideoSize andPlaycount:_cellVideoPlaycount andSharecount:_cellVideoSharecount andFavcount:_cellVideoFavcount andDeleteFavFlag:_mIsDeleteFavVideo andDeleteShareFlag:_mIsDeleteShareVideo andShareInfo:[self getVideoSharedInfo]];
        // set user indicator delegate
        _cell.videoIndicatorDelegate = self;
    }
    
    return _cell;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: willSelectRowAtIndexPath:
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // init content array
    NSMutableDictionary *_contents = [[NSMutableDictionary alloc] init];
    // add each content to array if not nil
    // No.1 content video image url
    //[_contents setObject:[[_mTableDataSource objectAtIndex:[indexPath row]] objectForKey:@"image_url"] forKey:@"image_url"];
    // No.2 content video description
    if ([self getVideoDescriptionInRow:[indexPath row]]) {
         [_contents setObject:[self getVideoDescriptionInRow:[indexPath row]] forKey:@"description"];
    }
    // No.3 content video episodeList
    if ([self getVideoEpisodeListInRow:[indexPath row]]) {
        [_contents setObject:[self getVideoEpisodeListInRow:[indexPath row]] forKey:@"episodeList"];
    }
    // No.4 content video sharedInfo
    if ([self getVideoSharedInfo]) {
        [_contents setObject:[self getVideoSharedInfo] forKey:@"sharedInfo"];
    }
    
    return [videoDetailTableViewCell getCellHeightWithContents:_contents];
    
    /*
    tableView.delegate = nil;
    CGFloat _ret = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    tableView.delegate = self;
     
    return _ret;
     */
}

// videoUserIndicatorDelegate methods implemetation
// play the video
-(void) videoPlay:(NSString*) pVideoUrl{
    // get video url, nil is movie or small video and other is series
    if (pVideoUrl) {
        _mVideoUrl = pVideoUrl;
    }
    else {
        // set default movie or small video url 
        NSMutableString *_movieSmallVideoUrl = [NSMutableString stringWithFormat:@"%@/%@.m3u8", [urlConstant videoUrl], [self getVideoSourceIdInRow:0]];
        // append linked movie or small video url, seperate by "||"
        [_movieSmallVideoUrl appendString:@"||"];
        [_movieSmallVideoUrl appendString:[self getVideoUrlInRow:0]];
        
        _mVideoUrl = _movieSmallVideoUrl;
    }
    /*
    if([[[UserManager shareSingleton] userBean] businessState] == opened){
        _mVideoUrl = (pVideoUrl) ? pVideoUrl : [NSString stringWithFormat:@"%@/%@.mp4", [urlConstant videoUrl], [self getVideoSourceIdInRow:0]];
    }
    else{
        // update video url
        _mVideoUrl = (pVideoUrl) ? pVideoUrl : [self getVideoUrlInRow:0];
    }
     */
    
    // show progressHud
    [_mHud showWhileExecuting:@selector(sendVideoPlayAuthenticateRequest) onTarget:self withObject:nil animated:YES];
}

// delete the shared video record with type
-(void) deleteSharedVideo{
    if(![[[UserManager shareSingleton] userBean] userKey]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法删除此分享视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendDeleteSharedVideoRequest) onTarget:self withObject:nil animated:YES];
    }
}

// overwrite method:(void) doneLoadingTableViewData:
-(void) doneLoadingTableViewData:(ASIHTTPRequest*) pRequest{
    NSLog(@"done loading data, the request url = %@", pRequest.url);
    
    // request succeed, tableView to reload
    if(pRequest.responseStatusCode == 200){
        // tableView reloadData
        [_mTableView reloadData];
    }
    
    // get request userInfo
    // reloading data
    if(pRequest.userInfo != nil){
        NSLog(@"reloading data request %@, its user info = %@", pRequest.url, pRequest.userInfo);
        
        // update reloading flag
        _reloading = NO;
    }
    // first loading data
    else{
        // get sended shared video received
        if(_mIsDeleteShareVideo && _mVideoSharedType == Sended){
            NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
            
            // set fetch sended video receivers url
            NSString *_sendedVideoRecvslUrl = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant sendedShareReceiversUrl]];
            
            // init fetch sended video receivers request param
            NSMutableDictionary *_sendedVideoRecvsParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", _mVideoSharedId, @"shareId", nil];
            NSLog(@"sendedVideoRecvs - url = %@ and param %@", _sendedVideoRecvslUrl, _sendedVideoRecvsParam);
            
            [self sendSigRequestWithUrl:_sendedVideoRecvslUrl andPostBody:_sendedVideoRecvsParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestFetchRecvs:) andFailedRespMeth:@selector(didFailedRequestFetchRecvs:) andRequestType:synchronous];
        }
        else{
            // done load view after delay 500ms
            [self performSelector:@selector(doneLoadView) withObject:nil afterDelay:0.5];
        }
    }
}

// overwrite method:(void) didFinishedRequestTableData:
-(void) didFinishedRequestTableData:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestTableData- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    
    // init table data source
    if(_mTableDataSource == nil){
        _mTableDataSource = [[NSMutableArray alloc] initWithObjects:_jsonData, nil];
    }
    // normally this case
    else if([_mTableDataSource count] == 0 && [pRequest responseStatusCode] == 200){
        [_mTableDataSource addObject:_jsonData];
    }
    //NSLog(@"videoDetailViewController - tableSataSource : %@ and count = %d", _mTableDataSource, [_mTableDataSource count]);
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
}

// video play authenticate request response methods
-(void) didFinishedRequestVideoPlayAuth:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestVideoPlayAuth - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get result
    if(pRequest.responseStatusCode == 200){
        NSString *_status = [_jsonData objectForKey:@"status"];
        feiyingBusinessState _businessState;
        // judge feiying business state
        if ([_status isEqualToString:@"opened"]) {
            _businessState = opened;
            
            // update video url
            _mVideoUrl = [_mVideoUrl getInternalVideoUrl];
        }
        else if ([_status isEqualToString:@"unopened"]) {
            _businessState = unopened;
            
            // update video url
            _mVideoUrl = [_mVideoUrl getExternalVideoUrl];
        }
        
        // update feiying business state
        [[[UserManager shareSingleton] userBean] setBusinessState:_businessState];
        NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
        [_userDefaults setObject:[NSNumber numberWithInt:_businessState] forKey:@"businessState"];
        
        // present to feiying videoPlayerView
        feiyingVideoPlayerViewController *_playerViewController = [[feiyingVideoPlayerViewController alloc] initWithVideoUrl:_mVideoUrl];    
        
        // feiyingVideoPlayer begin to play
        [_playerViewController beginToPlay];
        
        // present feiyingVideoPlayer view
        [self presentModalViewController:_playerViewController animated:YES];
        
        // send add video play count request
        [self sendAddPlayCountRequest];
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法播放此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestVideoPlayAuth:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestVideoPlayAuth - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// video share authenticate request response methods
-(void) didFinishedRequestVideoShareAuth:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestVideoShareAuth - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get result
    if(pRequest.responseStatusCode == 200){
        // create video share viewController and present modalViewController
        videoShareViewController *_shareViewController = [[videoShareViewController alloc] initWithShareVideoTitle:[self getVideoTitleInRow:0] andChannelId:[self getVideoChannelIdInRow:0] andSourceId:[self getVideoSourceIdInRow:0]];
        // set previous video detail view controller
        _shareViewController.previousVDVC = self;
        
        // push video share view controller to navigation controller
        [self.navigationController pushViewController:_shareViewController animated:YES];
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法播放此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestVideoShareAuth:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestVideoShareAuth - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// add fav request response methods
-(void) didFinishedRequestAddFav:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestAddFav - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            // get video category
            NSString *_videoCategory = [self getVideoChannelIdInRow:0].stringValue;
            NSLog(@"fav video category key = %@ and category = %@", _videoCategory, [VIDEOCATEGORYDICTIONARY objectForKey:_videoCategory]);
            
            iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"添加收藏到%@成功,请到收藏页面查看.", [VIDEOCATEGORYDICTIONARY objectForKey:_videoCategory]]];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // notify fav tab view
            [self notifyFavtabViews];
        }
        else if([_result isEqualToString:@"1"]){
            iToast *_toast = [iToast makeText:@"此视频已经被收藏过了."];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
        else{
            iToast *_toast = [iToast makeText:@"操作失败,请联系我们."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法收藏此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestAddFav:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestAddFav - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// delete fav request response methods
-(void) didFinishedRequestDeleteFav:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestDeleteFav - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            iToast *_toast = [iToast makeText:@"取消收藏成功."];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // pop up
            [self.navigationController popViewControllerAnimated:YES];
            
            // delete the row
            if(_mParentTableViewController && _mParentTableViewIndexPath){
                [_mParentTableViewController.tableDataSource removeObjectAtIndex:[_mParentTableViewIndexPath row]];
                [_mParentTableViewController.tableView beginUpdates];
                [_mParentTableViewController.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:_mParentTableViewIndexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
                [_mParentTableViewController.tableView endUpdates];
            }
            else{
                NSLog(@"error, didFinishedRequestDeleteFav - catastrophe.");
                
                iToast *_toast = [iToast makeText:@"请手动刷新界面."];
                [_toast setDuration:iToastDurationNormal];
                [_toast setGravity:iToastGravityBottom];
                [_toast show];
            }
            
            // notify fav tab nav root view
            [self notifyFavTabRootView];
        }
        else{
            iToast *_toast = [iToast makeText:@"操作失败,请联系我们."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法取消收藏此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestDeleteFav:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestDeleteFav - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// send share video request response methods
-(void) didFinishedRequestSendShare:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestSendShare - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            iToast *_toast = [iToast makeText:@"分享成功,请到分享的飞去页面查看."];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // notify share tab feiqu share list view
            [self notifySharetabFeiquShareListView];
        }
        else{
            iToast *_toast = [iToast makeText:@"操作失败,请联系我们."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];

        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法分享此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestSendShare:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestAddShare - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// delete shared video record request response methods
-(void) didFinishedRequestDeleteShared:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestDeleteFav - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get login result
    if(pRequest.responseStatusCode == 200 && _jsonData){
        NSString *_result = [_jsonData objectForKey:@"result"];
        
        // 0 - succeed
        if([_result isEqualToString:@"0"]){
            iToast *_toast = [iToast makeText:@"删除分享成功."];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
            
            // pop up
            [self.navigationController popViewControllerAnimated:YES];
            
            // delete the row
            if(_mParentTableViewController && _mParentTableViewIndexPath){
                [_mParentTableViewController.tableDataSource removeObjectAtIndex:[_mParentTableViewIndexPath row]];
                [_mParentTableViewController.tableView beginUpdates];
                [_mParentTableViewController.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:_mParentTableViewIndexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
                [_mParentTableViewController.tableView endUpdates];
            }
            else{
                NSLog(@"error, didFinishedRequestDeleteShared - catastrophe.");
                
                iToast *_toast = [iToast makeText:@"请手动刷新界面."];
                [_toast setDuration:iToastDurationNormal];
                [_toast setGravity:iToastGravityBottom];
                [_toast show];
            }
        }
        else{
            iToast *_toast = [iToast makeText:@"操作失败,请联系我们."];
            [_toast setDuration:iToastDurationNormal];
            [_toast setGravity:iToastGravityBottom];
            [_toast show];
        }
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
            
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法删除此分享视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestDeleteShared:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestDeleteFav - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

// fetch sended video receivers request response methods
-(void) didFinishedRequestFetchRecvs:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestFetchRecvs - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"response json format data = %@", _jsonData);
    
    // get fetch videoShare Feiqu recvs result
    if(pRequest.responseStatusCode == 200 && _jsonData){        
        // get sended video receivers
        NSMutableString *_recvsString = [[NSMutableString alloc] init];
        for(NSDictionary *_obj in [[NSArray alloc] initWithArray:[_jsonData objectForKey:@"list"]]){
            [_recvsString appendFormat:@"%@ ", ((NSNumber*)[_obj objectForKey:@"receive"]).stringValue];
        }
        _mVideoSharePersons = _recvsString;
    }
    else{
        // set default videoShare Feiqu persons
        _mVideoSharePersons = @"暂时无法获取到飞去者.";
    }
    
    // table view dataSource reloaded
    [_mTableView reloadData];
    // done load view after delay 500ms
    [self performSelector:@selector(doneLoadView) withObject:nil afterDelay:0.5];
}

-(void) didFailedRequestFetchRecvs:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestDeleteFav - request url = %@, error: %@", pRequest.url, _error);
    
    // set default videoShare Feiqu persons
    _mVideoSharePersons = @"暂时无法获取到飞去者.";
    
    // table view dataSource reloaded
    [_mTableView reloadData];
    // done load view after delay 500ms
    [self performSelector:@selector(doneLoadView) withObject:nil afterDelay:0.5];
}

// overwrite method:(void) alertView: clickedButtonAtIndex:
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"alertView - clickedButtonAtIndex - index = %d", buttonIndex);
    
    if(buttonIndex!=0){
        // set user login info
        [self setUserLoginInfo];
    }
}

// MFMessageComposeViewControllerDelegate methods implemetation
-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    UIViewController *_ares= controller.visibleViewController;
    
    NSLog(@"MFMessageComposeViewController = %@, visible viewController = %@ and MessageComposeResult = %d", controller, _ares, result);
    
    // switch result
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"sms send cancel.");
            break;
        case MessageComposeResultFailed:
            {
                NSLog(@"sms send error.");
                iToast *_toast = [iToast makeText:@"短信发送失败,请保持手机未停机,然后重试."];
                [_toast setDuration:iToastDurationNormal];
                [_toast setGravity:iToastGravityBottom];
                [_toast show];
            }
            break;
        case MessageComposeResultSent:
            {
                NSLog(@"sms send succeed.");
                NSString *_phoneStr = [controller.recipients getPhoneStringWithSep:@","];
                NSString *_info = [controller.body getVideoSharedNote];
                NSLog(@"phone string = %@ and info = %@", _phoneStr, _info);
            
                // send video share request
                [self sendShareVideoRequest:_phoneStr andInfo:_info];
            
            }
            break;
            
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    // set global MsgViewController nil and create an new
    gMsgViewController = nil;
    gMsgViewController = [[MFMessageComposeViewController alloc] init];
}

// MBProgressHUDDelegate methods implemetation
- (void)hudWasHidden:(MBProgressHUD *)hud{
    //NSLog(@"MBProgressHUD was hidden.");
    
    // remove MBProgressHUD from super view when hidden and then set it is nil
    [_mHud removeFromSuperview];
    _mHud = nil;
    
    // create and init an new user indicator progress
    _mHud = [[MBProgressHUD alloc] initWithView:self.view];
    //_mHud.mode = MBProgressHUDModeDeterminate;
    // set label text
    _mHud.labelText = @"处理中...";
    // set delegate
    _mHud.delegate = self;
    // add subViews to self view
    [self.view addSubview:_mHud];
}

// methods implematation
// add fav video
-(void) videoAddFav{
    if(![[[UserManager shareSingleton] userBean] name]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法收藏此视频" andMsg:@"您还没有设置账户信息"];
    }
    else if(![[[UserManager shareSingleton] userBean] userKey]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法收藏此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendVideoAddFavRequest) onTarget:self withObject:nil animated:YES];
    }
}

// delete fav video
-(void) videoDeleteFav{
    if(![[[UserManager shareSingleton] userBean] userKey]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法取消收藏此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendVideoDeleteFavRequest) onTarget:self withObject:nil animated:YES];
    }
}

// share the video to persons
-(void) videoShare{
    if(![[[UserManager shareSingleton] userBean] name]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法分享此视频" andMsg:@"您还没有设置账户信息"];
    }
    else if(![[[UserManager shareSingleton] userBean] userKey]){
        // show user info setting alertView
        [self showUserInfoSettingAlertViewWithTitle:@"暂时无法分享此视频" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
    }
    else{
        // show progressHud
        [_mHud showWhileExecuting:@selector(sendVideoShareAuthenticateRequest) onTarget:self withObject:nil animated:YES];
    }
}

// get video shared info
-(NSDictionary*) getVideoSharedInfo{
    NSMutableDictionary *_shareInfo = nil;
    if(_mIsDeleteShareVideo){
        // shareType, shareId, sharePersons and shareTime
        _shareInfo = [[NSMutableDictionary alloc] init];
        [_shareInfo setObject:[NSNumber numberWithInt:_mVideoSharedType] forKey:@"shareType"];
        [_shareInfo setObject:_mVideoShareTime forKey:@"shareTime"];
        if(_mVideoSharePersons){
            [_shareInfo setObject:_mVideoSharePersons forKey:@"sharePersons"];
        }
        //NSLog(@"getVideoSharedInfo - share info = %@", _shareInfo);
    }
    
    return _shareInfo;
}

@end
