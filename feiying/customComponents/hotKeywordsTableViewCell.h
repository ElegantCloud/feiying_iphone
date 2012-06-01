//
//  hotKeywordsTableViewCell.h
//  feiying
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface hotKeywordsTableViewCell : baseTableViewCell

// init with keyword and count
-(id) initWithKeyword:(NSString*) pKeyword andCount:(NSString*) pCount;

@end
