//
//  baseTabViewController.m
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "baseTabViewController.h"

#import "videoSearchViewController.h"
#import "videoDetailViewController.h"
#import "userLoginViewController.h"
#import "userAccountSettingViewController.h"
#import "shareTabViewController.h"
#import "favTabViewController.h"

#import "../customComponents/videoTableViewCell.h"
#import "../customComponents/tableFooterView.h"
#import "../customComponents/tabViewNavigationController.h"
#import "../customComponents/searchShareImgView.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"
#import "../util/NSString+util.h"
#import "../common/UserManager.h"

#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/Toast/iToast.h"
#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"

#import "AppDelegate.h"

@implementation baseTabViewController

@synthesize rootUrl = _mRootUrl;
@synthesize isTableViewReload = _mTableViewReload;

@synthesize tableDataSource = _mTableDataSource;
@synthesize tableView = _mTableView;

// @private methods
// get object for key at the row
-(/*NSString**/id) getObject:(NSString*) pKey andRow:(NSInteger) pRow{
    NSString *ret = nil;
    
    
    // get tableCell data of the row
    NSDictionary *_tableCellData = [_mTableDataSource objectAtIndex:pRow];
    ret = [_tableCellData objectForKey:pKey];
    //NSLog(@"getMoviePropertyInRow - row: %d and property-%@: %@", pRow, pKey, ret);
    
    return ret;
}

// cache image for url at prescript row
-(UIImage*) cacheImageForUrl:(NSURL *)pUrl andRow:(NSInteger) pRow{    
    // get cached image
    id _cachedImage = [gImageCacheDic objectForKey:pUrl];
    //NSLog(@"image cache dictionary = %@, key = %@ and cached image = %@", gImageCacheDic, pUrl, _cachedImage);
    
    if(_cachedImage == nil){
        // prevent catch image request repeat
        [gImageCacheDic setObject:@"feiying image loading..." forKey:pUrl];
        
        // async download the image with its url
        ASIHTTPRequest *_fetchImageRequest = [ASIHTTPRequest requestWithURL:pUrl];
        // set userInfo/tag
        _fetchImageRequest.tag = pRow;
        // set timeout seconds
        [_fetchImageRequest setTimeOutSeconds:5.0];
        // set delegate
        _fetchImageRequest.delegate = self;
        // set response methods
        _fetchImageRequest.didFinishSelector = @selector(didFinishedRequestImage:);
        _fetchImageRequest.didFailSelector = @selector(didFailedRequestImage:);
        
        // start send request
        [_fetchImageRequest startAsynchronous];
    }
    else if([_cachedImage isKindOfClass:[UIImage class]]){
        videoTableViewCell *_tableViewCell = (videoTableViewCell*)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pRow inSection:0]];
        
        // get image view
        UIImageView *_imgView = ((UIImageView*)[_tableViewCell.contentView viewWithTag:1314]);
        if([_imgView isMemberOfClass:[searchShareImgView class]]){
            // search or share Image view
            [(searchShareImgView*)_imgView setSuitableImage:_cachedImage];
        }
        else{
            // normal image view
            _imgView.image = _cachedImage;
        }
        
        //((UIImageView*)[_tableViewCell.contentView viewWithTag:1314]).image = _cachedImage;
    }
    else if(![_cachedImage isKindOfClass:[UIImage class]]){
        _cachedImage = nil;
    }
    
    return _cachedImage;
}

// view loading done
-(void) doneLoadView{
    // remove viewLoadingIndicator view
    [_mViewLoadingIndicatorView stopAnimating];
    
    // show self tableView
    _mTableView.hidden = NO;
}

// done loading tableView dataSource
-(void) doneLoadingTableViewData:(ASIHTTPRequest*) pRequest{
    NSLog(@"done loading data, the request url = %@", pRequest.url);
    
    // process response status code
    switch (pRequest.responseStatusCode) {
        // request succeed, loading table dataSource
        case 200:
            {
                // tableView reloadData
                [_mTableView reloadData];
                
                // get visible rows indexPaths
                [_mTableView visibleCells];
                NSArray *_indexPathsArray = [NSArray arrayWithArray:_mTableView.indexPathsForVisibleRows];
                // update video image
                for(int index = 0; index < [_indexPathsArray count]; index++){
                    [self getVideoImageInRow:((NSIndexPath*)[_indexPathsArray objectAtIndex:index]).row];
                }
                
                // init and add table footerView
                CGFloat _cellHeight = [videoTableViewCell getCellHeightWithContents:nil];
                if([_mTableDataSource count]*_cellHeight < _mTableView.frame.size.height){
                    //NSLog(@"**************** base content height = %f and table frame size height = %f", [_mTableDataSource count]*_cellHeight, _mTableView.frame.size.height);
                    
                    _mTableView.tableFooterView = [[tableFootNoMoreDataView alloc] initWithFrame:CGRectMake(0.0 , _mTableView.frame.size.height, _mTableView.frame.size.width, 45.0)];
                }
            }
            break;
           
            /*
        case 400:
            {
                // show user info setting alertView
                UIAlertView *_alertView = [self showUserInfoSettingAlertViewWithTitle:@"加载失败" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
                // set tag -1, flag
                _alertView.tag = -1;
            }
            break;
             */
    }
    
    // get request userInfo
    // reloading data
    if(pRequest.userInfo != nil){
        NSLog(@"reloading data request %@, its user info = %@", pRequest.url, pRequest.userInfo);
        
        // update reloading flag
        _reloading = NO;
        
        [_mRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_mTableView];
    }
    // first loading data
    else{
        // done load view after delay 500ms
        [self performSelector:@selector(doneLoadView) withObject:nil afterDelay:0.5];
    }
}

// done appending more tableView dataSource
-(void) doneAppendingTableViewData:(ASIHTTPRequest*) pRequest{
    NSLog(@"done appending more data, the request url = %@", pRequest.url);
    
    // process response status code
    switch (pRequest.responseStatusCode) {
        // request succeed, append more data to dataSource
        case 200:
            {
                // tableView reloadData
                [_mTableView reloadData];
            
                // get new added visible row
                NSInteger _row = 0;
                if([_mTableDataSource count]%20){
                    _row = 20*([_mTableDataSource count]/20);
                }
                else{
                    _row = [_mTableDataSource count] - 20;
                }
                [self getVideoImageInRow:/*[_mTableDataSource count]-20*/_row];
            }
            break;
            
            /*
        case 400:
            // show user info setting alertView
            [self showUserInfoSettingAlertViewWithTitle:@"加载失败" andMsg:@"您的账户在其他手机上登录过,请您重新设置账户信息"];
            break;
             */
    }
    
    // update append data flag
    _appending = NO;

    // hide table footerView
    _mTableView.tableFooterView = nil;
}

// init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // base setting
        // set background color
        self.view.backgroundColor = [UIColor whiteColor];
        
        // update view frame
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height-/*navigationBar height*/44.0-/*tabBar height*/50.0+1.0);
        
        // set baseView default title
        self.title = @"baseTab";
        
        // navigationBar setting
        // create logo image
        UIImageView *_logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        // set frame
        _logoImage.frame = CGRectMake(0.0, 0.0, /*width*/37.5, /*height*/30.0);
        // set as left navigationBar barButtonItem
        UIBarButtonItem *logoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_logoImage];
        // set leftBarButtonItem
        self.navigationItem.leftBarButtonItem = logoBarButtonItem;
        
        // create search barButtonItem as right navigationBar barButtonItem
        // create video search button
        UIButton *_videoSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set frame
        _videoSearchButton.frame = CGRectMake(0.0, 0.0, /*width*/50.0, /*height*/30.0);
        [_videoSearchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        // add target
        [_videoSearchButton addTarget:self action:@selector(videoSearchNavigation) forControlEvents:UIControlEventTouchUpInside];
        //UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_videoSearchButton];
        UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(videoSearchNavigation)];
        // set rightBarButtonItem
        self.navigationItem.rightBarButtonItem = searchBarButtonItem;
        
        // create, init and add loading tip
        UILabel *_viewLoadingIndicatorTip = [[UILabel alloc] initWithFrame:CGRectMake(_mViewLoadingIndicatorView.frame.size.width/2-40.0+10.0, 30.0, 80.0, 20.0)];
        // set text
        _viewLoadingIndicatorTip.text = @"加载中...";
        _viewLoadingIndicatorTip.textColor = [UIColor grayColor];
        _viewLoadingIndicatorTip.textAlignment = UITextAlignmentCenter;
        _viewLoadingIndicatorTip.font = [UIFont systemFontOfSize:14.0];
        _viewLoadingIndicatorTip.tag = -1314;
        
        // create view loading activityIndicator
        _mViewLoadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        // set frame center
        _mViewLoadingIndicatorView.center = CGPointMake(self.view.center.x, self.view.center.y-30.0);
        // add viewLoadingIndicatorTip to viewLoading indicatorView
        [_mViewLoadingIndicatorView addSubview:_viewLoadingIndicatorTip];
        // add viewLoading indicatorView to the view
        [self.view addSubview:_mViewLoadingIndicatorView];
        // start animating
        [_mViewLoadingIndicatorView startAnimating];
        
        // create user login indicator view
        _mUserLoginIndicatorView = [[userLoginIndicatorView alloc] initWithFrame:self.view.frame];
        // set user login info delegate
        _mUserLoginIndicatorView.setUserLoginInfoDelegate = self;
        
        // tab tableview setting
        _mTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        // set separatorStyle none
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // set tableView delegate and dataSource
        [_mTableView setDelegate:self];
        [_mTableView setDataSource:self];
        // add tableView to the view
        [self.view addSubview:_mTableView];
        // hide tableView first
        _mTableView.hidden = YES;
        
        // create and init EGO refreshTableHeaderView
        _mRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.5-_mTableView.frame.size.height, _mTableView.frame.size.width, _mTableView.frame.size.height)];
        // set EGORefreshTableHeader delegate
        _mRefreshHeaderView.delegate = self;
        // add table data EGO refreshTableHeaderView to view
        [_mTableView addSubview:_mRefreshHeaderView];
        // update the last update date
        [_mRefreshHeaderView refreshLastUpdatedDate];
        
        // tabBar item setting
        _mTabBarItem = [[UITabBarItem alloc] initWithTitle:@"baseTab" image:[UIImage imageNamed:@"first.png.png"] tag:0];
        // set tabBar item
        self.tabBarItem = _mTabBarItem;
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

-(void) viewWillAppear:(BOOL)animated{
    // view will first appear, refresh
    if(!_mTableViewReload){
        _mTableViewReload = YES;
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

// UIScrollViewDelegate methods implemetation
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"tableView did end decelerating.");
    
    // get visible rows indexPaths
    NSArray *_indexPathsArray = [NSArray arrayWithArray:_mTableView.indexPathsForVisibleRows];
    //NSLog(@"visible rows indexPaths array: %@", _indexPathsArray);
    
    // update video image
    for(int index = 0; index < [_indexPathsArray count]; index++){
        [self getVideoImageInRow:((NSIndexPath*)[_indexPathsArray objectAtIndex:index]).row];
    }
    
    // when scroll end decelerating, send get more data request if needed
    if(_appending){
        NSLog(@"begin to append more data.");
        
        // get data and init more data request url
        NSString *_moreDataUrlStr = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [_mPagerInfo objectForKey:@"nextPage"]];
        NSLog(@"next page url = %@", _moreDataUrlStr);
        
        // async fetch more data
        [self sendNormalRequestWithUrl:_moreDataUrlStr andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestMoreData:) andFailedRespMeth:@selector(didFailedRequestMoreData:) andRequestType:asynchronous];
        /*
        if([[[UserManager shareSingleton] userBean] name]){
            // init get more table dataSource request param
            NSMutableDictionary *_moreTableDataSourceParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", [NSString stringWithFormat:@"%d", ((NSNumber*)[_mPagerInfo objectForKey:@"offset"]).intValue+1], @"offset", nil];
            
            [self sendSigRequestWithUrl:_moreDataUrlStr andPostBody:_moreTableDataSourceParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestMoreData:) andFailedRespMeth:@selector(didFailedRequestMoreData:) andRequestType:asynchronous];
        }
        else{
            [self sendNormalRequestWithUrl:_moreDataUrlStr andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestMoreData:) andFailedRespMeth:@selector(didFailedRequestMoreData:) andRequestType:asynchronous];
        }
         */
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    // scroll to bottom of self tableView, judge if or not have more data
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height && !_appending && _mTableDataSource && [_mTableDataSource count]>0){
        // judge if or not have more data
        if([_mPagerInfo objectForKey:@"hasNext"] && [(NSNumber*)[_mPagerInfo objectForKey:@"hasNext"] boolValue]){
            // need to append more data, update append data flag
            _appending = YES;
            
            // init and add table footerView
            _mTableView.tableFooterView = [[tableFootSpinnerView alloc] initWithFrame:CGRectMake(0.0 , _mTableView.frame.size.height, _mTableView.frame.size.width, 45.0)];
        }
        else{
            NSLog(@"no more data.");
            
            // init and add table footerView
            if(!_mTableView.tableFooterView){
                _mTableView.tableFooterView = [[tableFootNoMoreDataView alloc] initWithFrame:CGRectMake(0.0 , _mTableView.frame.size.height, _mTableView.frame.size.width, 45.0)];
            }
            
            return;
        }
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_mRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // if decelerate is no(ios4)
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

// UITableViewDataSource methods implemetation
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // set default row of each section
    NSInteger _ret = 15;
    
    if(section == 0){
        _ret = [_mTableDataSource count];
    }
    
    return _ret;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    // table cell
    videoTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"baseTabViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellVideoImage = [self setVideoInitImageInRow:[indexPath row] andImageType:videoImage];
        NSString *_cellVideoTitle = [self getVideoTitleInRow:[indexPath row]];
        NSString *_cellVideoTotalTime = [self getVideoTotalTimeInRow:[indexPath row]];
        NSString *_cellVideoSize = [self getVideoSizeInRow:[indexPath row]];
        //NSLog(@"cell %d - video title: %@, total time: %@ and size: %@", [indexPath row],  _cellVideoTitle, _cellVideoTotalTime, _cellVideoSize);
        
        _cell = [[videoTableViewCell alloc] initWithTitle:_cellVideoTitle andImage:_cellVideoImage andTotalTime:_cellVideoTotalTime andSize:_cellVideoSize];
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // set after selected reverse background bolor will dismiss
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"row: %d selected. content: %@", [indexPath row], [_mTableDataSource objectAtIndex:[indexPath row]]);
    
    // video detail viewController
    videoDetailViewController *vdViewController = [[videoDetailViewController alloc] initWithDetailInfo:[_mTableDataSource objectAtIndex:[indexPath row]]];
    
    // add navigation in view
    [self.navigationController pushViewController:vdViewController animated:YES];
    
    return indexPath;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    tableView.delegate = nil;
    CGFloat _ret = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    tableView.delegate = self;
    
    return _ret;
     */
    return [videoTableViewCell getCellHeightWithContents:nil];
}

// EGORefreshTableHeaderDelegate methods implemetation
-(void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    // egoRefreshTableHeader did trigger refresh
    NSLog(@"begin to reload data.");
    
    // update reloading flag
    _reloading = YES;
    
    // init table dataSource
    [self initTableDataSource:_mRootUrl];
}

-(BOOL) egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return  _reloading;
}

-(NSDate*) egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

// methods implemetation
// send normal http request
-(void) sendNormalRequestWithUrl:(NSString*) pUrl andUserInfo:(NSDictionary *)pUserInfo andFinishedRespMeth:(SEL)pFinRespMeth andFailedRespMeth:(SEL)pFailRespMeth andRequestType:(asiHTTPRequestType)pRequestType{
    // judge request param
    if(pUrl == nil){
        NSLog(@"sendNormalRequestWithUrl - request url is nil.");
        
        return;
    }
    
    // create ASIHTTPRequest
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:pUrl]];
    
    // set timeout seconds
    [_request setTimeOutSeconds:5.0];
    
    // set user infomation
    _request.userInfo = pUserInfo;
    
    // set delegate
    [_request setDelegate:self];
    
    // set response methods
    if(pFinRespMeth && [self respondsToSelector:pFinRespMeth]){
        _request.didFinishSelector = pFinRespMeth;
    }
    if(pFailRespMeth && [self respondsToSelector:pFailRespMeth]){
        _request.didFailSelector = pFailRespMeth;
    }
    
    // start send request
    switch (pRequestType) {
        case asynchronous:
            [_request startAsynchronous];
            break;
            
        case synchronous:
            [_request startSynchronous];
            break;
    }
}

// send request with url
-(void) sendRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType{
    // judge request param
    if(pUrl == nil){
        NSLog(@"sendRequestWithUrl - request url is nil.");
        
        return;
    }
    
    // synchronous request
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pUrl]];
    
    // set timeout seconds
    [_request setTimeOutSeconds:5.0];
    
    //  set post value
    [pPostBodyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        // set request post value
        [_request addPostValue:obj forKey:key];
    }];
    
    // set user infomation
    _request.userInfo = pUserInfo;
    
    // set delegate
    _request.delegate = self;
    
    // set response methods
    if(pFinRespMeth && [self respondsToSelector:pFinRespMeth]){
        _request.didFinishSelector = pFinRespMeth;
    }
    if(pFailRespMeth && [self respondsToSelector:pFailRespMeth]){
        _request.didFailSelector = pFailRespMeth;
    }
    
    // start send request
    switch (pRequestType) {
        case asynchronous:
            [_request startAsynchronous];
            break;
            
        case synchronous:
            [_request startSynchronous];
            break;
    }
}

// send sig request with url
-(void) sendSigRequestWithUrl:(NSString*) pUrl andPostBody:(NSMutableDictionary*) pPostBodyDic andUserInfo:(NSDictionary*) pUserInfo andFinishedRespMeth:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType{
    // judge request param
    if(pUrl == nil){
        NSLog(@"sendSigRequestWithUrl - request url is nil.");
        
        return;
    }
    
    // synchronous request
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pUrl]];
    
    // set timeout seconds
    [_request setTimeOutSeconds:5.0];
    
    //  set post value
    NSMutableArray *_postBodyDataArray = [[NSMutableArray alloc] init];
    [pPostBodyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        // set request post value
        [_request addPostValue:obj forKey:key];
        
        // init post body data array
        [_postBodyDataArray addObject:[[NSString alloc] initWithFormat:@"%@=%@", key, obj]];
    }];
    
    // post request signature
    //NSLog(@"post body data array = %@", _postBodyDataArray);
    // postBody data array sort
    NSMutableArray *_sortedArray = [[NSMutableArray alloc] initWithArray:[_postBodyDataArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    //NSLog(@"sorted post body data array = %@", _sortedArray);
    
    // append userKey
    if([[[UserManager shareSingleton] userBean] userKey]){
        [_sortedArray addObject:[[[UserManager shareSingleton] userBean] userKey]];
    }
    //NSLog(@"after append user key sorted post body data array = %@", _sortedArray);
    
    // generate signature
    NSMutableString *_sortedArrayString = [[NSMutableString alloc] init];
    for(NSString *_str in _sortedArray){
        [_sortedArrayString appendString:_str];
    }
    NSString *_signature = [_sortedArrayString md5];
    //NSLog(@"the signature is %@", _signature);
    
    // add signature to postBody data
    [_request addPostValue:_signature forKey:@"sig"];
    
    // set user infomation
    _request.userInfo = pUserInfo;
    
    // set delegate
    _request.delegate = self;
    
    // set response methods
    if(pFinRespMeth && [self respondsToSelector:pFinRespMeth]){
        _request.didFinishSelector = pFinRespMeth;
    }
    if(pFailRespMeth && [self respondsToSelector:pFailRespMeth]){
        _request.didFailSelector = pFailRespMeth;
    }
    
    // start send request
    switch (pRequestType) {
        case asynchronous:
            [_request startAsynchronous];
            break;
            
        case synchronous:
            [_request startSynchronous];
            break;
    }
}

// send authenticate request with finished and failed response method
-(void) sendAuthenticateRequest:(SEL) pFinRespMeth andFailedRespMeth:(SEL) pFailRespMeth andRequestType:(asiHTTPRequestType) pRequestType{
    // get user login name
    NSString *_loginName = [[[UserManager shareSingleton] userBean] name];
    //NSLog(@"sendAuthenticateRequest - request param - user login name = %@", _loginName);
    
    // init authenticate request param
    NSMutableDictionary *_authenticateParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_loginName, @"username", nil];
    
    [self sendSigRequestWithUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant authenticateUrl]] andPostBody:_authenticateParam andUserInfo:nil andFinishedRespMeth:pFinRespMeth andFailedRespMeth:pFailRespMeth andRequestType:pRequestType];
}

// popup fav and share tab navigation viewController and update rootViewController
-(void) popupFavShareTabNavAndUpdateRoot{
    // get fav tab navigation view controller
    UINavigationController *_favTabNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:1];
    UINavigationController *_shareTabNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:0];
    
    // popup to root view controller
    [_favTabNav popToRootViewControllerAnimated:YES];
    [_shareTabNav popToRootViewControllerAnimated:YES];
    
    // update fav tab root view controller
    ((baseTabViewController *)[_favTabNav.viewControllers objectAtIndex:0]).isTableViewReload = NO;
    // update feiqu share list
    ((shareTabViewController*)[_shareTabNav.viewControllers objectAtIndex:0]).feiquShareList.isTableDSRefresh = YES;
}

// show alertView with title and message
-(UIAlertView*) showUserInfoSettingAlertViewWithTitle:(NSString*) pTitle andMsg:(NSString*) pMsg{
    UIAlertView *_userLoginIndicatorAlertDialog = [[UIAlertView alloc] initWithTitle:pTitle message:pMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置账户", nil];
    
    // show alertView
    [_userLoginIndicatorAlertDialog show];
    
    return _userLoginIndicatorAlertDialog;
}

// init table dataSource
-(void) initTableDataSource:(NSString *)pRequestUrl{
    // init reloading tag
    NSDictionary *_userInfo = nil;
    
    // set root url
    if(_mRootUrl == nil || ![_mRootUrl isEqualToString:pRequestUrl]){
        _mRootUrl = pRequestUrl;
    }
    //NSLog(@"root url = %@", _mRootUrl);
    
    // set reloading table sourceData request userInfo
    if(/*_mTableDataSource != nil*/_reloading){
        //NSLog(@"table dataSource size = %d and object = %@", [_mTableDataSource count], _mTableDataSource);
        // set userInfo
        _userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"table dataSource reloading...", @"reqUserInfo", nil];
    }
    
    // get table dataSource
    [self sendNormalRequestWithUrl:pRequestUrl andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
    /*
    if([[[UserManager shareSingleton] userBean] name]){
        // init get table dataSource request param
        NSMutableDictionary *_tableDataSourceParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", nil];
        
        [self sendSigRequestWithUrl:pRequestUrl andPostBody:_tableDataSourceParam andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
    }
    else{
        [self sendNormalRequestWithUrl:pRequestUrl andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
    }
     */
}

// movie search navigation button response method
-(void) videoSearchNavigation{
    // video search viewController
    videoSearchViewController *vsViewController = [[videoSearchViewController alloc] init];
    
    // set frame
    //msrViewController.view.frame = CGRectMake(0.0, 0.0, 320.0, 400.0);
    
    // add navigation in view
    [self.navigationController pushViewController:vsViewController animated:YES];
}

// set video init image and type
-(UIImage*) setVideoInitImageInRow:(NSInteger) pRow andImageType:(videoImageType)pImageType{
    UIImage *_ret = nil;
    
    // get image from imageCacheDic
    if(gImageCacheDic != nil){
        // set default video image url string
        NSString *urlString = [NSString stringWithFormat:@"%@/%@.jpg", [urlConstant videoImgUrl], [self getVideoSourceIdInRow:pRow]];
        /*
        if([[[UserManager shareSingleton] userBean] businessState] == unopened){
            urlString = [self getObject:@"image_url" andRow:pRow];
        }
         */
        // generate gImageCacheDic key
        NSURL *urlKey = [NSURL URLWithString:urlString];
        // if object is imageFetchRequest prevent repeat flag, ignore it 
        _ret = [[gImageCacheDic objectForKey:urlKey] isKindOfClass:[NSString class]] ? _ret : [gImageCacheDic objectForKey:urlKey];
        //NSLog(@"setVideoInitImageInRow - image cache dic = %@, cached image = %@, key = %@ and row = %d", gImageCacheDic, _ret, urlKey, pRow);
        
        if(_ret == nil){
            switch (pImageType) {
                case videoImage:
                    _ret = [UIImage imageNamed:@"videoDefImg.png"];
                    break;
                    
                case mtvImage:
                    _ret = [UIImage imageNamed:@"mtvDefImg.png"];
                    break;
                    
                case ssImage:
                    _ret = [UIImage imageNamed:@"searchShareDefImg.png"];
                    break;
                    
                default:
                    _ret = [UIImage imageNamed:@"first.png"];
                    break;
            }
        }
    }
    
    return _ret;
}

// get video information
// video image
-(UIImage*) getVideoImageInRow:(NSInteger)pRow{
    // get image url
    NSString *_imageUrl = [NSString stringWithFormat:@"%@/%@.jpg", [urlConstant videoImgUrl], [self getVideoSourceIdInRow:pRow]];
    /*
    if([[[UserManager shareSingleton] userBean] businessState] == unopened){
        _imageUrl = [self getObject:@"image_url" andRow:pRow];
    }
    */
    //NSLog(@"video image url: %@ and row = %d", _imageUrl, pRow);
    
    // set default return image data
    UIImage *_retImage = nil;
    if(_imageUrl != nil){
        // get image from application cache(NSDictionary) and key is image url
        _retImage = [self cacheImageForUrl:[NSURL URLWithString:_imageUrl] andRow:pRow];
        //NSLog(@"getVideoImageInRow - image: %@", _retImage);
    }
    
    return _retImage;
}

// video title
-(NSString*) getVideoTitleInRow:(NSInteger)pRow{
    return [self getObject:@"title" andRow:pRow];
}

// video total time
-(NSString*) getVideoTotalTimeInRow:(NSInteger)pRow{
    return [self getObject:@"time" andRow:pRow];
}

// video episode count
-(NSString*) getVideoEpisodeCountInRow:(NSInteger) pRow{
    return [self getObject:@"episode_count" andRow:pRow];
}

// video episode state
-(NSString*) getVideoEpisodeStateInRow:(NSInteger) pRow{
    // get result
    int _result = ((NSNumber*)[self getObject:@"episode_all" andRow:pRow]).intValue;
    // define ret string
    NSString *_ret = nil;
    
    if(_result == 0){
        _ret = @"热播";
    }
    else if(_result == 1){
        _ret = @"全";
    }
    
    return _ret;
}

// video size
-(NSString*) getVideoSizeInRow:(NSInteger)pRow{
    return [self getObject:@"size" andRow:pRow];
}

// video play count
-(NSString*) getVideoPlaycountInRow:(NSInteger)pRow{
    return [self getObject:@"play_count" andRow:pRow];
}

// video share count
-(NSString*) getVideoSharecountInRow:(NSInteger)pRow{
    return [self getObject:@"share_count" andRow:pRow];
}

// video fav count
-(NSString*) getVideoFavcountInRow:(NSInteger)pRow{
    return [self getObject:@"fav_count" andRow:pRow];
}

// video actors
-(NSString*) getVideoActorsInRow:(NSInteger)pRow{
    return [self getObject:@"actor" andRow:pRow];
}

// video release date
-(NSString*) getVideoReleaseDateInRow:(NSInteger)pRow{
    return [self getObject:@"release_date" andRow:pRow];
}

// video origin locate
-(NSString*) getVideoOriginLocateInRow:(NSInteger)pRow{
    return [self getObject:@"origin" andRow:pRow];
}

// video director
-(NSString*) getVideoDirectorInRow:(NSInteger)pRow{
    return [self getObject:@"director" andRow:pRow];
}

// video description
-(NSString*) getVideoDescriptionInRow:(NSInteger)pRow{
    return [self getObject:@"description" andRow:pRow];
}

// video episode list
-(NSArray*) getVideoEpisodeListInRow:(NSInteger)pRow{
    return [self getObject:@"list" andRow:pRow];
}

// video channel id
-(NSNumber*) getVideoChannelIdInRow:(NSInteger)pRow{
    return [[NSNumber alloc] initWithInteger:[[self getObject:@"channel" andRow:pRow] integerValue]];
}

// video source id
-(NSString*) getVideoSourceIdInRow:(NSInteger)pRow{
    return [self getObject:@"source_id" andRow:pRow];
}

// video url
-(NSString*) getVideoUrlInRow:(NSInteger)pRow{
    return [self getObject:@"video_url" andRow:pRow];
}

// video share time
-(NSString*) getVideoShareTimeInRow:(NSInteger) pRow{
    return [self getObject:@"share_time" andRow:pRow];
}

// video share id
-(NSString*) getVideoShareIdInRow:(NSInteger) pRow{
    return [self getObject:@"share_id" andRow:pRow];
}

// share video sent to
-(NSString*) getShareVideoSendToInRow:(NSInteger) pRow{
    return [self getObject:@"receive" andRow:pRow];
}

// share video receive from
-(NSString*) getShareVideoReceiveFromInRow:(NSInteger) pRow{
    return [self getObject:@"send" andRow:pRow];
}

// get channel information
// channel image
-(UIImage*) getChannelImageInRow:(NSInteger)pRow{
    // definde return image
    UIImage *_ret;
    
    // get image name
    NSString *_imageName = [self getObject:@"image" andRow:pRow];
    //NSLog(@"channel image name: %@", _imageName);
    
    if(_imageName == nil){
        _ret = [UIImage imageNamed:@"first.png"];
    }
    else{
        _ret = [UIImage imageNamed:_imageName];
    }
    
    return _ret;
}

// channel title
-(NSString*) getChannelTitleInRow:(NSInteger)pRow{
    return [self getObject:@"title" andRow:pRow];
}

// channel id
-(NSNumber*) getChannelIdInRow:(NSInteger) pRow{
    return [[NSNumber alloc] initWithInteger:[[self getObject:@"id" andRow:pRow] integerValue]];
}

// channel fav video count
-(NSString*) getChannelFavVideoCountInRow:(NSInteger)pRow{
    NSString *_ret = [self getObject:@"favcount" andRow:pRow];
    if (_ret == nil) {
        _ret = @"0";
    }
    return _ret;
}

// ASIHTTPRequestDelegate methods implemetation
// tableView dataSource fetch request response methods
-(void) didFinishedRequestTableData:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestTableData- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    
    // update page info
    _mPagerInfo = [_jsonData objectForKey:@"pager"];
    //NSLog(@"pager object: %@", _mPagerInfo);
    
    // init table data source
    if(_mTableDataSource == nil){
        _mTableDataSource = [[NSMutableArray alloc] initWithArray:[_jsonData objectForKey:@"list"]];
    }
    else{
        [_mTableDataSource setArray:[_jsonData objectForKey:@"list"]];
    }
    //NSLog(@"list object: %@", _mTableDataSource);
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
}

-(void) didFailedRequestTableData:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestTableData url = %@, error: %@", pRequest.url, _error);
    
    //NSLog(@"baseTableViewController - didFailedRequestTableData - self = %@", self);
    if ([self isKindOfClass:[videoDetailViewController class]]) {
        iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"获取视频详细信息失败,%@,请返回重新加载", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
        
        // hide video detail view controller's view bottom toolBar
        for (UIView *_subview in self.view.subviews) {
            if ([_subview isKindOfClass:[UIToolbar class]]) {
                _subview.hidden = YES;
            }
        }
        
        NSLog(@"get video info rootUrl = %@", pRequest.url);
    }
    else if([self isMemberOfClass:[searchResultViewController class]]){
        iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"搜索失败,%@,请重试", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
        [_toast setDuration:iToastDurationNormal];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
    else{
        iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"%@,请下拉刷新", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
        
        NSLog(@"get video list rootUrl = %@", _mRootUrl);
    }
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
}

// video image fetch request response methods
-(void) didFinishedRequestImage:(ASIHTTPRequest*) pRequest{
    //NSLog(@"didFinishedRequestImage- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get image data
    UIImage *_image = [UIImage imageWithData:[pRequest responseData]];
    // judge image is or not nil
    if(_image != nil){
        // update image dictionary record(key = pRequest.url)
        [gImageCacheDic setObject:_image forKey:pRequest.url];
        
        // update tableView data
        //NSLog(@"request tag = %d", pRequest.tag);
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:pRequest.tag inSection:0];
        videoTableViewCell *_tableViewCell = (videoTableViewCell*)[_mTableView cellForRowAtIndexPath:_indexPath];
        
        // get image view
        UIImageView *_imgView = ((UIImageView*)[_tableViewCell.contentView viewWithTag:1314]);
        if([_imgView isMemberOfClass:[searchShareImgView class]]){
            // search or share Image view
            [(searchShareImgView*)_imgView setSuitableImage:_image];
        }
        else{
            // normal image view
            _imgView.image = _image;
        }
        
        //((UIImageView*)[_tableViewCell.contentView viewWithTag:1314]).image = _image;
    }
    else{
        // update image dictionary record(key = pRequest.url) and object is nil to replace the string "feiying image loading..."
        //[gImageCacheDic setObject:nil forKey:pRequest.url];
        [gImageCacheDic removeObjectForKey:pRequest.url];
    }
}

-(void) didFailedRequestImage:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestImage url = %@, error: %@", pRequest.url, _error);
    
    // update image dictionary record(key = pRequest.url) and object is nil to replace the string "feiying image loading..."
    //[gImageCacheDic setObject:nil forKey:pRequest.url];
    [gImageCacheDic removeObjectForKey:pRequest.url];
}

// more data fetch request response methods
-(void) didFinishedRequestMoreData:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestMoreData- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    
    // update page info
    if([pRequest responseStatusCode] == 200){
        _mPagerInfo = [_jsonData objectForKey:@"pager"];
    }
    //NSLog(@"pager object: %@", _mPagerInfo);
    
    // update table data source
    NSArray *_moreData = [_jsonData objectForKey:@"list"];
    //NSLog(@"more data list object: %@", _moreData);
    [_mTableDataSource addObjectsFromArray:_moreData];
    
    // done appending more data
    [self doneAppendingTableViewData:pRequest];
}

-(void) didFailedRequestMoreData:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestMoreData url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"%@,请向下滑动重新加载更多数据", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
    
    // done appending more data
    [self doneAppendingTableViewData:pRequest];
}

/*
// UIAlertViewDelegate methods implemetation
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{  
    NSLog(@"baseTabViewController - alertView: clickedButtonAtIndex: - alertView tag = %d and buttonIndex = %d", alertView.tag, buttonIndex);
    
    // button command
    switch (buttonIndex) {
        // cancel
        case 0:
            if(alertView.tag == -1){
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        
        // set user account info
        case 1:
            [self setUserLoginInfo];
            // show fav channel list
            if(alertView.tag == -1){
                NSLog(@"show fav channel list");
                
                //
            }
            break;
    }
}
 */

// userLoginDelegate methods implemetation
// user login succeed
-(void) userLoginSucceed{
    NSLog(@"baseTabViewController - userLoginSucceed - self = %@", self);
    
    // get the current tab navigation view controller
    UINavigationController *_tabNav = (UINavigationController*)(self.tabBarController.selectedViewController);
    if(![[_tabNav.viewControllers objectAtIndex:0] isMemberOfClass:[shareTabViewController class]] && ![[_tabNav.viewControllers objectAtIndex:0] isMemberOfClass:[favTabViewController class]]){
        // update fav and share tab root view controller
        [self popupFavShareTabNavAndUpdateRoot];
    }
    else{
        self.isTableViewReload = NO;
    }
    
    [self viewWillAppear:YES];
    
    // dismiss login viewController
    [self dismissModalViewControllerAnimated:YES];
}

// set user login info
-(void) setUserLoginInfo{
    // set user info
    // get user default setting
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *_loginName = [_userDefaults objectForKey:@"loginName"];
    NSString *_loginPwd = [_userDefaults objectForKey:@"loginPwd"];
    NSLog(@"baseTabViewController - setUserLoginInfo - login name = %@ and login pwd = %@", _loginName, _loginPwd);
    
    /*
    // user login view setting
    userLoginViewController *_userLoginViewController = [[userLoginViewController alloc] init];
    // set user login view controller name and pwd input field if has
    if(_loginName){
        _userLoginViewController.userNameInput.text = _loginName;
    }
    if(_loginPwd){
        _userLoginViewController.passwordInput.text = _loginPwd;
    }
    // set user login delegate
    _userLoginViewController.userLoginDelegate = self;
    */
     
    // user register and login view setting
    userAccountSettingViewController *_userLoginViewController = [[userAccountSettingViewController alloc] init];
    // set user register and login view controller name input field if has
    if(_loginName){
        _userLoginViewController.userNameInput.text = _loginName;
    }
    // set user register and login delegate
    _userLoginViewController.userRegLoginDelegate = self;
    
    // add _user loginViewController to nav and present modalViewController
    UINavigationController *_loginViewNavController = [[tabViewNavigationController alloc] initWithRootViewController:_userLoginViewController];
    [self presentModalViewController:_loginViewNavController animated:YES];
}

@end
