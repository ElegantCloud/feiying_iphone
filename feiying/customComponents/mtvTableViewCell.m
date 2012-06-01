//
//  mtvTableViewCell.m
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mtvTableViewCell.h"

@implementation movieTVTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with movie/teleplay image, title, total time(movie), episode count(teleplay), actors, origin locate and release date
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage andTotalTime:(NSString *)pTotalTime andEpisodeCountState:(NSString*) pEpisodeCountState andActors:(NSString *)pActors andOriginLocate:(NSString *)pOriginLocate andReleaseDate:(NSString*)pReleasedate{
    self = [super init];
    if (self) {
        // set cell selected color, accessoryType and background image
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mtvTableCellBGImg"]];
        
        // cell content setting
        UIImageView *_movieTVImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 75.0, 100.0)];
        _movieTVImage.contentMode = UIViewContentModeScaleAspectFit;
        _movieTVImage.tag = 1314;
        _movieTVImage.image = pImage;
        _movieTVImage.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *_movieTVTitle = [[UILabel alloc] initWithFrame:CGRectMake(2*_movieTVImage.frame.origin.x+_movieTVImage.frame.size.width+5.0, _movieTVImage.frame.origin.y, 300.0-90.0-_movieTVImage.frame.origin.x, 20.0)];
        _movieTVTitle.font = [UIFont boldSystemFontOfSize:13];
        _movieTVTitle.text = pTitle;
        _movieTVTitle.backgroundColor = [UIColor clearColor];
        
        UILabel *_movieTVTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(_movieTVTitle.frame.origin.x, _movieTVTitle.frame.origin.y+_movieTVTitle.frame.size.height+2.0, _movieTVTitle.frame.size.width, 18.0)];
        _movieTVTotalTime.font = [UIFont systemFontOfSize:12];
        _movieTVTotalTime.text = [NSString stringWithFormat:@"时长: %@", pTotalTime];
        _movieTVTotalTime.textColor = [UIColor grayColor];
        _movieTVTotalTime.backgroundColor = [UIColor clearColor];
        
        UILabel *_movieTVEpisodeCountState = [[UILabel alloc] initWithFrame:_movieTVTotalTime.frame];
        _movieTVEpisodeCountState.font = [UIFont systemFontOfSize:12];
        _movieTVEpisodeCountState.text = [NSString stringWithFormat:@"剧集: %@", pEpisodeCountState];
        _movieTVEpisodeCountState.textColor = [UIColor grayColor];
        _movieTVEpisodeCountState.backgroundColor = [UIColor clearColor];
        
        UILabel *_movieTVActors = [[UILabel alloc] initWithFrame:CGRectMake(_movieTVTotalTime.frame.origin.x, _movieTVTotalTime.frame.origin.y+_movieTVTotalTime.frame.size.height+2.0, _movieTVTotalTime.frame.size.width, _movieTVTotalTime.frame.size.height)];
        _movieTVActors.font = [UIFont systemFontOfSize:12];
        _movieTVActors.text = [NSString stringWithFormat:@"主演: %@", pActors];
        _movieTVActors.textColor = [UIColor grayColor];
        _movieTVActors.backgroundColor = [UIColor clearColor];
        
        UILabel *_movieTVOriginLocate = [[UILabel alloc] initWithFrame:CGRectMake(_movieTVActors.frame.origin.x, _movieTVActors.frame.origin.y+_movieTVActors.frame.size.height+2.0, _movieTVActors.frame.size.width, _movieTVActors.frame.size.height)];
        _movieTVOriginLocate.font = [UIFont systemFontOfSize:12];
        _movieTVOriginLocate.text = [NSString stringWithFormat:@"地区: %@", pOriginLocate];
        _movieTVOriginLocate.textColor = [UIColor grayColor];
        _movieTVOriginLocate.backgroundColor = [UIColor clearColor];
        
        UILabel *_movieTVReleaseDate = [[UILabel alloc] initWithFrame:CGRectMake(_movieTVOriginLocate.frame.origin.x, _movieTVOriginLocate.frame.origin.y+_movieTVOriginLocate.frame.size.height+2.0, _movieTVOriginLocate.frame.size.width, _movieTVOriginLocate.frame.size.height)];
        _movieTVReleaseDate.font = [UIFont systemFontOfSize:12];
        _movieTVReleaseDate.text = [NSString stringWithFormat:@"年份: %@", pReleasedate];
        _movieTVReleaseDate.textColor = [UIColor grayColor];
        _movieTVReleaseDate.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_movieTVImage];
        [self.contentView addSubview:_movieTVTitle];
        if(pTotalTime){
            [self.contentView addSubview:_movieTVTotalTime];
        }
        /*if(pEpisodeCountState)*/else{
            [self.contentView addSubview:_movieTVEpisodeCountState];
        }
        [self.contentView addSubview:_movieTVActors];
        [self.contentView addSubview:_movieTVOriginLocate];
        [self.contentView addSubview:_movieTVReleaseDate];
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 110.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
