//
//  baseTableViewCell.m
//  feiying
//
//  Created by  on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "baseTableViewCell.h"

#import "channelTableViewCell.h"
#import "videoTableViewCell.h"
#import "mtvTableViewCell.h"

#import "shareTableViewCell.h"
#import "hotKeywordsTableViewCell.h"
#import "searchResultTableViewCell.h"

@implementation baseTableViewCell

// get tableViewCell height with contents
+(CGFloat) getCellHeightWithContents:(NSMutableDictionary *)pContents{
    CGFloat _ret = 0.0;
    //NSLog(@"this tableView cell class = %@", [self class]);
    
    // judge tableView cell class
    if ([self isSubclassOfClass:[videoTableViewCell class]]) {
        _ret = 70.0;
    }
    else if([self isSubclassOfClass:[channelTableViewCell class]]){
        _ret = 60.0;
    }
    else if([self isSubclassOfClass:[movieTVTableViewCell class]]){
        _ret = 110.0;
    }
    else if([self isSubclassOfClass:[shareTableViewCell class]]){
        _ret = 66.25;
    }
    else if([self isSubclassOfClass:[hotKeywordsTableViewCell class]]){
        _ret = 40.0;
    }
    else if([self isSubclassOfClass:[searchResultTableViewCell class]]){
        _ret = 66.25;
    }
    
    return _ret;
}

// self init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
