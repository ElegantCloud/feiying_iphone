//
//  shareTableViewCell.m
//  feiying
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "shareTableViewCell.h"
#import "searchShareImgView.h"

@implementation shareTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with video image, title, share time, send to or receive from
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage andShareTime:(NSString *)pShareTime andSendTo:(NSString *)pSendTo andReceiveFrom:(NSString *)pReceiveFrom{
    self = [super init];
    if (self) {
        // Initialization code
        // set cell selected color, accessoryType and background image
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchShareVideoCellBGImg"]];
        
        // cell content setting
        searchShareImgView *_videoImage = [[searchShareImgView alloc] initWithFrame:CGRectMake(5.0, 5.0, 75.0, 56.25)];
        _videoImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoImage.tag = 1314;
        [_videoImage setSuitableImage:pImage];
        
        UILabel *_videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(2*_videoImage.frame.origin.x+_videoImage.frame.size.width+5.0, _videoImage.frame.origin.y, 300.0-90.0-_videoImage.frame.origin.x, 36.0)];
        _videoTitle.font = [UIFont boldSystemFontOfSize:13];
        _videoTitle.numberOfLines = 2;
        _videoTitle.text = pTitle;
        _videoTitle.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoShareTime = [[UILabel alloc] initWithFrame:CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y+_videoTitle.frame.size.height+2.0, _videoTitle.frame.size.width, 18.0)];
        _videoShareTime.font = [UIFont systemFontOfSize:12];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _videoShareTime.text = [NSString stringWithFormat:@"分享时间: %@", [dateFormatter stringFromDate:(NSDate*)[NSDate dateWithTimeIntervalSince1970:[pShareTime doubleValue]]]];
        _videoShareTime.textColor = [UIColor grayColor];
        _videoShareTime.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoSendTo = [[UILabel alloc] initWithFrame:CGRectMake(_videoShareTime.frame.origin.x, _videoShareTime.frame.origin.y+_videoShareTime.frame.size.height+2.0, _videoShareTime.frame.size.width, _videoShareTime.frame.size.height)];
        _videoSendTo.font = [UIFont systemFontOfSize:12];
        _videoSendTo.text = [NSString stringWithFormat:@"分享给: %@", pSendTo];
        _videoSendTo.textColor = [UIColor grayColor];
        _videoSendTo.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoReceiveFrom = [[UILabel alloc] initWithFrame:_videoSendTo.frame];
        _videoReceiveFrom.font = [UIFont systemFontOfSize:12];
        _videoReceiveFrom.text = [NSString stringWithFormat:@"来自: %@", pReceiveFrom];
        _videoReceiveFrom.textColor = [UIColor grayColor];
        _videoReceiveFrom.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_videoImage];
        [self.contentView addSubview:_videoTitle];
        [self.contentView addSubview:_videoShareTime];
        if(pSendTo){
            [self.contentView addSubview:_videoSendTo];
        }
        if(pReceiveFrom){
            [self.contentView addSubview:_videoReceiveFrom];
            
            // update frames
            _videoTitle.numberOfLines = 1;
            _videoTitle.frame = CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y-2.0, _videoTitle.frame.size.width, 18.0);
            
            _videoShareTime.frame = CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y+_videoTitle.frame.size.height+2.0, _videoTitle.frame.size.width, 18.0);
            
            _videoReceiveFrom.frame = CGRectMake(_videoShareTime.frame.origin.x, _videoShareTime.frame.origin.y+_videoShareTime.frame.size.height+2.0, _videoShareTime.frame.size.width, _videoShareTime.frame.size.height);
        }
        
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
