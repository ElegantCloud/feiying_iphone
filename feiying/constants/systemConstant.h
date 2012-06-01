//
//  systemConstant.h
//  feiying
//
//  Created by  on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TABLEHEIGHT 367.0

#define BACKGROUNDCOLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:245.0/255.0 alpha:1.0]

#define VIDEOCATEGORYDICTIONARY [NSDictionary dictionaryWithObjectsAndKeys:@"电影", @"1", @"电视剧", @"2", @"资讯", @"3", @"搞笑", @"4", @"音乐", @"5", @"体育", @"6", @"时尚", @"7", @"娱乐", @"8", @"综艺", @"9", nil]

@interface systemConstant : NSObject

// static methods
// root url
+(NSString*) systemRootUrl;

// video type smallVideo common tag
+(NSString*) samllVideoCommonTag;

// channel init dataSource
+(NSArray*) channelInitDataSource;

@end
