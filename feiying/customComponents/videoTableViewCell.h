//
//  videoTableViewCell.h
//  feiying
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "baseTableViewCell.h"

@interface videoTableViewCell : baseTableViewCell

// init with video image, title, total time and size
-(id) initWithTitle:(NSString*) pTitle andImage:(UIImage*) pImage andTotalTime:(NSString*) pTotalTime andSize:(NSString*) pSize;

@end
