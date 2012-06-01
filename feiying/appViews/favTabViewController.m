//
//  favTabViewController.m
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "favTabViewController.h"

#import "videoChannelViewController.h"
#import "mtvChannelViewController.h"
#import "channelTableViewCell.h"

#import "../common/UserManager.h"
#import "../util/NSString+util.h"
#import "../util/NSNumber+util.h"
#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/Toast/iToast.h"

@implementation favTabViewController

// private methods
// merger table dataSource
-(void) mergerTableDataSource:(NSArray *) pList{
    //NSLog(@"mergerTableDataSource - param pList = %@", pList);
    
    for(NSUInteger index = 0; index < [_mTableDataSource count]; index++){
        NSMutableDictionary *_tableDataSourceObject = [[NSMutableDictionary alloc] initWithDictionary:[_mTableDataSource objectAtIndex:index] copyItems:YES];
        //NSLog(@"1 --- table dataSouce[%d] = %@", (index+1), _tableDataSourceObject);
        
        // set matched flag
        BOOL _matched = NO;
        
        // pList scan
        for(NSDictionary *_object in pList){
            //NSLog(@"pList object = %@", _object);
            
            // get pList object video channel
            NSNumber *_objChannel = [_object objectForKey:@"channel"];
            //NSLog(@"object video channel = %@", _objChannel);
            
            // compare
            if([_objChannel isEqualToNumber:[self getChannelIdInRow:index]]){
                _matched = YES;
                
                //[_tableDataSourceObject addEntriesFromDictionary:_object];
                [_tableDataSourceObject setObject:[_object objectForKey:@"favcount"] forKey:@"favcount"];
                //NSLog(@"2 --- table dataSouce[%d] = %@", (index+1), _tableDataSourceObject);
            }
        }
        
        // reset fav count
        if(!_matched && [_tableDataSourceObject objectForKey:@"favcount"]){
            [_tableDataSourceObject setObject:@"0" forKey:@"favcount"];
        }
        
        // replace table dataSource
        [_mTableDataSource replaceObjectAtIndex:index withObject:_tableDataSourceObject];
    }
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // overwrite title
        self.title = @"收藏";
        
        // set navigationItem rightBarButtonItem nil
        self.navigationItem.rightBarButtonItem = nil;
        
        // overwrite tabBar item
        _mTabBarItem.image = [UIImage imageNamed:@"favTab.png"];
        _mTabBarItem.title = @"收藏";
        _mTabBarItem.tag = 1;
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
    if(![[[UserManager shareSingleton] userBean] name]){
        // set indicator tip string
        [_mUserLoginIndicatorView setUserLoginIndicatorTipString:@"您还没有设置账户信息,暂时无法使用收藏功能."];
        // add user login indicator view to view
        [self.view addSubview:_mUserLoginIndicatorView];
        
        return;
    }
    else if(![[[UserManager shareSingleton] userBean] userKey]){
        // set indicator tip string
        [_mUserLoginIndicatorView setUserLoginIndicatorTipString:@"您的账户在其他手机上登录过,请您重新设置账户信息,以便您使用收藏功能."];
        // add user login indicator view to view
        [self.view addSubview:_mUserLoginIndicatorView];
        
        return;
    }
    else{
        // send use fav function authenticate reques
        [self sendAuthenticateRequest:@selector(didFinishedRequestUseFavFunctionAuth:) andFailedRespMeth:@selector(didFailedRequestUseFavFunctionAuth:) andRequestType:asynchronous];
        
        /*
        // remove user loginIndicatorView
        [_mUserLoginIndicatorView removeFromSuperview];
        
        // view reload?
        if(!_mTableViewReload){
            NSLog(@"viewWillAppear - init table dataSource.");
            // init table dataSource
            [self initTableDataSource:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant favChannelListUrl]]];
        }
        
        [super viewWillAppear:animated];
         */
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

// overwrite method:(void) initTableDataSource:
-(void) initTableDataSource:(NSString *)pRequestUrl{
    // init reloading tag
    NSDictionary *_userInfo = nil;
    
    // set root url
    if(_mRootUrl == nil || ![_mRootUrl isEqualToString:pRequestUrl]){
        _mRootUrl = pRequestUrl;
    }
    //NSLog(@"root url = %@", _mRootUrl);
    
    // set reloading table sourceData request userInfo
    if(_reloading){
        //NSLog(@"table dataSource size = %d and object = %@", [_mTableDataSource count], _mTableDataSource);
        // set userInfo
        _userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"table dataSource reloading...", @"reqUserInfo", nil];
    }
    
    // init get fav list param
    NSMutableDictionary *_getFavListParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", nil];
    
    // create asynchronous httpRequest
    [self sendSigRequestWithUrl:pRequestUrl andPostBody:_getFavListParam andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
}

// overwrite method:(void) doneLoadingTableViewData:
-(void) doneLoadingTableViewData:(ASIHTTPRequest*) pRequest{
    NSLog(@"fav done loading data, the request url = %@", pRequest.url);
    
    // show refresh button as rightBarButtonItem
    if(pRequest.responseStatusCode != 400){
        //UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshFavVideoChannel)];
        UIBarButtonItem *_refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFavVideoChannel)];
        self.navigationItem.rightBarButtonItem = _refreshBarButtonItem;
    }
    // hide refresh button
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // process response status code
    switch (pRequest.responseStatusCode) {
        case 200:
            // request succeed, tableView to reload
            [_mTableView reloadData];
            break;
            
        case 400:
            // update user info setting indicator label string
            [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
            
            // view will appear again
            [self viewWillAppear:YES];
            break;
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
        // done load view after delay 500ms
        [self performSelector:@selector(doneLoadView) withObject:nil afterDelay:0.5];
    }
}

// overwrite method:(void) didFinishedRequestTableData:
-(void) didFinishedRequestTableData:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestTableData- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    //NSLog(@"didFinishedRequestTableData - list object = %@", [_jsonData objectForKey:@"list"]);
    
    if(_jsonData){
        // merger table data source
        //NSLog(@"before merger table dataSource: %@", _mTableDataSource);
        [self mergerTableDataSource:[_jsonData objectForKey:@"list"]];
        //NSLog(@"after merger table dataSource: %@", _mTableDataSource);
    }
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
}

// overwrite method:(void) didFailedRequestTableData:
-(void) didFailedRequestTableData:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestTableData url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"%@,请点击刷新按钮重新获取收藏列表", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
}

// use fav function authenticate request response methods
-(void) didFinishedRequestUseFavFunctionAuth:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestUseFavFunctionAuth - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get result
    if(pRequest.responseStatusCode == 200){
        // remove user loginIndicatorView
        [_mUserLoginIndicatorView removeFromSuperview];
        
        // view reload?
        if(!_mTableViewReload){
            NSLog(@"favTabViewController - viewWillAppear - init table dataSource.");
            // init table dataSource
            [self initTableDataSource:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant favChannelListUrl]]];
        }
        
        [super viewWillAppear:YES];
    }
    else if(pRequest.responseStatusCode == 400){
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        [self viewWillAppear:YES];
    }
    else{
        iToast *_toast = [iToast makeText:NSLocalizedString(@"network access exception or error", "network access exception or error tip string")];
        [_toast setDuration:iToastDurationLong];
        [_toast setGravity:iToastGravityCenter];
        [_toast show];
    }
}

-(void) didFailedRequestUseFavFunctionAuth:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestUseFavFunctionAuth - request url = %@, error: %@", pRequest.url, _error);
    
    iToast *_toast = [iToast makeText:[NSString stringWithFormat:@"%@,请点击刷新按钮重新获取收藏列表", NSLocalizedString(@"network access exception or error", "network access exception or error tip string")]];
    [_toast setDuration:iToastDurationLong];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
    
    // done reloading data
    [self doneLoadingTableViewData:pRequest];
    
    // set rootUrl
    _mRootUrl = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant favChannelListUrl]];
}

// methods implemetation
-(void) refreshFavVideoChannel{
    // table dataSource refresh
    _reloading = YES;
    
    [self initTableDataSource:_mRootUrl];
}
 
@end
