//
//  systemConstant.m
//  feiying
//
//  Created by  on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "systemConstant.h"
#import "../openSource/JSONKit/JSONKit.h"

#import "../common/UserManager.h"

static NSString* _rootUrl = @"http://fy1.richitec.com/feiying";
//static NSString* _rootUrl = @"http://192.168.1.13/feiying";

static NSString* _smallVideoCommonTag = @"video";

static NSMutableArray* _channelInitDataSource = nil;

@implementation systemConstant

+(NSString*) systemRootUrl{
    return _rootUrl;
}

+(NSString*) samllVideoCommonTag{
    return _smallVideoCommonTag;
}

+(NSArray*) channelInitDataSource{
    if(!_channelInitDataSource){
        _channelInitDataSource = [[NSMutableArray alloc] init];
        
        // add each channel init
        //[_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"电影\",\"image\":\"movieChannel.png\",\"id\":\"%d\"}", 1] objectFromJSONString]];
        //[_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"电视剧\",\"image\":\"seriesChannel.png\",\"id\":\"%d\"}", 2] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"资讯\",\"image\":\"infoChannel.png\",\"id\":\"%d\"}", 3] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"搞笑\",\"image\":\"funnyChannel.png\",\"id\":\"%d\"}", 4] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"音乐\",\"image\":\"musicChannel.png\",\"id\":\"%d\"}", 5] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"体育\",\"image\":\"sportsChannel.png\",\"id\":\"%d\"}", 6] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"时尚\",\"image\":\"fashionChannel.png\",\"id\":\"%d\"}", 7] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"娱乐\",\"image\":\"entertainmentChannel.png\",\"id\":\"%d\"}", 8] objectFromJSONString]];
        [_channelInitDataSource addObject:[[NSString stringWithFormat:@"{\"title\":\"综艺\",\"image\":\"varietyChannel.png\",\"id\":\"%d\"}", 9] objectFromJSONString]];
    }
    
    return _channelInitDataSource;
}

@end
