//
//  NSNumber+util.m
//  feiying
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+util.h"

@implementation NSNumber (util)

// is movie or teleplay string
-(BOOL) isMovieORTV{
    BOOL ret = NO;
    
    if(self.integerValue == 1 || self.integerValue == 2){
        ret = YES;
    }
    
    return ret;
}

@end
