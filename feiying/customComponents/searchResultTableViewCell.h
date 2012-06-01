//
//  searchResultTableViewCell.h
//  feiying
//
//  Created by  on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface searchResultTableViewCell : baseTableViewCell

// init with video image and title
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage;

@end
