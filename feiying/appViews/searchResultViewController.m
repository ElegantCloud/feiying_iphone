//
//  searchResultViewController.m
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "searchResultViewController.h"
#import "../customComponents/searchResultTableViewCell.h"
#import "videoSearchViewController.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

@implementation searchResultViewController

@synthesize searchViewController = _mSearchViewController;

// private methods
// update searchViewController left navigation item
-(void) updateLeftNavigationItem{
    // update searchViewController left navigation item
    //_mSearchViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:_mSearchViewController action:@selector(videoSearchBack)];
    
    // initialize back button
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // set frame
    _backButton.frame = CGRectMake(0.0, 0.0, 48.0, 30.0);
    // set normal image and highlight image
    [_backButton setImage:[UIImage imageNamed:@"backButtonImgNormal.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"backButtonImgHighlight.png"] forState:UIControlStateHighlighted];
    // add target
    [_backButton addTarget:_mSearchViewController action:@selector(videoSearchBack) forControlEvents:UIControlEventTouchUpInside];
    _mSearchViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
   
    // update searchViewController title
    _mSearchViewController.title = @"搜索结果";
    
    // UIView animation
    [UIView beginAnimations:@"forward" context:nil];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_mTableView cache:YES];
    
    // UIView animation commit
    [UIView commitAnimations];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        // remove refreshHeaderView
        [_mRefreshHeaderView removeFromSuperview];
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+49.0);
        
        // update frame
        _mTableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-49.0-22.0+31.0);
        
        // update loading indicator tip and loading indicator frame
        ((UILabel*)[_mViewLoadingIndicatorView viewWithTag:-1314]).text = @"搜索中...";
        _mViewLoadingIndicatorView.center = _mTableView.center;
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

// overwrite UITableViewDataSource method:(UITableViewCell* ) tableView:(UITableView *) cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"searchResultViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellVideoImage = [self setVideoInitImageInRow:[indexPath row] andImageType:ssImage];
        NSString *_cellVideoTitle = [self getVideoTitleInRow:[indexPath row]];
        //NSLog(@"cell %d - video title: %@", [indexPath row],  _cellVideoTitle);
        
        _cell = [[searchResultTableViewCell alloc] initWithTitle:_cellVideoTitle andImage:_cellVideoImage];
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [searchResultTableViewCell getCellHeightWithContents:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // init section header view
    UIView *_sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 22.0)];
    
    UILabel *_headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sectionHeaderView.frame.origin.x+5.0, _sectionHeaderView.frame.origin.y+2.0, _sectionHeaderView.frame.size.width-4.0, 18.0)];
    _headerViewLabel.backgroundColor = [UIColor clearColor];
    // text
    _headerViewLabel.text = _mSearchResultLabelString;
    _headerViewLabel.textColor = [UIColor whiteColor];
    _headerViewLabel.font = [UIFont systemFontOfSize:13.0];
    // add to section herader view
    [_sectionHeaderView addSubview:_headerViewLabel];
    
    if (section == 0){
        [_sectionHeaderView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
    }
        
    return _sectionHeaderView;
}

// overwrite UIScrollViewDelegate method:(void)scrollViewDidEndDecelerating:
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
        NSString *_moreDataUrlStr = [[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [_mPagerInfo objectForKey:@"nextPage"]] stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
        NSLog(@"next page url = %@", _moreDataUrlStr);
        
        // async fetch more data
        ASIHTTPRequest *_fetchMoreData = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_moreDataUrlStr]];
        // set timeout seconds
        [_fetchMoreData setTimeOutSeconds:5.0];
        // set delegate
        _fetchMoreData.delegate = self;
        // set response methods
        _fetchMoreData.didFinishSelector = @selector(didFinishedRequestMoreData:);
        _fetchMoreData.didFailSelector = @selector(didFailedRequestMoreData:);
        
        // start send request
        [_fetchMoreData startAsynchronous];
    }
}

// overwrite UIScrollViewDelegate method:(void) scrollViewDidEndDragging: willDecelerate:
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // if decelerate is no(ios4)
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

// ASIHTTPRequestDelegate methods implemetation
// search result dataSource fetch request response methods
-(void) didFinishedRequestFetchSearchResult:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestFetchSearchResult- request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // init response json format data and data array count
    NSDictionary *_jsonData = [[[NSString alloc] initWithData:[pRequest responseData] encoding:NSUTF8StringEncoding] objectFromJSONString];
    
    // update search result label string
    NSInteger _resultCount = (_jsonData) ? ((NSNumber*)[(NSDictionary*)[_jsonData objectForKey:@"pager"] objectForKey:@"count"]).integerValue : 0;
    _mSearchResultLabelString = [NSString stringWithFormat:@"搜索结果: 共搜索到%d条记录", _resultCount];;
    
    [super performSelector:@selector(didFinishedRequestTableData:) withObject:pRequest];
    
    // update searchViewController left navigation item
    [self updateLeftNavigationItem];
}

-(void) didFailedRequestFetchSearchResult:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestFetchSearchResult url = %@, error: %@", pRequest.url, _error);
    
    // table data source remove all objects and table view reload data
    [_mTableDataSource removeAllObjects];
    [_mTableView reloadData];
    
    // update search result label string
    _mSearchResultLabelString = @"搜索失败";
    
    [super performSelector:@selector(didFailedRequestTableData:) withObject:pRequest];
    
    // update searchViewController left navigation item
    [self updateLeftNavigationItem];
}

// methods implemetation
-(void) beginToSearch:(NSString *)pSearchTitle{
    // start animating
    if(![_mViewLoadingIndicatorView isAnimating]){
        //NSLog(@"searchResultViewController - beginToSearch - startAnimating.");
        
        // hide table view
        _mTableView.hidden = YES;
        
        // show viewLoadingIndicatorView
        [_mViewLoadingIndicatorView startAnimating];
    }
    
    // tableView scroll to top
    if(_mTableDataSource && [_mTableDataSource count] > 0){
        [_mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    // init search request url
    NSString *_searchRequestUrl = [NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant videoSearchUrl]];
    
    // init reloading tag
    NSDictionary *_userInfo = nil;
    
    // set root url
    if(_mRootUrl == nil || ![_mRootUrl isEqualToString:_searchRequestUrl]){
        _mRootUrl = _searchRequestUrl;
    }
    //NSLog(@"root url = %@", _mRootUrl);
    
    // set reloading table sourceData request userInfo
    if(/*_mTableDataSource != nil*/_reloading){
        //NSLog(@"table dataSource size = %d and object = %@", [_mTableDataSource count], _mTableDataSource);
        // set userInfo
        _userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"table dataSource reloading...", @"reqUserInfo", nil];
    }
    
    // init get search data param
    NSMutableDictionary *_getSearchDataParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pSearchTitle, @"searchTitle", nil];
    
    // create asynchronous httpRequest
    [self sendRequestWithUrl:_searchRequestUrl andPostBody:_getSearchDataParam andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestFetchSearchResult:) andFailedRespMeth:@selector(didFailedRequestFetchSearchResult:) andRequestType:asynchronous];
}

@end
