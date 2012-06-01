//
//  NSArray+util.m
//  feiying
//
//  Created by  on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+util.h"

@implementation NSArray (util)

// get phone number string from array with separater string
-(NSString*) getPhoneStringWithSep:(NSString *)pSeparater{
    NSMutableString *_ret = (self) ? [[NSMutableString alloc] init] : nil;
    
    NSString *_sep = (pSeparater) ? pSeparater : @"";
    
    if(self){
        for(NSInteger index = 0; index < [self count]; index++){
            if(index != [self count]-1){
                [_ret appendFormat:@"%@%@", [self objectAtIndex:index], _sep];
            }
            else{
                [_ret appendString:[self objectAtIndex:index]];
            }
        }
    }
    
    return _ret;
}

@end
