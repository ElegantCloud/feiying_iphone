//
//  mtvDetailViewController.m
//  feiying
//
//  Created by  on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mtvDetailViewController.h"

#import "../customComponents/mtvDetailTableViewCell.h"
#import "../constants/systemConstant.h"
#import "../util/NSString+util.h"

#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/ASIHTTPRequest/ASIHTTPRequest.h"

@implementation movieTVDetailViewController

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

// overwrite UITableViewDataSource method:(UITableViewCell*) tableView: cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    movieTVDetailTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"movieTVDetailViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellVideoImage = [self getVideoImageInRow:[indexPath row]];
        NSString *_cellVideoTitle = [self getVideoTitleInRow:[indexPath row]];
        NSString *_cellVideoOriginLocate = [self getVideoOriginLocateInRow:[indexPath row]];
        NSString *_cellVideoReleaseDate = [self getVideoReleaseDateInRow:[indexPath row]];
        NSString *_cellVideoDirector = [self getVideoDirectorInRow:[indexPath row]];
        NSString *_cellVideoActors = [self getVideoActorsInRow:[indexPath row]];
        NSString *_cellVideoTotalTime = [self getVideoTotalTimeInRow:[indexPath row]];
        NSString *_cellVideoEpisodeCount = [self getVideoEpisodeCountInRow:[indexPath row]];
        NSString *_cellVideoEpisodeState = [self getVideoEpisodeStateInRow:[indexPath row]];
        NSString *_cellVideoPlaycount = [self getVideoPlaycountInRow:[indexPath row]];
        NSString *_cellVideoSharecount = [self getVideoSharecountInRow:[indexPath row]];
        NSString *_cellVideoFavcount = [self getVideoFavcountInRow:[indexPath row]];
        NSString *_cellVideoDescription = [self getVideoDescriptionInRow:[indexPath row]];
        NSArray *_cellVideoEpisodeList = [self getVideoEpisodeListInRow:[indexPath row]];
        //NSLog(@"cell %d - video image = %@, title: %@, origin locate: %@, release date: %@, director: %@, actors: %@, total time: %@, episode state = %@, episode count = %@, play count: %@, share count: %@, fav count: %@ and description = %@.", [indexPath row], _cellVideoImage, _cellVideoTitle, _cellVideoOriginLocate, _cellVideoReleaseDate, _cellVideoDirector, _cellVideoActors, _cellVideoTotalTime, _cellVideoEpisodeState, _cellVideoEpisodeCount, _cellVideoPlaycount, _cellVideoSharecount, _cellVideoFavcount, _cellVideoDescription);
        
        _cell = [[movieTVDetailTableViewCell alloc] initWithTitle:_cellVideoTitle andImage:_cellVideoImage andOriginLocate:_cellVideoOriginLocate andReleaseDate:_cellVideoReleaseDate andDirector:_cellVideoDirector andActors:_cellVideoActors andTotalTime:_cellVideoTotalTime andEpisodeCountState:[NSString stringWithFormat:@"%@(%@)", _cellVideoEpisodeCount, _cellVideoEpisodeState] andPlaycount:_cellVideoPlaycount andSharecount:_cellVideoSharecount andFavcount:_cellVideoFavcount andDescription:_cellVideoDescription andEpisodeList:_cellVideoEpisodeList andDeleteFavFlag:_mIsDeleteFavVideo andDeleteShareFlag:_mIsDeleteShareVideo andShareInfo:[self getVideoSharedInfo]];
        // set user indicator delegate
        _cell.videoIndicatorDelegate = self;
    }
    
    return _cell;
}

@end
