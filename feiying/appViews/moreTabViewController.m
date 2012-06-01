//
//  moreTabViewController.m
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "moreTabViewController.h"
#import "aboutViewController.h"
#import "feedbackViewController.h"
#import "userLoginViewController.h"
#import "userAccountSettingViewController.h"

#import "../common/UserManager.h"
#import "../util/UIImage+util.h"
#import "../constants/systemConstant.h"

@implementation moreTabViewController

// private methods
/*
// popup home, fav and share tab navigation viewController and update rootViewController
-(void) popupHomeFavShareTabNavAndUpdateRoot{
    // get fav tab navigation view controller
    UINavigationController *_favTabNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:1];
    UINavigationController *_shareTabNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:0];
    UINavigationController *_homeTabNav = (UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:2];
    
    // popup to root view controller
    [_favTabNav popToRootViewControllerAnimated:YES];
    [_shareTabNav popToRootViewControllerAnimated:YES];
    
    // update fav tab root view controller
    ((baseTabViewController*)_favTabNav.visibleViewController).isTableViewReload = NO;
    // update feiqu share list
    ((shareTabViewController*)_shareTabNav.visibleViewController).feiquShareList.isTableDSRefresh = YES;
    ((baseTabViewController *)[_homeTabNav.viewControllers objectAtIndex:0]).isTableViewReload = NO;
}
 */

// account setting
-(void) accountSetting{
    // get user default setting
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *_loginName = [_userDefaults objectForKey:@"loginName"];
    NSString *_loginPwd = [_userDefaults objectForKey:@"loginPwd"];
    NSLog(@"moreTabViewController - setUserLoginInfo - login name = %@ and login pwd = %@", _loginName, _loginPwd);
    
    /*
    // user login view setting
    userLoginViewController *_userLoginViewController = [[userLoginViewController alloc] init];
    // set user login view controller name and pwd input field if has
    if(_loginName){
        _userLoginViewController.userNameInput.text = _loginName;
    }
    if(_loginPwd){
        _userLoginViewController.passwordInput.text = _loginPwd;
    }
    // set user login delegate
    _userLoginViewController.userLoginDelegate = self;
     */
    
    // user register and login view setting
    userAccountSettingViewController *_userLoginViewController = [[userAccountSettingViewController alloc] init];
    // set user register and login view controller name input field if has
    if(_loginName){
        _userLoginViewController.userNameInput.text = _loginName;
    }
    // set user register and login delegate
    _userLoginViewController.userRegLoginDelegate = self;
    
    // push user account setting to nav
    [self.navigationController pushViewController:_userLoginViewController animated:YES];
}

// mark in app store
-(void) markInAppStore{
    NSLog(@"markInAppStore - not implemetation now.");
    
    //
}

// user feedback
-(void) userFeedback{
    // user feedback
    feedbackViewController *_userFeedbackViewController = [[feedbackViewController alloc] init];
    
    // push user feedback to nav
    [self.navigationController pushViewController:_userFeedbackViewController animated:YES];
}

// about the product
-(void) productAbout{
    // about the product
    aboutViewController *_productAboutViewController = [[aboutViewController alloc] init];
    
    // push about the product to nav
    [self.navigationController pushViewController:_productAboutViewController animated:YES];
}

// self init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // overwrite title
        self.title = @"更多";
        
        // remove table view and stop view loading indocator animating
        [_mTableView removeFromSuperview];
        [_mViewLoadingIndicatorView stopAnimating];
        
        // init setting table view
        _mSettingTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        // set background color
        _mSettingTableView.backgroundColor = BACKGROUNDCOLOR;
        // set delegate and dataSource
        [_mSettingTableView setDelegate:self];
        [_mSettingTableView setDataSource:self];
        // add setting table view to view
        [self.view addSubview:_mSettingTableView];
        
        // set navigationItem rightBarButtonItem nil
        self.navigationItem.rightBarButtonItem = nil;
        
        // overwrite tabBar item
        _mTabBarItem.image = [UIImage imageNamed:@"moreTab.png"];
        _mTabBarItem.title = @"更多";
        _mTabBarItem.tag = 4;
        
        // set table
        _mTableDataSource = [NSMutableArray arrayWithObjects:@"给飞影打分", @"用户反馈", @"关于飞影", nil];
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
    UITableViewCell *_cell = [_mSettingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // update cell detail text lbbel text
    _cell.detailTextLabel.text = ([[[UserManager shareSingleton] userBean] name]) ? [[[UserManager shareSingleton] userBean] name] : @"未登录";
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

// overwrite method:(NSInteger)tableView: numberOfRowsInSection:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger _ret = 0;
    
    switch (section) {
        case 0:
            _ret = 1;
            break;
            
        case 1:
            _ret = [_mTableDataSource count];
            break;
    }
    
    return _ret;
}

// overwrite method:(NSInteger)numberOfSectionsInTableView:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// overwrite method:(NSString *)tableView: titleForHeaderInSection:
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *_ret = nil;
    
    switch (section) {
        case 0:
            _ret = @"个人帐号";
            break;
            
        case 1:
            _ret = @"软件信息";
            break;
    }
    
    return _ret;
}

// overwrite method:(UITableViewCell *)tableView: cellForRowAtIndexPath:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"moreTabViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data        
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test cell"];
        // set style
        _cell.selectionStyle = UITableViewCellSelectionStyleGray;
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch ([indexPath section]) {
        case 0:
            //_cell.imageView.image = [UIImage imageNamed:@"account.png"];
            _cell.imageView.image = [[UIImage imageNamed:@"account.png"] scale:0.6];
            _cell.detailTextLabel.textColor = [UIColor blackColor];
            _cell.detailTextLabel.text = ([[[UserManager shareSingleton] userBean] name]) ? [[[UserManager shareSingleton] userBean] name] : @"未登录";
            break;
            
        case 1:
            _cell.textLabel.text = [_mTableDataSource objectAtIndex:[indexPath row]];
            break;
    }
    
    return _cell;
}

// overwrite method:(NSIndexPath*) tableView: willSelectRowAtIndexPath:
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"moreTabViewController - section: %d row: %d selected.", [indexPath section], [indexPath row]);
    
    switch ([indexPath section]) {
        case 0:
            // account setting
            [self accountSetting];
            break;
            
        case 1:
            switch ([indexPath row]) {
                case 0:
                    // mark in app store
                    [self markInAppStore];
                    break;
                    
                case 1:
                    // user feedback
                    [self userFeedback];
                    break;
                    
                case 2:
                    // about the product
                    [self productAbout];
                    break;
            }
            break;
    }
    
    return indexPath;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}

// overwrite method:(void) userLoginSucceed
-(void) userLoginSucceed{
    NSLog(@"moreTabViewController - userLoginSucceed - self = %@", self);
    
    // pop up navigation controller
    [self.navigationController popViewControllerAnimated:YES];
    
    // update fav and share tab root view controller
    [self popupFavShareTabNavAndUpdateRoot];
}

@end
