//
//  searchResultTableViewCell.m
//  feiying
//
//  Created by  on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "searchResultTableViewCell.h"

@implementation searchResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
// init with video image and title
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage{
    self = [super init];
    if (self) {
        // Initialization code
        // set cell selected color, accessoryType and background image
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchShareVideoCellBGImg"]];
        
        // cell content setting
        UIImageView *_videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 75.0, 56.25)];
        _videoImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoImage.tag = 1314;
        _videoImage.image = pImage;
        _videoImage.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *_videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(2*_videoImage.frame.origin.x+_videoImage.frame.size.width+5.0, _videoImage.frame.origin.y+_videoImage.frame.size.height/2-36.0/2, 300.0-90.0-_videoImage.frame.origin.x, 36.0)];
        _videoTitle.font = [UIFont boldSystemFontOfSize:13];
        _videoTitle.numberOfLines = 2;
        _videoTitle.text = pTitle;
        _videoTitle.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_videoImage];
        [self.contentView addSubview:_videoTitle];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, /*88.0*/66.25);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
