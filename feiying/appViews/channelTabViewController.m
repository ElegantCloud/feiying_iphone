//
//  channelTabViewController.m
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "channelTabViewController.h"

#import "videoChannelViewController.h"
#import "mtvChannelViewController.h"
#import "favTabViewController.h"
#import "../customComponents/channelTableViewCell.h"

#import "../util/NSNumber+util.h"
#import "../constants/systemConstant.h"

@implementation channelTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // overwrite title
        self.title = @"频道";
        
        // remove refreshHeaderView
        [_mRefreshHeaderView removeFromSuperview];
        
        // overwrite tabBar item
        _mTabBarItem.image = [UIImage imageNamed:@"channelTab.png"];
        _mTabBarItem.title = @"频道";
        _mTabBarItem.tag = 3;
        
        // init table dataSource
        _mTableDataSource = [[NSMutableArray alloc] initWithArray:[systemConstant channelInitDataSource]];
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
    if([self isMemberOfClass:[channelTabViewController class]]){
        // stop viewLoadingIndicatorView and show tableView
        [_mViewLoadingIndicatorView stopAnimating];
        _mTableView.hidden = NO;
    }
    
    [super viewWillAppear:animated];
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

// overwrite UITableViewDataSource method:(UITableViewCell*) tableView: cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    channelTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"channelTabViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellChannelImage = [self getChannelImageInRow:[indexPath row]];
        NSString *_cellChannelTitle = [self getChannelTitleInRow:[indexPath row]];
        NSString *_cellChannelCount = [self getChannelFavVideoCountInRow:[indexPath row]];
        if([self isMemberOfClass:[favTabViewController class]]){
            _cellChannelTitle = [[NSString alloc] initWithFormat:@"%@(%@)", _cellChannelTitle, _cellChannelCount];
        }
        //NSLog(@"cell %d - channel image: %@, title: %@ and count = %@", [indexPath row], _cellChannelImage, _cellChannelTitle, _cellChannelCount);
        
        _cell = [[channelTableViewCell alloc] initWithChannelTitle:_cellChannelTitle andImage:_cellChannelImage];
    }
    
    return _cell;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: willSelectRowAtIndexPath:
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"row: %d selected. content: %@", [indexPath row], [_mTableDataSource objectAtIndex:[indexPath row]]);
    
    // get channel id, channel title and fav channel flag
    NSNumber* _channelId = [self getChannelIdInRow:[indexPath row]];
    NSString *_channelTitle = [self getChannelTitleInRow:[indexPath row]];
    BOOL _favChannel = ([self isMemberOfClass:[favTabViewController class]]) ? YES : NO;
    
    // define channel viewController
    videoChannelViewController *channelViewController;
    
    // deal movie, teleplay and video
    if([_channelId isMovieORTV]){        
        channelViewController = [[movieTVChannelViewController alloc] initWithChannelTitle:_channelTitle andId:_channelId andFavChannel:_favChannel];
    }
    else{
        channelViewController = [[videoChannelViewController alloc] initWithChannelTitle:_channelTitle andId:_channelId andFavChannel:_favChannel];
    }
    
    // add navigation in view
    [self.navigationController pushViewController:channelViewController animated:YES];
    
    return indexPath;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [channelTableViewCell getCellHeightWithContents:nil];
}

@end
