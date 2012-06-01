//
//  channelTableViewCell.m
//  feiying
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "channelTableViewCell.h"

@implementation channelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with channel item
-(id) initWithChannelTitle:(NSString *)pChannelTitle andImage:(UIImage *)pChannelImage{
    self = [super init];
    if(self){
        // set cell selected color, accessoryType and background image
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"norFavChannelCellBGImg"]];
        
        // cell content setting
        UIImageView *_channelImage = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, 10.0, 40.0, 40.0)];
        _channelImage.image = pChannelImage;
        
        UILabel *_channelTitle = [[UILabel alloc] initWithFrame:CGRectMake(2*30.0+40.0, 15.0, 300.0-100.0-60.0, 30.0)];
        _channelTitle.font = [UIFont systemFontOfSize:16];
        _channelTitle.text = pChannelTitle;
        _channelTitle.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_channelImage];
        [self.contentView addSubview:_channelTitle];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 60.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
