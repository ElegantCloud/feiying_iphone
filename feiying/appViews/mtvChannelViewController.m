//
//  mtvChannelViewController.m
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mtvChannelViewController.h"

#import "mtvTableViewcell.h"
#import "mtvDetailViewController.h"
#import "../constants/systemConstant.h"

@implementation movieTVChannelViewController

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
    movieTVTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"movieTVChannelViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        UIImage *_cellMovieTVImage = [self setVideoInitImageInRow:[indexPath row] andImageType:mtvImage];
        NSString *_cellMovieTVTitle = [self getVideoTitleInRow:[indexPath row]];
        NSString *_cellMovieTVTotalTime = [self getVideoTotalTimeInRow:[indexPath row]];
        NSString *_cellMovieTVEpisodeState = [self getVideoEpisodeStateInRow:[indexPath row]];
        NSString *_cellMovieTVEpisodeCount = [self getVideoEpisodeCountInRow:[indexPath row]];
        NSString *_cellMovieTVActors = [self getVideoActorsInRow:[indexPath row]];
        NSString *_cellMovieTVOriginLocate = [self getVideoOriginLocateInRow:[indexPath row]];
        NSString *_cellMovieTVReleaseDate = [self getVideoReleaseDateInRow:[indexPath row]];
        //NSLog(@"cell %d - movieTV title: %@, total time: %@, episode state = %@, episode count = %@, actors: %@, originLocate = %@ and release date: %@", [indexPath row], _cellMovieTVTitle, _cellMovieTVTotalTime, _cellMovieTVEpisodeState, _cellMovieTVEpisodeCount, _cellMovieTVActors, _cellMovieTVOriginLocate, _cellMovieTVReleaseDate);
        
        _cell = [[movieTVTableViewCell alloc] initWithTitle:_cellMovieTVTitle andImage:_cellMovieTVImage andTotalTime:_cellMovieTVTotalTime andEpisodeCountState:[NSString stringWithFormat:@"%@(%@)", _cellMovieTVEpisodeCount, _cellMovieTVEpisodeState] andActors:_cellMovieTVActors andOriginLocate:_cellMovieTVOriginLocate andReleaseDate:_cellMovieTVReleaseDate];
    }
    
    return _cell;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [movieTVTableViewCell getCellHeightWithContents:nil];
}

@end
