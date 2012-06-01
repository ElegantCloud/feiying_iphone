//
//  commonTableViewController.m
//  feiying
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonTableViewController.h"
#import "videoDetailViewController.h"
#import "mtvDetailViewController.h"
#import "videoChannelViewController.h"
#import "shareListViewController.h"
#import "searchResultViewController.h"

#import "../common/UserManager.h"
#import "../util/NSString+util.h"
#import "../util/NSNumber+util.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"

@implementation commonTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

// overwrite method:(void) initTableDataSource:
-(void) initTableDataSource:(NSString *)pRequestUrl{
    // normal channel
    if([self isKindOfClass:[videoChannelViewController class]] && !((videoChannelViewController*)self).isFavChannel){
        NSLog(@"normal channel - initTableDataSource.");
        [super initTableDataSource:pRequestUrl];
        
        return;
    }
    
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
    
    // init get list data param
    NSMutableDictionary *_getListParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", nil];
    
    // create asynchronous httpRequest
    [self sendSigRequestWithUrl:pRequestUrl andPostBody:_getListParam andUserInfo:_userInfo andFinishedRespMeth:@selector(didFinishedRequestTableData:) andFailedRespMeth:@selector(didFailedRequestTableData:) andRequestType:asynchronous];
}

// overwrite UIScrollViewDelegate method:(void)scrollViewDidEndDecelerating:
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // normal channel
    if([self isKindOfClass:[videoChannelViewController class]] && !((videoChannelViewController*)self).isFavChannel){
        NSLog(@"normal channel - scrollViewDidEndDecelerating.");
        [super scrollViewDidEndDecelerating:scrollView];
        
        return;
    }
    
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
        
        // init get more data param
        NSMutableDictionary *_getMoreParam = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[UserManager shareSingleton] userBean] name], @"username", [NSString stringWithFormat:@"%d", ((NSNumber*)[_mPagerInfo objectForKey:@"offset"]).intValue+1], @"offset", nil];
        
        // create asynchronous httpRequest
        [self sendSigRequestWithUrl:_mRootUrl andPostBody:_getMoreParam andUserInfo:nil andFinishedRespMeth:@selector(didFinishedRequestMoreData:) andFailedRespMeth:@selector(didFailedRequestMoreData:) andRequestType:asynchronous];
    }
}

// overwrite UITableViewDelegate methods:(CGFloat) tableView: willSelectRowAtIndexPath:
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"row: %d selected. content: %@", [indexPath row], [_mTableDataSource objectAtIndex:[indexPath row]]);
    
    // video detail viewController
    NSString *_videoDetailInfoSourceId = [self getVideoSourceIdInRow:[indexPath row]];
    NSNumber *_videoDetailInfoChannelId = [self getVideoChannelIdInRow:[indexPath row]];
    NSLog(@"video detail infomation source id = %@ and its channel id = %@", _videoDetailInfoSourceId, _videoDetailInfoChannelId);
    
    videoDetailViewController *vdViewController = nil;
    if([_videoDetailInfoChannelId isMovieORTV]){
        // movie or teleplay detail information view controller
        vdViewController = [[movieTVDetailViewController alloc] initWithSourceID:_videoDetailInfoSourceId andVideoChannelId:_videoDetailInfoChannelId];
    }
    else{
        vdViewController = [[videoDetailViewController alloc] initWithSourceID:_videoDetailInfoSourceId andVideoChannelId:_videoDetailInfoChannelId];
    }
    
    // set videoDetailViewController parent table view controller and parent indexPath
    vdViewController.parentTableViewController = self;
    vdViewController.parentTableViewIndexPath = indexPath;
    
    // parse videoDetailViewController and set other members
    if([self isKindOfClass:[videoChannelViewController class]]){
        NSLog(@"video channel view controller.");
        
        // set video detail view controller is delete fav flag
        if (((videoChannelViewController*)self).isFavChannel) {
            vdViewController.isDeleteFavVideoFlag = YES;
        }
        
        // add navigation in view
        [self.navigationController pushViewController:vdViewController animated:YES];
    }
    else if([self isMemberOfClass:[searchResultViewController class]]){
        NSLog(@"video search result view controller.");
        
        // add navigation in view
        [((searchResultViewController*)self).searchViewController.navigationController pushViewController:vdViewController animated:YES];
    }
    else if([self isMemberOfClass:[shareListViewController class]]){
        NSLog(@"share list view controller.");
        
        // set video detail view controller is delete share flag, video share type and share id
        vdViewController.isDeleteShareVideoFlag = YES;
        vdViewController.videoSharedType = ((shareListViewController*)self).shareListViewType;
        vdViewController.videoSharedId = [self getVideoShareIdInRow:[indexPath row]];
        vdViewController.videoSharedTime = [self getVideoShareTimeInRow:[indexPath row]];
        if(vdViewController.videoSharedType == Received){
            vdViewController.videoSharedPersons = [self getShareVideoReceiveFromInRow:[indexPath row]];
        }
        else if(vdViewController.videoSharedType == Sended){
            vdViewController.videoSharedPersons = [self getShareVideoSendToInRow:[indexPath row]];
        }
        
        // add navigation in view
        [((shareListViewController*)self).parentTabViewController.navigationController pushViewController:vdViewController animated:YES];
        
        // show navigation bar
        [((shareListViewController*)self).parentTabViewController.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
    return indexPath;
}

@end
