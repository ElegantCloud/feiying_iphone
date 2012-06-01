//
//  videoChannelViewController.h
//  feiying
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "commonTableViewController.h"

@interface videoChannelViewController : commonTableViewController{
    // is fav channel
    BOOL _mIsFavChannel;
    
    // channel list url
    NSString *_mChannelListUrl;
}

@property (nonatomic, readwrite) BOOL isFavChannel;

// init with video channel title , id and fav channel flag
-(id) initWithChannelTitle:(NSString*) pTitle andId:(NSNumber*) pId andFavChannel:(BOOL) pIsFavChannel;

@end
