//
//  episodeListTableView.h
//  feiying
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class episodeGridCellView;

// episodeGridCell delegate
@protocol episodeGridCellDelegate <NSObject>

// touch inside
-(void) touchInside:(episodeGridCellView*) pEpisodeGridCellView;

@end

// episode grid cell view
@interface episodeGridCellView : UILabel{
    // episodeGridCell delegate
    id<episodeGridCellDelegate> _episodeGridCellDelegate;
    
    // episodeGridCellView in tableView row
    NSInteger _mRow;
}

@property (nonatomic, readwrite) NSInteger row;

// init with text and episodeGridCell delegate
-(id) initWithText:(NSString*) pText andEpisodeGridCellDelegate:(id<episodeGridCellDelegate>) pDelagate;

@end



// episodeList delegate
@protocol episodeListDelegate <NSObject>

// episode grid cell was touched with param
-(void) beenTouched:(NSString*) pParam;

@end

// episode list table view cell
@interface episodeListTableViewCell : UITableViewCell<episodeGridCellDelegate>{
    // episodeList table view message selector receiver
    id _mReceiver;
    // episodeList table view message selector
    SEL _mSelector;
    
    // parent table view
    UITableView *_mParentTableView;
    
    // episode grid cell view count
    NSInteger _mEpisodeListColumn;
    // episodeList contents array
    NSArray *_mEpisodeListContentsArray;
}

@property (nonatomic, retain) UITableView *parentTableView;

@property (nonatomic, readwrite) NSInteger episodeListColumn;
@property (nonatomic, retain) NSArray *episodeListContentsArray;

// init with episode grid cell view display string array, response method and sender
-(id) initWithGridCellTitle:(NSArray*) pTitlesArray andRespMeth:(SEL) pSelector andSender:(id) pSender;

@end

// episode list table view
@interface episodeListTableView : UITableView<UITableViewDataSource, UITableViewDelegate>{
    // episode list array
    NSArray *_mEpisodeListArray;
    
    // episode grid cell view count
    NSInteger _mEpisodeListColumn;
    
    // episode list delegate
    id<episodeListDelegate> _episodeListDelegate;
    
    // been selected episode grid cell index
    NSInteger _mBeenSelectedCellIndex;
}

@property (nonatomic, readwrite) NSInteger episodeListColumn;

@property (nonatomic, retain) id<episodeListDelegate> episodeListDelegate;

// init with episode list array
-(id) initWithEpisodeList:(NSArray*) pEpisodeList;

@end
