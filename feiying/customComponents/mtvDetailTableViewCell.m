//
//  mtvDetailTableViewCell.m
//  feiying
//
//  Created by  on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mtvDetailTableViewCell.h"
#import "../customComponents/episodeListView.h"

#import "../util/NSString+util.h"

@implementation movieTVDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// init with movie/teleplay image, title, originLocate, releaseDate, director, actors, total time(movie), episode count(teleplay), play count, share count, fav count, description
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage andOriginLocate:(NSString *)pOriginLocate andReleaseDate:(NSString *)pReleaseDate andDirector:(NSString *)pDirector andActors:(NSString *)pActors andTotalTime:(NSString *)pTotalTime andEpisodeCountState:(NSString*) pEpisodeCountState andPlaycount:(NSString *)pPlaycount andSharecount:(NSString *)pSharecount andFavcount:(NSString *)pFavcount andDescription:(NSString *)pDescription andEpisodeList:(NSArray*) pEpisodeList andDeleteFavFlag:(BOOL) pDeleteFav andDeleteShareFlag:(BOOL)pDeleteShare andShareInfo:(NSDictionary*) pShareInfo{
    self = [super init];
    if (self) {
        // Initialization code
        // set cell selected color
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // define top padding size
        CGFloat _topPadding = (pDeleteShare) ? 6.0+46.0+5.0 : 6.0;
        CGFloat _episodeListHeight = 0.0;
        
        // set share info view and update top padding
        _topPadding +=[self setShareInfoView:pShareInfo andIsShared:pDeleteShare];
        
        // cell content setting
        UILabel *_videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, _topPadding, 320.0-2*10.0, 20.0)];
        _videoTitle.font = [UIFont boldSystemFontOfSize:16];
        _videoTitle.text = pTitle;
        _videoTitle.textAlignment = UITextAlignmentCenter;
        _videoTitle.backgroundColor = [UIColor clearColor];
        
        UIImageView *_videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y+_videoTitle.frame.size.height+6.0, 150.0, 200.0)];
        _videoImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoImage.tag = 1314;
        _videoImage.image = pImage;
        _videoImage.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *_videoTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(_videoImage.frame.origin.x+_videoImage.frame.size.width+10.0, _videoImage.frame.origin.y+1.0, 320.0-(_videoImage.frame.origin.x+_videoImage.frame.size.width+10.0)-10.0, 18.0)];
        _videoTotalTime.font = [UIFont systemFontOfSize:12];
        _videoTotalTime.text = [NSString stringWithFormat:@"时长: %@", pTotalTime];
        _videoTotalTime.textColor = [UIColor grayColor];
        _videoTotalTime.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoEpisodeCountState = [[UILabel alloc] initWithFrame:CGRectMake(_videoImage.frame.origin.x+_videoImage.frame.size.width+10.0, _videoImage.frame.origin.y+1.0, 320.0-(_videoImage.frame.origin.x+_videoImage.frame.size.width+10.0)-10.0, 18.0)];
        _videoEpisodeCountState.font = [UIFont systemFontOfSize:12];
        _videoEpisodeCountState.text = [NSString stringWithFormat:@"剧集: %@", pEpisodeCountState];
        _videoEpisodeCountState.textColor = [UIColor grayColor];
        _videoEpisodeCountState.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoDirector = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoTotalTime.frame.origin.y+_videoTotalTime.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoDirector.font = [UIFont systemFontOfSize:12];
        _videoDirector.text = [NSString stringWithFormat:@"导演: %@", pDirector];
        _videoDirector.textColor = [UIColor grayColor];
        //_videoDirector.numberOfLines = 2;
        _videoDirector.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoActors = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoDirector.frame.origin.y+_videoDirector.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoActors.font = [UIFont systemFontOfSize:12];
        _videoActors.text = [NSString stringWithFormat:@"主演: %@", pActors];
        _videoActors.textColor = [UIColor grayColor];
        //_videoActors.numberOfLines = 2;
        _videoActors.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoOriginLocate = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoActors.frame.origin.y+_videoActors.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoOriginLocate.font = [UIFont systemFontOfSize:12];
        _videoOriginLocate.text = [NSString stringWithFormat:@"地区: %@", pOriginLocate];
        _videoOriginLocate.textColor = [UIColor grayColor];
        _videoOriginLocate.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoReleaseDate = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoOriginLocate.frame.origin.y+_videoOriginLocate.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoReleaseDate.font = [UIFont systemFontOfSize:12];
        _videoReleaseDate.text = [NSString stringWithFormat:@"年份: %@", pReleaseDate];
        _videoReleaseDate.textColor = [UIColor grayColor];
        _videoReleaseDate.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoPlaycount = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoReleaseDate.frame.origin.y+_videoReleaseDate.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoPlaycount.font = [UIFont systemFontOfSize:12];
        _videoPlaycount.text = [NSString stringWithFormat:@"播放: %@", pPlaycount];
        _videoPlaycount.textColor = [UIColor grayColor];
        _videoPlaycount.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoSharecount = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoPlaycount.frame.origin.y+_videoPlaycount.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoSharecount.font = [UIFont systemFontOfSize:12];
        _videoSharecount.text = [NSString stringWithFormat:@"分享: %@", pSharecount];
        _videoSharecount.textColor = [UIColor grayColor];
        _videoSharecount.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoFavcount = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoSharecount.frame.origin.y+_videoSharecount.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoFavcount.font = [UIFont systemFontOfSize:12];
        _videoFavcount.text = [NSString stringWithFormat:@"收藏: %@", pFavcount];
        _videoFavcount.textColor = [UIColor grayColor];
        _videoFavcount.backgroundColor = [UIColor clearColor];
        
        // set and init video play and delete share button if needed
        customButton *_videoPlayButton = [[customButton alloc] init];
        // set frame
        _videoPlayButton.frame = CGRectMake((self.frame.size.width-60.0)/2, _videoImage.frame.origin.y+_videoImage.frame.size.height+16.0, 60.0, 30.0);
        // set title
        _videoPlayButton.labelText.text = @"播放";
        // add target
        [_videoPlayButton addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
        customButton *_videoDeleteShareButton = [[customButton alloc] init];
        _videoDeleteShareButton.frame = CGRectMake(_videoPlayButton.frame.origin.x+_videoPlayButton.frame.size.width+10.0, _videoPlayButton.frame.origin.y, 80.0, 30.0);
        _videoDeleteShareButton.labelText.text = @"删除分享";
        [_videoDeleteShareButton addTarget:self action:@selector(deleteShareVideoRecordAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *_videoDescriptionTip = [[UILabel alloc] initWithFrame:CGRectMake(_videoImage.frame.origin.x, _videoPlayButton.frame.origin.y+_videoPlayButton.frame.size.height+16.0, 100.0, 22.0)];
        _videoDescriptionTip.font = [UIFont boldSystemFontOfSize:16];
        _videoDescriptionTip.text = @"详情描述:";
        _videoDescriptionTip.backgroundColor = [UIColor clearColor];
        
        // get videoDescription content height
        NSInteger _descriptionRows = 0;
        for(NSString *_paragraph in [pDescription getStrParagraphArray]){
            _descriptionRows += ((NSInteger)[_paragraph getStrPixelLenByFontSize:14]%310==0) ? [_paragraph getStrPixelLenByFontSize:14]/(320.0-2*5.0) : [_paragraph getStrPixelLenByFontSize:14]/(320.0-2*5.0)+1; 
        }
        //NSLog(@"pDescription = %@ and rows= %d", pDescription, _descriptionRows);
        UITextView *_videoDescriptionContent = [[UITextView alloc] initWithFrame:CGRectMake(5.0, _videoDescriptionTip.frame.origin.y+_videoDescriptionTip.frame.size.height+5.0, 320.0-2*5.0, _descriptionRows*[pDescription getStrPixelHeightByFontSize:14])];
        _videoDescriptionContent.editable = NO;
        _videoDescriptionContent.scrollEnabled = NO;
        _videoDescriptionContent.text = pDescription;
        _videoDescriptionContent.font = [UIFont systemFontOfSize:13];
        _videoDescriptionContent.backgroundColor = [UIColor clearColor];
        
        // add table cell content to view
        [self.contentView addSubview:_videoTitle];
        [self.contentView addSubview:_videoImage];
        if(pTotalTime){
            [self.contentView addSubview:_videoTotalTime];
            
            // movie has play button
            [self.contentView addSubview:_videoPlayButton];
        }
        /*if(pEpisodeCountState)*/else{
            [self.contentView addSubview:_videoEpisodeCountState];

            // normal tv detail view, no video play button
            if(!pDeleteShare){
                // update video description tip and content
                _videoDescriptionTip.center = CGPointMake(_videoDescriptionTip.center.x, _videoDescriptionTip.center.y-30.0-16.0);
                _videoDescriptionContent.center = CGPointMake(_videoDescriptionContent.center.x, _videoDescriptionContent.center.y-30.0-16.0);
            }
            
            // set episode list
            // init episode list tip
            UILabel *_episodeListTip = [[UILabel alloc] initWithFrame:CGRectMake(_videoDescriptionTip.frame.origin.x, _videoDescriptionContent.frame.origin.y+_videoDescriptionContent.frame.size.height+16.0, 100.0, 22.0)];
            _episodeListTip.font = [UIFont boldSystemFontOfSize:16];
            _episodeListTip.text = @"剧集列表:";
            _episodeListTip.backgroundColor = [UIColor clearColor];
            
            [self.contentView addSubview:_episodeListTip];
            
            // init episode list view
            /*
            episodeListView *_episodeList = [[episodeListView alloc] initWithEpisodeList:pEpisodeList];
            _episodeList.frame = CGRectMake(10.0, _episodeListTip.frame.origin.y+_episodeListTip.frame.size.height+5.0, _episodeList.frame.size.width, _episodeList.frame.size.height);
             */
            
            // episodeListTableView
            episodeListTableView *_episodeList = [[episodeListTableView alloc] initWithEpisodeList:pEpisodeList];
            // set frame
            _episodeList.frame = CGRectMake(_episodeList.frame.origin.x, _episodeListTip.frame.origin.y+_episodeListTip.frame.size.height+5.0, _episodeList.frame.size.width, _episodeList.frame.size.height);
            // set background color
            _episodeList.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:0.6];
            // set episode list column
            _episodeList.episodeListColumn = 5;
            // set episodeListDelegate
            _episodeList.episodeListDelegate = self;
            // add to view
            [self.contentView addSubview:_episodeList];
            // set episode tip and list height
            _episodeListHeight = 16.0+_episodeListTip.frame.size.height+5.0+_episodeList.frame.size.height;
            
            // if series, delete share button resize, left move 60.0/2+10.0/2+10.0(padding)
            _videoDeleteShareButton.frame = CGRectMake(_videoDeleteShareButton.frame.origin.x-35.0-10.0, _videoDeleteShareButton.frame.origin.y, _videoDeleteShareButton.frame.size.width, _videoDeleteShareButton.frame.size.height);
        }
        [self.contentView addSubview:_videoDirector];
        [self.contentView addSubview:_videoActors];
        [self.contentView addSubview:_videoOriginLocate];
        [self.contentView addSubview:_videoReleaseDate];
        [self.contentView addSubview:_videoPlaycount];
        [self.contentView addSubview:_videoSharecount];
        [self.contentView addSubview:_videoFavcount];
        [self.contentView addSubview:_videoDescriptionTip];
        [self.contentView addSubview:_videoDescriptionContent];
        
        // left move 60.0/2+10.0/2 if delete shared video button is visible
        if(pDeleteShare){
            _videoPlayButton.frame = CGRectMake(_videoPlayButton.frame.origin.x-35.0, _videoPlayButton.frame.origin.y, _videoPlayButton.frame.size.width, _videoPlayButton.frame.size.height);
            _videoDeleteShareButton.frame = CGRectMake(_videoDeleteShareButton.frame.origin.x-35.0, _videoDeleteShareButton.frame.origin.y, _videoDeleteShareButton.frame.size.width, _videoDeleteShareButton.frame.size.height);
            
            // add _videoDeleteShareButton to view
            [self.contentView addSubview:_videoDeleteShareButton];
        }
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _videoDescriptionContent.frame.origin.y+_videoDescriptionContent.frame.size.height+_episodeListHeight+6.0);
        //NSLog(@"self frame height = %f", _videoDescriptionContent.frame.origin.y+_videoDescriptionContent.frame.size.height+_episodeListHeight+6.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// episodeListDelegate methods implemetation
-(void) beenTouched:(NSString *)pParam{
    // call delegate method to play the series episode
    [_videoIndicatorDelegate videoPlay:pParam];
}

// methods implemetation
// play the series episode action
-(void) playSeriesEpisodeAction:(NSString*) pEpisodeUrl{
    // call delegate method to play the series episode
    [_videoIndicatorDelegate videoPlay:pEpisodeUrl];
}

@end
