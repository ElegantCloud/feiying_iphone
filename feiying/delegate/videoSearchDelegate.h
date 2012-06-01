//
//  videoSearchDelegate.h
//  feiying
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol videoSearchDelegate <NSObject>

// video search with keyword
-(void) videoSearch:(NSString*) pKeyWord;

// video search begin
-(void) videoSearchBegin;

// video search end
-(void) videoSearchEnd;

@end
