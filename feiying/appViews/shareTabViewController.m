//
//  shareTabViewController.m
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "shareTabViewController.h"
#import "../customComponents/userLoginIndicatorView.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"
#import "../common/UserManager.h"

#import "../openSource/ASIHTTPRequest/ASIFormDataRequest.h"
#import "../openSource/JSONKit/JSONKit.h"
#import "../openSource/Toast/iToast.h"

@implementation shareTabViewController

@synthesize feiquShareList = _mFeiquSeg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // overwrite title
        self.title = @"分享";
        
        // stop view loading indocator animating
        [_mViewLoadingIndicatorView stopAnimating];
        
        // set navigationItem rightBarButtonItem nil
        self.navigationItem.rightBarButtonItem = nil;
        
        // overwrite tabBar item
        _mTabBarItem.image = [UIImage imageNamed:@"shareTab.png"];
        _mTabBarItem.title = @"分享";
        _mTabBarItem.tag = 0;
        
        // init subViews
        /*
        // video share type segmented control
        // init segment item array
        NSArray *_segItemArray = [[NSArray alloc] initWithObjects:@"飞来", @"飞去", nil];
        // create and int segmented control
        _mListSegmentedControl = [[UISegmentedControl alloc] initWithItems:_segItemArray];
        // set style
        _mListSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        // set tint color and background color
        _mListSegmentedControl.tintColor = [UIColor lightGrayColor];
        _mListSegmentedControl.backgroundColor = [UIColor grayColor];
        // set frame
        _mListSegmentedControl.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.x, self.view.frame.size.width, 35.0);
        // add segment item changed target
        [_mListSegmentedControl addTarget:self action:@selector(segItemChanged:) forControlEvents:UIControlEventValueChanged];
         */
        
        // init toolbar item array
        NSArray *_toolbarItemArray = [[NSArray alloc] initWithObjects:@"飞来", @"飞去", nil];
        _mShareTabHearderToolbar = [[shareTypeToolBar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.x, self.view.frame.size.width, 44.0)];
        // set shareTypeToolBar items array
        [_mShareTabHearderToolbar setBarButtonItems:_toolbarItemArray];
        // set shareTypeToolBar delegate
        _mShareTabHearderToolbar.shareTypeToolBarDelegate = self;
        
        // feilai segment view controller
        _mFeilaiSeg = [[shareListViewController alloc] initWithShareType:Received andFetchDataUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant receivedShareListUrl]]];
        _mFeilaiSeg.view.frame = CGRectMake(self.view.frame.origin.x, _mShareTabHearderToolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-_mShareTabHearderToolbar.frame.size.height);
        _mFeilaiSeg.parentTabViewController = self;
        
        // feiqu segment view controller
        _mFeiquSeg = [[shareListViewController alloc] initWithShareType:Sended andFetchDataUrl:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant sendedShareListUrl]]];
        _mFeiquSeg.view.frame = _mFeilaiSeg.view.frame;
        _mFeiquSeg.parentTabViewController = self;
        _mFeiquSeg.view.hidden = YES;
        
        // add subViews to view
        [self.view addSubview:_mFeilaiSeg.view];
        [self.view addSubview:_mFeiquSeg.view];
        //[self.view addSubview:_mListSegmentedControl];
        [self.view addSubview:_mShareTabHearderToolbar];
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
        [_mUserLoginIndicatorView setUserLoginIndicatorTipString:@"您还没有设置账户信息,暂时无法使用分享功能."];
        // add user login indicator view to view
        [self.view addSubview:_mUserLoginIndicatorView];
        
        return;
    }
    else if(![[[UserManager shareSingleton] userBean] userKey]){
        // show navigation bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        // set shareTab view controller title
        self.title = @"分享";
        
        // set indicator tip string
        [_mUserLoginIndicatorView setUserLoginIndicatorTipString:@"您的账户在其他手机上登录过,请您重新设置账户信息,以便您使用分享功能."];
        // add user login indicator view to view
        [self.view addSubview:_mUserLoginIndicatorView];
        
        return;
    }
    else{
        // first hide navigation bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        // send use share function authenticate reques
        [self sendAuthenticateRequest:@selector(didFinishedRequestUseShareFunctionAuth:) andFailedRespMeth:@selector(didFailedRequestUseShareFunctionAuth:) andRequestType:asynchronous];
        
        /*
        // remove user loginIndicatorView
        [_mUserLoginIndicatorView removeFromSuperview];
        
        // hide navigation bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        // init selected segment share list view controller table dataSource
        if(!_mFeilaiSeg.view.hidden){
            [_mFeilaiSeg initOrRefreshTableDataSource];
        }
        if(!_mFeiquSeg.view.hidden){
            [_mFeiquSeg initOrRefreshTableDataSource];
        }
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

// shareTypeToolBarDelegate methods implemttation
-(void) barItemChanged:(UIButton *)pBarButton{
    //NSLog(@"shareTabViewController - barItemChanged - barButton tag = %d and toolbar selected item index = %d.", pBarButton.tag, _mShareTabHearderToolbar.selectedItemIndex);
    
    if(pBarButton.tag == 0 && _mShareTabHearderToolbar.selectedItemIndex != pBarButton.tag){
        _mFeilaiSeg.view.hidden = NO;
        _mFeiquSeg.view.hidden = YES;
        
        [_mFeilaiSeg initOrRefreshTableDataSource];
    }
    else if(pBarButton.tag == 1 && _mShareTabHearderToolbar.selectedItemIndex != pBarButton.tag){
        _mFeilaiSeg.view.hidden = YES;
        _mFeiquSeg.view.hidden = NO;
        
        [_mFeiquSeg initOrRefreshTableDataSource];
    }
    
    // update selected item index
    _mShareTabHearderToolbar.selectedItemIndex = pBarButton.tag;
}

// use share function authenticate request response methods
-(void) didFinishedRequestUseShareFunctionAuth:(ASIHTTPRequest*) pRequest{
    NSLog(@"didFinishedRequestUseShareFunctionAuth - request url = %@, responseStatusCode = %d, responseStatusMsg = %@", pRequest.url, [pRequest responseStatusCode], [pRequest responseStatusMessage]);
    
    // get result
    if(pRequest.responseStatusCode == 200){
        // remove user loginIndicatorView
        [_mUserLoginIndicatorView removeFromSuperview];
        
        /*
        // hide navigation bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        */
         
        // init selected segment share list view controller table dataSource
        if(!_mFeilaiSeg.view.hidden){
            [_mFeilaiSeg initOrRefreshTableDataSource];
        }
        if(!_mFeiquSeg.view.hidden){
            [_mFeiquSeg initOrRefreshTableDataSource];
        }
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

-(void) didFailedRequestUseShareFunctionAuth:(ASIHTTPRequest*) pRequest{
    NSError *_error = [pRequest error];
    NSLog(@"didFailedRequestUseShareFunctionAuth - request url = %@, error: %@", pRequest.url, _error);
    
    // init selected segment share list view controller table dataSource
    if(!_mFeilaiSeg.view.hidden){
        [_mFeilaiSeg initOrRefreshTableDataSource];
    }
    if(!_mFeiquSeg.view.hidden){
        // set feiqu share list refresh
        _mFeiquSeg.isTableDSRefresh = YES;
        
        [_mFeiquSeg initOrRefreshTableDataSource];
    }
}

// methods implemttation
-(void) segItemChanged:(UISegmentedControl*) pSeg{
    //NSLog(@"segment selected index = %d", pSeg.selectedSegmentIndex);
    
    if(pSeg.selectedSegmentIndex == 0){
        _mFeilaiSeg.view.hidden = NO;
        _mFeiquSeg.view.hidden = YES;
        
        [_mFeilaiSeg initOrRefreshTableDataSource];
    }
    else if(pSeg.selectedSegmentIndex == 1){
        _mFeilaiSeg.view.hidden = YES;
        _mFeiquSeg.view.hidden = NO;
        
        [_mFeiquSeg initOrRefreshTableDataSource];
    }
}

@end
