//
//  videoSearchViewController.m
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoSearchViewController.h"

@implementation videoSearchViewController

@synthesize videoSearchToolbar = _mvsToolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // base setting
        // set title
        self.title = @"搜索";
        
        // update view frame
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, self.view.frame.size.height-/*navigationBar height*/44.0-/*tabBar height*/50.0+1.0);
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+49.0);
        
        // create and init feiying videoSearchToolBar
        _mvsToolBar = [[videoSearchToolBar alloc] init];
        // set frame
        _mvsToolBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 40.0);
        // set delegate
        _mvsToolBar.videoSearchDelegate = self;
        
        // hot keywords label tip view controller
        _mHotKeywordsViewController = [[hotKeywordsViewController alloc] init];
        _mHotKeywordsViewController.view.frame = CGRectMake(_mvsToolBar.frame.origin.x, _mvsToolBar.frame.origin.y+_mvsToolBar.frame.size.height, _mvsToolBar.frame.size.width, self.view.frame.size.height-_mvsToolBar.frame.size.height);
        // set parent video search view controller
        _mHotKeywordsViewController.parentVideoSearchViewController = self;
        
        // video search result table viewController
        _mSRTableViewController = [[searchResultViewController alloc] init];
        // set view frame
        _mSRTableViewController.view.frame = _mHotKeywordsViewController.view.frame;
        // hide first
        _mSRTableViewController.view.hidden = YES;
        _mSRTableViewController.searchViewController = self;
        
        // set mask view
        _mMaskView = [[maskView alloc] initWithFrame:_mHotKeywordsViewController.view.frame];
        // set maskViewDelegate
        _mMaskView.maskViewDelegate = self;
        // set hidden
        _mMaskView.hidden = YES;
        
        // add feiyingMovieSearchToolBar, hot key word tip view and video search result to the view
        [self.view addSubview:_mvsToolBar];
        [self.view addSubview:_mHotKeywordsViewController.view];
        [self.view addSubview:_mSRTableViewController.view];
        
        [self.view addSubview:_mMaskView];
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

// videoSearchDelegate methods implemetation
-(void) videoSearch:(NSString *)pKeyWord{
    //NSLog(@"videoSearchViewController's videoSearchDelegate - videoSearch method implemetation, pKeyWord: %@", pKeyWord);
    
    // hide hot keywords view controller and show search result
    _mHotKeywordsViewController.view.hidden = YES;
    _mSRTableViewController.view.hidden = NO;
    
    // begin to search
    [_mSRTableViewController beginToSearch:pKeyWord];
}

-(void) videoSearchBegin{
    _mMaskView.hidden = NO;
}

-(void) videoSearchEnd{
    _mMaskView.hidden = YES;
}

// maskViewDelegate methods implemetation
-(void) touchInside:(maskView *)pMaskView{
    [_mvsToolBar videoSearchCancelAction];
}

// methods implemetation
-(void) videoSearchBack{
    // update left navigation item and title
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"搜索";
    
    // hide search result
    _mSRTableViewController.view.hidden = YES;
    
    // refresh table dataSource if hotKeywordsViewController is hidden
    if(_mHotKeywordsViewController.view.hidden){
        [_mHotKeywordsViewController initTableDataSource:_mHotKeywordsViewController.rootUrl];
    }
    
    // UIView animation
    [UIView beginAnimations:@"back" context:nil];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_mHotKeywordsViewController.view cache:YES];
    
    // show hot keywords view controller
    _mHotKeywordsViewController.view.hidden = NO;
    
    // UIView animation commit
    [UIView commitAnimations];
}

@end
