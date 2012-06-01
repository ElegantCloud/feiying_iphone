//
//  shareListViewController.m
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "shareListViewController.h"
#import "../customComponents/shareTableViewCell.h"
#import "../customComponents/videoTableViewCell.h"
#import "../customComponents/tableFooterView.h"

#import "../util/NSString+util.h"

#import "../common/UserManager.h"

#import "../openSource/ASIHTTPRequest/ASIHTTPRequest.h"

@implementation shareListViewController

@synthesize isTableDSRefresh = _mIsTableDSRefresh;

@synthesize shareListViewType = _mShareListViewType;
@synthesize parentTabViewController = _mParentTabViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithShareType:(ShareListViewType)pShareListViewType andFetchDataUrl:(NSString *)pUrl{
    self = [super init];
    if(self){
        // Custom initialization
        // set share type and fetch data request url
        _mShareListViewType = pShareListViewType;
        _mFetchDataUrl = pUrl;
        
        // update table view frame
        _mTableView.frame = CGRectMake(_mTableView.frame.origin.x, _mTableView.frame.origin.y, _mTableView.frame.size.width, _mTableView.frame.size.height-/*segmentedControl height*/44.0+/*navigationBar height*/44.0);
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

// overwrite method:(UITableViewCell* ) tableView:(UITableView *) cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"shareListViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellVideoImage = [self setVideoInitImageInRow:[indexPath row] andImageType:ssImage];
        NSString *_cellVideoTitle = [self getVideoTitleInRow:[indexPath row]];
        NSString *_cellVideoShareTime = [self getVideoShareTimeInRow:[indexPath row]];
        NSString *_cellVideoSendto = [self getShareVideoSendToInRow:[indexPath row]];
        NSString *_cellVideoReceiveFrom = [self getShareVideoReceiveFromInRow:[indexPath row]];
        //NSLog(@"cell %d - video title: %@, share time: %@, send to: %@ and receive from: %@", [indexPath row],  _cellVideoTitle, _cellVideoShareTime, _cellVideoSendto, _cellVideoReceiveFrom);
        
        _cell = [[shareTableViewCell alloc] initWithTitle:_cellVideoTitle andImage:_cellVideoImage andShareTime:_cellVideoShareTime andSendTo:[_cellVideoSendto.description getVideoSharedPersonsInAddressBook] andReceiveFrom:[_cellVideoReceiveFrom.description getVideoSharedPersonsInAddressBook]];
    }
    
    return _cell;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [shareTableViewCell getCellHeightWithContents:nil];
}

// overwrite method:(void) doneLoadingTableViewData:
-(void) doneLoadingTableViewData:(ASIHTTPRequest*) pRequest{
    NSLog(@"share list done loading data, the request url = %@", pRequest.url);
    
    // process response status code
    if (pRequest.responseStatusCode == 400) {
        _mParentTabViewController.title = @"分享";
        
        // update user info setting indicator label string
        [[UserManager shareSingleton] setUser:[[[UserManager shareSingleton] userBean] name] andUserKey:nil];
        
        // parentTabViewController view will appear again
        [_mParentTabViewController viewWillAppear:YES];
        
        return;
    }
    else{
        // call super method:(void) doneLoadingTableViewData:
        // request succeed, tableView to reload
        if(pRequest.responseStatusCode == 200){
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
                //NSLog(@"**************** shareList content height = %f and table frame size height = %f", [_mTableDataSource count]*_cellHeight, _mTableView.frame.size.height);
                
                _mTableView.tableFooterView = [[tableFootNoMoreDataView alloc] initWithFrame:CGRectMake(0.0 , _mTableView.frame.size.height, _mTableView.frame.size.width, 45.0)];
            }
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
}

// methods implemetation
-(void) initOrRefreshTableDataSource{
    switch (_mShareListViewType) {
        case Sended:
            _mParentTabViewController.title = @"飞去";
            break;
            
        case Received:
            _mParentTabViewController.title = @"飞来";
            break;
    }
    _mParentTabViewController->_mTabBarItem.title = @"分享";
    
    // init table data source 
    if(!_mTableDSHadInited){
        [self initTableDataSource:_mFetchDataUrl];
        
        // reset table had inited flag
        _mTableDSHadInited = YES;
    }
    
    // refresh table data source
    if(_mIsTableDSRefresh){
        if(_mShareListViewType == Sended){
            _mIsTableDSRefresh = NO;
        }
        
        [self initTableDataSource:_mFetchDataUrl];
    }
    
    // set received share list view controller will show, data source needs refresh
    if(_mShareListViewType == Received){
        _mIsTableDSRefresh = YES;
    }
}

@end
