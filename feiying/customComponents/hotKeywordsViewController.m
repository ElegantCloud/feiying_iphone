//
//  hotKeywordsViewController.m
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "hotKeywordsViewController.h"
#import "videoSearchViewController.h"
#import "hotKeywordsTableViewCell.h"

#import "../constants/systemConstant.h"
#import "../constants/urlConstant.h"

@implementation hotKeywordsViewController

@synthesize parentVideoSearchViewController = _mParentVideoSearchViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // remove refreshHeaderView
        //[_mRefreshHeaderView removeFromSuperview];
        
        // set separatorStyle none
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        // update table view frame
        _mTableView.frame = CGRectMake(_mTableView.frame.origin.x, _mTableView.frame.origin.y, _mTableView.frame.size.width, _mTableView.frame.size.height+9.0);
        
        // init table data source
        [self initTableDataSource:[NSString stringWithFormat:@"%@%@", [systemConstant systemRootUrl], [urlConstant hotKeywordsUrl]]];
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

// overwrite UIScrollViewDelegate method:(void) scrollViewDidScroll:
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

// overwrite method:(UITableViewCell*) tableView: cellForRowAtIndexPath:
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"hotKeywordsViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        NSString *_cellKeyword = [(NSDictionary*)[_mTableDataSource objectAtIndex:[indexPath row]] objectForKey:@"keyword"];
        NSString *_cellKeywordCount = [NSString stringWithFormat:@"%@次", ((NSNumber*)[(NSDictionary*)[_mTableDataSource objectAtIndex:[indexPath row]] objectForKey:@"count"]).stringValue];
        //NSLog(@"cell %d - keyword: %@ and count: %@", [indexPath row],  _cellKeyword, _cellKeywordCount);
        
        _cell = [[hotKeywordsTableViewCell alloc] initWithKeyword:_cellKeyword andCount:_cellKeywordCount];
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // init section header view
    UIView *_sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 22.0)];
    
    UILabel *_headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sectionHeaderView.frame.origin.x+5.0, _sectionHeaderView.frame.origin.y+2.0, _sectionHeaderView.frame.size.width-4.0, 18.0)];
    _headerViewLabel.backgroundColor = [UIColor clearColor];
    // text
    _headerViewLabel.text = @"热门搜索词:";
    _headerViewLabel.textColor = [UIColor whiteColor];
    _headerViewLabel.font = [UIFont systemFontOfSize:13.0];
    // add to section herader view
    [_sectionHeaderView addSubview:_headerViewLabel];
    
    if (section == 0){
        [_sectionHeaderView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
    }
    
    return _sectionHeaderView;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: willSelectRowAtIndexPath:
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"row: %d selected. content: %@", [indexPath row], [_mTableDataSource objectAtIndex:[indexPath row]]);
    
    // get search keyword
    NSString *_keyword = [(NSDictionary*)[_mTableDataSource objectAtIndex:[indexPath row]] objectForKey:@"keyword"];
    NSLog(@"selected hot search keyword = %@", _keyword);
    
    // set search text and begin to search
    ((videoSearchViewController*)_mParentVideoSearchViewController).videoSearchToolbar.text = _keyword;
    [((videoSearchViewController*)_mParentVideoSearchViewController).videoSearchToolbar videoSearchAction];
    
    return indexPath;
}

// overwrite UITableViewDelegate methods:(NSIndexPath*) tableView: heightForRowAtIndexPath:
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [hotKeywordsTableViewCell getCellHeightWithContents:nil];
}

@end
