//
//  episodeListTableView.m
//  feiying
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "episodeListTableView.h"

#import "../util/NSString+util.h"
#import "../common/UserManager.h"
#import "../constants/urlConstant.h"

#include <objc/message.h>
#import <QuartzCore/QuartzCore.h>

// episode grid cell view implemetation
@implementation episodeGridCellView

@synthesize row = _mRow;

// overwrite method:(id) init
-(id) init{
    self = [super init];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor clearColor];
        // set user interaction enabled
        self.userInteractionEnabled = YES;
    }
    return  self;
}

// overwrite method:(id) initWithFrame:
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = [UIColor clearColor];
        // set user interaction enabled
        self.userInteractionEnabled = YES;
    }
    return  self;
}

// init with text and episodeGridCell delegate
-(id) initWithText:(NSString*) pText andEpisodeGridCellDelegate:(id<episodeGridCellDelegate>)pDelagate{
    self = [self init];
    if(self){
        // Initialization code
        // set episodeGridCell delegate
        _episodeGridCellDelegate = pDelagate;
        
        // set text
        self.text = pText;
    }
    return self;
}

// overwrite method:(void) setText:
-(void) setText:(NSString *)text{
    // set text
    super.text = text;
    
    // set text alignment and font
    self.textAlignment = UITextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:16.0];
    
    // update grid cell view frame
    self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.frame.size.width, 2*6.0+[text getStrPixelHeightByFontSize:16.0]);
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesBegan, touches = %@ and event = %@", touches, event);
    
    // call episodeGridCell delegate method
    if(_episodeGridCellDelegate){
        [_episodeGridCellDelegate touchInside:self];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesEnded, touches = %@ and event = %@", touches, event);
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesCancelled, touches = %@ and event = %@", touches, event);
}

@end



// episode list table view cell implemetation
@implementation episodeListTableViewCell

@synthesize parentTableView = _mParentTableView;

@synthesize episodeListColumn = _mEpisodeListColumn;
@synthesize episodeListContentsArray = _mEpisodeListContentsArray;

// init with episode grid cell view display string array, response method and sender
-(id) initWithGridCellTitle:(NSArray *)pTitlesArray andRespMeth:(SEL)pSelector andSender:(id)pSender{
    self = [super init];
    if(self){
        // Initialization code
        // save message receiver
        _mReceiver = pSender;
        // sace message selector
        _mSelector = pSelector;
        
        // create init episode grid cell view and add to content view
        for (int _index = 0; _index < [pTitlesArray count]; _index++) {
            episodeGridCellView *_episodeGridCellView = [[episodeGridCellView alloc] initWithText:[pTitlesArray objectAtIndex:_index] andEpisodeGridCellDelegate:self];
            
            // set subViews tag
            _episodeGridCellView.tag = _index;
            
            // add to content view
            [self.contentView addSubview:_episodeGridCellView];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// overwrite method:(void) setEpisodeListColumn:
-(void) setEpisodeListColumn:(NSInteger)episodeListColumn{
    // set episodeList column 
    _mEpisodeListColumn = episodeListColumn;
    
    // update each subView frame
    CGFloat _horizontalMergin = 3.0;
    CGFloat _verticalMergin = 2.0;
    CGFloat _horizontalPadding = 2.0;
    CGFloat _width = (self.frame.size.width-10.0-2*_horizontalMergin-(_mEpisodeListColumn-1)*_horizontalPadding)/_mEpisodeListColumn;
    
    for (episodeGridCellView *_view in self.contentView.subviews) {
        _view.frame = CGRectMake(_verticalMergin+_view.tag*(_width+_horizontalPadding), _verticalMergin, _width, _view.frame.size.height);
    }
}

// overwrite method:(void) setTag:
-(void) setTag:(NSInteger)tag{
    // set episodeGridCellView row
    for (episodeGridCellView *_view in self.contentView.subviews) {
        _view.row = tag;
    }
}

// episodeGridCellDelegate methods implemetation
-(void) touchInside:(episodeGridCellView *)pEpisodeGridCellView{
    //NSLog(@"episodeListTableViewCell - touchInside - pEpisodeGridCellView = %@", pEpisodeGridCellView);
    
    // get param: series episode url
    NSDictionary *_episodeInfoDic = [_mEpisodeListContentsArray objectAtIndex:((pEpisodeGridCellView.text.integerValue)%_mEpisodeListColumn == 0) ? _mEpisodeListColumn-1 : (pEpisodeGridCellView.text.integerValue)%_mEpisodeListColumn-1];
    // set default episodeUrl
    NSMutableString *_episodeUrl = [NSMutableString stringWithFormat:@"%@/%@_%d.mp4", [urlConstant videoUrl], [_episodeInfoDic objectForKey:@"source_id"], ((NSNumber*)[_episodeInfoDic objectForKey:@"episode_index"]).intValue];
    // append linked episodeUrl, seperate by "||"
    [_episodeUrl appendString:@"||"];
    [_episodeUrl appendString:[_episodeInfoDic objectForKey:@"video_url"]];
    /*
    if([[[UserManager shareSingleton] userBean] businessState] == unopened){
        _episodeUrl = [_episodeInfoDic objectForKey:@"video_url"];
    }
    */
    //NSLog(@"episode info =%@ and url = %@", _episodeInfoDic, _episodeUrl);
    
    // call table view method:(void) setBeenSelectedCellsBgColorAndLayer:
    [_mParentTableView performSelector:@selector(setBeenSelectedCellsBgColorAndLayer:) withObject:pEpisodeGridCellView];
    
    // send message
    objc_msgSend(_mReceiver, _mSelector, _episodeUrl);
}

@end

// episode list table view
@implementation episodeListTableView

@synthesize episodeListColumn = _mEpisodeListColumn;

@synthesize episodeListDelegate = _episodeListDelegate;

// private methods
// set been selected cell bgColor and layer
-(void) setBeenSelectedCellsBgColorAndLayer:(episodeGridCellView*) pCell{
    //NSLog(@"beenSelectedCellIndex - index = %d", _mBeenSelectedCellIndex);
    
    if(_mBeenSelectedCellIndex != 0){
        // get last been selected cell row and column
        NSUInteger _row = (_mBeenSelectedCellIndex%_mEpisodeListColumn == 0) ? _mBeenSelectedCellIndex/_mEpisodeListColumn : _mBeenSelectedCellIndex/_mEpisodeListColumn+1;
        NSUInteger _column = (_mBeenSelectedCellIndex%_mEpisodeListColumn == 0) ? _mEpisodeListColumn : _mBeenSelectedCellIndex%_mEpisodeListColumn;
        
        // get last been selected cell
        episodeListTableViewCell *_lastBeenSelectedTableCell = (episodeListTableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_row-1 inSection:0]];
        episodeGridCellView *_lastBeenSelectedGridCell = [_lastBeenSelectedTableCell.contentView.subviews objectAtIndex:_column-1];
        
        //NSLog(@"lastBeenSelectedCell - row = %d, column = %d and cell = %@", _row, _column, _lastBeenSelectedGridCell);
        
        // recover last been selected cell backgroundColor
        _lastBeenSelectedGridCell.backgroundColor = [UIColor clearColor];
        
        // recover last been selected cell layer
        _lastBeenSelectedGridCell.layer.cornerRadius = 1.0;
        _lastBeenSelectedGridCell.layer.masksToBounds = NO;
    }
    
    // update been selected cell index
    _mBeenSelectedCellIndex = pCell.row*_mEpisodeListColumn+pCell.tag+1;
    
    // set been selected cell backgroundColor
    pCell.backgroundColor = [UIColor darkGrayColor];
    
    // set been selected cell layer
    pCell.layer.cornerRadius = pCell.frame.size.height/3;
    pCell.layer.masksToBounds = YES;
}

// init with episode list array
-(id) initWithEpisodeList:(NSArray*) pEpisodeList{
    self = [super init];
    if(self){
        // Initialization code
        // set episode list
        _mEpisodeListArray = (pEpisodeList) ? pEpisodeList : [[NSArray alloc] init];
        
        // set dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // set separator style
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // set frame
        NSInteger _episodeListRows = ([pEpisodeList count]%5 == 0) ? [pEpisodeList count]/5 : [pEpisodeList count]/5+1;
        self.frame = CGRectMake(self.bounds.origin.x+5.0, self.bounds.origin.y, 320.0-2*5.0, _episodeListRows*(33.0+4.0));
    }
    return  self;
}

// UITableViewDataSource methods implemetation
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger _ret = 0;
    
    // judge section
    if(section == 0){
        _ret = ([_mEpisodeListArray count]%_mEpisodeListColumn == 0) ? [_mEpisodeListArray count]/_mEpisodeListColumn : [_mEpisodeListArray count]/_mEpisodeListColumn+1;
    }
    
    return _ret;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // table cell
    episodeListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"test cell"];
    
    if(_cell == nil){
        //NSLog(@"episodeListTableView - cellForRowAtIndexPath - indexPath = %@", indexPath);
        
        // cell data
        NSMutableArray *_titleArray = [[NSMutableArray alloc] initWithCapacity:_mEpisodeListColumn];
        for (int _index = indexPath.row*_mEpisodeListColumn; _index < (indexPath.row+1)*_mEpisodeListColumn; _index++) {
            // judge episodeList array bounds
            if (_index < [_mEpisodeListArray count]) {
                [_titleArray addObject:(_index < 9) ? [NSString stringWithFormat:@"0%d", _index+1] : [NSString stringWithFormat:@"%d", _index+1]];
            }
        }
        
        _cell = [[episodeListTableViewCell alloc] initWithGridCellTitle:_titleArray andRespMeth:@selector(beenTouched:) andSender:_episodeListDelegate];
    }

    // Configure the cell...
    // set parent table view
    _cell.parentTableView = self;
    // set episodeListTableViewCell column
    _cell.episodeListColumn = _mEpisodeListColumn;
    // set episodeListTableViewCell content array
    _cell.episodeListContentsArray = [_mEpisodeListArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row*_mEpisodeListColumn, ((indexPath.row+1)*_mEpisodeListColumn < [_mEpisodeListArray count]) ? _mEpisodeListColumn : [_mEpisodeListArray count]-indexPath.row*_mEpisodeListColumn)]];
    // set tag
    _cell.tag = indexPath.row;
    
    // to reappear last been selected grid cell
    for (int _index = 0; _index < [_cell.episodeListContentsArray count]; _index++) {
        if(_mBeenSelectedCellIndex == indexPath.row*_mEpisodeListColumn+_index+1){
            // get grid cell view
            episodeGridCellView *_gridCellView = [_cell.contentView.subviews objectAtIndex:_index];
            
            // set cell backgroundColor
            _gridCellView.backgroundColor = [UIColor darkGrayColor];
            
            // set cell layer
            _gridCellView.layer.cornerRadius = _gridCellView.frame.size.height/3;
            _gridCellView.layer.masksToBounds = YES;
        }
    }
    
    return _cell;
}

// UITableViewDelegate methods implemetation
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33.0+2*2.0;
}

@end
