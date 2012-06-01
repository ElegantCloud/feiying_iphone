//
//  homeTabViewController.m
//  feiying
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "homeTabViewController.h"

#import "../customComponents/videoTableViewCell.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

@implementation homeTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // overwrite title
        self.title = @"首页";
        
        // overwrite tabBar item
        _mTabBarItem.image = [UIImage imageNamed:@"homeTab.png"];
        _mTabBarItem.title = @"首页";
        _mTabBarItem.tag = 2;
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
        // init table dataSource
        [self initTableDataSource:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant homePageUrl]]];
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
