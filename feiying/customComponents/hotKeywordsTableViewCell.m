//
//  hotKeywordsTableViewCell.m
//  feiying
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "hotKeywordsTableViewCell.h"

@implementation hotKeywordsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with keyword and count
-(id) initWithKeyword:(NSString*) pKeyword andCount:(NSString*) pCount{
    self = [super init];
    if (self) {
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // cell content setting
        UILabel *_keyword = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 5.0, (300.0-25.0)/2+45.0, 30.0)];
        // set text
        _keyword.font = [UIFont systemFontOfSize:16];
        _keyword.text = pKeyword;
        _keyword.backgroundColor = [UIColor clearColor];
        
        UILabel *_keywordCount = [[UILabel alloc] initWithFrame:CGRectMake(_keyword.frame.origin.x+_keyword.frame.size.width, _keyword.frame.origin.y, (300.0-25.0)/2-45.0, 30.0)];
        // set text
        _keywordCount.font = [UIFont systemFontOfSize:16];
        _keywordCount.text = pCount;
        _keywordCount.textColor = [UIColor grayColor];
        _keywordCount.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_keyword];
        [self.contentView addSubview:_keywordCount];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 40.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
