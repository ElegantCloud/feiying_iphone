//
//  videoDetailTableViewCell.m
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "videoDetailTableViewCell.h"

#import "../constants/systemConstant.h"
#import "../util/NSString+util.h"

#import "AppDelegate.h"

@implementation videoDetailTableViewCell

@synthesize videoIndicatorDelegate = _videoIndicatorDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = BACKGROUNDCOLOR;
    }
    return self;
}

// init with video image, title, total time, size, play count, share count, fav count, category, source id and video url
-(id) initWithTitle:(NSString *)pTitle andImage:(UIImage *)pImage andTotalTime:(NSString *)pTotalTime andSize:(NSString*) pSize andPlaycount:(NSString *)pPlaycount andSharecount:(NSString *)pSharecount andFavcount:(NSString *)pFavcount andDeleteFavFlag:(BOOL) pDeleteFav andDeleteShareFlag:(BOOL)pDeleteShare andShareInfo:(NSDictionary*) pShareInfo{
    self = [super init];
    if (self) {
        // Initialization code        
        // set cell selected color
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // define top padding size
        CGFloat _topPadding = (pDeleteShare) ? 5.0+45.0+5.0 : 5.0;
        
        // set share info view and update top padding
        _topPadding +=[self setShareInfoView:pShareInfo andIsShared:pDeleteShare];
        
        // cell content setting
        UILabel *_videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, _topPadding, 320.0-2*15.0, 40.0)];
        _videoTitle.font = [UIFont boldSystemFontOfSize:14];
        _videoTitle.numberOfLines = 2;
        _videoTitle.text = pTitle;
        _videoTitle.backgroundColor = [UIColor clearColor];
        
        UIImageView *_videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_videoTitle.frame.origin.x, _videoTitle.frame.origin.y+_videoTitle.frame.size.height+5.0, 134.0, 100.0)];
        _videoImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoImage.tag = 1314;
        _videoImage.image = pImage;
        _videoImage.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *_videoTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(_videoImage.frame.origin.x+_videoImage.frame.size.width+15.0, _videoImage.frame.origin.y+1.0, 320.0-(_videoImage.frame.origin.x+_videoImage.frame.size.width+15.0)-15.0, 18.0)];
        _videoTotalTime.font = [UIFont systemFontOfSize:12];
        _videoTotalTime.text = [NSString stringWithFormat:@"时长: %@", pTotalTime];
        _videoTotalTime.textColor = [UIColor grayColor];
        _videoTotalTime.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoSize = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoTotalTime.frame.origin.y+_videoTotalTime.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
        _videoSize.font = [UIFont systemFontOfSize:12];
        _videoSize.text = [NSString stringWithFormat:@"大小: %@", pSize];
        _videoSize.textColor = [UIColor grayColor];
        _videoSize.backgroundColor = [UIColor clearColor];
        
        UILabel *_videoPlaycount = [[UILabel alloc] initWithFrame:CGRectMake(_videoTotalTime.frame.origin.x, _videoSize.frame.origin.y+_videoSize.frame.size.height+2.0, _videoTotalTime.frame.size.width, 18.0)];
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
        _videoPlayButton.frame = CGRectMake((320.0-60.0)/2, _videoFavcount.frame.origin.y+_videoFavcount.frame.size.height+1.0+30.0, 60.0, 30.0);
        // set title
        _videoPlayButton.labelText.text = @"播放";
        // add target
        [_videoPlayButton addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
        customButton *_videoDeleteShareButton = [[customButton alloc] init];
        // set frame
        _videoDeleteShareButton.frame = CGRectMake(_videoPlayButton.frame.origin.x+_videoPlayButton.frame.size.width+10.0, _videoPlayButton.frame.origin.y, 80.0, 30.0);
        // set title
        _videoDeleteShareButton.labelText.text = @"删除分享";
        // add target
        [_videoDeleteShareButton addTarget:self action:@selector(deleteShareVideoRecordAction) forControlEvents:UIControlEventTouchUpInside];
        
        // add table cell content to view
        [self.contentView addSubview:_videoTitle];
        [self.contentView addSubview:_videoImage];
        [self.contentView addSubview:_videoTotalTime];
        [self.contentView addSubview:_videoSize];
        [self.contentView addSubview:_videoPlaycount];
        [self.contentView addSubview:_videoSharecount];
        [self.contentView addSubview:_videoFavcount];
        
        [self.contentView addSubview:_videoPlayButton];
        
        // left move 60.0/2+10.0/2 if delete shared video button is visible
        if(pDeleteShare){
            _videoPlayButton.frame = CGRectMake(_videoPlayButton.frame.origin.x-35.0, _videoPlayButton.frame.origin.y, _videoPlayButton.frame.size.width, _videoPlayButton.frame.size.height);
            _videoDeleteShareButton.frame = CGRectMake(_videoDeleteShareButton.frame.origin.x-35.0, _videoDeleteShareButton.frame.origin.y, _videoDeleteShareButton.frame.size.width, _videoDeleteShareButton.frame.size.height);
            
            // add _videoDeleteShareButton to view
            [self.contentView addSubview:_videoDeleteShareButton];
        }
        
        // set frame size height
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _videoPlayButton.frame.origin.y+_videoPlayButton.frame.size.height+30.0);
        //NSLog(@"self frame height = %f", _videoPlayButton.frame.origin.y+_videoPlayButton.frame.size.height+30.0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// overwrite method:(CGFloat) getCellHeightWithContents:
+(CGFloat) getCellHeightWithContents:(NSMutableDictionary *)pContents{
    //NSLog(@"videoDetailTableViewCell - getCellHeightWithContents - contents = %@", pContents);
    
    // set default return height
    CGFloat _ret = 0.0;
    
    // get video description, episodeList and shareInfo
    NSDictionary *_shareInfo = [pContents objectForKey:@"sharedInfo"];
    if(_shareInfo){
        // remove shareInfo
        [pContents removeObjectForKey:@"sharedInfo"];
        
        // top mergin with shareInfo
        _ret += 5.0+45.0+5.0;
        
        // share info string
        NSString *_shareInfoString = nil;
        if(((NSNumber*)[_shareInfo objectForKey:@"shareType"]).intValue == Received){
            _shareInfoString = [NSString stringWithFormat:@"来自: %@", [((NSString*)[_shareInfo objectForKey:@"sharePersons"]).description getVideoSharedPersonsInAddressBook]];
        }
        else if(((NSNumber*)[_shareInfo objectForKey:@"shareType"]).intValue == Sended){
            _shareInfoString = [NSString stringWithFormat:@"分享给: %@", [((NSString*)[_shareInfo objectForKey:@"sharePersons"]).description getVideoSharedPersonsInAddressBook]];
        }
        // get share info string row height and update height
        if([_shareInfoString getStrPixelLenByFontSize:12]>/*shareInfo frame width*/320.0-2*10.0){
            _ret += 18.0;
        }
    }
    else{
        // top mergin without shareInfo
        _ret +=5.0;
    }
    
    if ([pContents count] == 0) {
        // small video
        _ret += /*title*/40.0+/*padding*/5.0+/*image*/100.0+/*padding*/30.0+/*playButton*/30.0+/*bottom mergin*/30.0;
    }
    else{
        // movie or series
        // update top mergin
        _ret += (_shareInfo) ? 2.0 : 1.0;
        
        _ret += /*title*/20.0+/*padding*/6.0+/*image*/200.0+/*padding*/16.0+/*playButton*/30.0+/*bottom mergin*/6.0;
        
        // description
        NSString *_description = [pContents objectForKey:@"description"];
        if(_description){
            // description tip
            _ret += /*padding*/16.0+22.0;
            // description content
            NSInteger _descriptionRows = 0;
            for(NSString *_paragraph in [_description getStrParagraphArray]){
                _descriptionRows += ((NSInteger)[_paragraph getStrPixelLenByFontSize:14]%310==0) ? [_paragraph getStrPixelLenByFontSize:14]/(320.0-2*5.0) : [_paragraph getStrPixelLenByFontSize:14]/(320.0-2*5.0)+1; 
            }
            _ret += /*padding between tip and content*/5.0+_descriptionRows*[_description getStrPixelHeightByFontSize:14];
        }
        
        // episode list
        NSArray *_episodeList = [pContents objectForKey:@"episodeList"];
        if(_episodeList){
            if(!_shareInfo){
                _ret -=/*padding*/16.0+/*playButton*/30.0;
            }
            
            // episode list tip
            _ret += /*padding*/16.0+22.0;
            NSInteger _episodeListRows = ([_episodeList count]%5==0) ? [_episodeList count]/5 : [_episodeList count]/5+1;
            // episode list content
            //_ret += /*padding between tip and content*/5.0+2*/*episodeList mergin*/2.0+(/*episodeList row height*/30.0+/*episodeList row padding*/3.0)*(_episodeListRows-1);
            //_ret += /*????????*/30.0;
            
            // episodeListTableView
            _ret += /*padding between tip and content*/5.0+(/*episodeList row height*/33.0+/*episodeList row padding*/4.0)*_episodeListRows;
        }
    }
    
    // cell sizefit
    if(_ret < TABLEHEIGHT){
        _ret = TABLEHEIGHT;
    }
    
    // get image
    //UIImage *_img = [gImageCacheDic objectForKey:[NSURL URLWithString:[pContents objectForKey:@"image_url"]]];
    
    //NSLog(@"videoDetailTableViewCell - getCellHeightWithContents - height = %f", _ret);
    
    return _ret;
}

// methods implemetation
// play the video action
-(void) playVideoAction{    
    // call delegate method to play the video
    [_videoIndicatorDelegate videoPlay:nil];
}

// delete the share video record action
-(void) deleteShareVideoRecordAction{
    // call delegate method to delete the share video record
    [_videoIndicatorDelegate deleteSharedVideo];
}

// set share info view
-(NSInteger) setShareInfoView:(NSDictionary *)pShareInfo andIsShared:(BOOL)pIsShared{
    NSInteger _ret = 0;
    
    // judge if need to set share info
    if(pIsShared){
        NSLog(@"video share info = %@, share type = %d, share time = %@ and sharePersons = %@", pShareInfo, ((NSNumber*)[pShareInfo objectForKey:@"shareType"]).intValue, [pShareInfo objectForKey:@"shareTime"], [pShareInfo objectForKey:@"sharePersons"]);
        
        // init share info tip height
        NSInteger _shareInfoTipHeight = 18.0;
        // get video share persons
        NSString *_videoSharePerson = [((NSString*)[pShareInfo objectForKey:@"sharePersons"]).description getVideoSharedPersonsInAddressBook];
        
        // set video shared info tip
        UILabel *_videoShareInfoTip = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 320.0-2*10.0, _shareInfoTipHeight)];
        _videoShareInfoTip.font = [UIFont systemFontOfSize:12];
        //_videoShareInfoTip.backgroundColor = [UIColor greenColor];
        // set share info tip text
        if(((NSNumber*)[pShareInfo objectForKey:@"shareType"]).intValue == Received){
            _videoShareInfoTip.text = [NSString stringWithFormat:@"来自: %@", _videoSharePerson];
        }
        else if(((NSNumber*)[pShareInfo objectForKey:@"shareType"]).intValue == Sended){
            _videoShareInfoTip.text = [NSString stringWithFormat:@"分享给: %@", _videoSharePerson];
        }
        // update share info tip height, number of rows and top padding
        if([_videoShareInfoTip.text getStrPixelLenByFontSize:12]>_videoShareInfoTip.frame.size.width){
            _videoShareInfoTip.frame = CGRectMake(_videoShareInfoTip.frame.origin.x, _videoShareInfoTip.frame.origin.y, _videoShareInfoTip.frame.size.width, _videoShareInfoTip.frame.size.height+_shareInfoTipHeight);
            _videoShareInfoTip.numberOfLines = 2;
            _ret = _shareInfoTipHeight;
        }
        _videoShareInfoTip.backgroundColor = [UIColor clearColor];
        
        // add share person info tip to view
        [self.contentView addSubview:_videoShareInfoTip];
        
        UILabel *_videoShareTime = [[UILabel alloc] initWithFrame:CGRectMake(_videoShareInfoTip.frame.origin.x, _videoShareInfoTip.frame.origin.y+_videoShareInfoTip.frame.size.height+2.0, _videoShareInfoTip.frame.size.width, 18.0)];
        _videoShareTime.font = [UIFont systemFontOfSize:12];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _videoShareTime.text = [NSString stringWithFormat:@"分享时间: %@", [dateFormatter stringFromDate:(NSDate*)[NSDate dateWithTimeIntervalSince1970:[[pShareInfo objectForKey:@"shareTime"] doubleValue]]]];
        _videoShareTime.backgroundColor = [UIColor clearColor];
        
        // add shareTime to view
        [self.contentView addSubview:_videoShareTime];
    }
    
    return  _ret;
}

@end
