//
//  videoTableViewCell.m
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation videoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with video image, title, total time and size
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage andTotalTime:(NSString *)pTotalTime andSize:(NSString *)pSize{
    self = [super init];
    if (self) {
        // set cell selected color, accessoryType and background image
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoTableCellBGImg"]];
        
        // cell content setting
        UIView *_videoImageBGView = [[UIView alloc] initWithFrame:CGRectMake(3.0, 3.0, 84.0, 64.0)];
        _videoImageBGView.layer.cornerRadius = 2.0;
        _videoImageBGView.layer.masksToBounds = YES;
        
        UIImageView *_videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 80.0, 60.0)];
        _videoImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoImage.tag = 1314;
        _videoImage.image = pImage;
        _videoImage.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *_videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(2*_videoImage.frame.origin.x+_videoImage.frame.size.width+5.0, _videoImage.frame.origin.y+2.0, 300.0-95.0-_videoImage.frame.origin.x, 36.0)];
        _videoTitle.font = [UIFont boldSystemFontOfSize:13];
        _videoTitle.numberOfLines = 2;
        _videoTitle.text = pTitle;
        _videoTitle.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y+_videoTitle.frame.size.height+2.0, _videoTitle.frame.size.width/2, 18.0)];
        _videoTotalTime.font = [UIFont systemFontOfSize:12];
        _videoTotalTime.text = [NSString stringWithFormat:@"时长: %@", pTotalTime];
        _videoTotalTime.textColor = [UIColor grayColor];
        _videoTotalTime.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoSize = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x+_videoTotalTime.frame.size.width, _videoTotalTime.frame.origin.y, _videoTotalTime.frame.size.width, _videoTotalTime.frame.size.height)];
        _videoSize.font = [UIFont systemFontOfSize:12];
        _videoSize.text = [NSString stringWithFormat:@"大小: %@", pSize];
        _videoSize.textColor = [UIColor grayColor];
        _videoSize.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        //[self.contentView addSubview:_videoImageBGView];
        [self.contentView addSubview:_videoImage];
        [self.contentView addSubview:_videoTitle];
        [self.contentView addSubview:_videoTotalTime];
        [self.contentView addSubview:_videoSize];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 70.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
