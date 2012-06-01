//
//  videoChannelViewController.m
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoChannelViewController.h"

#import "videoDetailViewController.h"
#import "mtvDetailViewController.h"

#import "../common/UserManager.h"
#import "../util/NSNumber+util.h"
#import "../util/NSString+util.h"
#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"

@implementation videoChannelViewController

@synthesize isFavChannel = _mIsFavChannel;

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// init with video channel title , id and fav channel flag
-(id) initWithChannelTitle:(NSString *)pTitle andId:(NSNumber *)pId andFavChannel:(BOOL)pIsFavChannel{
    self = [super init];
    
    // set fav channel flag
    _mIsFavChannel = pIsFavChannel;
    
    if(self){
        // Custom initialization
        NSLog(@"videoChannelViewController - initWithChannelTitle - title: %@, id = %@ and is fav channel flag = %d", pTitle, pId, pIsFavChannel);
        
        // base setting
        // set title
        self.title = pTitle;
        
        // set navigationItem nil
        self.navigationItem.leftBarButtonItem = nil;
        if(_mIsFavChannel){
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        // tabBar item setting
        self.tabBarItem = nil;
        
        // init video channel table dataSource fetch request url
        if(_mIsFavChannel){
            // fav channel
            _mChannelListUrl = [NSString stringWithFormat:@"%@%@/%d", [systemConstant systemRootUrl], [urlConstant commonFavChannelPageUrl], pId.integerValue];
        }
        else{
            // normal channel
            _mChannelListUrl = [NSString stringWithFormat:@"%@%@/%d", [systemConstant systemRootUrl], [urlConstant commonChannelPageUrl], pId.integerValue];
        }
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
    // view reload?
    if(!_mTableViewReload){
        NSLog(@"videoChannelViewController - viewWillAppear - init table dataSource.");
        // init table dataSource
        [self initTableDataSource:_mChannelListUrl];
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

@end
