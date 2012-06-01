//
//  urlConstant.m
//  feiying
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "urlConstant.h"
#import "systemConstant.h"

static NSString* _videoUrl = @"http://fy2.richitec.com/feiying";
static NSString* _videoImgUrl = @"http://fy2.richitec.com/feiying";

static NSString* _loginUrl = @"/mobile/system/login";
static NSString* _getValidateCodeUrl = @"/mobile/system/getPhoneCode";
static NSString* _checkValidateUrl = @"/mobile/system/checkPhoneCode";
static NSString* _regUserUrl = @"/mobile/system/regUser";
static NSString* _userRegLoginUrl = @"/mobile/system/reglogin";

static NSString* _channelPageUrl = @"/mobile/video";
static NSString* _commonVideoDetailInfoUrl = @"/mobile/info";

static NSString* _favChannelListUrl = @"/mobile/fav/channellist";
static NSString* _favChannelPageUrl = @"/mobile/fav/channel";
static NSString* _videoFavIndicatorUrl = @"/mobile/fav";

static NSString* _sendShareVideoUrl = @"/mobile/share/add";
static NSString* _deleteSendedShareVideoUrl = @"/mobile/share/del";
static NSString* _sendedShareVideoListUrl = @"/mobile/share/list";
static NSString* _sendedShareVideoReceiversUrl = @"/mobile/share/recvs";
static NSString* _receivedShareVideoListUrl = @"/mobile/recv/list";
static NSString* _deleteReceivedShareVideoUrl = @"/mobile/recv/del";

static NSString* _addVideoPlayCountUrl = @"/mobile/recordPlayCount";

static NSString* _authenticateUrl = @"/mobile/system/auth";

static NSString* _videoSearchUrl = @"/mobile/search";

static NSString* _searchHotKeywordsUrl = @"/keywords";

static NSString* _feedbackUrl = @"/feedback";

@implementation urlConstant

+(NSString*) videoUrl{
    return _videoUrl;
}

+(NSString*) videoImgUrl{
    return _videoImgUrl;
}

+(NSString*) loginUrl{
    return _loginUrl;
}

+(NSString*) getValidateCodeUrl{
    return _getValidateCodeUrl;
}

+(NSString*) getCheckValidateUrl{
    return _checkValidateUrl;
}

+(NSString*) regUserUrl{
    return _regUserUrl;
}

+(NSString*) userRegLoginUrl{
    return _userRegLoginUrl;
}

+(NSString*) homePageUrl{
    return [NSString stringWithFormat:@"%@/0", _channelPageUrl];
}

+(NSString*) commonChannelPageUrl{
    return _channelPageUrl;
}

+(NSString*) commonvVideoDetailInfoPageUrl{
    return _commonVideoDetailInfoUrl;
}

+(NSString*) favChannelListUrl{
    return _favChannelListUrl;
}

+(NSString*) commonFavChannelPageUrl{
    return _favChannelPageUrl;
}

+(NSString*) videoFavIndicatorUrl{
    return _videoFavIndicatorUrl;
}

+(NSString*) sendShareUrl{
    return _sendShareVideoUrl;
}

+(NSString*) deleteSendedShareUrl{
    return _deleteSendedShareVideoUrl;
}

+(NSString*) sendedShareListUrl{
    return _sendedShareVideoListUrl;
}

+(NSString*) sendedShareReceiversUrl{
    return _sendedShareVideoReceiversUrl;
}

+(NSString*) receivedShareListUrl{
    return _receivedShareVideoListUrl;
}

+(NSString*) deleteReceivedShareUrl{
    return _deleteReceivedShareVideoUrl;
}

+(NSString*) addVideoPlayCountUrl{
    return _addVideoPlayCountUrl;
}

+(NSString*) authenticateUrl{
    return _authenticateUrl;
}

+(NSString*) videoSearchUrl{
    return _videoSearchUrl;
}

+(NSString*) videoWebPlayAddr{
    return [NSString stringWithFormat:@"%@/play", [systemConstant systemRootUrl]];
}

+(NSString*) hotKeywordsUrl{
    return _searchHotKeywordsUrl;
}

+(NSString*) feedbackSubmitUrl{
    return _feedbackUrl;
}

@end
