//
//  aboutViewController.m
//  feiying
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "aboutViewController.h"

#import "../util/NSString+util.h"
#import "../constants/systemConstant.h"

@implementation aboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // set title
        self.title = @"关于";
        
        // hide tabBar when pushed
        self.hidesBottomBarWhenPushed = YES;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20.0, self.view.frame.size.width, self.view.frame.size.height+49.0);
        
        // init about string and get about section number of rows
        _mAboutSectionString = @"       飞影For iPhone客户端是安徽联通为其iphone手机用户精心打造的免费网络视频播放软件,该软件将目前互联网上最新最热的视频聚合在一个统一界面中,避免用户反复访问不同视频网站带来的繁琐.该软件通过细致贴心的界面设计、聚合了丰富多彩的视频节目、高清流畅的播放服务, 为安徽联通的iPHONE用户带来不一样的在线视频观看体验!";
        for(NSString *_paragraph in [_mAboutSectionString getStrParagraphArray]){
            _mAboutSectionRows += ((NSInteger)[_paragraph getStrPixelLenByFontSize:15]%260==0) ? [_paragraph getStrPixelLenByFontSize:15]/260.0 : [_paragraph getStrPixelLenByFontSize:15]/260.0+1;
        }
        
        // group style table view about info
        UITableView *_aboutInfo = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        // set background color
        _aboutInfo.backgroundColor = BACKGROUNDCOLOR;
        // set dataSource and delegate
        [_aboutInfo setDataSource:self];
        [_aboutInfo setDelegate:self];
        // add about info to view
        [self.view addSubview:_aboutInfo];
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

// UITableViewDataSource methods implemetation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *_ret = nil;
    
    switch (section) {
        case 0:
            _ret = @"版本信息";
            break;
            
        case 1:
            _ret = @"关于飞影";
            break;
    }
    
    return _ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"aboutViewController - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data        
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test cell"];
        // set style
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch ([indexPath section]) {
        case 0:
            _cell = [[versionSectionTableViewCell alloc] initWithLogoImg:[UIImage imageNamed:@"logo.png"] andVersionInfo:@"飞影  1.0.0(iphone)" andCopyright:@"安徽联通 版权所有"];
            break;
            
        case 1:
            _cell.textLabel.numberOfLines = _mAboutSectionRows;
            _cell.textLabel.text = _mAboutSectionString;
            _cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            break;
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // define return value
    CGFloat _ret = 0;
    
    switch ([indexPath section]) {
        case 0:
            /*
            tableView.delegate = nil;
            _ret = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
            tableView.delegate = self;
             */
            
            _ret = [versionSectionTableViewCell getCellHeightWithContents:[NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"logo.png"], @"logoimg", nil]];
            break;
            
        case 1:
            _ret = _mAboutSectionRows*[_mAboutSectionString getStrPixelHeightByFontSize:15]+2*5.0;
            break;
    }
    
    return _ret;
}

@end

///////////////////////////////////////////
@implementation versionSectionTableViewCell

// init with logoImg, version info and copyright
-(id) initWithLogoImg:(UIImage*) pLogoImg andVersionInfo:(NSString*) pVersionInfo andCopyright:(NSString*) pCopyright{
    self = [super init];
    if (self) {
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // cell content setting
        UIImageView *_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-20.0-50.0)/2, 5.0, 50.0, 40.0)];
        _logoImage.image = pLogoImg;
        
        UILabel *_versionInfo = [[UILabel alloc] initWithFrame:CGRectMake(5.0, _logoImage.frame.origin.y+_logoImage.frame.size.height+2.0, self.frame.size.width-20.0-2*5.0, 30.0)];
        // set text
        _versionInfo.font = [UIFont systemFontOfSize:15];
        _versionInfo.text = pVersionInfo;
        _versionInfo.textAlignment = UITextAlignmentCenter;
        _versionInfo.backgroundColor = [UIColor clearColor];
        
        UILabel *_copyright = [[UILabel alloc] initWithFrame:CGRectMake(_versionInfo.frame.origin.x, _versionInfo.frame.origin.y+_versionInfo.frame.size.height+2.0, _versionInfo.frame.size.width, 30.0)];
        // set text
        _copyright.font = [UIFont systemFontOfSize:15];
        _copyright.text = pCopyright;
        _copyright.textAlignment = UITextAlignmentCenter;
        _copyright.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_logoImage];
        [self.contentView addSubview:_versionInfo];
        [self.contentView addSubview:_copyright];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 2*5.0+2*2.0+_logoImage.frame.size.height+_versionInfo.frame.size.height+_copyright.frame.size.height);
        //NSLog(@"self frame height = %f", 2*5.0+2*2.0+_logoImage.frame.size.height+_versionInfo.frame.size.height+_copyright.frame.size.height);
    }
    return self;
}

// overwrite method:(CGFloat) getCellHeightWithContents:
+(CGFloat) getCellHeightWithContents:(NSMutableDictionary *)pContents{
    //NSLog(@"versionSectionTableViewCell - getCellHeightWithContents - contents = %@", pContents);
    
    // set default return height
    CGFloat _ret = /*top mergin*/5.0+/*versionInfo height*/30.0+/*padding*/2.0+/*copyright height*/30.0+/*bottom mergin*/5.0;
    
    // get logo image
    UIImage *_logoImg = [pContents objectForKey:@"logoimg"];
    _ret += /*padding*/2.0+_logoImg.size.height;
    
    //NSLog(@"versionSectionTableViewCell - getCellHeightWithContents - height = %f", _ret);
    return _ret;
}

@end
